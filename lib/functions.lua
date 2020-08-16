local fn = {}

function fn.init()
  fn.id_prefix = "arc-"
  fn.id_counter = 1000
end

function fn.no_grid()
  if fn.grid_width() == 0 then
    return true
  else 
    return false
  end
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
function fn.playback()
  return sound.playback == 0 and "READY" or "PLAYING"
end

function fn.grid_width()
  return g.cols
end

function fn.grid_height()
  return g.rows
end

function fn.index(x, y)
  return x + ((y - 1) * fn.grid_width())
end

function fn.id()
  fn.id_counter = fn.id_counter + 1
  return fn.id_prefix .. os.time(os.date("!*t")) .. "-" .. fn.id_counter
end

function fn.xy(cell)
  return "X" .. cell.x .. "Y" .. cell.y
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

function fn.nearest_value(table, number)
    local nearest_so_far, nearest_index
    for i, y in ipairs(table) do
        if not nearest_so_far or (math.abs(number-y) < nearest_so_far) then
            nearest_so_far = math.abs(number-y)
            nearest_index = i
        end
    end
    return table[nearest_index]
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

-- structure cycler

function fn.select_cell_structure(i) -- structure popup, function 1/3
  if enc_counter[3]["this_clock"] ~= nil then
    clock.cancel(enc_counter[3]["this_clock"])
    counters:reset_enc(3)
  end
  fn.is_selecting_structure(true)
  keeper.selected_cell:cycle_structure(i)
  fn.dirty_screen(true)
  if enc_counter[3]["this_clock"] == nil then
    enc_counter[3]["this_clock"] = clock.run(fn.select_structure_wait)
  end
end

function fn.is_selecting_structure(bool) -- structure popup, function 2/3
  if bool == nil then return selecting_structure end
  selecting_structure = bool
  return selecting_structure
end

function fn.select_structure_wait() -- structure popup, function 3/3
  enc_counter[3]["waiting"] = true
  clock.sleep(graphics.ui_wait_threshold * 2)
  graphics:set_message("DONE", counters.default_message_length)
  enc_counter[3]["waiting"] = false
  enc_counter[3]["this_clock"] = nil
  fn.is_selecting_structure(false)
  menu:focus_off()
  fn.dirty_screen(true)
end

-- piano / note picker

function fn.select_cell_note(i) -- piano keyboard popup, function 1/4
  graphics:set_message("NOTE...", counters.default_message_length)
  if enc_counter[3]["this_clock"] ~= nil then
    clock.cancel(enc_counter[3]["this_clock"])
    counters:reset_enc(3)
  end
  fn.is_selecting_note(true)
  keeper.selected_cell:set_note(fn.temp_note() + i)
  fn.dirty_screen(true)
  if enc_counter[3]["this_clock"] == nil then
    enc_counter[3]["this_clock"] = clock.run(fn.select_note_wait)
  end
end

function fn.temp_note() -- piano keyboard popup, function 2/4
 -- increment with either the note if is already in this scale or snap
  return
    fn.table_find(
      sound.notes_in_this_scale,
      keeper.selected_cell.note)
  or 
    fn.table_find(
      sound.notes_in_this_scale,
      mu.snap_note_to_array(
        keeper.selected_cell.note,
        sound.notes_in_this_scale))
end

function fn.is_selecting_note(bool) -- piano keyboard popup, function 3/4
  if bool == nil then return selecting_note end
  selecting_note = bool
  return selecting_note
end

function fn.select_note_wait() -- piano keyboard popup, function 4/4
  enc_counter[3]["waiting"] = true
  clock.sleep(graphics.ui_wait_threshold * 2)
  graphics:set_message("DONE", counters.default_message_length)
  enc_counter[3]["waiting"] = false
  enc_counter[3]["this_clock"] = nil
  fn.is_selecting_note(false)
  fn.dirty_screen(true)
end

-- seed

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
  keeper.selected_cell:set_structure(math.random(1, 2))
  local ports = { "n", "e", "s", "w" }
  for i = 1, #ports do
    if fn.coin() == 1 then
      keeper.selected_cell:open_port(ports[i])
    end
  end
  keeper.selected_cell:set_offset(math.random(1, sound.meter or 16))
  keeper.selected_cell:set_note(math.random(math.floor(#sound.notes_in_this_scale * .6, #sound.notes_in_this_scale * .8)))
end

return fn