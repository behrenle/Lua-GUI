if not gui then
  gui = {}
end

function gui.newButton(x, y, l, h, text, func)
  local button = gui.newLabel(x, y, l, h, text)

  button.setStyles(gui.button_style)

  if type(func) == "function" then
    button.click = func
  end

  return button
end
