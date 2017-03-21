local gui = {}

local function unpackColor(color)
  return color[1], color[2], color[3], color[4]
end

local style_methods = {}

-- position
function style_methods:setPos(x, y)
  self.x, self.y = x, y
end
function style_methods:getPos()
  return self.x, self.y
end

-- dimensions
function style_methods:setDimensions(l, h)
  self.l, self.h = l, h
end
function style_methods:getDimensions()
  return self.l, self.h
end

-- visable
function style_methods:setVisable(state)
  self.visable = state
end
function style_methods:getVisable()
  return self.visable
end

-- line_width
function style_methods:setLineWidth(...)
  local widths = {...}
  if #widths == 1 then
    self.line_width_top    = widths[1] or 1
    self.line_width_right  = widths[1] or 1
    self.line_width_bottom = widths[1] or 1
    self.line_width_left   = widths[1] or 1
  else
    self.line_width_top    = widths[1] or 1
    self.line_width_right  = widths[2] or 1
    self.line_width_bottom = widths[3] or 1
    self.line_width_left   = widths[4] or 1
  end
end
function style_methods:getLineWidth()
  return self.line_width_top,
         self.line_width_bottom,
         self.line_width_left,
         self.line_width_right
end

-- arc width
function style_methods:setArcWidth(...)
  local widths = {...}
  if #widths == 1 then
    self.arc_width_1 = widths[1] or 1
    self.arc_width_2 = widths[1] or 1
    self.arc_width_3 = widths[1] or 1
    self.arc_width_4 = widths[1] or 1
  else
    self.arc_width_1 = widths[1] or 1
    self.arc_width_2 = widths[2] or 1
    self.arc_width_3 = widths[3] or 1
    self.arc_width_4 = widths[4] or 1
  end
end
function style_methods:getArcWidth()
  return self.arc_width_1,
         self.arc_width_2,
         self.arc_width_3,
         self.arc_width_4
end

-- arc radius
function style_methods:setArcRadius(...)
  local rs = {...}
  if #rs == 1 then
    self.arc_radius_1 = rs[1] or 1
    self.arc_radius_2 = rs[1] or 1
    self.arc_radius_3 = rs[1] or 1
    self.arc_radius_4 = rs[1] or 1
  else
    self.arc_radius_1 = rs[1] or 1
    self.arc_radius_2 = rs[2] or 1
    self.arc_radius_3 = rs[3] or 1
    self.arc_radius_4 = rs[4] or 1
  end
end
function style_methods:getArcRadius()
  return self.arc_Radius_1,
         self.arc_Radius_2,
         self.arc_Radius_3,
         self.arc_Radius_4
end

-- area color
function style_methods:setAreaColor(color_table)
  self.area_color = color_table
end
function style_methods:getAreaColor()
  return self.area_color
end

-- line color
function style_methods:setLineColor(...)
  local color_tables = {...}
  if #color_tables == 1 then
    self.line_color_top    = color_tables[1] or {255,255,255,255}
    self.line_color_right  = color_tables[1] or {255,255,255,255}
    self.line_color_bottom = color_tables[1] or {255,255,255,255}
    self.line_color_left   = color_tables[1] or {255,255,255,255}
  else
    self.line_color_top    = color_tables[1] or {255,255,255,255}
    self.line_color_right  = color_tables[2] or {255,255,255,255}
    self.line_color_bottom = color_tables[3] or {255,255,255,255}
    self.line_color_left   = color_tables[4] or {255,255,255,255}
  end
end
function style_methods:getLineColor()
  return self.line_color_top,
         self.line_color_right,
         self.line_color_bottom,
         self.line_color_left
end

-- arc color
function style_methods:setArcColor(...)
  local color_tables = {...}
  if #color_tables == 1 then
    self.arc_color_1 = color_tables[1] or {255,255,255,255}
    self.arc_color_2 = color_tables[1] or {255,255,255,255}
    self.arc_color_3 = color_tables[1] or {255,255,255,255}
    self.arc_color_4 = color_tables[1] or {255,255,255,255}
  else
    self.arc_color_1 = color_tables[1] or {255,255,255,255}
    self.arc_color_2 = color_tables[2] or {255,255,255,255}
    self.arc_color_3 = color_tables[3] or {255,255,255,255}
    self.arc_color_4 = color_tables[4] or {255,255,255,255}
  end
end
function style_methods:getLineColor()
  return self.arc_color_1,
         self.arc_color_2,
         self.arc_color_3,
         self.arc_color_4
end

-- set border
function style_methods:setBorder(state)
  self.draw_border = state
end
function style_methods:getBorder()
  return self.draw_border
end

-- set area
function style_methods:setArea(state)
  self.draw_area = state
end
function style_methods:getArea(state)
  return self.draw_area
end

-- border
function style_methods:setBorderWidth(n)
  self:setLineWidth(n)
  self:setArcWidth(n)
end
function style_methods:setBorderColor(color_table)
  self:setLineColor(color_table)
  self:setArcColor(color_table)
end

function gui.newObject(X, Y, L, H)
  -- the object:
  local object = {}

  -- default style
  local default_style = {
    x                 = X or 0,
    y                 = Y or 0,
    l                 = L or 1,
    h                 = H or 1,
    visable           = true,
    draw_border       = true,
    draw_area         = true,
    line_width_top    = 1,
    line_width_bottom = 1,
    line_width_left   = 1,
    line_width_right  = 1,
    arc_width_1       = 1,
    arc_width_2       = 1,
    arc_width_3       = 1,
    arc_width_4       = 1,
    arc_radius_1      = 0,
    arc_radius_2      = 0,
    arc_radius_3      = 0,
    arc_radius_4      = 0,
    area_color        = {32, 32, 32, 255},
    line_color_top    = {255,255,255,255},
    line_color_bottom = {255,255,255,255},
    line_color_left   = {255,255,255,255},
    line_color_right  = {255,255,255,255},
    arc_color_1       = {255,255,255,255},
    arc_color_2       = {255,255,255,255},
    arc_color_3       = {255,255,255,255},
    arc_color_4       = {255,255,255,255},
  }

  -- other style
  local hover_style        = setmetatable({}, {__index = default_style})
  local left_click_style   = setmetatable({}, {__index = hover_style})
  local right_click_style  = setmetatable({}, {__index = hover_style})
  local middle_click_style = setmetatable({}, {__index = hover_style})

  -- current style
  local style              = {}                        -- address for the link to the current style table
  local meta_style         = {__index = default_style} -- sets the style-link destination
  setmetatable(style, meta_style)                      -- creates the link

  -- adding style methods
  local meta_default  = {__index = style_methods}      -- link to the style methods table
  setmetatable(default_style, meta_default)            -- creates the link

  -- get styles
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

  -- other object methods
  function object.isInside(pos_x, pos_y)
    -- general hitbox
    if style.x <= pos_x and pos_x < style.x + style.l and
       style.y <= pos_y and pos_y < style.y + style.h
    then
      local x_1_top    = style.x + style.arc_radius_1
      local x_2_top    = style.x + style.l - style.arc_radius_2
      local x_1_bottom = style.x + style.arc_radius_4
      local x_2_bottom = style.x + style.l - style.arc_radius_3
      local y_1_left   = style.y + style.arc_radius_1
      local y_2_left   = style.y + style.h - style.arc_radius_4
      local y_1_right  = style.y + style.arc_radius_2
      local y_2_right  = style.y + style.h - style.arc_radius_3

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
  end

  function object.draw()
    if style.visable then
      local x_1_top    = style.x + style.arc_radius_1
      local x_2_top    = style.x + style.l - style.arc_radius_2
      local x_1_bottom = style.x + style.arc_radius_4
      local x_2_bottom = style.x + style.l - style.arc_radius_3
      local y_1_left   = style.y + style.arc_radius_1
      local y_2_left   = style.y + style.h - style.arc_radius_4
      local y_1_right  = style.y + style.arc_radius_2
      local y_2_right  = style.y + style.h - style.arc_radius_3

      local x_1_main   = math.max(x_1_top, x_1_bottom)
      local x_2_main   = math.min(x_2_top, x_2_bottom)

      -- area
      if style.draw_area then
        love.graphics.setColor(unpackColor(style.area_color))

        love.graphics.polygon(
          "fill",
          x_1_main - 1, style.y,
          x_2_main + 1, style.y,
          x_2_main + 1, style.y + style.h,
          x_1_main - 1, style.y + style.h
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
              style.x, y_1_left - 1,
              style.x + style.arc_radius_1 - 1, y_1_left - 1,
              style.x + style.arc_radius_1 - 1, y_2_left + 1,
              style.x, y_2_left + 1
            )
          else
            love.graphics.polygon(
              "fill",
              style.x + style.arc_radius_4 - 1, y_1_left - 1,
              style.x + style.arc_radius_1 - 1, y_1_left - 1,
              style.x + style.arc_radius_1 - 1, style.y + style.h,
              style.x + style.arc_radius_4 - 1, style.y + style.h
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
              x_2_top + 1, style.y + style.h
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
                x_2_bottom + 1, style.y,
                x_2_bottom + style.arc_radius_3 - style.arc_radius_2 + 1, style.y,
                x_2_bottom + style.arc_radius_3 - style.arc_radius_2 + 1, y_2_right + 1,
                x_2_bottom + 1, y_2_right + 1
              )
            end
          else
            love.graphics.polygon(
              "fill",
              x_2_top + 1, y_1_right - 1,
              style.x + style.l, y_1_right - 1,
              style.x + style.l, y_2_right + 1,
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
              style.x + 1, y_1_left - 1,
              style.x + style.arc_radius_4 - 1, y_1_left - 1,
              style.x + style.arc_radius_4 - 1, y_2_left + 1,
              style.x, y_2_left + 1
            )
          else
            love.graphics.polygon(
              "fill",
              style.x + style.arc_radius_1 - 1, style.y,
              style.x + style.arc_radius_4 - 1, style.y,
              style.x + style.arc_radius_4 - 1, y_2_left + 1,
              style.x + style.arc_radius_1 - 1, y_2_left + 1
            )
          end
        else
          love.graphics.polygon(
            "fill",
            style.x, y_1_left - 1,
            style.x + style.arc_radius_1 - 1, y_1_left - 1,
            style.x + style.arc_radius_1 - 1, y_2_left + 1,
            style.x, y_2_left + 1
          )
        end
      end

      -- border
      if style.draw_border then
        love.graphics.setLineStyle("smooth")

        love.graphics.setColor(unpackColor(style.line_color_top))
        if style.line_width_top > 0 then
          love.graphics.setLineWidth(style.line_width_top)
          love.graphics.line(
            x_1_top + 0.75, style.y,
            x_2_top - 0.75, style.y
          )
        end

        love.graphics.setColor(unpackColor(style.line_color_bottom))
        if style.line_width_bottom > 0 then
          love.graphics.setLineWidth(style.line_width_bottom)
          love.graphics.line(
            x_1_bottom + 0.75, style.y + style.h,
            x_2_bottom - 0.75, style.y + style.h
          )
        end

        love.graphics.setColor(unpackColor(style.line_color_left))
        if style.line_width_left > 0 then
          love.graphics.setLineWidth(style.line_width_left)
          love.graphics.line(
            style.x, y_1_left + 0.75,
            style.x, y_2_left - 0.75
          )
        end

        love.graphics.setColor(unpackColor(style.line_color_right))
        if style.line_width_right > 0 then
          love.graphics.setLineWidth(style.line_width_right)
          love.graphics.line(
            style.x + style.l, y_1_right + 0.75,
            style.x + style.l, y_2_right - 0.75
          )
        end

        love.graphics.setColor(unpackColor(style.arc_color_1))
        if style.arc_radius_1 > 0 then
          love.graphics.setLineWidth(style.arc_width_1)
          love.graphics.arc(
            "line", "open",
            x_1_top, y_1_left,
            style.arc_radius_1,
            math.pi, 3/2*math.pi
          )
        end

        love.graphics.setColor(unpackColor(style.arc_color_2))
        if style.arc_radius_2 > 0 then
          love.graphics.setLineWidth(style.arc_width_2)
          love.graphics.arc(
            "line", "open",
            x_2_top, y_1_right,
            style.arc_radius_2,
            3/2*math.pi, 2*math.pi
          )
        end

        love.graphics.setColor(unpackColor(style.arc_color_3))
        if style.arc_radius_3 > 0 then
          love.graphics.setLineWidth(style.arc_width_3)
          love.graphics.arc(
            "line", "open",
            x_2_bottom, y_2_right,
            style.arc_radius_3,
            0, 1/2*math.pi
          )
        end

        love.graphics.setColor(unpackColor(style.arc_color_4))
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
    end
  end

  return object
end

return gui
