local graphics = {}

function graphics.init()
  graphics.levels = {}
  graphics.levels["o"] = 0
  graphics.levels["l"] = 5
  graphics.levels["m"] = 10
  graphics.levels["h"] = 15
end

function graphics.setup()
  screen.clear()
  screen.aa(0)
  screen.font_face(0)
  screen.font_size(8)
end

function graphics.teardown()
  screen.update()
end

function graphics:mlrs(x1, y1, x2, y2, level)
  screen.level(level or graphics.levels["h"])  
  screen.move(x1, y1)
  screen.line_rel(x2, y2)
  screen.stroke()
end

function graphics:mls(x1, y1, x2, y2, level)
  screen.level(level or graphics.levels["h"])  
  screen.move(x1, y1)
  screen.line(x2, y2)
  screen.stroke()
end

function graphics:rect(x, y, w, h, level)
  screen.level(level or graphics.levels["h"])  
  screen.rect(x, y, w, h)
  screen.fill()
end

function graphics:circle(x, y, r, level)
  screen.level(level or graphics.levels["h"])  
  screen.circle(x, y, r)
  screen.fill()
end

function graphics:text(x, y, string, level)
  screen.level(level or graphics.levels["h"])  
  screen.move(x, y)
  screen.text(string)
end

function graphics:text_right(x, y, string, level)
  screen.level(level or graphics.levels["h"])  
  screen.move(x, y)
  screen.text_right(string)
end

function graphics:text_left(x, y, string, level)
  self:text(x, y, string, level)
end

function graphics:walls(x, y)
  self:mls(x, y-1, x, y+25)
  self:mls(x+1, y-1, x, y+25)
  self:mls(x+20, y-1, x+20, y+25)
  self:mls(x+21, y-1, x+20, y+25)
end

function graphics:kasagi(x, y)
  self:mls(x-5, y-6, x+25, y-6)
  self:mls(x-5, y-5, x+25, y-5)
end

function graphics:roof(x, y)
  self:mls(x, y, x+20, y)
  self:mls(x, y+1, x+20, y+1)
end

function graphics:third_floor(x, y)
  self:mls(x, y+6, x+20, y+6)
  self:mls(x, y+7, x+20, y+7)
end

function graphics:second_floor(x, y)
  self:mls(x, y+12, x+20, y+12)
  self:mls(x, y+13, x+20, y+13)
end

function graphics:floor(x, y)
  self:mls(x, y+18, x+20, y+18)
  self:mls(x, y+19, x+20, y+19)  
end

function graphics:foundation(x, y)
  self:mls(x-5, y+24, x+25, y+24)
  self:mls(x-5, y+25, x+25, y+25)
end

function graphics:cell(x, y)
  self:walls(x, y)
  self:roof(x, y)
  self:floor(x, y)
end

function graphics:hive(x, y)
  self:cell(x, y)
  self:third_floor(x, y)
  self:second_floor(x, y)
end

function graphics:gate(x, y)
  self:walls(x, y)
  self:kasagi(x, y)
  self:roof(x, y)
  self:third_floor(x, y)
end

function graphics:shrine(x, y)
  self:walls(x, y)
  self:roof(x, y)
  self:third_floor(x, y)
  self:mls(x+10, y+11, x+10, y+19)
  self:mls(x+11, y+11, x+11, y+19)
end

return graphics