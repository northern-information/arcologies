local graphics = {}

function graphics.init()
  graphics.ni_frame = 0
  graphics.temporary_message_on = false
  graphics.temporary_message = ""
  graphics.tab_width = 5
  graphics.tab_height = 5
  graphics.tab_padding = 1
  graphics.structure_x = 98
  graphics.structure_y = 20
  graphics.total_cells = fn.grid_height() * fn.grid_width()
  graphics.analysis_pixels = {}
  graphics.ui_wait_threshold = 0.5
  graphics.cell_attributes = Cell:new(0, 0, 0).attributes
end

function graphics:time(x, y)
  local o = 3
  local m = sound.meter
  local b = counters.this_beat()
  -- print(b .. "/" .. m)
  for i = 1,m do
    self:ps((i * o) + x, y, (b == i) and 5 or 0)
  end
  if keeper.is_cell_selected then
    local x2 = x
    local y2 = y + 3
    local meta = keeper.selected_cell.metabolism
    local off =  keeper.selected_cell.offset
    -- print(fn.cycle(b % meta, 1, meta))
    for i = 1,meta do
      self:ps(((i + off)* o) + x2, y2, ((fn.cycle(b % meta, 1, meta)) == i) and 5 or 0)
    end
  end
end


function graphics:get_tab_x(i)
  return (((self.tab_width + self.tab_padding) * i) - self.tab_width)
end

function graphics:title_bar_and_tabs()
  self:rect(0, 0, 128, 7)
  for i = 1,#page.titles do
    self:rect(self:get_tab_x(i), self.tab_padding, self.tab_width, self.tab_height, 5)
  end
  self:select_tab(page.active_page)
  self:top_message()
  self:page_name()
end

function graphics:set_message(string, time)
  self.temporary_message_on = true
  self.temporary_message = string
  counters.message = counters.ui.frame + time
end

function graphics:top_message()
  local message = ""
  if counters.message > counters.ui.frame then
    message = self.temporary_message
  else
    self.temporary_message_on = false
    if sound.playback == 0 then
      message = self:ready_animation(counters.ui_quarter_frame_fmod(10))
    else
      self:time(#page.titles * (self.tab_padding + self.tab_width), 2)
      -- message = counters.this_beat() .. " " .. self:playing_animation(counters.generation_fmod(4))
    end
  end
  self:text((#page.titles + 1) * self.tab_width + 2, 6, message, 0)
end

function graphics:top_message_cell_structure()
  if page.active_page ~= 2 then
    self:set_message(keeper.selected_cell.structure_value, counters.default_message_length)
  end
end

function graphics:panel()
  self:rect(54, 11, 88, 55)
end

function graphics:select_tab(i)
  self:rect(self:get_tab_x(i), self.tab_padding, self.tab_width, self.tab_height + 1, 0)
  self:mlrs(self:get_tab_x(i) + 2, 3, 1, 6)
end

function graphics:page_name()
  if self.temporary_message_on then
    -- empty
  elseif page.active_page == 2 and keeper.is_cell_selected then
    self:text_right(127, 6, keeper.selected_cell.structure_value, 0)
  else
    self:text_right(127, 6, page.titles[page.active_page], 0)
  end
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

function graphics:ps(x, y, level)
  screen.level(level or 15)
  screen.pixel(x, y)
  screen.stroke(s)
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

function graphics:playback_icon(x, y)
  if sound.playback == 0 then
    self:icon(x, y, "||", 1)
  else
    self:icon(x, y, counters.generation_fmod(sound.meter), (counters.generation_fmod(sound.meter) == 1) and 1 or 0)
  end
end

function graphics:status(x, y, string, level)
  screen.level(level or 15)
  screen.move(x, y)
  screen.text(string)
  self:reset_font()
end

function graphics:text_center(x, y, string, level)
  screen.level(level or 15)
  screen.move(x, y)
  screen.text_center(string)
end

function graphics:text_right(x, y, string, level)
  screen.level(level or 15)
  screen.move(x, y)
  screen.text_right(string)
end

function graphics:text_left(x, y, string, level)
  self:text(x, y, string, level)
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
  screen.move(x+1, y+15)
  screen.font_size(16)
  screen.text(string)
  self:reset_font()
end

function graphics:structure_and_title(string)
    if string == "HIVE" then
      glyphs:hive(self.structure_x, self.structure_y, 0)
    elseif string == "SHRINE" then
      glyphs:shrine(self.structure_x, self.structure_y, 0)
    elseif string == "GATE" then
      glyphs:gate(self.structure_x, self.structure_y, 0)
    elseif string == "RAVE" then
      glyphs:rave(self.structure_x, self.structure_y, 0)
    end
end

function graphics:draw_ports()
  if keeper.is_cell_selected then
    if keeper.selected_cell:is_port_open("n") then
      glyphs:north_port(self.structure_x, self.structure_y, 0)
    end
    if keeper.selected_cell:is_port_open("e") then
      glyphs:east_port(self.structure_x, self.structure_y, 0)
    end
    if keeper.selected_cell:is_port_open("s") then
      glyphs:south_port(self.structure_x, self.structure_y, 0)
    end
    if keeper.selected_cell:is_port_open("w") then
      glyphs:west_port(self.structure_x, self.structure_y, 0)
    end
  end
end

function graphics:analysis(selected_item)
  local chart = {}
  chart.values = {}
  chart.values[1] = keeper:count_cells(1)
  chart.values[2] = keeper:count_cells(2)
  chart.values[3] = keeper:count_cells(3)
  chart.values[4] = #keeper.signals
  chart.values_total = 0
  for i = 1, #chart.values do chart.values_total = chart.values_total + chart.values[i] end
  chart.percentages = {}
  for i = 1, #chart.values do chart.percentages[i] = chart.values[i] / chart.values_total end
  chart.degrees = {}
  for i = 1, #chart.percentages do chart.degrees[i] = chart.percentages[i] * 360 end


  local pie_chart_x = 22
  local pie_chart_y = 30
  local pie_chart_r = 20
  local total_degrees = 0
  local text_degrees = 1
  local percent = 0
  local spacing = 10
  local pie_highlight = 0
  self:circle(pie_chart_x, pie_chart_y, pie_chart_r, 15)
  self:circle(pie_chart_x, pie_chart_y, pie_chart_r - 1, 0)
  if #keeper.cells + #keeper.signals > 0 then
    for i = 1, #chart.percentages do
      total_degrees = total_degrees + chart.degrees[i]
      text_degrees = text_degrees + chart.degrees[i] -- / 2
      sector_x = math.cos(math.rad(total_degrees)) * pie_chart_r
      sector_y = math.sin(math.rad(total_degrees)) * pie_chart_r
      self:mlrs(pie_chart_x, pie_chart_y, sector_x, sector_y, 15)
      text_x = math.cos(math.rad(text_degrees)) * pie_chart_r
      text_y = math.sin(math.rad(text_degrees)) * pie_chart_r
      pie_highlight = (i == selected_item) and 15 or 3
      self:rect(pie_chart_x + text_x, pie_chart_y + text_y, screen.text_extents(chart.values[i]) + 2, 7, pie_highlight)
      self:text_left(pie_chart_x + text_x + 1, pie_chart_y + text_y + 6, chart.values[i], 0)
    end
  end

  -- line graph
  local line_graph_start_x = 56
  local line_graph_start_y = 43
  local line_graph_spacing = 2
  local line_graph_y = 0
  local line_highlight = 0
  for i = 1, 4 do
    if chart.values[i] ~= 0 then
      line_highlight = (i == selected_item) and 15 or 3
      line_graph_y = line_graph_start_y + ((i - 1) * line_graph_spacing)
      self:mls(line_graph_start_x, line_graph_y, line_graph_start_x + chart.percentages[i] * 100, line_graph_y, line_highlight)
    end
  end

  -- menu
  local menu_item_start = 0
  local menu_item_x = 0
  local menu_item_y = 64
  local menu_item = ""
  local menu_item_width = 0
  local menu_item_spacing =  6
  local menu_highlight = 0
  for i = 1, 4 do
    menu_highlight = (i == selected_item) and 15 or 5
    menu_item = i ~= 4 and Cell:new().structures[i] .. "S" or "SIGNALS"
    menu_item_width = screen.text_extents(menu_item)
    menu_item_x = menu_item_start + ((i - 1) * menu_item_spacing)
    graphics:text(menu_item_x, menu_item_y, menu_item, menu_highlight)
    menu_item_start = menu_item_start + menu_item_width
  end

  -- grid (thank you @okyeron)
  for i = 1, fn.grid_width() * fn.grid_height() do
    self.analysis_pixels[i] = 0
    if selected_item ~= 4 then
      for k,v in pairs(keeper.cells) do
        if v.structure_key == selected_item and v.index == i then
          self.analysis_pixels[i] = 15
        end
      end
    elseif selected_item == 4 then
      for k,v in pairs(keeper.signals) do
        if v.index == i then
          self.analysis_pixels[i] = 15
        end
      end
    end
  end
  screen.level(1)
  for x = 1, fn.grid_width(), 1 do
    for y = 1, fn.grid_height(), 1 do
      pidx = x + ((y - 1) * fn.grid_width())
      self:draw_pixel(x, y, self.analysis_pixels[pidx])
    end
  end
  screen.stroke()
  -- more data
  self:text(106, 18, counters.music.generation, 1)
  self:playback_icon(105, 19)
  fn.dirty_grid(true)
end

function graphics:draw_pixel(x, y, b)
  local offset = { x = 54, y = 11, spacing = 3 }
  pidx = x + ((y - 1) * fn.grid_width())
  if self.analysis_pixels[pidx] > 0 then
    screen.stroke()
    screen.level(b)
  end
  screen.pixel((x * offset.spacing) + offset.x, (y * offset.spacing) + offset.y)
  if self.analysis_pixels[pidx] > 0 then
    screen.stroke()
    screen.level(1)
  end
end

function graphics:piano(k)
  local selected = (k % 12) + 1
  local x = 29
  local y = 12
  local key_width = 10
  local key_height = 30

  --[[ have to draw the white keys first becuase the black are then drawn on top
  so this is a super contrived way of drawing a piano with two loops...
  the only alternative i could think of was to elegantly draw all the keys
  in one pass but then make all these ugly highlights on top for the selected
  with a second pass. this route was the most maintainable and dynamic...
  here, "index" is where the piano key is on the the white or black color index]]
  local keys = {}
  for i = 1,12 do keys[i] = {} end
  keys[1]  = { ["color"] = 1, ["index"] = 1 } -- c
  keys[2]  = { ["color"] = 0, ["index"] = 1 } -- c#
  keys[3]  = { ["color"] = 1, ["index"] = 2 } -- d
  keys[4]  = { ["color"] = 0, ["index"] = 2 } -- d#
  keys[5]  = { ["color"] = 1, ["index"] = 3 } -- e
  keys[6]  = { ["color"] = 1, ["index"] = 4 } -- f
  keys[7]  = { ["color"] = 0, ["index"] = 3 } -- f#
  keys[8]  = { ["color"] = 1, ["index"] = 5 } -- g
  keys[9]  = { ["color"] = 0, ["index"] = 4 } -- g#
  keys[10] = { ["color"] = 1, ["index"] = 6 } -- a
  keys[11] = { ["color"] = 0, ["index"] = 5 } -- a#
  keys[12] = { ["color"] = 1, ["index"] = 7 } -- b
  keys[selected]["selected"] = true

  -- white keys
  for i = 1,12 do
    if keys[i]["color"] == 1 then
      self:rect(x + ((keys[i]["index"] - 1) * key_width), y, key_width, key_height, 0)
      self:rect(x + ((keys[i]["index"] - 1) * key_width) + 2, y + 2, key_width - 2, key_height - 4, keys[i]["selected"] and 5 or 15)
    end
  end

  -- black keys
  for i = 1,12 do
    if keys[i]["color"] == 0 then
      local adjust = keys[i]["index"] > 2 and 1 or 0 -- e# doesn't exist! yeah yeah...
      self:rect(x + ((keys[i]["index"] - 1 + adjust) * key_width) + 8, y, 6, key_height - 10, 0)
      if keys[i]["selected"] then
        self:rect(x + ((keys[i]["index"] - 1 + adjust) * key_width) + 10, y + 2, 2, key_height - 14, 5)
      end
    end
  end
  self:rect(x + (7 * key_width), y, 2, key_height, 0) -- end

  -- note readout
  screen.font_size(30)
  self:text_center(64, 64, keeper.selected_cell:get_note_name(), 15, 10)
  self:reset_font()
end

function graphics:structure_palette(i)
  self:rect(((i - 1) * 15) + 1, 12, 13, 13, 15)
  glyphs:small_hive(5, 15, i == 1 and 0 or 15)
  glyphs:small_shrine(20, 15, i == 2 and 0 or 15)
  glyphs:small_gate(35, 15, i == 3 and 0 or 15)
  glyphs:small_rave(50, 15, i == 4 and 0 or 15)
end

function graphics:seed()
  local seed = params:get("seed")
  if seed == 0 then
    screen.font_size(42)
    self:text_center(64, 50, "ABORT", 15)
  else
    screen.font_size(42)
    self:text_center(64, 50, params:get("seed"), 15)
  end
  self:reset_font()
end

function graphics:deleting_all(timer)
  screen.font_size(16)
  self:text_center(64, 28, "DELETING ALL", 15)
  screen.font_size(32)
  self:text_left(14, 54, timer .. "." .. math.random(1, 10) .. math.random(1, 10), 15)
  self:reset_font()
end

function graphics:select_a_cell()
  self:panel()
  self:text(64, 33, "SELECT", 0)
  self:text(64, 43, "A CELL", 0)
  glyphs:cell(self.structure_x, self.structure_y, 0)
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

function graphics:splash()
  local col_x = -55
  local row_x = 123
  local y = 45
  local l = counters.ui.frame >= 89 and 0 or 15  
  col_x = col_x + self.ni_frame
  row_x = row_x - self.ni_frame
  if counters.ui.frame >= 89 then
    self:rect(0, 0, 128, 50, 15)
  end
  self:n_col(col_x, y, l)
  self:n_col(col_x+20, y, l)
  self:n_col(col_x+40, y, l)
  self:n_row_top(row_x, y, l)
  self:n_row_top(row_x+20, y, l)
  self:n_row_top(row_x+40, y, l)
  self:n_row_bottom(row_x+9, y+37, l)
  self:n_row_bottom(row_x+29, y+37, l)
  if counters.ui.frame >= 89 then
    self:text_center(64, 60, "NORTHERN INFORMATION")
  end
  if counters.ui.frame < 90 then
    self.ni_frame = self.ni_frame + 1  
    fn.dirty_screen(true)
  end
  if counters.ui.frame == 160 or fn.break_splash() then
    fn.break_splash(true)
    page:select(1)
  end
end

function graphics:n_col(x, y, l)
  self:mls(x, y, x+12, y-40, l)
  self:mls(x+1, y, x+13, y-40, l)
  self:mls(x+2, y, x+14, y-40, l)
  self:mls(x+3, y, x+15, y-40, l)
  self:mls(x+4, y, x+16, y-40, l)
  self:mls(x+5, y, x+17, y-40, l)
end

function graphics:n_row_top(x, y, l)
  self:mls(x+20, y-39, x+28, y-39, l)
  self:mls(x+20, y-38, x+28, y-38, l)
  self:mls(x+19, y-37, x+27, y-37, l)
  self:mls(x+19, y-36, x+27, y-36, l)
end

function graphics:n_row_bottom(x, y, l)
  self:mls(x+21, y-40, x+29, y-40, l)
  self:mls(x+20, y-39, x+28, y-39, l)
  self:mls(x+20, y-38, x+28, y-38, l)  
  self:mls(x+19, y-37, x+27, y-37, l)
end


return graphics