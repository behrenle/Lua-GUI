local gui = {}

local function unpackColor(color)
  return color[1], color[2], color[3], color[4]
end

function gui.newObject(x, y, l, h)
  -- the object:
  local object = {}

  -- style
  local default_style = {
    x                 = x or 0,
    y                 = y or 0,
    l                 = l or 1,
    h                 = h or 1,
    visable           = true,
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

  -- style table
  local style      = {}
  local meta_style = {__index = default_style}
  setmetatable(style, meta_style)

  -- attributes
  --- position and dimensions
  local x, y    = x or 0, y or 0
  local l, h    = l or 1, h or 1
  --- appearance
  local visable    = true
  local line_width_top    = 1
  local line_width_bottom = 1
  local line_width_left   = 1
  local line_width_right  = 1
  local arc_width_1 = 1
  local arc_width_2 = 1
  local arc_width_3 = 1
  local arc_width_4 = 1
  --- components
  local draw_border = true
  local draw_area   = true
  --- colors
  local border_color = {255,255,255,255}
  local area_color   = {32, 32, 32, 255}
  --- border arcs
  local border_radius_1 = 0
  local border_radius_2 = 0
  local border_radius_3 = 0
  local border_radius_4 = 0


  -- object methods
  function object.setPos(pos_x, pos_y)
    x, y = pos_x, pos_y
  end
  function object.setDimensions(length, height)
    l, h = length, height
  end
  function object.setVisable(v)
    visable = v
  end
  function object.setLineWidth(...)
    local n = {...}
    if #n == 1 then
      line_width_top    = n[1]
      line_width_right  = n[1]
      line_width_bottom = n[1]
      line_width_left   = n[1]
    else
      line_width_top    = n[1] or 1
      line_width_right  = n[2] or 1
      line_width_bottom = n[3] or 1
      line_width_left   = n[4] or 1
    end
  end
  function object.setArcWidth(...)
    local n = {...}
    if #n == 1 then
      arc_width_1 = n[1]
      arc_width_2 = n[1]
      arc_width_3 = n[1]
      arc_width_4 = n[1]
    else
      arc_width_1 = n[1] or 1
      arc_width_2 = n[2] or 1
      arc_width_3 = n[3] or 1
      arc_width_4 = n[4] or 1
    end
  end
  function object.drawBorder(b)
    draw_border = b
  end
  function object.drawArea(a)
    draw_area = a
  end
  function object.setAreaColor(r, g, b, a)
    area_color = {r, g, b, a}
  end
  function object.setBorderColor(r, g, b, a)
    border_color = {r, g, b, a}
  end
  function object.setBorderRadius(...)
    local r = {...}
    if #r == 1 then
      border_radius_1 = r[1]
      border_radius_2 = r[1]
      border_radius_3 = r[1]
      border_radius_4 = r[1]
    else
      border_radius_1 = r[1] or border_radius_1
      border_radius_2 = r[2] or border_radius_2
      border_radius_3 = r[3] or border_radius_3
      border_radius_4 = r[4] or border_radius_4
    end
  end
  function object.isInside(pos_x, pos_y)
    -- general hitbox
    if x <= pos_x and pos_x < x + l and
       y <= pos_y and pos_y < y + h
    then
      local x_1_top    = x + border_radius_1
      local x_2_top    = x + l - border_radius_2
      local x_1_bottom = x + border_radius_4
      local x_2_bottom = x + l - border_radius_3
      local y_1_left   = y + border_radius_1
      local y_2_left   = y + h - border_radius_4
      local y_1_right  = y + border_radius_2
      local y_2_right  = y + h - border_radius_3

      local x_1_main   = math.max(x_1_top, x_1_bottom)
      local x_2_main   = math.min(x_2_top, x_2_bottom)

      -- corner 1:
      if pos_x <= x_1_top and pos_y <= y_1_left then
        local dx = x_1_top - pos_x
        local dy = y_1_left - pos_y
        local dq = dx^2 + dy^2
        if dq <= border_radius_1^2 then
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
        if dq <= border_radius_2^2 then
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
        if dq <= border_radius_3^2 then
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
        if dq <= border_radius_4^2 then
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
    if visable then
      local x_1_top    = x + border_radius_1
      local x_2_top    = x + l - border_radius_2
      local x_1_bottom = x + border_radius_4
      local x_2_bottom = x + l - border_radius_3
      local y_1_left   = y + border_radius_1
      local y_2_left   = y + h - border_radius_4
      local y_1_right  = y + border_radius_2
      local y_2_right  = y + h - border_radius_3

      local x_1_main   = math.max(x_1_top, x_1_bottom)
      local x_2_main   = math.min(x_2_top, x_2_bottom)

      -- area
      if draw_area then
        love.graphics.setColor(unpackColor(area_color))

        love.graphics.polygon(
          "fill",
          x_1_main - 1, y,
          x_2_main + 1, y,
          x_2_main + 1, y + h,
          x_1_main - 1, y + h
        )

        if border_radius_1 > 0 then
          love.graphics.arc(
            "fill", "pie",
            x_1_top - 1, y_1_left - 1,
            border_radius_1,
            math.pi, 3/2*math.pi
          )
          if border_radius_1 < border_radius_4 then
            love.graphics.polygon(
              "fill",
              x, y_1_left - 1,
              x + border_radius_1 - 1, y_1_left - 1,
              x + border_radius_1 - 1, y_2_left + 1,
              x, y_2_left + 1
            )
          else
            love.graphics.polygon(
              "fill",
              x + border_radius_4 - 1, y_1_left - 1,
              x + border_radius_1 - 1, y_1_left - 1,
              x + border_radius_1 - 1, y + h,
              x + border_radius_4 - 1, y + h
            )
          end
        end

        if border_radius_2 > 0 then
          love.graphics.arc(
            "fill", "pie",
            x_2_top + 1, y_1_right - 1,
            border_radius_2,
            3/2*math.pi, 2*math.pi
          )
          if border_radius_2 < border_radius_3 then
            love.graphics.polygon(
              "fill",
              x_2_top + 1, y_1_right - 1,
              x_2_top + border_radius_2, y_1_right - 1,
              x_2_top + border_radius_2, y_2_right + 1,
              x_2_top + 1, y_2_right + 1
            )
          else
            love.graphics.polygon(
              "fill",
              x_2_top + 1, y_1_right - 1,
              x_2_top + border_radius_2 - border_radius_3 + 1, y_1_right - 1,
              x_2_top + border_radius_2 - border_radius_3 + 1, y + h,
              x_2_top + 1, y + h
            )
          end
        end

        if border_radius_3 > 0 then
          love.graphics.arc(
            "fill", "pie",
            x_2_bottom + 1, y_2_right + 1,
            border_radius_3,
            0, 1/2*math.pi
          )
          if border_radius_3 ~= border_radius_2 then
            if border_radius_3 < border_radius_2 then
              love.graphics.polygon(
                "fill",
                x_2_bottom + 1, y_1_right - 1,
                x_2_bottom + border_radius_3, y_1_right - 1,
                x_2_bottom + border_radius_3, y_2_right + 1,
                x_2_bottom + 1, y_2_right + 1
              )
            else
              love.graphics.polygon(
                "fill",
                x_2_bottom + 1, y,
                x_2_bottom + border_radius_3 - border_radius_2 + 1, y,
                x_2_bottom + border_radius_3 - border_radius_2 + 1, y_2_right + 1,
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

        if border_radius_4 > 0 then
          love.graphics.arc(
            "fill", "pie",
            x_1_bottom - 1, y_2_left + 1,
            border_radius_4,
            1/2*math.pi, math.pi
          )
        end
        if border_radius_4 ~= border_radius_1 then
          if border_radius_4 < border_radius_1 then
            love.graphics.polygon(
              "fill",
              x + 1, y_1_left - 1,
              x + border_radius_4 - 1, y_1_left - 1,
              x + border_radius_4 - 1, y_2_left + 1,
              x, y_2_left + 1
            )
          else
            love.graphics.polygon(
              "fill",
              x + border_radius_1 - 1, y,
              x + border_radius_4 - 1, y,
              x + border_radius_4 - 1, y_2_left + 1,
              x + border_radius_1 - 1, y_2_left + 1
            )
          end
        else
          love.graphics.polygon(
            "fill",
            x, y_1_left - 1,
            x + border_radius_1 - 1, y_1_left - 1,
            x + border_radius_1 - 1, y_2_left + 1,
            x, y_2_left + 1
          )
        end
      end

      -- border
      if draw_border then
        love.graphics.setColor(unpackColor(border_color))
        love.graphics.setLineStyle("smooth")

        if line_width_top > 0 then
          love.graphics.setLineWidth(line_width_top)
          love.graphics.line(x_1_top + 0.75, y, x_2_top - 0.75, y)
        end

        if line_width_bottom > 0 then
          love.graphics.setLineWidth(line_width_bottom)
          love.graphics.line(x_1_bottom + 0.75, y + h, x_2_bottom - 0.75, y + h)
        end

        if line_width_left > 0 then
          love.graphics.setLineWidth(line_width_left)
          love.graphics.line(x, y_1_left + 0.75, x, y_2_left - 0.75)
        end

        if line_width_right > 0 then
          love.graphics.setLineWidth(line_width_right)
          love.graphics.line(x + l, y_1_right + 0.75, x + l, y_2_right - 0.75)
        end

        if border_radius_1 > 0 then
          love.graphics.setLineWidth(arc_width_1)
          love.graphics.arc(
            "line", "open",
            x_1_top, y_1_left,
            border_radius_1,
            math.pi, 3/2*math.pi
          )
        end
        if border_radius_2 > 0 then
          love.graphics.setLineWidth(arc_width_2)
          love.graphics.arc(
            "line", "open",
            x_2_top, y_1_right,
            border_radius_2,
            3/2*math.pi, 2*math.pi
          )
        end
        if border_radius_3 > 0 then
          love.graphics.setLineWidth(arc_width_3)
          love.graphics.arc(
            "line", "open",
            x_2_bottom, y_2_right,
            border_radius_3,
            0, 1/2*math.pi
          )
        end
        if border_radius_4 > 0 then
          love.graphics.setLineWidth(arc_width_4)
          love.graphics.arc(
            "line", "open",
            x_1_bottom, y_2_left,
            border_radius_4,
            1/2*math.pi, math.pi
          )
        end
      end
    end
  end

  return object
end

return gui
