local g = grid.connect()

function g.init()
  g.signal_deaths = {}
  g.signal_and_cell_collisions = {}
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
  self:led_cells()
  self:led_leylines()
  self:led_signals()
  self:led_signal_deaths()
  self:led_signal_and_cell_collision()
  self:led_selected_cell()
  self:led_cell_ports()
  self:led_cell_analysis()
  self:refresh()
end

function g.key(x, y, z)
  if z == 0 then return end
  fn.break_splash(true)
  if not keeper.is_cell_selected then
    keeper:select_cell(x, y)
    graphics:top_message_cell_structure()
  else
    if keeper.selected_cell.index == fn.index(x, y) then
      keeper.selected_cell:cycle_structure(1)
      graphics:top_message_cell_structure()
    elseif keeper.selected_cell:find_port(x, y) then
      keeper.selected_cell:toggle_port(x, y)
    elseif keeper:get_cell(fn.index(x, y)) then
      keeper:select_cell(x, y)
      graphics:top_message_cell_structure()
    else
      keeper:deselect_cell()
    end
  end
  page:select(2)
  fn.dirty_grid(true)
  fn.dirty_screen(true)
end

function g:led_signals()
  local level = page.active_page == 3 and menu.selected_item == 4 and 10 or 2
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

function g:led_cell_analysis()
  if page.active_page == 3 then
    for k,v in pairs(keeper.cells) do
        if v.structure == menu.selected_item then
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

function g:led_cell_ports()
  if not keeper.is_cell_selected then return end
  local x = keeper.selected_cell_x
  local y = keeper.selected_cell_y
  local high = util.clamp(counters.grid_frame() % 15, 10, 15)
  local low = util.clamp(counters.grid_frame() % 15, 3, 5)
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
      if fn.in_bounds(start_x, i) then self:led(start_x, i, 2) end
    end
  elseif start_y == end_y then -- horizontal
    for i = math.min(start_x, end_x), math.max(start_x, end_x) do
      if fn.in_bounds(i, start_y) then self:led(i, start_y, 2) end
    end
  else
    print("Error: leylines must be perpendicular to the field.")
  end
  fn.dirty_grid(true)
end

return g