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


  -- love engine callback methods
  function object.draw()
    if visable then
      -- area
      if draw_area then
        love.graphics.setColor(unpackColor(area_color))
        love.graphics.polygon("fill", x, y, x + l, y, x + l, y + h, x, y + h)
      end
      -- border
      if draw_border then
        love.graphics.setColor(unpackColor(border_color))
        love.graphics.setLineWidth(line_width)
        love.graphics.polygon("line", x, y, x + l, y, x + l, y + h, x, y + h)
      end
    end
  end

  return object
end

return gui
