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
  graphics.reset_font()
end

function graphics.reset_font()
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

function graphics:bpm(x, y, string, level)
  screen.level(level or graphics.levels["h"])
  screen.move(x, y)
  screen.font_size(30)
  screen.text(string)
  graphics.reset_font()
end

function graphics:status(x, y, string, level)
  screen.level(level or graphics.levels["h"])
  screen.move(x, y)
  screen.text(string)
  graphics.reset_font()
end

function graphics:text_right(x, y, string, level)
  screen.level(level or graphics.levels["h"])  
  screen.move(x, y)
  screen.text_right(string)
end

function graphics:text_left(x, y, string, level)
  self:text(x, y, string, level)
end

function graphics:a(x, y)
  self:kasagi(x, y)
  self:right_wall(x, y)
  self:roof(x, y)
  self:second_floor(x,y)
  self:floor(x, y)
  self:mls(x, y+11, x, y+19)
  self:mls(x+1, y+11, x+1, y+19)
end

function graphics:left_wall(x, y)
  self:mls(x, y-1, x, y+25, 0)
  self:mls(x+1, y-1, x, y+25, 0)
end

function graphics:right_wall(x, y)
  self:mls(x+20, y-1, x+20, y+25, 0)
  self:mls(x+21, y-1, x+20, y+25, 0)
end


function graphics:kasagi(x, y)
  self:mls(x-5, y-6, x+25, y-6, 0)
  self:mls(x-5, y-5, x+25, y-5, 0)
end

function graphics:roof(x, y)
  self:mls(x, y, x+20, y, 0)
  self:mls(x, y+1, x+20, y+1, 0)
end

function graphics:third_floor(x, y)
  self:mls(x, y+6, x+20, y+6, 0)
  self:mls(x, y+7, x+20, y+7, 0)
end

function graphics:second_floor(x, y)
  self:mls(x, y+12, x+20, y+12, 0)
  self:mls(x, y+13, x+20, y+13, 0)
end

function graphics:floor(x, y)
  self:mls(x, y+18, x+20, y+18, 0)
  self:mls(x, y+19, x+20, y+19, 0)  
end

function graphics:foundation(x, y)
  self:mls(x-5, y+24, x+25, y+24, 0)
  self:mls(x-5, y+25, x+25, y+25, 0)
end

function graphics:cell(x, y)
  self:left_wall(x, y)
  self:right_wall(x, y)
  self:roof(x, y)
  self:floor(x, y)
end

function graphics:hive(x, y)
  self:cell(x, y)
  self:third_floor(x, y)
  self:second_floor(x, y)
end

function graphics:gate(x, y)
  self:left_wall(x, y)
  self:right_wall(x, y)
  self:kasagi(x, y)
  self:roof(x, y)
  self:third_floor(x, y)
end

function graphics:shrine(x, y)
  self:left_wall(x, y)
  self:right_wall(x, y)
  self:roof(x, y)
  self:third_floor(x, y)
  self:mls(x+10, y+11, x+10, y+19, 0)
  self:mls(x+11, y+11, x+11, y+19, 0)
end

function graphics:north_port(x, y, adjust)
  self:rect(x+9, y-8 + adjust, 2, 4, 0)
  self:rect(x+8, y-6 + adjust, 4, 2, 0)
end

function graphics:east_port(x, y)
  self:rect(x+24, y+11, 4, 2, 0)
  self:rect(x+24, y+10, 2, 4, 0)
end

function graphics:south_port(x, y)
  self:rect(x+9, y+26, 2, 4, 0)
  self:rect(x+8, y+26, 4, 2, 0)
end

function graphics:west_port(x, y)
  self:rect(x-8, y+11, 4, 2, 0)
  self:rect(x-6, y+10, 2, 4, 0)
end

function graphics:panel_static()
  local pixel_density = 15
  local line_density = 10
  if (params:get("Static") == 1) then 
    for x = 54, 128 do
      for y = 12, 64 do
        if (math.random(0, 100) <= line_density) then
          self:mls(54, y, 128, y, math.random(8,10))
        end
        if (math.random(0, 100) <= pixel_density) then
          screen.level(math.random(13,15))
          screen.pixel(x, y)
          screen.fill()
        end
      end
    end
  end
end

function graphics:top_menu_static()
  local pixel_density = 15
  local line_density = 10
  if (params:get("Static") == 1) then 
    for x = 1, 128 do
      for y = 1, 6 do
        if (math.random(0, 100) <= line_density) then
          self:mls(1, y, 128, y, math.random(8,10))
        end
        if (math.random(0, 100) <= pixel_density) then
          screen.level(math.random(13,15))
          screen.pixel(x, y)
          screen.fill()
        end
      end
    end
  end
end


return graphics