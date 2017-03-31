if not gui then
  gui = {}
end

function gui.newImage(x, y, l, h, imageData)
  local image  = gui.newObject(x, y, l, h)
  local img    = imageData
  local canvas = love.graphics.newCanvas(l, h)
  local image_data, last_l, last_h

  image.setStyles(gui.image_style)

  local drawer = {}
  function drawer:update()
    local style = image.getStyle()
    local l, h  = style:getDimensions()

    if l ~= last_l or h ~= last_h then
      local i_l, i_h = img:getDimensions()
      canvas         = love.graphics.newCanvas(l, h)
      love.graphics.setCanvas(canvas)
      love.graphics.draw(img, 0, 0, 0, l / i_l, h / i_h)
      --[[love.graphics.draw(
        data, style.line_width_left, style.line_width_top, 0,
        (l - style.line_width_left - style.line_width_right)/i_l,
        (h - style.line_width_top - style.line_width_bottom)/i_h
      )]]
      love.graphics.setCanvas()
      image_data = canvas:newImageData()

      function map(x, y, r, g, b, a)
        local px, py = image.getAbsolutePosition()
        if image.isInside(px + x, py + y) then
          return r, g, b, a
        else
          return 0, 0, 0, 0
        end
      end

      image_data:mapPixel(map)

      last_l = l
      last_h = h
    end
  end
  function drawer:draw()
    local style    = image.getStyle()
    local l, h     = style:getDimensions()
    local x, y     = image.getAbsolutePosition()
    local i_l, i_h = image_data:getDimensions()
    love.graphics.draw(
      love.graphics.newImage(image_data),
      x + style.line_width_left - 1/4, y + style.line_width_left - 1/4, 0,
      (l - style.line_width_left - style.line_width_right + 1/4) / i_l,
      (h - style.line_width_top - style.line_width_bottom + 1/4) / i_h
    )
  end

  image.insertObject(drawer)

  return image
end
