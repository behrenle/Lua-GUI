local gui = {}

local function unpackColor(color)
  return color[1], color[2], color[3], color[4]
end

function gui.newObject(X, Y, L, H)
  -- the object:
  local object = {}

  -- style
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
  local hover_style   = setmetatable({}, {__index = default_style})
  local click_style   = setmetatable({}, {__index = default_style})
  local style         = {}                        -- link to the current style talbe
  local meta_style    = {__index = default_style} -- sets the style-link destination
  setmetatable(style, meta_style)

  -- object methods
  function object.setPos(pos_x, pos_y)
    default_style.x, default_style.y = pos_x, pos_y
  end
  function object.setDimensions(length, height)
    default_style.l, default_style.h = length, height
  end
  function object.setVisable(v)
    visable = v
  end
  function object.setLineWidth(...)
    local n = {...}
    if #n == 1 then
      default_style.line_width_top    = n[1]
      default_style.line_width_right  = n[1]
      default_style.line_width_bottom = n[1]
      default_style.line_width_left   = n[1]
    else
      default_style.line_width_top    = n[1] or 1
      default_style.line_width_right  = n[2] or 1
      default_style.line_width_bottom = n[3] or 1
      default_style.line_width_left   = n[4] or 1
    end
  end
  function object.setArcWidth(...)
    local n = {...}
    if #n == 1 then
      style.arc_width_1 = n[1]
      style.arc_width_2 = n[1]
      style.arc_width_3 = n[1]
      style.arc_width_4 = n[1]
    else
      style.arc_width_1 = n[1] or 1
      style.arc_width_2 = n[2] or 1
      style.arc_width_3 = n[3] or 1
      style.arc_width_4 = n[4] or 1
    end
  end
  function object.drawBorder(b)
    default_style.draw_border = b
  end
  function object.drawArea(a)
    default_style.draw_area = a
  end
  function object.setAreaColor(r, g, b, a)
    default_style.area_color = {r, g, b, a}
  end
  function object.setBorderColor(r, g, b, a)
    border_color = {r, g, b, a}
  end
  function object.setBorderRadius(...)
    local r = {...}
    if #r == 1 then
      default_style.arc_radius_1 = r[1]
      default_style.arc_radius_2 = r[1]
      default_style.arc_radius_3 = r[1]
      default_style.arc_radius_4 = r[1]
    else
      default_style.arc_radius_1 = r[1] or default_style.arc_radius_1
      default_style.arc_radius_2 = r[2] or default_style.arc_radius_2
      default_style.arc_radius_3 = r[3] or default_style.arc_radius_3
      default_style.arc_radius_4 = r[4] or default_style.arc_radius_4
    end
  end
  function object.isInside(pos_x, pos_y)
    -- general hitbox
    if style.x <= pos_x and pos_x < style.x + style.l and
       style.y <= pos_y and pos_y < style.y + h
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
              style.x + style.arc_radius_1 - 1, style.y + h,
              style.x + style.arc_radius_4 - 1, style.y + h
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
