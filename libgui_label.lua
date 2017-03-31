if not gui then
  gui = {}
end

function gui.newLabel(x, y, l, h, text)
  local label = gui.newObject(x, y, l, h)
  local text  = text or "no text"

  label.setStyles(gui.label_style)

  function label.setText(str)
    text = str
  end
  function label.getText()
    return text
  end

  local text_obj = {}
  function text_obj.draw()
    local style = label.getStyle()
    local x, y  = label.getAbsolutePosition()
    local l, h  = style:getDimensions()

    local pos_x_1 = x + (style.arc_radius_1 + style.arc_radius_4)/2
    local pos_x_2 = x + l - (style.arc_radius_2 + style.arc_radius_3)/2
    local pos_y   = y + (h - style.font:getHeight()) / 2
    local limit   = math.abs(pos_x_2 - pos_x_1)

    love.graphics.setFont(style.font)
    love.graphics.printf(text, pos_x_1, pos_y, limit, style.text_align)
  end

  label.insertObject(text_obj)
  return label
end
