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
  dirty_screen(true)
end

function microframe()
  return core.counters.ui.microframe
end

function id(x, y)
  return "x" .. x .. "y" .. y
end