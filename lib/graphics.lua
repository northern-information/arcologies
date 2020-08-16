local graphics = {}

function graphics.init()
  graphics.temporary_message = ""
  graphics.tab_width = 5
  graphics.tab_height = 5
  graphics.tab_padding = 1
  graphics.structure_x = 98
  graphics.structure_y = 22
  graphics.total_cells = fn.grid_height() * fn.grid_width()
  graphics.analysis_pixels = {}
  graphics.ui_wait_threshold = 0.5
  graphics.cell_attributes = Cell:new(0, 0, 0).attributes
end

function graphics:get_tab_x(i)
  return (((self.tab_width + self.tab_padding) * i) - self.tab_width)
end

function graphics:title_bar()
  self:rect(0, 0, 128, 7)
  for i = 1,#page.titles do
    self:rect(self:get_tab_x(i), self.tab_padding, self.tab_width, self.tab_height, 5)
  end
  self:top_message(graphics:playback(counters.generation_fmod(4)))
end

function graphics:set_message(string, time)
  self.temporary_message = string
  counters.message = counters.ui.frame + time
end

function graphics:top_message(string)
  if fn.is_deleting() then
    self.temporary_message = "DELETING..."
    counters.message = counters.ui.frame + 1
  end
  if counters.message > counters.ui.frame then
    self:text((#page.titles + 1) * self.tab_width + 2, 6, self.temporary_message, 0)
  else
    self:text((#page.titles + 1) * self.tab_width + 2, 6, string, 0)
  end
end

function graphics:top_message_cell_structure()
  if page.active_page ~= 2 then
    self:set_message(keeper.selected_cell.available_structures[keeper.selected_cell.structure], counters.default_message_length)
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
    (sound.playback == 0) and
      self:ready_animation(counters.ui_quarter_frame_fmod(10)) or
      self:playing_animation(counters.generation_fmod(4))
  )
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

function graphics:seed_selected(x, y)
  self:rect(x, y, 18, 18, 0)
end

function graphics:structure(string)
    self:text_center(107, 61, string, 0)
    if string == "HIVE" then
      self:hive()
    elseif string == "SHRINE" then
      self:shrine()
    elseif string == "GATE" then
      self:gate()
    elseif string == "RAVE" then
      self:rave()
    end
end

function graphics:left_wall(x, y)
  self:mls(x, y-1, x, y+25, 0)
  self:mls(x+1, y-1, x, y+25, 0)
end

function graphics:three_quarter_left_wall(x, y)
  self:mls(x, y+5, x, y+25, 0)
  self:mls(x+1, y+5, x, y+25, 0)
end

function graphics:right_wall(x, y)
  self:mls(x+20, y-1, x+20, y+25, 0)
  self:mls(x+21, y-1, x+20, y+25, 0)
end

function graphics:three_quarter_right_wall(x, y)
  self:mls(x+20, y+5, x+20, y+25, 0)
  self:mls(x+21, y+5, x+20, y+25, 0)
end

function graphics:kasagi(x, y)
  self:mls(x-5, y, x+25, y, 0)
  self:mls(x-5, y+1, x+25, y+1, 0)
end

function graphics:roof(x, y)
  self:mls(x, y, x+21, y, 0)
  self:mls(x, y+1, x+21, y+1, 0)
end

function graphics:third_floor(x, y)
  self:mls(x, y+6, x+21, y+6, 0)
  self:mls(x, y+7, x+21, y+7, 0)
end

function graphics:second_floor(x, y)
  self:mls(x, y+12, x+21, y+12, 0)
  self:mls(x, y+13, x+21, y+13, 0)
end

function graphics:floor(x, y)
  self:mls(x, y+18, x+21, y+18, 0)
  self:mls(x, y+19, x+21, y+19, 0)
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

function graphics:gate()
  local x = self.structure_x
  local y = self.structure_y
  self:three_quarter_left_wall(x, y)
  self:three_quarter_right_wall(x, y)
  self:kasagi(x, y)
  self:third_floor(x, y)
  self:second_floor(x, y)
end

function graphics:rave()
  local x = self.structure_x
  local y = self.structure_y
  self:left_wall(x, y)
  self:three_quarter_right_wall(x, y)
  self:roof(x, y)
  self:third_floor(x, y)
end

function graphics:draw_ports()
  local x = self.structure_x
  local y = self.structure_y
  if keeper.is_cell_selected then
    if keeper.selected_cell:is_port_open("n") then
      self:north_port(x, y)
    end
    if keeper.selected_cell:is_port_open("e") then
      self:east_port(x, y)
    end
    if keeper.selected_cell:is_port_open("s") then
      self:south_port(x, y)
    end
    if keeper.selected_cell:is_port_open("w") then
      self:west_port(x, y)
    end
  end
end

function graphics:north_port(x, y)
  self:rect(x+9, y-7, 2, 4, 0)
  self:rect(x+8, y-5, 4, 2, 0)
end

function graphics:east_port(x, y)
  self:rect(x+23, y+11, 4, 2, 0)
  self:rect(x+23, y+10, 2, 4, 0)
end

function graphics:south_port(x, y)
  self:rect(x+9, y+26, 2, 4, 0)
  self:rect(x+8, y+26, 4, 2, 0)
end

function graphics:west_port(x, y)
  self:rect(x-7, y+11, 4, 2, 0)
  self:rect(x-5, y+10, 2, 4, 0)
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
    menu_item = i ~= 4 and Cell:new(0, 0, 0).available_structures[i] .. "S" or "SIGNALS"
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
        if v.structure == selected_item and v.index == i then
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
  local x = 56
  local y = 35
  local key_width = 8
  local key_height = 27

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
      self:rect(x + ((keys[i]["index"] - 1 + adjust) * key_width) + 6, y, 6, key_height - 10, 0)
      if keys[i]["selected"] then
        self:rect(x + ((keys[i]["index"] - 1 + adjust) * key_width) + 8, y + 2, 2, key_height - 14, 5)
      end
    end
  end
  self:rect(x + (7 * key_width), y, 2, key_height, 0) -- end

  -- note readout
  screen.font_size(30)
  self:text(55, 32, keeper.selected_cell:get_note_name(), 0, 10)
  self:reset_font()
end

function graphics:seed()
  local seed = params:get("seed")
  if seed == 0 then
    screen.font_size(24)
    self:text(55, 32, "ABORT", 0)
  else
    screen.font_size(30)
    self:text(55, 32, params:get("seed"), 0)
  end
  self:reset_font()
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