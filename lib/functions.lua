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

function is_selecting_note(bool)
  if bool == nil then return selecting_note end
  selecting_note = bool
  return selecting_note
end

function long_press(k)
  clock.sleep(1)
  key_counter[k] = nil
  if k == 3 then
    keeper:delete_all_cells()
    is_deleting(false)
    graphics:set_message("DELETED", counters.default_message_length)
  end
  dirty_screen(true)
end







-- todo: move to counters?

function set_note(d)
  graphics:set_message("NOTE...", counters.default_message_length)
  if enc_counter[3]["this_clock"] ~= nil then
    clock.cancel(enc_counter[3]["this_clock"])
    counters:reset_enc(3)
  end
  is_selecting_note(true)
  keeper.selected_cell:set_sound(util.clamp(keeper.selected_cell.sound + d, 1, 144))
  dirty_screen(true)
  if enc_counter[3]["this_clock"] == nil then
    enc_counter[3]["this_clock"] = clock.run(select_note_wait)
  end
end 





function select_note_wait(s)
  enc_counter[3]["waiting"] = true
  clock.sleep(graphics.ui_wait_threshold * 2)
  graphics:set_message("DONE", counters.default_message_length)
  enc_counter[3]["waiting"] = false
  enc_counter[3]["this_clock"] = nil
  is_selecting_note(false)
  dirty_screen(true)
end

function set_seed(s)
  graphics:set_message("SEEDING...", counters.default_message_length)
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
  clock.sleep(graphics.ui_wait_threshold)
  enc_counter[3]["waiting"] = false
  enc_counter[3]["this_clock"] = nil
  seed_cells(s)
  dirty_screen(true)
end

function seed_cells(s)
  if s == 0 then
    graphics:set_message("CANCELED SEED", counters.default_message_length)
  else
    keeper:delete_all_cells()
    graphics:set_message("SEEDED " .. s, counters.default_message_length)
    for i = 1, s do
      random_cell()
    end
    keeper:deselect_cell()
  end
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
  keeper.selected_cell:set_offset(math.random(1, sound.meter))
  keeper.selected_cell:set_sound(math.random(68, 82))
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