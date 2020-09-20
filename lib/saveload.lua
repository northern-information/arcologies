saveload = {}

function saveload:collect_data_for_save(name)
  data = {
    arcology_name = name or arcology_name,
    version_major = config.settings.version_major,
    version_minor = config.settings.version_minor,
    version_patch = config.settings.version_patch,
    clock_tempo = params:get("clock_tempo"),
    length = sound.length,
    root = sound.root,
    scale = sound.scale,
    transpose = sound.transpose,
    counters_music_generation = counters.music_generation,
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

function saveload:load(data)
  counters:stop()
  s.init()
  arcology_name = data.arcology_name
  params:set("clock_tempo", data.clock_tempo or data.bpm)
  sound.length = data.length
  sound.root = data.root
  sound:set_scale(data.scale)
  sound.transpose = data.transpose or 0
  counters.music_generation = data.counters_music_generation
  keeper.init()
  filesystem:load_crypt_by_name(data.crypt_name)
  saveload:load_cells(data)
  saveload:load_signals(data)
  keeper:update_all_crypts()
  arcology_loaded = true
end

function saveload:load_cells(data)
  for k, load_cell in pairs(data.keeper_cells) do
    local tmp = Cell:new(load_cell.x, load_cell.y, load_cell.generation)
    -- if the structure doesn't exist anymore, load it as a hive.
    tmp.structure_value  = (type(fn.table_find(structures:all(), load_cell.structure_value)) == "number") and load_cell.structure_value or "HIVE"
    -- cells from older arcologies don't have newer attributes, so...
    tmp.capacity         = load_cell.capacity        or tmp.capacity
    tmp.channel          = load_cell.channel         or tmp.channel
    tmp.charge           = load_cell.charge          or tmp.charge
    tmp.crow_out         = load_cell.crow_out        or tmp.crow_out
    tmp.crumble          = load_cell.crumble         or tmp.crumble
    tmp.deflect          = load_cell.deflect         or tmp.deflect
    tmp.device           = load_cell.device          or tmp.device
    tmp.drift            = load_cell.drift           or tmp.drift
    tmp.duration         = load_cell.duration        or tmp.duration
    tmp.level            = load_cell.level           or tmp.level
    tmp.metabolism       = load_cell.metabolism      or tmp.metabolism
    tmp.network_value    = load_cell.network_value   or tmp.network_value
    tmp.note_count       = load_cell.note_count      or tmp.note_count
    tmp.notes            = load_cell.notes           or tmp.notes
    tmp.offset           = load_cell.offset          or tmp.offset
    tmp.operator         = load_cell.operator        or tmp.operator
    tmp.ports            = load_cell.ports           or tmp.ports
    tmp.probability      = load_cell.probability     or tmp.probability
    tmp.pulses           = load_cell.pulses          or tmp.pulses
    tmp.range_max        = load_cell.range_max       or tmp.range_max
    tmp.range_min        = load_cell.range_min       or tmp.range_min
    tmp.resilience       = load_cell.resilience      or tmp.resilience
    tmp.state_index      = load_cell.state_index     or tmp.state_index
    tmp.sub_menu_items   = load_cell.sub_menu_items  or tmp.sub_menu_items
    tmp.territory        = load_cell.territory       or tmp.territory
    tmp.velocity         = load_cell.velocity        or tmp.velocity
    tmp:set_available_ports()
    tmp:set_er()
    table.insert(keeper.cells, tmp)
  end
end

function saveload:load_signals(data)
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
end

return saveload