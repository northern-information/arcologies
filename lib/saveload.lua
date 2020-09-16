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
    tmp.amortize         = load_cell.amortize        or amortize_trait.amortize
    tmp.capacity         = load_cell.capacity        or capacity_trait.capacity
    tmp.channel          = load_cell.channel         or 1
    tmp.charge           = load_cell.charge          or charge_trait.charge
    tmp.crow_out         = load_cell.crow_out        or crow_out_trait.crow_out
    tmp.crumble          = load_cell.crumble         or crumble_trait.crumble
    tmp.deflect          = load_cell.deflect         or deflect_trait.deflect
    tmp.depreciate       = load_cell.depreciate      or depreciate_trait.depreciate
    tmp.device           = load_cell.device          or device_trait.device
    tmp.drift            = load_cell.drift           or drift_trait.drift
    tmp.duration         = load_cell.duration        or 16
    tmp.interest         = load_cell.interest        or interest_trait.interest
    tmp.level            = load_cell.level           or level_trait.level
    tmp.metabolism       = load_cell.metabolism      or metabolism_trait.metabolism
    tmp.network_value    = load_cell.network_value   or network_value_trait.network_value
    tmp.net_income       = load_cell.net_income      or net_income_trait.net_income
    tmp.note_count       = load_cell.note_count      or note_count_trait.note_count
    tmp.notes            = load_cell.notes           or notes_trait.notes
    tmp.offset           = load_cell.offset          or offset_trait.offset
    tmp.operator         = load_cell.operator        or operator_trait.operator
    tmp.ports            = load_cell.ports           or ports_trait.ports
    tmp.probability      = load_cell.probability     or probability_trait.probability
    tmp.pulses           = load_cell.pulses          or pulses_trait.pulses
    tmp.range_max        = load_cell.range_max       or range_max_trait.range_max
    tmp.range_min        = load_cell.range_min       or range_min_trait.range_min
    tmp.state_index      = load_cell.state_index     or state_index_trait.state_index
    tmp.structure_value  = load_cell.structure_value or structure_value_trait.structure_value
    tmp.sub_menu_items   = load_cell.sub_menu_items  or sub_menu_items_trait.sub_menu_items
    tmp.taxes            = load_cell.taxes           or taxes_trait.taxes
    tmp.territory        = load_cell.territory       or territory_trait.territory
    tmp.velocity         = load_cell.velocity        or velocity_trait.velocity
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