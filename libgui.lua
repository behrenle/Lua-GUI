local gui = {}

local function unpackColor(color)
  return color[1], color[2], color[3], color[4]
end

function gui.newObject(x, y, l, h)
  -- the object:
  local object = {}


  -- attributes
  --- position and dimensions
  local x, y    = x or 0, y or 0
  local l, h    = l or 1, h or 1
  --- appearance
  local visable    = true
  local line_width = 1
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
  function object.setLineWidth(n)
    line_width = n
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

      -- main area
      if x_1_main <= pos_x and pos_x <= x_2_main then
        return true, "main"
      end

      -- corner 1:
      if pos_x <= x_1_top and pos_y <= y_1_left then
        local dx = x_1_top - pos_x
        local dy = y_1_left - pos_y
        local dq = dx^2 + dy^2
        if dq <= border_radius_1^2 then
          return true, "corner_1"
        end
      end
      -- corner 2:
      if pos_x >= x_2_top and pos_y <= y_1_right then
        local dx = x_2_top - pos_x
        local dy = y_1_right - pos_y
        local dq = dx^2 + dy^2
        if dq <= border_radius_2^2 then
          return true, "corner_2"
        end
      end
      -- corner_3:
      if pos_x >= x_2_bottom and pos_y >= y_2_right then
        local dx = x_2_bottom - pos_x
        local dy = y_2_right - pos_y
        local dq = dx^2 + dy^2
        if dq <= border_radius_2^2 then
          return true, "corner_3"
        end
      end
      -- corner_4:
      if pos_x <= x_1_bottom and pos_y >= y_2_left then
        local dx = x_1_bottom - pos_x
        local dy = y_2_left - pos_y
        local dq = dx^2 + dy^2
        if dq <= border_radius_2^2 then
          return true, "corner_4"
        end
      end

      return false
    end
  end


  -- love engine callback methods
  function object.draw()
    if visable then
      love.graphics.setLineWidth(line_width)
      love.graphics.setPointSize(line_width)

      local x_1_top    = x + border_radius_1 + line_width
      local x_2_top    = x + l - border_radius_2 - line_width
      local x_1_bottom = x + border_radius_4 + line_width
      local x_2_bottom = x + l - border_radius_3 - line_width
      local y_1_left   = y + border_radius_1 + line_width
      local y_2_left   = y + h - border_radius_4 - line_width
      local y_1_right  = y + border_radius_2 + line_width
      local y_2_right  = y + h - border_radius_3 - line_width

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
            x_1_top - line_width, y_1_left - line_width,
            border_radius_1,
            math.pi, 3/2*math.pi
          )
          if border_radius_1 < border_radius_4 then
            love.graphics.polygon(
              "fill",
              x, y_1_left - 1,
              x + border_radius_1, y_1_left - 1,
              x + border_radius_1, y_2_left + 1,
              x, y_2_left + 1
            )
          else
            love.graphics.polygon(
              "fill",
              x + border_radius_4, y_1_left - 1,
              x + border_radius_1, y_1_left - 1,
              x + border_radius_1, y + h,
              x + border_radius_4, y + h
            )
          end
        end

        if border_radius_2 > 0 then
          love.graphics.arc(
            "fill", "pie",
            x_2_top + line_width, y_1_right - line_width,
            border_radius_2,
            3/2*math.pi, 2*math.pi
          )
          if border_radius_2 < border_radius_3 then
            love.graphics.polygon(
              "fill",
              x_2_top + line_width, y_1_right - 1,
              x_2_top + border_radius_2, y_1_right - 1,
              x_2_top + border_radius_2, y_2_right + 1,
              x_2_top + line_width, y_2_right + 1
            )
          else
            love.graphics.polygon(
              "fill",
              x_2_top + line_width, y_1_right - 1,
              x_2_top + border_radius_2 - border_radius_3 + line_width, y_1_right - 1,
              x_2_top + border_radius_2 - border_radius_3 + line_width, y + h,
              x_2_top + line_width, y + h
            )
          end
        end

        if border_radius_3 > 0 then
          love.graphics.arc(
            "fill", "pie",
            x_2_bottom + line_width, y_2_right + line_width,
            border_radius_3,
            0, 1/2*math.pi
          )
          if border_radius_3 ~= border_radius_2 then
            if border_radius_3 < border_radius_2 then
              love.graphics.polygon(
                "fill",
                x_2_bottom + line_width, y_1_right - 1,
                x_2_bottom + border_radius_3, y_1_right - 1,
                x_2_bottom + border_radius_3, y_2_right + 1,
                x_2_bottom + line_width, y_2_right + 1
              )
            else
              love.graphics.polygon(
                "fill",
                x_2_bottom + line_width, y,
                x_2_bottom + border_radius_3 - border_radius_2 + line_width, y,
                x_2_bottom + border_radius_3 - border_radius_2 + line_width, y_2_right + 1,
                x_2_bottom + line_width, y_2_right + 1
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
            x_1_bottom - line_width, y_2_left + line_width,
            border_radius_4,
            1/2*math.pi, math.pi
          )
        end
        if border_radius_4 ~= border_radius_1 then
          if border_radius_4 < border_radius_1 then
            love.graphics.polygon(
              "fill",
              x, y_1_left - 1,
              x + border_radius_4, y_1_left - 1,
              x + border_radius_4, y_2_left + 1,
              x, y_2_left + 1
            )
          else
            love.graphics.polygon(
              "fill",
              x + border_radius_1, y,
              x + border_radius_4, y,
              x + border_radius_4, y_2_left + 1,
              x + border_radius_1, y_2_left + 1
            )
          end
        else
          love.graphics.polygon(
            "fill",
            x, y_1_left - 1,
            x + border_radius_1, y_1_left - 1,
            x + border_radius_1, y_2_left + 1,
            x, y_2_left + 1
          )
        end
      end

      -- border
      if draw_border then
        love.graphics.setColor(unpackColor(border_color))

        love.graphics.line(x_1_top, y, x_2_top, y)
        love.graphics.line(x_1_bottom, y + h, x_2_bottom, y + h)
        love.graphics.line(x, y_1_left, x, y_2_left)
        love.graphics.line(x + l, y_1_right, x + l, y_2_right)

        if border_radius_1 > 0 then
          love.graphics.arc(
            "line", "open",
            x_1_top - line_width, y_1_left - line_width,
            border_radius_1,
            math.pi, 3/2*math.pi
          )
        end
        if border_radius_2 > 0 then
          love.graphics.arc(
            "line", "open",
            x_2_top + line_width, y_1_right - line_width,
            border_radius_2,
            3/2*math.pi, 2*math.pi
          )
        end
        if border_radius_3 > 0 then
          love.graphics.arc(
            "line", "open",
            x_2_bottom + line_width, y_2_right + line_width,
            border_radius_3,
            0, 1/2*math.pi
          )
        end
        if border_radius_4 > 0 then
          love.graphics.arc(
            "line", "open",
            x_1_bottom - line_width, y_2_left + line_width,
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
