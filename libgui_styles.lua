if not gui then
  gui = {}
end

-- slider style
gui.slider_style = {
  default_style = {
    draw_area   = false,
    arc_radius_1 = 10,
    arc_radius_2 = 10,
    arc_radius_3 = 10,
    arc_radius_4 = 10,
  }
}

-- label style
gui.label_style = {
  default_style = {
    draw_area   = false,
    draw_border = false,
    arc_radius_1 = 10,
    arc_radius_2 = 10,
    arc_radius_3 = 10,
    arc_radius_4 = 10,
  }
}

-- based on label_style
gui.button_style = {
  default_style  = {
    draw_area    = true,
    draw_border  = true,
    arc_radius_1 = 10,
    arc_radius_2 = 10,
    arc_radius_3 = 10,
    arc_radius_4 = 10,
  },
  hover_style    = {
    area_color   = {64, 64, 64, 255}
  }
}

-- default style
gui.default_style = {
  x                 = 0,
  y                 = 0,
  l                 = 1,
  h                 = 1,
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
  text_color        = {255,255,255,255},
  text_align        = "center",
  font              = love.graphics.newFont(24),
}
-- position
function gui.default_style:setPos(x, y)
  self.x, self.y = x, y
end
function gui.default_style:getPos()
  return self.x, self.y
end

-- dimensions
function gui.default_style:setDimensions(l, h)
  self.l, self.h = l, h
end
function gui.default_style:getDimensions()
  return self.l, self.h
end

-- visable
function gui.default_style:setVisable(state)
  self.visable = state
end
function gui.default_style:getVisable()
  return self.visable
end

-- line_width
function gui.default_style:setLineWidth(...)
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
function gui.default_style:getLineWidth()
  return self.line_width_top,
         self.line_width_bottom,
         self.line_width_left,
         self.line_width_right
end

-- arc width
function gui.default_style:setArcWidth(...)
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
function gui.default_style:getArcWidth()
  return self.arc_width_1,
         self.arc_width_2,
         self.arc_width_3,
         self.arc_width_4
end

-- arc radius
function gui.default_style:setArcRadius(...)
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
function gui.default_style:getArcRadius()
  return self.arc_radius_1,
         self.arc_radius_2,
         self.arc_radius_3,
         self.arc_radius_4
end

-- area color
function gui.default_style:setAreaColor(color_table)
  self.area_color = color_table
end
function gui.default_style:getAreaColor()
  return self.area_color
end

-- line color
function gui.default_style:setLineColor(...)
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
function gui.default_style:getLineColor()
  return self.line_color_top,
         self.line_color_right,
         self.line_color_bottom,
         self.line_color_left
end

-- arc color
function gui.default_style:setArcColor(...)
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
function gui.default_style:getLineColor()
  return self.arc_color_1,
         self.arc_color_2,
         self.arc_color_3,
         self.arc_color_4
end

-- set border
function gui.default_style:setBorder(state)
  self.draw_border = state
end
function gui.default_style:getBorder()
  return self.draw_border
end

-- set area
function gui.default_style:setArea(state)
  self.draw_area = state
end
function gui.default_style:getArea(state)
  return self.draw_area
end

-- border
function gui.default_style:setBorderWidth(n)
  self:setLineWidth(n)
  self:setArcWidth(n)
end
function gui.default_style:setBorderColor(color_table)
  self:setLineColor(color_table)
  self:setArcColor(color_table)
end
