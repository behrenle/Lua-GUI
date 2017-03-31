if not gui then
  gui = {}
end

function gui.unpackColor(color)
  return color[1], color[2], color[3], color[4]
end

function gui.newObject(X, Y, L, H)
  -- the object:
  local object  = {}

  -- subobjects
  local objects = {}

  -- default style
  local default_style       = setmetatable({}, {__index = gui.default_style})
  if X then default_style.x = X end
  if Y then default_style.y = Y end
  if L then default_style.l = L end
  if H then default_style.h = H end

  -- other style
  local hover_style        = setmetatable({}, {__index = default_style})
  local left_click_style   = setmetatable({}, {__index = hover_style})
  local right_click_style  = setmetatable({}, {__index = hover_style})
  local middle_click_style = setmetatable({}, {__index = hover_style})

  -- current style
  local style              = {}                        -- address for the link to the current style table
  local meta_style         = {__index = default_style} -- sets the style-link destination
  setmetatable(style, meta_style)                      -- creates the link

  -- get styles
  function object.getStyle()
    return style
  end
  function object.setStyles(s)
    if s["default_style"] then
      for i, v in pairs(s["default_style"]) do
        default_style[i] = v
      end
    end
    if s["hover_style"] then
      for i, v in pairs(s["hover_style"]) do
        hover_style[i] = v
      end
    end
    if s["left_click_style"] then
      for i, v in pairs(s["left_click_style"]) do
        left_click_style[i] = v
      end
    end
    if s["right_click_style"] then
      for i, v in pairs(s["right_click_style"]) do
        right_click_style[i] = v
      end
    end
    if s["middle_click_style"] then
      for i, v in pairs(s["middle_click_style"]) do
        middle_click_style[i] = v
      end
    end
  end
  function object.getDefaultStyle()
    return default_style
  end
  function object.getHoverStyle()
    return hover_style
  end
  function object.getLeftClickStyle()
    return left_click_style
  end
  function object.getRightClickStyle()
    return right_click_style
  end
  function object.getMiddleClickStyle()
    return middle_click_style
  end

  -- sub object methods
  function object.getObjects()
    return objects
  end
  function object.insertObject(obj)
    function obj.parent()
      return object
    end
    table.insert(objects, obj)
  end

  -- other object methods
  function object.getAbsolutePosition()
    if object.parent then
      local px, py = object.parent().getAbsolutePosition()
      return px + style.x, py + style.y
    else
      return style.x, style.y
    end
  end
  function object.isInside(pos_x, pos_y)
    -- position and dimensions data
    local x, y = object.getAbsolutePosition()
    local l, h = style.l, style.h
    -- general hitbox
    if x <= pos_x and pos_x < x + l and
       y <= pos_y and pos_y < y + h
    then
      local x_1_top    = x + style.arc_radius_1
      local x_2_top    = x + l - style.arc_radius_2
      local x_1_bottom = x + style.arc_radius_4
      local x_2_bottom = x + l - style.arc_radius_3
      local y_1_left   = y + style.arc_radius_1
      local y_2_left   = y + h - style.arc_radius_4
      local y_1_right  = y + style.arc_radius_2
      local y_2_right  = y + h - style.arc_radius_3

      local x_1_main   = math.max(x_1_top, x_1_bottom)
      local x_2_main   = math.min(x_2_top, x_2_bottom)

      -- corner 1:
      if pos_x <= x_1_top and pos_y <= y_1_left then
        local dx = x_1_top - pos_x
        local dy = y_1_left - pos_y
        local dq = dx^2 + dy^2
        if dq <= style.arc_radius_1^2 then
          return true, "corner_1"
        else
          return false
        end
      end
      -- corner 2:
      if pos_x >= x_2_top and pos_y <= y_1_right then
        local dx = x_2_top - pos_x
        local dy = y_1_right - pos_y
        local dq = dx^2 + dy^2
        if dq <= style.arc_radius_2^2 then
          return true, "corner_2"
        else
          return false
        end
      end
      -- corner_3:
      if pos_x >= x_2_bottom and pos_y >= y_2_right then
        local dx = x_2_bottom - pos_x
        local dy = y_2_right - pos_y
        local dq = dx^2 + dy^2
        if dq <= style.arc_radius_3^2 then
          return true, "corner_3"
        else
          return false
        end
      end
      -- corner_4:
      if pos_x <= x_1_bottom and pos_y >= y_2_left then
        local dx = x_1_bottom - pos_x
        local dy = y_2_left - pos_y
        local dq = dx^2 + dy^2
        if dq <= style.arc_radius_4^2 then
          return true, "corner_4"
        else
          return false
        end
      end

      return true, "main"
    end
    return false
  end


  -- love engine callback methods
  function object.update(dt)
    local x, y = love.mouse.getPosition()
    if object.isInside(x, y) then
      if love.mouse.isDown(1) then
        meta_style.__index = left_click_style
      elseif love.mouse.isDown(2) then
        meta_style.__index = right_click_style
      elseif love.mouse.isDown(3) then
        meta_style.__index = middle_click_style
      else
        meta_style.__index = hover_style
      end
    else
      meta_style.__index = default_style
    end
    for _, obj in pairs(objects) do
      if type(obj.update) == "function" then
        obj.update(dt)
      end
    end
  end

  function object.mousepressed(x, y, b)
    if object.isInside(x, y) then
      if b == 1 and type(object.click) == "function" then
        object.click()
      end
      for _, obj in pairs(objects) do
        if type(obj.mousepressed) == "function" then
          obj.mousepressed(x, y, b)
        end
      end
    end
  end

  function object.mousereleased(x, y, b)
    if object.isInside(x, y) then
      for _, obj in pairs(objects) do
        if type(obj.mousereleased) == "function" then
          obj.mousereleased(x, y, b)
        end
      end
    end
  end

  function object.keypressed(key)
    for _, obj in pairs(objects) do
      if type(object.keypressed) == "function" then
        object.keypressed(key)
      end
    end
  end

  function object.keyreleased(key)
    for _, obj in pairs(objects) do
      if type(object.released) == "function" then
        object.keyreleased(key)
      end
    end
  end

  function object.textinput(text)
    for _, obj in pairs(objects) do
      if type(obj.textinput) == "function" then
        obj.textinput(text)
      end
    end
  end

  function object.draw()
    if style.visable then
      -- position and dimensions data
      local x, y = object.getAbsolutePosition()
      local l, h = style.l, style.h

      -- temp variables
      local x_1_top    = x + style.arc_radius_1
      local x_2_top    = x + l - style.arc_radius_2
      local x_1_bottom = x + style.arc_radius_4
      local x_2_bottom = x + l - style.arc_radius_3
      local y_1_left   = y + style.arc_radius_1
      local y_2_left   = y + h - style.arc_radius_4
      local y_1_right  = y + style.arc_radius_2
      local y_2_right  = y + h - style.arc_radius_3

      local x_1_main   = math.max(x_1_top, x_1_bottom)
      local x_2_main   = math.min(x_2_top, x_2_bottom)

      -- area
      if style.draw_area then
        love.graphics.setColor(gui.unpackColor(style.area_color))

        love.graphics.polygon(
          "fill",
          x_1_main - 1, y,
          x_2_main + 1, y,
          x_2_main + 1, y + h,
          x_1_main - 1, y + h
        )

        if style.arc_radius_1 > 0 then
          love.graphics.arc(
            "fill", "pie",
            x_1_top - 1, y_1_left - 1,
            style.arc_radius_1,
            math.pi, 3/2*math.pi
          )
          if style.arc_radius_1 < style.arc_radius_4 then
            love.graphics.polygon(
              "fill",
              x, y_1_left - 1,
              x + style.arc_radius_1 - 1, y_1_left - 1,
              x + style.arc_radius_1 - 1, y_2_left + 1,
              x, y_2_left + 1
            )
          else
            love.graphics.polygon(
              "fill",
              x + style.arc_radius_4 - 1, y_1_left - 1,
              x + style.arc_radius_1 - 1, y_1_left - 1,
              x + style.arc_radius_1 - 1, y + h,
              x + style.arc_radius_4 - 1, y + h
            )
          end
        end

        if style.arc_radius_2 > 0 then
          love.graphics.arc(
            "fill", "pie",
            x_2_top + 1, y_1_right - 1,
            style.arc_radius_2,
            3/2*math.pi, 2*math.pi
          )
          if style.arc_radius_2 < style.arc_radius_3 then
            love.graphics.polygon(
              "fill",
              x_2_top + 1, y_1_right - 1,
              x_2_top + style.arc_radius_2, y_1_right - 1,
              x_2_top + style.arc_radius_2, y_2_right + 1,
              x_2_top + 1, y_2_right + 1
            )
          else
            love.graphics.polygon(
              "fill",
              x_2_top + 1, y_1_right - 1,
              x_2_top + style.arc_radius_2 - style.arc_radius_3 + 1, y_1_right - 1,
              x_2_top + style.arc_radius_2 - style.arc_radius_3 + 1, style.y + style.h,
              x_2_top + 1, y + h
            )
          end
        end

        if style.arc_radius_3 > 0 then
          love.graphics.arc(
            "fill", "pie",
            x_2_bottom + 1, y_2_right + 1,
            style.arc_radius_3,
            0, 1/2*math.pi
          )
          if style.arc_radius_3 ~= style.arc_radius_2 then
            if style.arc_radius_3 < style.arc_radius_2 then
              love.graphics.polygon(
                "fill",
                x_2_bottom + 1, y_1_right - 1,
                x_2_bottom + style.arc_radius_3, y_1_right - 1,
                x_2_bottom + style.arc_radius_3, y_2_right + 1,
                x_2_bottom + 1, y_2_right + 1
              )
            else
              love.graphics.polygon(
                "fill",
                x_2_bottom + 1, y,
                x_2_bottom + style.arc_radius_3 - style.arc_radius_2 + 1, y,
                x_2_bottom + style.arc_radius_3 - style.arc_radius_2 + 1, y_2_right + 1,
                x_2_bottom + 1, y_2_right + 1
              )
            end
          else
            love.graphics.polygon(
              "fill",
              x_2_top + 1, y_1_right - 1,
              x + l, y_1_right - 1,
              x + l, y_2_right + 1,
              x_2_top + 1, y_2_right + 1
            )
          end
        end

        if style.arc_radius_4 > 0 then
          love.graphics.arc(
            "fill", "pie",
            x_1_bottom - 1, y_2_left + 1,
            style.arc_radius_4,
            1/2*math.pi, math.pi
          )
        end
        if style.arc_radius_4 ~= style.arc_radius_1 then
          if style.arc_radius_4 < style.arc_radius_1 then
            love.graphics.polygon(
              "fill",
              x + 1, y_1_left - 1,
              x + style.arc_radius_4 - 1, y_1_left - 1,
              x + style.arc_radius_4 - 1, y_2_left + 1,
              x, y_2_left + 1
            )
          else
            love.graphics.polygon(
              "fill",
              x + style.arc_radius_1 - 1, y,
              x + style.arc_radius_4 - 1, y,
              x + style.arc_radius_4 - 1, y_2_left + 1,
              x + style.arc_radius_1 - 1, y_2_left + 1
            )
          end
        else
          love.graphics.polygon(
            "fill",
            x, y_1_left - 1,
            x + style.arc_radius_1 - 1, y_1_left - 1,
            x + style.arc_radius_1 - 1, y_2_left + 1,
            x, y_2_left + 1
          )
        end
      end

      -- border
      if style.draw_border then
        love.graphics.setLineStyle("smooth")

        love.graphics.setColor(gui.unpackColor(style.line_color_top))
        if style.line_width_top > 0 then
          love.graphics.setLineWidth(style.line_width_top)
          love.graphics.line(
            x_1_top + 0.75, y,
            x_2_top - 0.75, y
          )
        end

        love.graphics.setColor(gui.unpackColor(style.line_color_bottom))
        if style.line_width_bottom > 0 then
          love.graphics.setLineWidth(style.line_width_bottom)
          love.graphics.line(
            x_1_bottom + 0.75, y + h,
            x_2_bottom - 0.75, y + h
          )
        end

        love.graphics.setColor(gui.unpackColor(style.line_color_left))
        if style.line_width_left > 0 then
          love.graphics.setLineWidth(style.line_width_left)
          love.graphics.line(
            x, y_1_left + 0.75,
            x, y_2_left - 0.75
          )
        end

        love.graphics.setColor(gui.unpackColor(style.line_color_right))
        if style.line_width_right > 0 then
          love.graphics.setLineWidth(style.line_width_right)
          love.graphics.line(
            x + l, y_1_right + 0.75,
            x + l, y_2_right - 0.75
          )
        end

        love.graphics.setColor(gui.unpackColor(style.arc_color_1))
        if style.arc_radius_1 > 0 then
          love.graphics.setLineWidth(style.arc_width_1)
          love.graphics.arc(
            "line", "open",
            x_1_top, y_1_left,
            style.arc_radius_1,
            math.pi, 3/2*math.pi
          )
        end

        love.graphics.setColor(gui.unpackColor(style.arc_color_2))
        if style.arc_radius_2 > 0 then
          love.graphics.setLineWidth(style.arc_width_2)
          love.graphics.arc(
            "line", "open",
            x_2_top, y_1_right,
            style.arc_radius_2,
            3/2*math.pi, 2*math.pi
          )
        end

        love.graphics.setColor(gui.unpackColor(style.arc_color_3))
        if style.arc_radius_3 > 0 then
          love.graphics.setLineWidth(style.arc_width_3)
          love.graphics.arc(
            "line", "open",
            x_2_bottom, y_2_right,
            style.arc_radius_3,
            0, 1/2*math.pi
          )
        end

        love.graphics.setColor(gui.unpackColor(style.arc_color_4))
        if style.arc_radius_4 > 0 then
          love.graphics.setLineWidth(style.arc_width_4)
          love.graphics.arc(
            "line", "open",
            x_1_bottom, y_2_left,
            style.arc_radius_4,
            1/2*math.pi, math.pi
          )
        end
      end
      for _, obj in pairs(objects) do
        if type(obj.draw) == "function" then
          obj.draw()
        end
      end
    end
  end

  return object
end
