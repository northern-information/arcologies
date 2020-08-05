function dirty_grid(bool)
  if bool == nil then return grid_dirty end
  grid_dirty = bool
  return grid_dirty
end

function dirty_screen(bool)
  if bool == nil then return screen_dirty end
  screen_dirty = bool
  return screen_dirty
end

function cache_check(cache, check)
  if cache ~= check then
    dirty_screen(true)
  end
end

function select_page(x)
  core.page.active_page = x
  core.page.items = page_items[page.active_page]
  core.page.selected_item = 1
end

function create_cell(x, y)
  c = Cell:new(x, y, core.counters.music.location)
  core.Field:add_cell(c)
end

function select_cell(x, y)
  core.selected_cell = {x, y}
  local cell_exists = core.Field:lookup(x, y)
  if not cell_exists then
    create_cell(x, y)
  end
  dirty_grid(true)
end

function cell_is_selected()
  return (#core.selected_cell == 2) and true or false
end

function deselect_cell()
  core.selected_cell = {}
  core.selected_cell_on = false
  dirty_grid(true)
end

function microframe()
  return core.counters.ui.microframe
end

