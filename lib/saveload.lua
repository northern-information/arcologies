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
      if data.version_major == 1 and 
         data.version_minor == 1 and 
         data.version_patch >= 4 then    self:load_114(data)

  elseif data.version_major == 1 and 
         data.version_minor == 1 then   self:load_110(data)

  elseif data.version_major == 1 and
         data.version_minor == 0 then   self:load_100(data)
  else 
    print("Error: arcology data is not in an acceptable format.")
  end
end


function saveload:load_114(data)
  arcology_name = data.arcology_name
  params:set("clock_tempo", data.clock_tempo)
  sound.length = data.length
  sound.root = data.root
  sound:set_scale(data.scale)
  counters.music_generation = data.counters_music_generation
  filesystem:load_crypt_by_name(data.crypt_name)
  keeper.init()
  for k, load_cell in pairs(data.keeper_cells) do
    local tmp = Cell:new(load_cell.x, load_cell.y, load_cell.generation)
    tmp.amortize         = load_cell.amortize
    tmp.capacity         = load_cell.capacity
    tmp.channel          = load_cell.channel
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

function saveload:load_110(data)
  arcology_name = data.arcology_name
  params:set("clock_tempo", data.bpm)
  sound.length = data.length
  sound.root = data.root
  sound:set_scale(data.scale)
  counters.music_generation = data.counters_music_generation
  filesystem:load_crypt_by_name(data.crypt_name)
  keeper.init()
  for k, load_cell in pairs(data.keeper_cells) do
    local tmp = Cell:new(load_cell.x, load_cell.y, load_cell.generation)
    tmp.amortize         = load_cell.amortize
    tmp.capacity         = load_cell.capacity
    tmp.channel          = 1
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

function saveload:load_100(data)
  arcology_name = data.arcology_name
  params:set("clock_tempo", data.bpm)
  sound.length = data.length
  sound.root = data.root
  sound:set_scale(data.scale)
  counters.music_generation = data.counters_music_generation
  filesystem:load_crypt_by_name(data.crypt_name)
  keeper.init()
  for k, load_cell in pairs(data.keeper_cells) do
    local tmp = Cell:new(load_cell.x, load_cell.y, load_cell.generation)
    tmp.capacity         = load_cell.capacity
    tmp.channel          = 1
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

return saveload