graphics = {}

function graphics.init()
  graphics.temporary_message_on = false
  graphics.temporary_message = ""
  graphics.tab_width = 5
  graphics.tab_height = 5
  graphics.tab_padding = 1
  graphics.structure_x = 98
  graphics.structure_y = 24
  graphics.total_cells = fn.grid_height() * fn.grid_width()
  graphics.analysis_pixels = {}
  graphics.splash_lines_open = {}
  graphics.splash_lines_close = {}
  graphics.splash_lines_close_available = {}
  for i=1,45 do graphics.splash_lines_open[i] = i end
  for i=1,64 do graphics.splash_lines_close_available[i] = i end
end

function graphics:structure(s)
    glyphs:draw_glyph(s, self.structure_x, self.structure_y, 0)
end

function graphics:structure_palette(i)
  local start_x = 7
  local start_y = 12
  local margin_x = 15
  local margin_y = 14
  local p = {}
  for setup = 1, #structures:all_enabled() do
      p[setup] = {
        selected = false,
        x = 0,
        y = 0
      }
  end
  p[i].selected = true

  for k,v in pairs(p) do
    local row, col = 1,1
    -- call me hardcode kassidy
    if k >=  9 and k <= 16 then row = 2 end
    if k >= 17 and k <= 24 then row = 3 end
    if k >= 25 and k <= 32 then row = 4 end
    p[k].y = start_y + (margin_y * (row - 1))
    col = k % 8
    col = col == 0 and 8 or col
    p[k].x = start_x + (margin_x * (col - 1))
    if p[k].selected then
      self:rect(p[k].x - 4, p[k].y - 3, 13, 13, 15)
    end
  end

  for i = 1, #structures:all_enabled() do
    glyphs:draw_small_glyph(structures:all_enabled()[i].name, p[i].x, p[i].y, p[i].selected and 0 or 15)
  end
  
end

function graphics:structure_palette_analysis(s)
  local x = 10
  local y = 56
  local margin = 3
  local threshold = 8
  local offset = s > threshold and s - threshold or 0
  local items = {}

  local signal_count = #keeper.signals
  local cell_count = keeper:count_cells(structures:all_names()[i])

  for i = 1, #keeper:get_analysis_items() do
    local adjust = 0
    if s > threshold then
      adjust = -14 * offset
    end
    items[i] = x + ((i - 1) * 14) + margin + adjust
  end

  for i = 1, #keeper:get_analysis_items() do
    glyphs:draw_small_glyph(keeper:get_analysis_items()[i], items[i], y, s == i and 15 or 5)
  end

  -- cover the scroll
  graphics:rect(0, y-1, 10, 9, 0)
  graphics:rect(120, y-1, 10, 9, 0)

  -- pop arrow to the left
  if s > threshold then
    graphics:text_left(0, y+7, "<", 5)
  end

  -- pop arrow to the right
  if s < #items and #items > threshold then
    graphics:text_right(128, y+7, ">", 5)
  end

end

function graphics:render_docs()
  local sheet = page.active_page == 1 and "HOME" or keeper.selected_cell.structure_name
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
  local beat = counters:this_beat()
  local meta = keeper.selected_cell.metabolism
  local l = sound.length

  -- always draw global transport
  for i = 1, l do
    self:ps((i * o) + x, y, (beat == i) and 5 or 0)
  end

  -- no selected cell, no soup
  if not keeper.is_cell_selected or meta == 0 then return end

  local steps = {}
      if keeper.selected_cell:is("HIVE")      then steps = keeper.selected_cell:get_metabolism_steps()
  elseif keeper.selected_cell:is("RAVE")      then steps = keeper.selected_cell:get_metabolism_steps()
  elseif keeper.selected_cell:is("MIRAGE")    then steps = keeper.selected_cell:get_metabolism_steps()
  elseif keeper.selected_cell:is("KUDZU")     then steps = keeper.selected_cell:get_metabolism_steps()
  elseif keeper.selected_cell:is("WINDFARM")  then steps = keeper.selected_cell:get_metabolism_steps()
  elseif keeper.selected_cell:is("DOME")      then steps = fn.deep_copy(keeper.selected_cell.er)
  elseif keeper.selected_cell:is("MAZE")      then steps = fn.deep_copy(keeper.selected_cell.turing)
  end

  -- no steps, no soup
  if #steps == 0 then return end

  local cell_offset =  keeper.selected_cell.offset or 0
  local adjusted_steps = fn.wrap(steps, cell_offset)

  for k, v in pairs(adjusted_steps) do 
    local this_step_pointer = ((fn.cycle(beat % meta, 1, meta)) == k)
    local this_step_level = self:get_this_step_level(this_step_pointer, v)
    local this_step_x = (k * o) + x
    local this_step_y =  y + o
    self:ps(this_step_x, this_step_y, this_step_level)
  end
end

function graphics:wrap_offset(i, off, l)
  return ((i + off) > l) and ((i + off) - l) or (i + off)
end

function graphics:get_this_step_level(this_step_pointer, this_step_boolean_value)
  local level = 15 -- non-existent step, so it is invisible
  if this_step_pointer and this_step_boolean_value then -- current step is grey
    level = 5
  elseif not this_step_pointer and this_step_boolean_value then -- possible step is black
    level = 0
  else 
    level = 15
  end
  return level
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
    if counters.playback == 0 then
      message = self:ready_animation(math.fmod(counters.ui.quarter_frame, 10) + 1)
    elseif not docs:is_active() then
      self:time(#page.titles * (self.tab_padding + self.tab_width), 2)
    end
  end
  self:text((#page.titles + 1) * self.tab_width + 2, 6, message, 0)
end

function graphics:top_message_cell_structure()
  if page.active_page ~= 2 then
    self:set_message(keeper.selected_cell.structure_name, counters.default_message_length)
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
  elseif page.active_page == 1 and arcology_loaded then
    self:text_right(127, 6, arcology_name, 0)
  elseif page.active_page == 2 and keeper.is_cell_selected then
    self:text_right(127, 6, keeper.selected_cell.structure_name, 0)
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
  if counters.playback == 0 then
    self:icon(x, y, "||", 1)
  else
    self:icon(x, y, counters:this_beat(), (counters:this_beat() == 1) and 1 or 0)
  end
end

function graphics:format_transpose(i)
  if i == 0 then return "" end
  return (i > 0) and "+" .. i  .. " "  or i .. " " 
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

function graphics:analysis(items, selected_item_key)
  -- menu
  self:structure_palette_analysis(selected_item_key)

  -- values
  local analysis_items = keeper:get_analysis_items()
  local chart = {}

  chart.values = {}
  for i = 1, #analysis_items do
    if analysis_items[i] == "SIGNALS" then
      table.insert(chart.values, keeper:count_signals())
    else
      table.insert(chart.values, keeper:count_cells(analysis_items[i]))
    end
  end

  self.test = chart.values

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
  local line_graph_start_x = 127
  local line_graph_start_y = 10
  local line_graph_spacing = 2
  local line_graph_x = 0
  local line_highlight = 0
  for i = 1, #chart.values do
    if chart.values[i] ~= 0 then
      line_highlight = (i == selected_item_key) and 5 or 1
      line_graph_y = line_graph_start_y + ((i - 1) * line_graph_spacing)
      local this_line_percentage = chart.percentages[i] * 100
      local this_width = util.round_up(math.floor(util.linlin(0, 100, 0, 10, this_line_percentage)), 1)
      self:mlrs(line_graph_start_x, line_graph_y, -this_width, 1, line_highlight)
      self:mls(128, line_graph_start_y, 128, (line_graph_start_y + (i * line_graph_spacing)), 1)
    end
  end

  -- grid (thank you @okyeron)
  for i = 1, fn.grid_width() * fn.grid_height() do
    self.analysis_pixels[i] = 0
    if selected_item_key== 1 then -- 1 is signals
      for k,v in pairs(keeper.signals) do
        if v.index == i then
          self.analysis_pixels[i] = 15
        end
      end
    else
      for k,v in pairs(keeper.cells) do
        if v.structure_name == analysis_items[selected_item_key] and v.index == i then
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
  self:text(54, 50, chart.values[selected_item_key], 15)
  self:text(74, 50, counters:this_beat(), 15)
  self:text(94, 50, counters.music_generation, 15)
  fn.dirty_grid(true)
end

function graphics:draw_pixel(x, y, b)
  local offset = { x = 50, y = 8, spacing = 4 }
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

function graphics:psyop_animation(i)
  local f = {}
  f[-3] = "||||..."
  f[-2] = ".|||..."
  f[-1] = "..||..."
  f[0]  = "...|..."
  f[1]  = "...||.."
  f[2]  = "...|||."
  f[3]  = "...||||"
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
  self:text_center(64, 60, "(Any encoder to dismiss.)", 5)
end

function graphics:splash()
  local col_x = 34
  local row_x = 34
  local y = 45
  local l = counters.ui.frame >= 49 and 0 or 15
  if counters.ui.frame >= 49 then
    self:rect(0, 0, 128, 50, 15)
  end

  self:ni(col_x, row_x, y, l)

  if #self.splash_lines_open > 1 then 
    local delete = math.random(1, #self.splash_lines_open)
    table.remove(self.splash_lines_open, delete)
    for i = 1, #self.splash_lines_open do
      self:mlrs(1, self.splash_lines_open[i] + 4, 128, 1, 0)
    end
  end


  if counters.ui.frame >= 49 then
    self:text_center(64, 60, "NORTHERN INFORMATION")
  end

  if counters.ui.frame > 100 then
    if #self.splash_lines_close_available > 0 then 
      local add = math.random(1, #self.splash_lines_close_available)
      table.insert(self.splash_lines_close, self.splash_lines_close_available[add])
      table.remove(self.splash_lines_close_available, add)
    end
    for i = 1, #self.splash_lines_close do
      self:mlrs(1, self.splash_lines_close[i], 128, 1, 0)
    end
  end

  if #self.splash_lines_close_available == 0 or fn.break_splash() then
    fn.break_splash(true)
    page:select(1)
  end
end

function graphics:ni(col_x, row_x, y, l)
  self:n_col(col_x, y, l)
  self:n_col(col_x+20, y, l)
  self:n_col(col_x+40, y, l)
  self:n_row_top(row_x, y, l)
  self:n_row_top(row_x+20, y, l)
  self:n_row_top(row_x+40, y, l)
  self:n_row_bottom(row_x+9, y+37, l)
  self:n_row_bottom(row_x+29, y+37, l)
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
  self:mls(x+21, y-39, x+29, y-39, l)
  self:mls(x+20, y-38, x+28, y-38, l)
  self:mls(x+20, y-37, x+28, y-37, l)
end


return graphics