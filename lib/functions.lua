local fn = {}

function fn.init()
  fn.id_prefix = "arc-"
  fn.id_counter = 1000
end

-- user interactions

function fn.long_press(k)
  clock.sleep(1)
  key_counter[k] = nil
  if k == 3 then
    keeper:delete_all_cells()
    fn.is_deleting(false)
    graphics:set_message("DELETED", counters.default_message_length)
  end
  fn.dirty_screen(true)
end

-- simple boolean getters/setters/checks

function fn.dirty_grid(bool)
  if bool == nil then return grid_dirty end
  grid_dirty = bool
  return grid_dirty
end

function fn.dirty_screen(bool)
  if bool == nil then return screen_dirty end
  screen_dirty = bool
  return screen_dirty
end

function fn.is_deleting(bool)
  if bool == nil then return deleting end
  deleting = bool
  return deleting
end

function fn.is_selecting_seed(bool)
  if bool == nil then return selecting_seed end
  selecting_seed = bool
  return selecting_seed
end

-- reusable parameter functions

function fn.cycle(value, min, max)
  if value > max then
    return min
  elseif value < 1 then
    return max
  else
    return value
  end
end

-- frequently used state checks, utilities, and formatters

function fn.grid_width()
  return g.cols
end

function fn.grid_height()
  return g.rows
end

function fn.index(x, y)
  return x + ((y - 1) * fn.grid_width())
end

function fn.grid_frame()
  return counters.grid.frame
end

function fn.generation()
  return counters.music.generation
end

function fn.ui_quarter_frame_fmod(i)
  return math.fmod(counters.ui.quarter_frame, i) + 1
end
function fn.generation_fmod(i)
  return math.fmod(fn.generation(), i) + 1
end

function fn.id()
  fn.id_counter = fn.id_counter + 1
  return fn.id_prefix .. os.time(os.date("!*t")) .. "-" .. fn.id_counter
end

function fn.rx()
  return math.random(1, fn.grid_width())
end

function fn.ry()
  return math.random(1, fn.grid_height())
end

function fn.coin()
  return math.random(0, 1)
end

function fn.table_find(t, element)
  for i,v in pairs(t) do
    if v == element then
      return i
    end
  end
end

function fn.in_bounds(x, y)
  if 1 > y then
    return false -- north
  elseif fn.grid_width() < x then
    return false -- east
  elseif fn.grid_height() < y then
    return false -- south
  elseif 1 > x then
    return false -- west
  else
    return true -- ok
  end
end

-- hyper specific features that combine many entities

function fn.set_note(i) -- piano keyboard popup, function 1/3
  graphics:set_message("NOTE...", counters.default_message_length)
  if enc_counter[3]["this_clock"] ~= nil then
    clock.cancel(enc_counter[3]["this_clock"])
    counters:reset_enc(3)
  end
  fn.is_selecting_note(true)
  keeper.selected_cell:set_note(keeper.selected_cell.note + i)
  fn.dirty_screen(true)
  if enc_counter[3]["this_clock"] == nil then
    enc_counter[3]["this_clock"] = clock.run(fn.select_note_wait)
  end
end

function fn.is_selecting_note(bool) -- piano keyboard popup, function 2/3
  if bool == nil then return selecting_note end
  selecting_note = bool
  return selecting_note
end

function fn.select_note_wait() -- piano keyboard popup, function 2/3
  enc_counter[3]["waiting"] = true
  clock.sleep(graphics.ui_wait_threshold * 2)
  graphics:set_message("DONE", counters.default_message_length)
  enc_counter[3]["waiting"] = false
  enc_counter[3]["this_clock"] = nil
  fn.is_selecting_note(false)
  fn.dirty_screen(true)
end

function fn.set_seed(s) -- seed arcologies, function 1/4
  graphics:set_message("SEEDING...", counters.default_message_length)
  if enc_counter[3]["this_clock"] ~= nil then
    clock.cancel(enc_counter[3]["this_clock"])
    counters:reset_enc(3)
  end
  fn.is_selecting_seed(true)
  params:set("seed", s)
  fn.dirty_screen(true)
  if enc_counter[3]["this_clock"] == nil then
    enc_counter[3]["this_clock"] = clock.run(fn.seed_wait, s)
  end
end

function fn.seed_wait() -- seed arcologies, function 2/4
  enc_counter[3]["waiting"] = true
  clock.sleep(graphics.ui_wait_threshold)
  enc_counter[3]["waiting"] = false
  enc_counter[3]["this_clock"] = nil
  fn.seed_cells()
  fn.is_selecting_seed(false)
  fn.dirty_screen(true)
end

function fn.seed_cells() -- seed arcologies, function 3/4
  if params:get("seed") == 0 then
    graphics:set_message("ABORTED SEED", counters.default_message_length)
  else
    keeper:delete_all_cells()
    graphics:set_message("SEEDED " .. params:get("seed"), counters.default_message_length)
    for i = 1, params:get("seed") do
      fn.random_cell()
    end
    keeper:deselect_cell()
  end
end

function fn.random_cell() -- seed arcologies, function 4/4
  keeper:select_cell(fn.rx(), fn.ry())
  keeper.selected_cell:set_structure(math.random(1, 3))
  local ports = { "n", "e", "s", "w" }
  for i = 1, #ports do
    if fn.coin() then
      keeper.selected_cell:open_port(ports[i])
    end
  end
  keeper.selected_cell:set_offset(math.random(1, sound.meter or 16))
  keeper.selected_cell:set_note(math.random(68, 82))
end

return fn