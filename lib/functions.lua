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
  core.field:add_cell(c)
end

function delete_cell(x, y)
  core.field:delete_cell(id(x, y))
  deselect_cell()
end

function select_cell(x, y)
  selected_cell_id = {}
  selected_cell_id[1] = x
  selected_cell_id[2] = y
  cell_selected = true
  if not core.field:lookup(id(x, y)) then
    create_cell(x, y)
  end
  dirty_grid(true)
  dirty_screen(true)
end

function id(x, y)
  return "x" .. x .. "y" .. y
end

function deselect_cell()
  selected_cell_id = {}
  cell_selected = false
  dirty_grid(true)
  dirty_screen(true)
end

function microframe()
  return core.counters.ui.microframe
end

function clear_static()
  core.graphics:reset_frames()
end