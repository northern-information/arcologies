fn = {}

-- seed

function fn.seed_cells()
  if params:get("seed_cell_count") ~= 0 and not fn.no_grid() then
    keeper:delete_all_cells()
    sound:set_random_root()
    sound:set_random_scale()
    params:set("clock_tempo", math.random(100, 160))
    counters.music_generation = 0
    for i = 1, params:get("seed_cell_count") do
      fn.random_cell()
    end
    keeper:deselect_cell()
    arcology_loaded = false
  end
end

function fn.random_cell()
  keeper:select_cell(fn.rx(), fn.ry())
  local yes = {}
  for k, v in pairs(parameters.structures) do
    if v then
      local structure = string.gsub(k, "structure_", "")
      table.insert(yes, structure)
    end
  end
  keeper.selected_cell:change(yes[math.random(1, #yes)])
  if keeper.selected_cell:has("NOTES")
  or keeper.selected_cell:is("CRYPT") then
    keeper.selected_cell:invert_ports()
  else
    local ports = { "n", "e", "s", "w" }
    for i = 1, #ports do
      if fn.coin() == 1 then
        keeper.selected_cell:open_port(ports[i])
      end
    end
  end
  if keeper.selected_cell:has("OFFSET") then
    keeper.selected_cell:set_offset(math.random(1, 5))
  end
  if keeper.selected_cell:has("METABOLISM") then
    keeper.selected_cell:set_metabolism(math.random(1, sound.length or 16))
  end
  if keeper.selected_cell:has("DURATION") then
    keeper.selected_cell:set_duration(math.random(1, sound.length or 16))
  end
  if keeper.selected_cell:has("DEFLECT") then
    keeper.selected_cell:set_deflect(math.random(1, 4))
  end
  if keeper.selected_cell:has("CRUMBLE") then
    keeper.selected_cell:set_crumble(math.random(1, 100))
  end
  if keeper.selected_cell:has("DRIFT") then
    keeper.selected_cell:set_crumble(math.random(1, 3))
  end
  if keeper.selected_cell:has("OPERATOR") then
    keeper.selected_cell:set_operator(math.random(1, 6))
  end
  if keeper.selected_cell:has("TERRITORY") then
    keeper.selected_cell:set_territory(math.random(1, 9))
  end
  if keeper.selected_cell:is("SHRINE") then
    keeper.selected_cell:set_note(sound:get_random_note(.6, .7), 1)
  end
  if keeper.selected_cell:is("DOME") then
    keeper.selected_cell:set_pulses(math.random(1, keeper.selected_cell.metabolism))
  end
  if keeper.selected_cell:is("CRYPT") then
    keeper.selected_cell:set_state_index(math.random(1, 6))
  end
end

-- general

function fn.init()
  fn.id_prefix = "arc-"
  fn.id_counter = 1000
end

function fn.cleanup()
  crow.ii.jf.mode(0)
  _midi:all_off()
  clock.cancel(music_clock_id)
  clock.cancel(redraw_clock_id)
  clock.cancel(grid_clock_id)
end

function fn.get_arcology_version()
  return config.settings.version_major .. "." ..
         config.settings.version_minor .. "." ..
         config.settings.version_patch
end

function fn.id()
  -- a servicable attempt creating unique ids
  -- i (tried a md5 library but it tanked performance)
  fn.id_counter = fn.id_counter + 1
  return fn.id_prefix .. os.time(os.date("!*t")) .. "-" .. fn.id_counter
end

function fn.dirty_grid(bool)
  if bool == nil then return grid_dirty end
  grid_dirty = bool
  return grid_dirty
end

function fn.dirty_arc(bool)
  if bool == nil then return arc_dirty end
  arc_dirty = bool
  return arc_dirty
end

function fn.dirty_arc_values(bool)
  if bool == nil then return arc_values_dirty end
  arc_values_dirty = bool
  return arc_values_dirty
end

function fn.dirty_screen(bool)
  if bool == nil then return screen_dirty end
  screen_dirty = bool
  return screen_dirty
end

function fn.break_splash(bool)
  if bool == nil then return splash_break end
  splash_break = bool
  return splash_break
end

function fn.dismiss_messages()
  fn.break_splash(true)
  _grid:dismiss_disconnect()
end

function fn.long_press(k)
  -- anything greater than half a second is a long press
  clock.sleep(.5)
  key_counter[k] = nil
  if k == 3 then
    popup:launch("delete_all", true, "key", 3)
  end
  fn.dirty_screen(true)
end

function fn.is_clock_internal()
  return params:get("clock_source") == 1
end

function fn.playback()
  return counters.playback == 0 and "READY" or "PLAYING"
end

-- grid

function fn.grid_width()
  return _grid.last_known_width
end

function fn.grid_height()
  return _grid.last_known_height
end

function fn.index(x, y)
  return x + ((y - 1) * fn.grid_width())
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

function fn.no_grid()
  return fn.grid_width() == 0 and true or false
end

function fn.is_cell_vacant(x, y)
  if not fn.in_bounds(x, y) then
    return false
  end
  local check_index = fn.index(x, y)
  for k, cell in pairs(keeper.cells) do
    if check_index == cell.index then
      return false
    end
  end
  return true
end

function fn.get_vacant_neighbors(x, y)
  local neighbors = {}
  if fn.is_cell_vacant(x, y - 1) then table.insert(neighbors, "n") end
  if fn.is_cell_vacant(x + 1, y) then table.insert(neighbors, "e") end
  if fn.is_cell_vacant(x, y + 1) then table.insert(neighbors, "s") end
  if fn.is_cell_vacant(x - 1, y) then table.insert(neighbors, "w") end
  return neighbors
end

-- maths

function fn.coin()
  return math.random(0, 1)
end

function fn.round(num, decimals)
  local mult = 10 ^ (decimals or 0)
  return math.floor(num * mult + 0.5) / mult
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

function fn.cycle(value, min, max)
  if value > max then
    return min
  elseif value < min then
    return max
  else
    return value
  end
end

function fn.over_cycle(value, min, max)
  if value > max then
    return fn.over_cycle(value - max, min, max)
  elseif value < min then
    return fn.over_cycle(max - value, min, max)
  else
    return value
  end
end

-- tables

function fn.wrap(t, l)
  for i = 1, l do
    table.insert(t, 1, t[#t])
    table.remove(t, #t)
  end
  return t
end

function fn.table_find(t, element)
  for i, v in pairs(t) do
    if v == element then
      return i
    end
  end
  return false
end

function fn.key_find(t, element)
  for k, v in pairs(t) do
    if k == element then
      return true
    end
  end
  return false
end

function fn.table_has(tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end

function fn.deep_copy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
        copy[fn.deep_copy(orig_key)] = fn.deep_copy(orig_value)
    end
    setmetatable(copy, fn.deep_copy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

function fn.shift_table(t, shift_amount)
  if shift_amount == 0 then return t end
  for i = 1, shift_amount do
    local last_value = t[#t]
    table.insert(t, 1, last_value)
    table.remove(t, #t)
  end
  return t
end

function fn.reverse_shift_table(t, shift_amount)
  if shift_amount == 0 then return t end
  for i = 1, shift_amount do
    local first_value = t[1]
    table.remove(t, 1)
    table.insert(t, #t + 1, first_value)
  end
  return t
end

-- dev

function rerun()
  norns.script.load(norns.state.script)
end

function fn.screenshot()
  local which_screen = string.match(string.match(string.match(norns.state.script,"/home/we/dust/code/(.*)"),"/(.*)"),"(.+).lua")
  _norns.screen_export_png("/home/we/dust/" .. which_screen .. "-" .. os.time() .. ".png")
end

function fn.wtfscale()
  for i = 1, #sound.scale_notes do
    print(sound.scale_notes[i], musicutil.note_num_to_name(sound.scale_notes[i]))
  end
end

function fn.arcdebug()
  print(" ")
  print(" ")
  print(" ")
  print("start arcologies debug -------------------------------")
  print(" ")
  print("generated at: " .. os.date("%Y_%m_%d_%H_%M_%S") .. " / " .. os.time())
  print("name: " .. arcology_name)
  print("version: " .. fn.get_arcology_version())
  print("bpm: " .. params:get("clock_tempo"))
  print("root: " .. sound.root)
  print("scale: " .. sound.scale_name)
  print("generation: " .. counters.music_generation)
  print("cell count: " .. #keeper.cells)
  print("signal count: " .. #keeper.signals)
  print(" ")
  print("cell census:")
  for k,cell in pairs(keeper.cells) do
    local coords = "x" .. cell.x .. "y" .. cell.y
    print(coords, cell.id, cell.structure_name)
  end
  print(" ")
  print("signal census:")
  for k,signal in pairs(keeper.signals) do
    local coords = "x" .. signal.x .. "y" .. signal.y
    print(coords, signal.id, signal.heading)
  end
  print(" ")
  print("end arcologies debug -------------------------------")
  print(" ")
  print(" ")
  print(" ")
end

return fn