local ui = {}

function ui.init()
  ui.tab_width = 5
  ui.tab_height = 5
  ui.tab_indicator_width = 1
  ui.tab_indicator_height = 6
  ui.tab_padding = 1
end

function ui:get_tab_x(i)
  return (((self.tab_width + self.tab_padding) * i) - self.tab_width)
end

function ui:top_menu()
  self.graphics:rect(0, 0, 128, 7)
end

function ui:top_menu_tabs()
  for i = 1,3 do
    self.graphics:rect(self:get_tab_x(i), self.tab_padding, self.tab_width, self.tab_height, self.graphics.levels["l"])
  end
end

function ui:select_tab(i)
  self.graphics:rect(self:get_tab_x(i), self.tab_padding, self.tab_width, self.tab_height + 1, self.graphics.levels["o"])
  self.graphics:mlrs(self:get_tab_x(i) + 2, 3, 1, 6)
end

function ui:top_message(string)
  self.graphics:text_right(127, 6, string, 0)
end


function ui.ready_animation(i)
  local f = {}
  f[0] = "....|...."
  f[1] = "...|'|..."
  f[2] = "..|...|.."
  f[3] = ".|.....|."
  f[4] = "|.......|"
  f[5] = "'|.....|'"
  f[6] = "..|...|.."
  f[7] = "...|.|..."
  f[8] = "....|...."
  f[9] = "....'...."
  return f[i % 10]
end

function ui.playing_animation(i)
  local f = {}
  f[0] = ">........"
  f[1] = "+>......."
  f[2] = ".->......"
  f[3] = "..+>....."
  f[4] = "...->...."
  f[5] = "....+>..."
  f[6] = ".....->.."
  f[7] = "......+>."
  f[8] = ".......->"
  f[9] = "........+"
  return f[i % 10]
end

return ui