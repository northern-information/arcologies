local graphics = {}

function graphics.init()
  graphics.levels = {}
  graphics.levels["o"] = 0
  graphics.levels["l"] = 5
  graphics.levels["m"] = 10
  graphics.levels["h"] = 15
  graphics.tab_width = 5
  graphics.tab_height = 5
  graphics.tab_padding = 1
  graphics.pixel_density = 15
  graphics.line_density = 5
  graphics.rows_start = 20
  graphics.structure_x = 94
  graphics.structure_y = 26
  graphics:reset_frames()
end

function graphics:reset_frames()
  graphics.top_menu_frame = {}
  graphics.top_menu_frame["lines"] = {}
  graphics.top_menu_frame["noise"] = {}
  graphics.panel_frame = {}
  graphics.panel_frame["lines"] = {}
  graphics.panel_frame["noise"] = {}
end

function graphics:ui()
  self:top_menu()
  self:top_menu_tabs()
  self:panel()
end

function graphics:get_tab_x(i)
  return (((self.tab_width + self.tab_padding) * i) - self.tab_width)
end

function graphics:top_menu()
  self:rect(0, 0, 128, 7)
end

function graphics:top_menu_tabs()
  for i = 1,3 do
    self:rect(self:get_tab_x(i), self.tab_padding, self.tab_width, self.tab_height, self.levels["l"])
  end
end

function graphics:panel()
  self:rect(54, 11, 88, 55)
end

function graphics:select_tab(i)
  self:rect(self:get_tab_x(i), self.tab_padding, self.tab_width, self.tab_height + 1, self.levels["o"])
  self:mlrs(self:get_tab_x(i) + 2, 3, 1, 6)
end

function graphics:top_message(string)
  self:text_right(127, 6, string, 0)
end

function graphics:setup()
  screen.clear()
  screen.aa(0)
  graphics:reset_font()
end

function graphics:reset_font()
  screen.font_face(0)
  screen.font_size(8)
end

function graphics:teardown()
  screen.update()
end

function graphics:mlrs(x1, y1, x2, y2, level)
  screen.level(level or self.levels["h"])  
  screen.move(x1, y1)
  screen.line_rel(x2, y2)
  screen.stroke()
end

function graphics:mls(x1, y1, x2, y2, level)
  screen.level(level or self.levels["h"])  
  screen.move(x1, y1)
  screen.line(x2, y2)
  screen.stroke()
end

function graphics:rect(x, y, w, h, level)
  screen.level(level or self.levels["h"])  
  screen.rect(x, y, w, h)
  screen.fill()
end

function graphics:circle(x, y, r, level)
  screen.level(level or self.levels["h"])  
  screen.circle(x, y, r)
  screen.fill()
end

function graphics:text(x, y, string, level)
  if string == nil then return end
  screen.level(level or self.levels["h"])  
  screen.move(x, y)
  screen.text(string)
end

function graphics:bpm(x, y, string, level)
  screen.level(level or self.levels["h"])
  screen.move(x, y)
  screen.font_size(30)
  screen.text(string)
  self:reset_font()
end

function graphics:status(x, y, string, level)
  screen.level(level or self.levels["h"])
  screen.move(x, y)
  screen.text(string)
  self:reset_font()
end

function graphics:text_right(x, y, string, level)
  screen.level(level or self.levels["h"])  
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
    self:rect(x, y, 18, 18, self.levels["o"])
    screen.level(self.levels["h"])
  else
    self:rect(x, y, 18, 18, self.levels["o"])
    self:rect(x+1, y+1, 16, 16, self.levels["h"])
    screen.level(self.levels["o"])
  end
  screen.move(x+2, y+15)
  screen.font_size(16)
  screen.text(string)
  self:reset_font()
end

function graphics:seed_selected(x, y)
  self:rect(x, y, 18, 18, 0)
end

function graphics:cell_id(selected_cell)
  local id = "NONE"
  if keeper.is_cell_selected then
    id = keeper.selected_cell_id
  end
  self:text(56, 63, id, 0)
end

function graphics:structure_type(s)
    self:text(56, 18, s, 0)
end

function graphics:structure_enable()
  self:text(2, 18, "STRUCTURE", 15)  
end

function graphics:structure_disable()
  self:text(2, 18, "STRUCTURE", self.levels["l"])
  self:mls(0, 16, 51, 15, self.levels["m"])
end

function graphics:metabolism_enable()
    self:text(2, 26, "METABOLISM", self.levels["h"])
end

function graphics:metabolism_disable()
  self:text(2, 26, "METABOLISM", self.levels["l"])
  self:mls(0, 24, 51, 23, self.levels["m"])
end

function graphics:sound_enable()
  self:text(2, 34, "SOUND", self.levels["h"])
end

function graphics:sound_disable()
  self:text(2, 34, "SOUND", self.levels["l"])
  self:mls(0, 32, 51, 31, self.levels["m"])
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
  self:text(56, 55, "NESW", 0)
  self:north_port(x, y, (adjust or 0))
  self:east_port(x, y)
  self:south_port(x, y)
  self:west_port(x, y)
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
    ">........",
    "+>.......",
    ".->......",
    "..+>.....",
    "...->....",
    "....+>...",
    ".....->..",
    "......+>.",
    ".......->",
    "........+"
  }
  return f[i]
end

function graphics:enc_confirm_animation(i)
  local f = {
    " ",
    ">",
    ">>",
    "9>>",
    " 9>>",
    "> 9>>",
    ">> 9>",
    "8>> 9",
    " 8>> ",
    "> 8>>",
    ">> 8>",
    "7>> 8",
    " 7>> ",
    "> 7>>",
    ">> 7>",
    "6>> 7",
    " 6>> ",
    "> 6>>",
    ">> 6>",
    "5>> 6",
    " 5>> ",
    "> 5>>",
    "4> 5>",
    "!4> 5",
    " !4> ",
    "> !4>",
    "3> !4",
    "!3> !",
    "> !3>",
    "2> !3",
    "!2> !",
    " !2> ",
    "> !2>",
    "1> !2>",
    "!1> !2",
    " !1> !",
    "  !1> ",
    "! !1>",
    "!! !1",
    "!!! !",
    "!!!! ",
    "!!!!!",
    "DONE!"
  }
  return f[i]
end

return graphics