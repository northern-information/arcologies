local graphics = {}

function graphics.init()
  graphics.temporary_message = ""
  graphics.tab_width = 5
  graphics.tab_height = 5
  graphics.tab_padding = 1
  graphics.structure_x = 94
  graphics.structure_y = 26
end

function graphics:get_tab_x(i)
  return (((self.tab_width + self.tab_padding) * i) - self.tab_width)
end

function graphics:top_menu()
  self:rect(0, 0, 128, 7)
  for i = 1,3 do
    self:rect(self:get_tab_x(i), self.tab_padding, self.tab_width, self.tab_height, 5)
  end
  self:top_message(graphics:playback(generation_fmod(4)))
end

function graphics:set_message(string, time)
  self.temporary_message = string
  counters.message = counters.ui.frame + time
end

function graphics:top_message(string)
  if is_deleting() then
    self.temporary_message = "DELETING..."
    counters.message = counters.ui.frame + 1
  end
  if counters.message > counters.ui.frame then
    self:text(20, 6, self.temporary_message, 0)
  else
    self:text(20, 6, string, 0)
  end
end

function graphics:panel()
  self:rect(54, 11, 88, 55)
end

function graphics:select_tab(i)
  self:rect(self:get_tab_x(i), self.tab_padding, self.tab_width, self.tab_height + 1, 0)
  self:mlrs(self:get_tab_x(i) + 2, 3, 1, 6)
end

function graphics:page_name(string)
  self:text_right(127, 6, string, 0)
end

function graphics:setup()
  screen.clear()
  screen.aa(0)
  self:reset_font()
end

function graphics:reset_font()
  screen.font_face(0)
  screen.font_size(8)
end

function graphics:teardown()
  screen.update()
end

function graphics:mlrs(x1, y1, x2, y2, level)
  screen.level(level or 15)  
  screen.move(x1, y1)
  screen.line_rel(x2, y2)
  screen.stroke()
end

function graphics:mls(x1, y1, x2, y2, level)
  screen.level(level or 15)  
  screen.move(x1, y1)
  screen.line(x2, y2)
  screen.stroke()
end

function graphics:rect(x, y, w, h, level)
  screen.level(level or 15)  
  screen.rect(x, y, w, h)
  screen.fill()
end

function graphics:circle(x, y, r, level)
  screen.level(level or 15)  
  screen.circle(x, y, r)
  screen.fill()
end

function graphics:text(x, y, string, level)
  if string == nil then return end
  screen.level(level or 15)  
  screen.move(x, y)
  screen.text(string)
end

function graphics:bpm(x, y, string, level)
  screen.level(level or 15)
  screen.move(x, y)
  screen.font_size(30)
  screen.text(string)
  self:reset_font()
end

function graphics:playback()
  self:top_message( 
    (params:get("playback") == 0) and 
      self:ready_animation(generation_fmod(10)) or 
      self:playing_animation(generation_fmod(4))
  )
end

function graphics:status(x, y, string, level)
  screen.level(level or 15)
  screen.move(x, y)
  screen.text(string)
  self:reset_font()
end

function graphics:text_right(x, y, string, level)
  screen.level(level or 15)  
  screen.move(x, y)
  screen.text_right(string)
end

function graphics:text_left(x, y, string, level)
  self:text(x, y, string, level)
end

function graphics:menu_highlight(i)
  self:rect(0, ((i - 1) * 8) + 12, 51, 7, 2)
end

function graphics:icon(x, y, string, invert)
  if invert == 0 then
    self:rect(x, y, 18, 18, 0)
    screen.level(15)
  else
    self:rect(x, y, 18, 18, 0)
    self:rect(x+1, y+1, 16, 16, 15)
    screen.level(0)
  end
  screen.move(x+2, y+15)
  screen.font_size(16)
  screen.text(string)
  self:reset_font()
end

function graphics:seed_selected(x, y)
  self:rect(x, y, 18, 18, 0)
end

function graphics:cell_id()
  -- self:text(2, 61, "CELL ID", 5)
  local id = "NONE"
  if keeper.is_cell_selected then
    id = keeper.selected_cell_id
  end
  self:text(56, 61, id, 0)
end

function graphics:structure_type(s)
    self:text(56, 18, s, 0)
end

function graphics:structure_enable()
  self:text(2, 18, dictionary.cell_attributes[1], 15)  
end

function graphics:structure_disable()
  self:text(2, 18, dictionary.cell_attributes[1], 5)
  self:mls(0, 16, 51, 15, 10)
end

function graphics:metabolism_enable()
    self:text(2, 26, dictionary.cell_attributes[2], 15)
    self:text(56, 25, params:get("page_metabolism"), 0)
end

function graphics:metabolism_disable()
  self:text(2, 26, dictionary.cell_attributes[2], 5)
  self:mls(0, 24, 51, 23, 10)
end

function graphics:sound_enable()
  self:text(2, 34, dictionary.cell_attributes[3], 15)
  graphics:text(56, 33, dictionary.sounds[params:get("page_sound")], 0)
end

function graphics:sound_disable()
  self:text(2, 34, dictionary.cell_attributes[3], 5)
  self:mls(0, 32, 51, 31, 10)
end

function graphics:velocity_enable()
  self:text(2, 42, dictionary.cell_attributes[4], 15)
  graphics:text(56, 41, dictionary.sounds[params:get("page_velocity")], 0)
end

function graphics:velocity_disable()
  self:text(2, 42, dictionary.cell_attributes[4], 5)
  self:mls(0, 40, 51, 39, 10)
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

function graphics:cell()
  local x = self.structure_x
  local y = self.structure_y
  self:left_wall(x, y)
  self:right_wall(x, y)
  self:roof(x, y)
  self:floor(x, y)
end

function graphics:hive()
  local x = self.structure_x
  local y = self.structure_y
  self:cell(x, y)
  self:third_floor(x, y)
  self:second_floor(x, y)
end

function graphics:gate()
  local x = self.structure_x
  local y = self.structure_y
  self:left_wall(x, y)
  self:right_wall(x, y)
  self:kasagi(x, y)
  self:roof(x, y)
  self:third_floor(x, y)
end

function graphics:shrine()
  local x = self.structure_x
  local y = self.structure_y
  self:left_wall(x, y)
  self:right_wall(x, y)
  self:roof(x, y)
  self:third_floor(x, y)
  self:mls(x+10, y+11, x+10, y+19, 0)
  self:mls(x+11, y+11, x+11, y+19, 0)
end

function graphics:draw_ports(adjust)
  local x = self.structure_x
  local y = self.structure_y
  local ports = ""
  if keeper.is_cell_selected then
    if keeper.selected_cell:is_port_open("n") then
      self:north_port(x, y, (adjust or 0))
      ports = ports .. "N"
    end
    if keeper.selected_cell:is_port_open("e") then
      self:east_port(x, y)
      ports = ports .. "E"
    end
    if keeper.selected_cell:is_port_open("s") then
      self:south_port(x, y)
      ports = ports .. "S"
    end
    if keeper.selected_cell:is_port_open("w") then
      self:west_port(x, y)
      ports = ports .. "W"
    end
    self:text(56, 52, ports, 0)
  end
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

function graphics:analysis()
  local hives = 5
  local gates = 10
  local shrines = 3
  local signals = 20
  local generation = generation()
  self:text_right(60, 18, dictionary.structures[1] .. "S", 5)
  self:text_right(60, 26, dictionary.structures[2] .. "S", 5)
  self:text_right(60, 34, dictionary.structures[3] .. "S", 5)
  self:text_right(60, 42, "SIGNALS", 5)
  self:text_right(60, 50, "GENERATION", 5)
  self:text(66, 18, hives, 15)
  self:text(66, 26, gates, 15)
  self:text(66, 34, shrines, 15)
  self:text(66, 42, signals, 15)
  self:text(66, 50, generation, 15)
  
end

function graphics:ready_animation(i)
  local f = {
    "....|....",
    "...|'|...",
    "..|...|..",
    ".|.....|.",
    "|.......|",
    "'|.....|'",
    "..|...|..",
    "...|.|...",
    "....|....",
    "....'...."
  }
  return f[i]
end

function graphics:playing_animation(i)
  local f = {
    ">",
    " >",
    "  >",
    "   >"
  }
  return f[i]
end

return graphics