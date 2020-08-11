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

function dirty_seed(bool)
  if bool == nil then return seed_dirty end
  seed_dirty = bool
  return seed_dirty
end

function is_deleting(bool)
  if bool == nil then return deleting end
  deleting = bool
  return deleting
end


function long_press(k)
  clock.sleep(1)
  key_counter[k] = nil
  if k == 3 then
    keeper:delete_all_cells()
    is_deleting(false)
    graphics:set_message("DELETED", 40)
  end
  dirty_screen(true)
end

function set_seed(s)
  graphics:set_message("SEEDING...", 40)
  if enc_counter[3]["this_clock"] ~= nil then
    clock.cancel(enc_counter[3]["this_clock"])
    counters:reset_enc(3)
  end
  seed = s
  dirty_screen(true)
  if enc_counter[3]["this_clock"] == nil then
    enc_counter[3]["this_clock"] = clock.run(seed_wait, s)
  end
end 

function seed_wait(s)
  enc_counter[3]["waiting"] = true
  clock.sleep(ui_wait_threshold)
  enc_counter[3]["waiting"] = false
  enc_counter[3]["this_clock"] = nil
  seed_cells(s)
  dirty_screen(true)
end

function seed_cells(s)
  keeper:delete_all_cells()
  graphics:set_message("SEEDED " .. s, 40)
  for i = 1, s do
    random_cell()
  end
  keeper:deselect_cell()
end

function random_cell()
  keeper:select_cell(rx(), ry())
  keeper.selected_cell:set_structure(math.random(1, 3))
  local ports = { "n", "e", "s", "w" }
  for i = 1, #ports do
    if coin() then
      keeper.selected_cell:open_port(ports[i])
    end
  end
  keeper.selected_cell:set_phase(math.random(1, meter))
  keeper.selected_cell:set_sound(math.random(1, #dictionary.sounds))
end


function select_page(x)
  page.active_page = x
  page.items = page_items[page.active_page]
  page.selected_item = 1
  dirty_screen(true)
end

function in_bounds(x, y)  
  if 1 > y then
    return false -- north
  elseif grid_width() < x then
    return false -- east
  elseif grid_height() < y then 
    return false -- south
  elseif 1 > x then
    return false -- west
  else
    return true -- ok
  end
end

function grid_width()
  return g.cols
end

function grid_height()
  return g.rows
end

function grid_frame()
  return counters.grid.frame
end

function generation()
  return counters.music.generation
end

function ui_quarter_frame_fmod(i)
  return math.fmod(counters.ui.quarter_frame, i) + 1
end
function generation_fmod(i)
  return math.fmod(generation(), i) + 1
end

function id(x, y)
  return "x" .. x .. "y" .. y
end

function table_find(t, element)
  for i,v in pairs(t) do
    if v == element then
      return i
    end
  end
end

function round(n)
  return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function rx()
  return math.random(1, grid_width())
end

function ry()
  return math.random(1, grid_height())
end

function coin()
  return math.random(0, 1)
end