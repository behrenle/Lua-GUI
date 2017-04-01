if not gui then
  gui = {}
end

function gui.newSlider(x, y, l, h, min_val, name, max_val, start_val, s_size)
  local slider = gui.newObject(x, y, l, h)
  local button = gui.newButton()

  function slider.getButton()
    return button
  end

  slider.setStyles(gui.slider_style)
  button.setStyles(gui.slider_button_style)

  local is_moving      = false
  local last_x, last_y = 0, 0
  local min_value      = min_val or 0
  local max_value      = max_val or min_value + 1
  local value          = start_val or min_value
  local step_size      = s_size or (max_value - min_value) / 100

  local updater = {}
  function updater.update(dt)
    local slider_default = slider.getDefaultStyle()
    local button_default = button.getDefaultStyle()
    local sl, sh         = slider_default:getDimensions()

    if not love.mouse.isDown(1) then
      is_moving = false
    end

    local s_size  = slider_default.slider_button_l

    if is_moving then
      local sx, sy  = slider.getAbsolutePosition()
      local x, y    = love.mouse.getPosition()
      value         = (x - sx - sl * s_size / 2) /
                      ((1 - s_size) * sl) * (max_value - min_value)
      if value < min_value then
        value = min_value
      elseif value > max_value then
        value = max_value
      end
    end

    button_default:setArcRadius(slider_default:getArcRadius())
    button_default:setDimensions(sl * s_size, sh)

    button_default:setPos(
      value / (max_value - min_value) * (1 - s_size) * sl, 0
    )
    button.setText(value)
  end

  function updater.mousepressed(x, y, b)
    if b == 1 then
      is_moving      = true
      last_x, last_y = x, y
    end
  end

  function updater.mousereleased(x, y, b)
    is_moving = false
  end

  button.insertObject(updater)
  slider.insertObject(button)

  return slider
end
