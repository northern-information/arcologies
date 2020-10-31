_grid = {}
g = grid.connect()

function _grid.init()
  _grid.counter = {}
  _grid.toggled = {}
  _grid.signal_deaths = {}
  _grid.signal_and_cell_collisions = {}
  _grid.flickers = {}
  _grid.first_in_x = nil
  _grid.first_in_y = nil
  _grid.paste_x = nil
  _grid.paste_y = nil
  _grid.is_copying = false
  _grid.is_pasting = false
  _grid.paste_counter = 15
  _grid.disconnect_dismissed = true
  _grid.last_known_width = g.cols
  _grid.last_known_height = g.rows
  for x = 1, _grid.last_known_width do
    _grid.counter[x] = {}
    for y = 1, _grid.last_known_height do
      _grid.counter[x][y] = nil
    end
  end
end

-- little g

function g.key(x, y, z)
  fn.break_splash(true)
  if z == 1 then
    _grid.counter[x][y] = clock.run(_grid.grid_long_press, g, x, y)
  elseif z == 0 then -- otherwise, if a grid key is released...
    if _grid.counter[x][y] then -- and the long press is still waiting...
      clock.cancel(_grid.counter[x][y]) -- then cancel the long press clock,
      _grid:short_press(x,y) -- and execute a short press instead.
    end
    -- release the copy
    if _grid.first_in_x == x and _grid.first_in_y == y then
      _grid.first_in_x = nil
      _grid.first_in_y = nil
      keeper.copied_cell = {}
      _grid.is_copying = false
      graphics:set_message("CLIPBOARD CLEARED")
    end
  end
end

function g.remove()
  _grid:alert_disconnect()
end

-- big _grid

function _grid:alert_disconnect()
  self.disconnect_dismissed = false
end

function _grid:dismiss_disconnect()
  self.disconnect_dismissed = true
end

function _grid.grid_redraw_clock()
  while true do
    clock.sleep(1 / 30)
    if fn.dirty_grid() == true then
      _grid:grid_redraw()
      fn.dirty_grid(false)
    end
    if keeper.is_cell_selected
    or #_grid.signal_deaths > 0
    or #_grid.flickers > 0
    or #_grid.signal_and_cell_collisions > 0 then 
      fn.dirty_grid(true)
    end
  end
end

function _grid:grid_redraw()
  g:all(0)
  self:led_leylines()
  self:led_territories()
  self:led_cells()
  self:led_signals()
  self:led_signal_deaths()
  self:led_flickers()
  self:led_signal_and_cell_collision()
  self:led_selected_cell()
  self:led_cell_ports()
  self:led_cell_analysis()
  self:led_paste_animation()
  g:refresh()
end

function _grid:short_press(x, y)
  if self.is_copying then
    local paste_over_cell = keeper:get_cell(fn.index(x, y))
    if paste_over_cell then
      keeper:delete_cell(paste_over_cell.id)
    end
    local tmp = fn.deep_copy(keeper.copied_cell)
    tmp:prepare_for_paste(x, y, counters.music_generation)
    table.insert(keeper.cells, tmp)
    graphics:set_message("PASTED " .. tmp.structure_name)
    self.is_pasting = true
    self.paste_x = x
    self.paste_y = y
  else

    -- no cell is selected, so select one
    if not keeper.is_cell_selected then
      keeper:select_cell(x, y)
      if parameters.is_designer_jump_on then
        page:select(2, "STRUCTURE")
      end
      graphics:top_message_cell_structure()
    else
      -- pressing the selected cell deselects it
      if keeper.selected_cell.index == fn.index(x, y) then
        keeper:deselect_cell()
      -- toggle a port
      elseif keeper.selected_cell:find_port(x, y) and not self.is_copying then
        keeper.selected_cell:toggle_port(x, y)
        local port = keeper.selected_cell:find_port(x, y)
        graphics:set_message("TOGGLED " .. string.upper(port[3]) .. " PORT")

      -- select another cell
      elseif keeper:get_cell(fn.index(x, y)) then
        keeper:select_cell(x, y)
        menu:reset()
        graphics:top_message_cell_structure()
      else
        keeper:deselect_cell()
      end
    end
  end
  fn.dirty_grid(true)
  fn.dirty_screen(true)
end

function _grid:grid_long_press(x, y)
  clock.sleep(.5)
  if not _grid.is_copying then
    keeper:select_cell(x, y)
    graphics:top_message_cell_structure()
    _grid.first_in_x = x
    _grid.first_in_y = y
    keeper.copied_cell = fn.deep_copy(keeper.selected_cell)
    _grid.is_copying = true
    graphics:set_message("COPIED " .. keeper.selected_cell.structure_name)
  end
  _grid.counter[x][y] = nil
  fn.dirty_grid(true)
end

function _grid:led_signals()
  local level = page.active_page == 3 and menu.selected_item == 1 and 10 or 2
  for k,v in pairs(keeper.signals) do
    if v.generation <= counters.music_generation then
      g:led(v.x, v.y, level)
    end
  end
end

function _grid:register_signal_death_at(x, y)
  local signal = {}
  signal.x = x
  signal.y = y
  signal.generation = counters.music_generation
  signal.level = 10
  table.insert(self.signal_deaths, signal)
end

function _grid:led_signal_deaths()
  for k,v in pairs(self.signal_deaths) do
    if v.level == 0 or v.generation + 2 < counters.music_generation then
      table.remove(self.signal_deaths, k)
    else
      g:led(v.x, v.y, v.level)
      v.level = v.level - 1
    end
  end
end

function _grid:register_flicker_at(x, y)
  local flicker = {}
  flicker.x = x
  flicker.y = y
  flicker.generation = counters.music_generation
  flicker.level = 10
  table.insert(self.flickers, flicker)
end

function _grid:led_flickers()
  for k, v in pairs(self.flickers) do
    if v.level == 0 or v.generation + 2 < counters.music_generation then
      table.remove(self.flickers, k)
    else
      g:led(v.x, v.y, v.level)
      v.level = v.level - 1
    end
  end
end

function _grid:register_collision_at(x, y)
  local collision = {}
  collision.x = x
  collision.y = y
  collision.generation = counters.music_generation
  collision.level = 15
  table.insert(self.signal_and_cell_collisions, collision)
end

function _grid:led_signal_and_cell_collision()
  for k,v in pairs(self.signal_and_cell_collisions) do
    if v.level == 0 or v.generation + 2 < counters.music_generation then
      table.remove(self.signal_and_cell_collisions, k)
    else
      g:led(v.x, v.y, v.level)
      v.level = v.level - 1
    end
  end
end

function _grid:led_cells()
  for k,v in pairs(keeper.cells) do
    g:led(v.x, v.y, 5)
  end
end

-- note the led analysis is up above in a _grid:led_signals
function _grid:led_cell_analysis()
  if page.active_page == 3 then
    for k,v in pairs(keeper.cells) do
        if v.structure_name == menu.selected_item_string then
          self:highlight_cell(v)
        end
      end
  end
end

function _grid:led_selected_cell()
  if keeper.is_cell_selected then
    self:highlight_cell(keeper.selected_cell)
  end
end

function _grid:highlight_cell(cell)
  g:led(cell.x, cell.y, util.clamp(counters.grid_frame() % 15, 5, 15))
end

function _grid:led_paste_animation()
  if self.paste_counter == 0 then
    self.paste_counter = 15
    self.is_pasting = false
    self.paste_x = nil
    self.paste_y = nil
  end
  if self.is_pasting then
    g:led(self.paste_x, self.paste_y, self.paste_counter)
    self.paste_counter = self.paste_counter - 1
  end
end

function _grid:led_cell_ports()
  if not keeper.is_cell_selected or self.is_copying then return end
  local x = keeper.selected_cell_x
  local y = keeper.selected_cell_y
  local high = util.clamp(counters.grid_frame() % 15, 10, 15)
  local low = 2
  if fn.in_bounds(x, y - 1) then
    g:led(x, y - 1, keeper.selected_cell:is_port_open("n") and high or low)
  end
  if fn.in_bounds(x + 1, y) then
    g:led(x + 1, y, keeper.selected_cell:is_port_open("e") and high or low)
  end
  if fn.in_bounds(x, y + 1) then
    g:led(x, y + 1, keeper.selected_cell:is_port_open("s") and high or low)
  end
  if fn.in_bounds(x - 1 , y) then
    g:led(x - 1, y, keeper.selected_cell:is_port_open("w") and high or low)
  end
end

function _grid:led_leylines()
  if not keeper.is_cell_selected then return end
  if keeper.selected_cell:is_port_open("n") then self:draw_northern_leyline() end
  if keeper.selected_cell:is_port_open("e") then self:draw_eastern_leyline() end
  if keeper.selected_cell:is_port_open("s") then self:draw_southern_leyline() end
  if keeper.selected_cell:is_port_open("w") then self:draw_western_leyline() end
end


--[[ these four draw_xxx_leyline functions are nuanced enough that i don't
  want them to share some huge paramaterized thing with 8 arguments. one
  way this could be made a bit more maintable would be to introduce a
  get_column_neighbors and get_row_neighbors, and then compare < and >
  afterwards instead of all in one go. ]]
function _grid:draw_northern_leyline()
  local neighbors, destination = {}, {}
  for k, cell in pairs(keeper.cells) do
    if cell.x == keeper.selected_cell.x and cell.id ~= keeper.selected_cell.id and cell.y < keeper.selected_cell.y then
      table.insert(neighbors, cell.y)
    end
  end
  destination["x"] = keeper.selected_cell.x
  destination["y"] = (#neighbors ~= 0) and fn.nearest_value(neighbors, keeper.selected_cell.y) + 1 or 1
  self:draw_leyline(
    keeper.selected_cell.x,
    keeper.selected_cell.y - 2, -- -1 for this cell & -1 for its open port
    destination.x,
    destination.y
  )
end

function _grid:draw_eastern_leyline()
  local neighbors, destination = {}, {}
  for k, cell in pairs(keeper.cells) do
    if cell.y == keeper.selected_cell.y and cell.id ~= keeper.selected_cell.id and cell.x > keeper.selected_cell.x then
      table.insert(neighbors, cell.x)
    end
  end
  destination["x"] = (#neighbors ~= 0) and fn.nearest_value(neighbors, keeper.selected_cell.x) - 1 or fn.grid_width()
  destination["y"] = keeper.selected_cell.y
  self:draw_leyline(
    keeper.selected_cell.x + 2, -- +1 for this cell & +1 for its open port
    keeper.selected_cell.y,
    destination.x,
    destination.y
  )
end

function _grid:draw_southern_leyline()
  local neighbors, destination = {}, {}
  for k, cell in pairs(keeper.cells) do
    if cell.x == keeper.selected_cell.x and cell.id ~= keeper.selected_cell.id and cell.y > keeper.selected_cell.y then
      table.insert(neighbors, cell.y)
    end
  end
  destination["x"] = keeper.selected_cell.x
  destination["y"] = (#neighbors ~= 0) and fn.nearest_value(neighbors, keeper.selected_cell.y) - 1 or fn.grid_height()
  self:draw_leyline(
    keeper.selected_cell.x,
    keeper.selected_cell.y + 2, -- +1 for this cell & +1 for its open port
    destination.x,
    destination.y
  )
end

function _grid:draw_western_leyline()
  local neighbors, destination = {}, {}
  for k, cell in pairs(keeper.cells) do
    if cell.y == keeper.selected_cell.y and cell.id ~= keeper.selected_cell.id and cell.x < keeper.selected_cell.x then
      table.insert(neighbors, cell.x)
    end
  end
  destination["x"] = (#neighbors ~= 0) and fn.nearest_value(neighbors, keeper.selected_cell.x) + 1 or 1
  destination["y"] = keeper.selected_cell.y
  self:draw_leyline(
    keeper.selected_cell.x - 2, -- -1 for this cell & -1 for its open port
    keeper.selected_cell.y,
    destination.x,
    destination.y
  )
end

function _grid:draw_leyline(start_x, start_y, end_x, end_y)
  if start_x == end_x then -- vertical
    for i = math.min(start_y, end_y), math.max(start_y, end_y) do
      if fn.in_bounds(start_x, i) then g:led(start_x, i, 1) end
    end
  elseif start_y == end_y then -- horizontal
    for i = math.min(start_x, end_x), math.max(start_x, end_x) do
      if fn.in_bounds(i, start_y) then g:led(i, start_y, 1) end
    end
  else
    print("Error: leylines must be perpendicular.")
  end
  fn.dirty_grid(true)
end

function _grid:led_territories()
  if not keeper.is_cell_selected or not keeper.selected_cell:has("TERRITORY") then return end
  local c = keeper.selected_cell:get_territory_coordinates()
  for x = c.x1, c.x2 do
    for y = c.y1, c.y2 do
      local l = math.ceil(util.linlin(0, 15, 0, 3, counters.grid_frame() % 15))
      if fn.in_bounds(x, y) then g:led(x, y, l) end
    end
  end
  fn.dirty_grid(true)
end

return _grid