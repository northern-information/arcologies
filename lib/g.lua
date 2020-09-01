local g = grid.connect()

function g.init()
  g.counter = {}
  g.toggled = {}
  g.signal_deaths = {}
  g.signal_and_cell_collisions = {}
  g.first_in_x = nil
  g.first_in_y = nil
  g.paste_x = nil
  g.paste_y = nil
  g.is_copying = false
  g.is_pasting = false
  g.paste_counter = 15
  g.disconnect_dismissed = true
  g.last_known_width = g.cols
  g.last_known_height = g.rows
  for x = 1, fn.grid_width() do
    g.counter[x] = {}
    for y = 1, fn.grid_height() do
      g.counter[x][y] = nil
    end
  end
end

function grid.add()
  g.init()
  g.last_known_width = g.cols
  g.last_known_height = g.rows
  fn.dirty_grid(true)
end

function grid.remove()
  g:alert_disconnect()
end

function g:alert_disconnect()
  g.disconnect_dismissed = false
end

function g:dismiss_disconnect()
  g.disconnect_dismissed = true
end

function g.grid_redraw_clock()
  while true do
    clock.sleep(1 / 30)
    if fn.dirty_grid() == true then
      g:grid_redraw()
      fn.dirty_grid(false)
    end
    if keeper.is_cell_selected then fn.dirty_grid(true) end
    if #g.signal_deaths > 0 then fn.dirty_grid(true) end
    if #g.signal_and_cell_collisions > 0 then fn.dirty_grid(true) end
  end
end

function g:grid_redraw()
  self:all(0)
  self:led_leylines()
  self:led_cells()
  self:led_signals()
  self:led_signal_deaths()
  self:led_signal_and_cell_collision()
  self:led_selected_cell()
  self:led_cell_ports()
  self:led_cell_analysis()
  self:led_paste_animation()
  self:refresh()
end

function g.key(x, y, z)
  fn.break_splash(true)
  if z == 1 then
    g.counter[x][y] = clock.run(g.grid_long_press, g, x, y)
  elseif z == 0 then -- otherwise, if a grid key is released...
    if g.counter[x][y] then -- and the long press is still waiting...
      clock.cancel(g.counter[x][y]) -- then cancel the long press clock,
      g:short_press(x,y) -- and execute a short press instead.
    end
    -- release the copy
    if g.first_in_x == x and g.first_in_y == y then
      g.first_in_x = nil
      g.first_in_y = nil
      keeper.copied_cell = {}
      g.is_copying = false
      graphics:set_message("CLIPBOARD CLEARED")
    end
  end
end


function g:short_press(x, y)
  if self.is_copying then
    local paste_over_cell = keeper:get_cell(fn.index(x, y))
    if paste_over_cell then
      keeper:delete_cell(paste_over_cell.id)
    end
    local tmp = fn.deep_copy(keeper.copied_cell)
    tmp:prepare_for_paste(x, y, counters.music_generation())
    table.insert(keeper.cells, tmp)
    graphics:set_message("PASTED " .. tmp.structure_value)
    self.is_pasting = true
    self.paste_x = x
    self.paste_y = y
  else

    -- no cell is selected, so select one
    if not keeper.is_cell_selected then
      keeper:select_cell(x, y)
      page:select(2, "STRUCTURE")
      graphics:top_message_cell_structure()
    else
      -- pressing the selected cell deselects it
      if keeper.selected_cell.index == fn.index(x, y) then
        keeper:deselect_cell()
      -- toggle a port
      elseif keeper.selected_cell:find_port(x, y) then
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

function g:grid_long_press(x, y)
  clock.sleep(.5)
  if not self.is_copying then
    keeper:select_cell(x, y)
    graphics:top_message_cell_structure()
    self.first_in_x = x
    self.first_in_y = y
    keeper.copied_cell = fn.deep_copy(keeper.selected_cell)
    self.is_copying = true
    graphics:set_message("COPIED " .. keeper.selected_cell.structure_value)
  end
  self.counter[x][y] = nil
  fn.dirty_grid(true)
end

function g:led_signals()
  local level = page.active_page == 3 and menu.selected_item == 1 and 10 or 2
  for k,v in pairs(keeper.signals) do
    if v.generation <= counters.music_generation() then
      self:led(v.x, v.y, level)
    end
  end
end

function g:register_signal_death_at(x, y)
  local signal = {}
  signal.x = x
  signal.y = y
  signal.generation = counters.music_generation()
  signal.level = 10
  table.insert(self.signal_deaths, signal)
end

function g:led_signal_deaths()
  for k,v in pairs(self.signal_deaths) do
    if v.level == 0 or v.generation + 2 < counters.music_generation() then
      table.remove(self.signal_deaths, k)
    else
      self:led(v.x, v.y, v.level)
      v.level = v.level - 1
    end
  end
end

function g:register_collision_at(x, y)
  local collision = {}
  collision.x = x
  collision.y = y
  collision.generation = counters.music_generation()
  collision.level = 15
  table.insert(self.signal_and_cell_collisions, collision)
end

function g:led_signal_and_cell_collision()
  for k,v in pairs(self.signal_and_cell_collisions) do
    if v.level == 0 or v.generation + 2 < counters.music_generation() then
      table.remove(self.signal_and_cell_collisions, k)
    else
      self:led(v.x, v.y, v.level)
      v.level = v.level - 1
    end
  end
end

function g:led_cells()
  for k,v in pairs(keeper.cells) do
    self:led(v.x, v.y, 5)
  end
end

-- note the led analysis is up above in a g:led_signals
function g:led_cell_analysis()
  if page.active_page == 3 then
    for k,v in pairs(keeper.cells) do
        if v.structure_value == menu.selected_item_string then
          self:highlight_cell(v)
        end
      end
  end
end

function g:led_selected_cell()
  if keeper.is_cell_selected then
    self:highlight_cell(keeper.selected_cell)
  end
end

function g:highlight_cell(cell)
  self:led(cell.x, cell.y, util.clamp(counters.grid_frame() % 15, 5, 15))
end

function g:led_paste_animation()
  if self.paste_counter == 0 then
    self.paste_counter = 15
    self.is_pasting = false
    self.paste_x = nil
    self.paste_y = nil
  end
  if self.is_pasting then
    self:led(self.paste_x, self.paste_y, self.paste_counter)
    self.paste_counter = self.paste_counter - 1
  end
end

function g:led_cell_ports()
  if not keeper.is_cell_selected then return end
  local x = keeper.selected_cell_x
  local y = keeper.selected_cell_y
  local high = util.clamp(counters.grid_frame() % 15, 10, 15)
  local low = 2
  if fn.in_bounds(x, y - 1) then
    self:led(x, y - 1, keeper.selected_cell:is_port_open("n") and high or low)
  end
  if fn.in_bounds(x + 1, y) then
    self:led(x + 1, y, keeper.selected_cell:is_port_open("e") and high or low)
  end
  if fn.in_bounds(x, y + 1) then
    self:led(x, y + 1, keeper.selected_cell:is_port_open("s") and high or low)
  end
  if fn.in_bounds(x - 1 , y) then
    self:led(x - 1, y, keeper.selected_cell:is_port_open("w") and high or low)
  end
end

function g:led_leylines()
  if not keeper.is_cell_selected then return end
  if keeper.selected_cell:is_port_open("n") then g:draw_northern_leyline() end
  if keeper.selected_cell:is_port_open("e") then g:draw_eastern_leyline() end
  if keeper.selected_cell:is_port_open("s") then g:draw_southern_leyline() end
  if keeper.selected_cell:is_port_open("w") then g:draw_western_leyline() end
end


--[[ these four draw_xxx_leyline functions are nuanced enough that i don't
  want them to share some huge paramaterized thing with 8 arguments. one
  way this could be made a bit more maintable would be to introduce a
  get_column_neighbors and get_row_neighbors, and then compare < and >
  afterwards instead of all in one go. ]]
function g:draw_northern_leyline()
  local neighbors, destination = {}, {}
  for k, cell in pairs(keeper.cells) do
    if cell.x == keeper.selected_cell.x and cell.id ~= keeper.selected_cell.id and cell.y < keeper.selected_cell.y then
      table.insert(neighbors, cell.y)
    end
  end
  destination["x"] = keeper.selected_cell.x
  destination["y"] = (#neighbors ~= 0) and fn.nearest_value(neighbors, keeper.selected_cell.y) + 1 or 1
  g:draw_leyline(
    keeper.selected_cell.x,
    keeper.selected_cell.y - 2, -- -1 for this cell & -1 for its open port
    destination.x,
    destination.y
  )
end

function g:draw_eastern_leyline()
  local neighbors, destination = {}, {}
  for k, cell in pairs(keeper.cells) do
    if cell.y == keeper.selected_cell.y and cell.id ~= keeper.selected_cell.id and cell.x > keeper.selected_cell.x then
      table.insert(neighbors, cell.x)
    end
  end
  destination["x"] = (#neighbors ~= 0) and fn.nearest_value(neighbors, keeper.selected_cell.x) - 1 or fn.grid_width()
  destination["y"] = keeper.selected_cell.y
  g:draw_leyline(
    keeper.selected_cell.x + 2, -- +1 for this cell & +1 for its open port
    keeper.selected_cell.y,
    destination.x,
    destination.y
  )
end

function g:draw_southern_leyline()
  local neighbors, destination = {}, {}
  for k, cell in pairs(keeper.cells) do
    if cell.x == keeper.selected_cell.x and cell.id ~= keeper.selected_cell.id and cell.y > keeper.selected_cell.y then
      table.insert(neighbors, cell.y)
    end
  end
  destination["x"] = keeper.selected_cell.x
  destination["y"] = (#neighbors ~= 0) and fn.nearest_value(neighbors, keeper.selected_cell.y) - 1 or fn.grid_height()
  g:draw_leyline(
    keeper.selected_cell.x,
    keeper.selected_cell.y + 2, -- +1 for this cell & +1 for its open port
    destination.x,
    destination.y
  )
end

function g:draw_western_leyline()
  local neighbors, destination = {}, {}
  for k, cell in pairs(keeper.cells) do
    if cell.y == keeper.selected_cell.y and cell.id ~= keeper.selected_cell.id and cell.x < keeper.selected_cell.x then
      table.insert(neighbors, cell.x)
    end
  end
  destination["x"] = (#neighbors ~= 0) and fn.nearest_value(neighbors, keeper.selected_cell.x) + 1 or 1
  destination["y"] = keeper.selected_cell.y
  g:draw_leyline(
    keeper.selected_cell.x - 2, -- -1 for this cell & -1 for its open port
    keeper.selected_cell.y,
    destination.x,
    destination.y
  )
end

function g:draw_leyline(start_x, start_y, end_x, end_y)
  if start_x == end_x then -- vertical
    for i = math.min(start_y, end_y), math.max(start_y, end_y) do
      if fn.in_bounds(start_x, i) then self:led(start_x, i, 1) end
    end
  elseif start_y == end_y then -- horizontal
    for i = math.min(start_x, end_x), math.max(start_x, end_x) do
      if fn.in_bounds(i, start_y) then self:led(i, start_y, 1) end
    end
  else
    print("Error: leylines must be perpendicular.")
  end
  fn.dirty_grid(true)
end

return g