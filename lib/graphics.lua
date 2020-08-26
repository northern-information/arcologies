local graphics = {}

function graphics.init()
  graphics.ni_frame = 0
  graphics.temporary_message_on = false
  graphics.temporary_message = ""
  graphics.tab_width = 5
  graphics.tab_height = 5
  graphics.tab_padding = 1
  graphics.structure_x = 98
  graphics.structure_y = 24
  graphics.total_cells = fn.grid_height() * fn.grid_width()
  graphics.analysis_pixels = {}
  graphics.ui_wait_threshold = 0.5
  graphics.cell_attributes = config.attributes
end

function graphics:structure_and_title(s)
    local x = self.structure_x
    local y = self.structure_y
    local l = 0
        if s == "HIVE"     then glyphs:hive(x, y, l)
    elseif s == "SHRINE"   then glyphs:shrine(x, y, l)
    elseif s == "GATE"     then glyphs:gate(x, y, l)
    elseif s == "RAVE"     then glyphs:rave(x, y, l)
    elseif s == "TOPIARY"  then glyphs:topiary(x, y, l)
    elseif s == "DOME"     then glyphs:dome(x, y, l)
    elseif s == "MAZE"     then glyphs:maze(x, y, l)
    elseif s == "CRYPT"    then glyphs:crypt(x, y, l)
    elseif s == "VALE"     then glyphs:vale(x, y, l)
    elseif s == "SOLARIUM" then glyphs:solarium(x, y, l)
    end
end

function graphics:structure_palette(i)
  -- todo refactor
  local row = i > 8 and 15 or 0
  local i = i > 8 and i - 8 or i
  self:rect(((i - 1) * 15) + 1, 12 + row, 13, 13, 15)
  -- row 1
  glyphs:small_hive(     5, 15, (i == 1 and row == 0) and 0 or 15)
  glyphs:small_shrine(  20, 15, (i == 2 and row == 0) and 0 or 15)
  glyphs:small_gate(    35, 15, (i == 3 and row == 0) and 0 or 15)
  glyphs:small_rave(    50, 15, (i == 4 and row == 0) and 0 or 15)
  glyphs:small_topiary( 65, 15, (i == 5 and row == 0) and 0 or 15)
  glyphs:small_dome(    80, 15, (i == 6 and row == 0) and 0 or 15)
  glyphs:small_maze(    95, 15, (i == 7 and row == 0) and 0 or 15)
  glyphs:small_crypt(  110, 15, (i == 8 and row == 0) and 0 or 15)
  -- row 2
  glyphs:small_vale(     5, 30, (i == 1 and row == 15) and 0 or 15)
  glyphs:small_solarium(20, 30, (i == 2 and row == 15) and 0 or 15)
end

function graphics:structure_palette_analysis(x, y, o, name)
  glyphs:small_signal(  x + (o * 0),  y, name == "SIGNALS" and 15 or 5)
  glyphs:small_hive(    x + (o * 3),  y, name == "HIVE" and 15 or 5)
  glyphs:small_shrine(  x + (o * 6),  y, name == "SHRINE" and 15 or 5)
  glyphs:small_gate(    x + (o * 9),  y, name == "GATE" and 15 or 5)
  glyphs:small_rave(    x + (o * 12), y, name == "RAVE" and 15 or 5)
  glyphs:small_topiary( x + (o * 15), y, name == "TOPIARY" and 15 or 5)
  glyphs:small_dome(    x + (o * 18), y, name == "DOME" and 15 or 5)
  glyphs:small_maze(    x + (o * 21), y, name == "MAZE" and 15 or 5)
  glyphs:small_crypt(   x + (o * 24), y, name == "CRYPT" and 15 or 5)
  glyphs:small_vale(    x + (o * 27), y, name == "VALE" and 15 or 5)
  glyphs:small_solarium(x + (o * 30), y, name == "SOLARIUM" and 15 or 5)
end

function graphics:render_docs()
  local sheet = page.active_page == 1 and "HOME" or keeper.structure_value
  if docs.sheets[sheet] == nil then
    glyphs:random(81, self.structure_y, 13)
    self:text_center(91, 33, "NO DOCS", 0)
    self:text_center(91, 43, "FOUND", 0)
  else
    for i, row in pairs(docs.sheets[sheet]) do
      graphics:text(56, 10 + (i * 8), docs.sheets[sheet][i], 0)
    end
  end
end

function graphics:time(x, y)
  local o = 3
  local x2 = x
  local y2 = y + o
  local meta = keeper.selected_cell.metabolism
  local off =  keeper.selected_cell.offset or 0
  local b = counters.this_beat()
  local l = sound.length
  -- global transport
  for i = 1, l do
    self:ps((i * o) + x, y, (b == i) and 5 or 0)
  end

  -- no metabolism or offset, no soup
  if not keeper.is_cell_selected then return end
  if keeper.selected_cell:is("HIVE") or
     keeper.selected_cell:is("RAVE") or
     keeper.selected_cell:is("DOME") or
     keeper.selected_cell:is("MAZE") then

    local steps = {}
        if keeper.selected_cell:is("DOME") then steps = keeper.selected_cell.er
    elseif keeper.selected_cell:is("MAZE") then steps = keeper.selected_cell.turing
    end

    if #steps > 0 and meta > 0 then
      for k,v in pairs(steps) do
        local step = ((fn.cycle(b % meta, 1, meta)) == k)
        local level = 0
        if step and v then
          level = 5
        elseif not step and v then
          level = 0
        else
          level = 15
        end
        self:ps((self:wrap_offset(k, off, l) * o) + x2, y2, level)
      end
    -- anything with an offset
    elseif keeper.selected_cell:has("OFFSET") then
      for i = 1, meta do
        self:ps((self:wrap_offset(i, off, l) * o) + x2, y2, ((fn.cycle(b % meta, 1, meta)) == i) and 5 or 0)
      end
    end
  end
end

function graphics:wrap_offset(i, off, l)
  return ((i + off) > l) and ((i + off) - l) or (i + off)
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
  time = time == nil and counters.default_message_length or time
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
      message = self:ready_animation(math.fmod(counters.ui.quarter_frame, 10) + 1)
    elseif not docs:is_active() then
      self:time(#page.titles * (self.tab_padding + self.tab_width), 2)
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
  elseif docs:is_active() then
    self:text_right(127, 6, "DOCUMENTATION", 0)
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
    self:icon(x, y, counters.this_beat(), (counters.this_beat() == 1) and 1 or 0)
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

function graphics:analysis(items, selected_item_string)
  local selected_item_key = fn.table_find(items, selected_item_string)

  -- menu
  self:structure_palette_analysis(1, 56, 4, selected_item_string)

  -- values
  local chart = {}

  chart.values = {}
  chart.values[1] = #keeper.signals
  for i = 1, #config.structures do chart.values[i+1] = keeper:count_cells(config.structures[i]) end

  chart.values_total = 0
  for i = 1, #chart.values do chart.values_total = chart.values_total + chart.values[i] end

  chart.percentages = {}
  for i = 1, #chart.values do chart.percentages[i] = chart.values[i] / chart.values_total end

  chart.degrees = {}
  for i = 1, #chart.percentages do chart.degrees[i] = chart.percentages[i] * 360 end


  -- pie chart
  local pie_chart_x = 25
  local pie_chart_y = 30
  local pie_chart_r = 18
  local total_degrees = 0
  local text_degrees = 1
  local percent = 0
  local spacing = 10
  local pie_highlight = 0
  self:circle(pie_chart_x, pie_chart_y, pie_chart_r, 5)
  self:circle(pie_chart_x, pie_chart_y, pie_chart_r - 1, 0)
  if #keeper.cells + #keeper.signals > 0 then
    for i = 1, #chart.percentages do
      total_degrees = total_degrees + chart.degrees[i]
      text_degrees = text_degrees + chart.degrees[i] -- / 2
      sector_x = math.cos(math.rad(total_degrees)) * pie_chart_r
      sector_y = math.sin(math.rad(total_degrees)) * pie_chart_r
      self:mlrs(pie_chart_x, pie_chart_y, sector_x, sector_y, i == selected_item_key and 15 or 5)
      text_x = math.cos(math.rad(text_degrees)) * pie_chart_r
      text_y = math.sin(math.rad(text_degrees)) * pie_chart_r
      if i == selected_item_key then
        self:rect(pie_chart_x + text_x, pie_chart_y + text_y, screen.text_extents(chart.values[i]) + 2, 7, 15)
        self:text_left(pie_chart_x + text_x + 1, pie_chart_y + text_y + 6, chart.values[i], 0)
      end
    end
  end

  -- line graph
  local line_graph_start_x = 54
  local line_graph_start_y = 36
  local line_graph_spacing = 2
  local line_graph_y = 0
  local line_highlight = 0
  for i = 1, #config.structures do
    if chart.values[i] ~= 0 then
      line_highlight = (i == selected_item_key) and 15 or 1
      line_graph_y = line_graph_start_y + ((i - 1) * line_graph_spacing)
      self:mls(line_graph_start_x, line_graph_y, line_graph_start_x + chart.percentages[i] * 100, line_graph_y, line_highlight)
    end
  end

  -- grid (thank you @okyeron)
  for i = 1, fn.grid_width() * fn.grid_height() do
    self.analysis_pixels[i] = 0
    if selected_item_string ~= "SIGNALS" then
      for k,v in pairs(keeper.cells) do
        if v.structure_value == selected_item_string and v.index == i then
          self.analysis_pixels[i] = 15
        end
      end
    elseif selected_item_string == "SIGNALS" then
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
  self:text(105, 16, counters.music.generation, 1)
  self:playback_icon(105, 17)
  fn.dirty_grid(true)
end

function graphics:draw_pixel(x, y, b)
  local offset = { x = 52, y = 9, spacing = 3 }
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

function graphics:piano(i)
  local k = keeper.selected_cell.notes[i]
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
  self:text_center(64, 64, keeper.selected_cell:get_note_name(i), 15, 10)
  self:reset_font()
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
  screen.font_size(64)
  self:text_center(64, 60, math.floor(timer / 10))
  screen.font_size(16)
  self:text(84, 60, "." .. math.random(0, 9) .. math.random(0, 9).. math.random(0, 9), 15)
  glyphs:random(18, 20, 1, true)
  glyphs:small_random(90, 38, 1, true)
  glyphs:small_random(101, 38, 1, true)
  glyphs:small_random(112, 38, 1, true)
  self:reset_font()
end

function graphics:select_a_cell()
  self:panel()
  glyphs:random(81, self.structure_y, 13)
  self:text_center(92, 33, "SELECT", 0)
  self:text_center(92, 43, "A CELL", 0)
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

function graphics:grid_connect_error()
  self:rect(1, 1, 128, 64, 15)
  self:text_center(64, 30, "PLEASE CONNECT A", 0)
  self:text_left(11, 42, "MONOME", 0)
  self:text_left(97, 42, "GRID.", 0)
  local l = counters.ui.quarter_frame % 15
  self:text_left(46, 42, "V", fn.cycle(l-0, 0, 15))
  self:text_left(51, 42, "A", fn.cycle(l-1, 0, 15))
  self:text_left(56, 42, "R", fn.cycle(l-2, 0, 15))
  self:text_left(61, 42, "I", fn.cycle(l-3, 0, 15))
  self:text_left(65, 42, "B", fn.cycle(l-4, 0, 15))
  self:text_left(70, 42, "R", fn.cycle(l-5, 0, 15))
  self:text_left(75, 42, "I", fn.cycle(l-6, 0, 15))
  self:text_left(79, 42, "G", fn.cycle(l-7, 0, 15))
  self:text_left(84, 42, "H", fn.cycle(l-8, 0, 15))
  self:text_left(89, 42, "T", fn.cycle(l-9, 0, 15))
end

function graphics:splash()
  local end_col = 34 -- starts at 68
  local end_row = 34 -- starts at 0
  local col_x = end_col + 95
  local row_x = end_row - 95
  local y = 45
  local l = counters.ui.frame >= 89 and 0 or 15
  if counters.ui.frame >= 89 then
    self:rect(0, 0, 128, 50, 15)
  end
  col_x = col_x - self.ni_frame
  row_x = row_x + self.ni_frame
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