fn = {}

-- state checks, utilities, and formatters

function fn.init()
  fn.id_prefix = "arc-"
  fn.id_counter = 1000
end

function fn.get_arcology_version()
  return config.settings.version_major .. "." ..
         config.settings.version_minor .. "." ..
         config.settings.version_patch
end

function fn.collect_data_for_save(name)
  data = {
    arcology_name = name or arcology_name,
    version_major = config.settings.version_major,
    version_minor = config.settings.version_minor,
    version_patch = config.settings.version_patch,
    bpm = params:get("bpm"),
    length = sound.length,
    root = sound.root,
    scale = sound.scale,
    counters_music_generation = counters.music.generation,
    crypt_name = filesystem.crypt_name,
    keeper_cells = {},
    keeper_signals = {}
  }
  for k, cell in pairs(keeper.cells) do
    table.insert(data.keeper_cells, fn.deep_copy(cell))
  end
  for k, signal in pairs(keeper.signals) do
    table.insert(data.keeper_signals, fn.deep_copy(signal))
  end
  return data
end

function fn.load(data)
  if data.version_major == 1 and data.version_minor == 0 then
    fn.load_10n(data)
  elseif data.version_major == 1 and data.version_minor == 1 then
    fn.load_11n(data)
  else 
    print("Error: arcology data is not in an acceptable format.")
  end
end

function fn.load_11n(data)
  arcology_name = data.arcology_name
  params:set("bpm", data.bpm)
  sound.length = data.length
  sound.root = data.root
  sound:set_scale(data.scale)
  counters.music.generation = data.counters_music_generation
  filesystem:load_crypt_by_name(data.crypt_name)
  keeper.init()
  for k, load_cell in pairs(data.keeper_cells) do
    local tmp = Cell:new(load_cell.x, load_cell.y, load_cell.generation)
    tmp.amortize         = load_cell.amortize
    tmp.capacity         = load_cell.capacity
    tmp.charge           = load_cell.charge
    tmp.crow_out         = load_cell.crow_out
    tmp.crumble          = load_cell.crumble
    tmp.deflect          = load_cell.deflect
    tmp.depreciate       = load_cell.depreciate
    tmp.device           = load_cell.device
    tmp.drift            = load_cell.drift
    tmp.duration         = load_cell.duration
    tmp.interest         = load_cell.interest
    tmp.level            = load_cell.level
    tmp.metabolism       = load_cell.metabolism
    tmp.network_value    = load_cell.network_value
    tmp.net_income       = load_cell.net_income
    tmp.note_count       = load_cell.note_count
    tmp.notes            = load_cell.notes
    tmp.offset           = load_cell.offset
    tmp.operator         = load_cell.operator
    tmp.ports            = load_cell.ports
    tmp.probability      = load_cell.probability
    tmp.pulses           = load_cell.pulses
    tmp.range_max        = load_cell.range_max
    tmp.range_min        = load_cell.range_min
    tmp.state_index      = load_cell.state_index
    tmp.structure_value  = load_cell.structure_value
    tmp.sub_menu_items   = load_cell.sub_menu_items
    tmp.taxes            = load_cell.taxes
    tmp.territory        = load_cell.territory
    tmp.velocity         = load_cell.velocity
    tmp:set_available_ports()
    table.insert(keeper.cells, tmp)
  end
  for k, load_signal in pairs(data.keeper_signals) do
    local tmp = Signal:new(load_signal.x, load_signal.y, load_signal.h, load_signal.generation)
    tmp.heading     = load_signal.heading
    tmp.index       = load_signal.index
    tmp.generation  = load_signal.generation
    tmp.y           = load_signal.y
    tmp.id          = load_signal.id
    tmp.x           = load_signal.x
    table.insert(keeper.signals, tmp)
  end
  arcology_loaded = true
end

function fn.load_10n(data)
  arcology_name = data.arcology_name
  params:set("bpm", data.bpm)
  sound.length = data.length
  sound.root = data.root
  sound:set_scale(data.scale)
  counters.music.generation = data.counters_music_generation
  filesystem:load_crypt_by_name(data.crypt_name)
  keeper.init()
  for k, load_cell in pairs(data.keeper_cells) do
    local tmp = Cell:new(load_cell.x, load_cell.y, load_cell.generation)
    tmp.capacity         = load_cell.capacity
    tmp.charge           = load_cell.charge
    tmp.crow_out         = load_cell.crow_out
    tmp.device           = load_cell.device
    tmp.duration         = 16
    tmp.state_index      = load_cell.state_index
    tmp.level            = load_cell.level
    tmp.metabolism       = load_cell.metabolism
    tmp.network_value    = load_cell.network_value
    tmp.note_count       = load_cell.note_count
    tmp.notes            = load_cell.notes
    tmp.offset           = load_cell.offset
    tmp.ports            = load_cell.ports
    tmp.probability      = load_cell.probability
    tmp.pulses           = load_cell.pulses
    tmp.range_max        = load_cell.range_max
    tmp.range_min        = load_cell.range_min
    tmp.structure_value  = load_cell.structure_value
    tmp.sub_menu_items   = load_cell.sub_menu_items
    tmp.velocity         = load_cell.velocity
    tmp:set_available_ports()
    table.insert(keeper.cells, tmp)
  end
  for k, load_signal in pairs(data.keeper_signals) do
    local tmp = Signal:new(load_signal.x, load_signal.y, load_signal.h, load_signal.generation)
    tmp.heading     = load_signal.heading
    tmp.index       = load_signal.index
    tmp.generation  = load_signal.generation
    tmp.y           = load_signal.y
    tmp.id          = load_signal.id
    tmp.x           = load_signal.x
    table.insert(keeper.signals, tmp)
  end
  arcology_loaded = true
end

function fn.get_structure_attributes(name)
  return config.structure_attribute_map[name]
end

function fn.id()
  -- a servicable attempt creating unique ids
  -- i (tried a md5 library but it tanked performance)
  fn.id_counter = fn.id_counter + 1
  return fn.id_prefix .. os.time(os.date("!*t")) .. "-" .. fn.id_counter
end

function fn.grid_width()
  return g.last_known_width
end

function fn.grid_height()
  return g.last_known_height
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

function fn.playback()
  return sound.playback == 0 and "READY" or "PLAYING"
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

function fn.wrap(t, l)
  for i = 1, l do
    table.insert(t, 1, t[#t])
    table.remove(t, #t)
  end
  return t
end

function fn.table_find(t, element)
  for i,v in pairs(t) do
    if v == element then
      return i
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

function fn.cycle(value, min, max)
  if value > max then
    return min
  elseif value < 1 then
    return max
  else
    return value
  end
end

function fn.long_press(k)
  -- anythin greater than half a second is a long press
  clock.sleep(.5)
  key_counter[k] = nil
  if k == 3 then
    popup:launch("delete_all", true, "key", 3)
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

function fn.break_splash(bool)
  if bool == nil then return splash_break end
  splash_break = bool
  return splash_break
end

function fn.dismiss_messages()
  fn.break_splash(true)
  g:dismiss_disconnect()
end

-- the lost souls

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

function fn.cleanup()
  g.all(0)
  poll:clear_all()
  if config.outputs.midi then
    m:cleanup()
  end
  if config.outputs.crow then
    crow.clear()
    crow.reset()
  end
  if config.outputs.jf then
    crow.ii.jf.mode(0)
  end
end

function fn.seed_cells()
  if params:get("seed_cell_count") ~= 0 and not fn.no_grid() then
    keeper:delete_all_cells()
    sound:set_random_root()
    sound:set_random_scale()
    params:set("bpm", math.random(100, 160))
    counters.music.generation = 0
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
  for k, v in pairs(parameters.seed_structures) do
    if v then
      local structure = string.gsub(k, "seed_structure_", "")
      table.insert(yes, structure)
    end
  end
  keeper.selected_cell:change(yes[math.random(1, #yes)])
  if keeper.selected_cell:is("SHRINE")
  or keeper.selected_cell:is("TOPIARY")
  or keeper.selected_cell:is("VALE")
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

return fn