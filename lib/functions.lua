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

function is_deleting(bool)
  if bool == nil then return deleting end
  deleting = bool
  return deleting
end

function cache_check(cache, check)
  if cache ~= check then
    dirty_screen(true)
  end
end

function select_page(x)
  page.active_page = x
  page.items = page_items[page.active_page]
  page.selected_item = 1
  dirty_screen(true)
end

function in_bounds(x, y)  
  if 0 > y then
    return false -- north
  
  elseif params:get("grid_width") < x then
    return false -- east
  
  elseif params:get("grid_height") < y then 
    return false -- south

  elseif 0 > x then
    return false -- west

  else
    return true -- ok
  end
end

function grid_frame()
  return counters.grid.frame
end

function microframe()
  return counters.ui.microframe
end

function generation()
  return counters.music.generation
end

function generation_fmod(i)
  return math.fmod(generation(), i) + 1
end

function id(x, y)
  return "x" .. x .. "y" .. y
end