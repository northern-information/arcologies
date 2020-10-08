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
  _softcut.init()
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
  fn.dirty_grid(true)
  arcology_loaded = true
end

function saveload:load_cells(data)
  for k, load_cell in pairs(data.keeper_cells) do
    local tmp = Cell:new(load_cell.x, load_cell.y, load_cell.generation)
    -- pre 1.8 used a different key for structures
    local structure_key = (data.version_major == 1 and data.version_minor >= 2 or (data.version_minor <= 1 and data.version_patch <= 7)) and "structure_value" or "structure_name"
    -- if the structure doesn't exist anymore, load it as a hive.
    tmp.structure_name  = fn.table_find(structures:all_names(), load_cell[structure_key]) and load_cell[structure_key] or "HIVE"
    for k, v in pairs(tmp:get_save_keys()) do
      -- cells from older arcologies don't have newer attributes, so:
      tmp[v] = load_cell[v] or tmp[v]
    end
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

function saveload:collect_data_for_map_save(name)
  data = {
    width = fn.grid_width(),
    height = fn.grid_height(),
    arcology_name = name or arcology_name,
    cells = {}
  }
  for k, cell in pairs(keeper.cells) do
    table.insert(data.cells, {cell.x, cell.y, string.lower(cell.structure_name)})
  end
  return data
end

return saveload