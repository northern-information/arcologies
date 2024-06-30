parameters = {}

function parameters.init()

  params:add_separator("")
  params:add_separator("- A R C O L O G I E S -")

  params:add_trigger("save", "< SAVE ARCOLOGY" )
  params:set_action("save", function(x) textentry.enter(filesystem.save) end)

  params:add_trigger("load", "> LOAD ARCOLOGY" )
  params:set_action("load", function(x) fileselect.enter(norns.state.data, filesystem.load) end)

  params:add_trigger("save_map", "< SAVE MAP" )
  params:set_action("save_map", function(x) textentry.enter(filesystem.save_map) end)

  params:add_trigger("midi_panic", "> MIDI PANIC!" )
  params:set_action("midi_panic", function() _midi:all_off() end)

  params:add_option("crypts_directory", "CRYPT(S)", filesystem.crypts_names, 1)
  params:set_action("crypts_directory", function(index) filesystem:set_crypt(index) end)

  params:add{ type = "number", id = "popup_patience", name = "POPUP PATIENCE",
    min = 0.5, max = 4.0, default = 0.5,
  }

  parameters.is_designer_jump_on = true
  params:add_option("designer_jump", "DESIGNER JUMP", {"ENABLED", "DISABLED"})
  params:set_action("designer_jump", function(index) parameters.is_designer_jump_on = index == 1 and true or false end)

  parameters.is_splash_screen_on = true
  params:add_option("splash_screen", "SPLASH SCREEN", {"ENABLED", "DISABLED"})
  params:set_action("splash_screen", function(index) parameters.is_splash_screen_on = index == 1 and true or false end)

  parameters.is_grayscale_on = false
  params:add_option("grayscale", "GRAYSCALE", {"DISABLED", "ENABLED"})
  params:set_action("grayscale", function(index) parameters.is_grayscale_on = index == 2 and true or false end)

  params:add_separator("")
  params:add_separator("NB / APIARY")
  nb_selector_names = {"nb_1", "nb_2", "nb_3", "nb_4"}
  nb:add_param(nb_selector_names[1], nb_selector_names[1])
  nb:add_param(nb_selector_names[2], nb_selector_names[2])
  nb:add_param(nb_selector_names[3], nb_selector_names[3])
  nb:add_param(nb_selector_names[4], nb_selector_names[4])
  nb:add_player_params()

  params:add_separator("")
  params:add_separator("KUDZU MANAGEMENT")

  params:add{ type = "number", id = "kudzu_metabolism", name = "KUDZU METABOLISM",
    min = 0, max = 16, default = 13
  }

  params:add{ type = "number", id = "kudzu_resilience", name = "KUDZU RESILIENCE",
    min = 0, max = 100, default = 25
  }

  params:add{ type = "number", id = "kudzu_crumble", name = "KUDZU CRUMBLE",
    min = 0, max = 100, default = 10
  }

  params:add{ type = "number", id = "kudzu_aggression", name = "KUDZU AGGRESSION",
    min = 0, max = 10, default = 1
  }

  params:add{ type = "number", id = "kudzu_cropdust_potency", name = "KUDZU CROPDUST POTENCY",
    min = 1, max = 100, default = 1
  }

  params:add_trigger("cropdust", "> CROPDUST" )
  params:set_action("cropdust", function() keeper:cropdust() end)

  params:add_separator("")
  params:add_separator("I2C STATION")

  params:add_option("jf_i2c_mode", "JF I2C MODE", {"1", "0"})
  params:set_action("jf_i2c_mode", function(index) crow.ii.jf.mode(index == 1 and 1 or 0) end)

  params:add_option("jf_i2c_tuning", "JF I2C TUNING", {"440 Hz", "432 Hz"})
  params:set_action("jf_i2c_tuning", function(index) crow.ii.jf.god_mode(index == 2 and 1 or 0) end)

  params:add_separator("")
  params:add_separator("RESEED CIVLIZATION")

  params:add_trigger("destroy_and_seed", "> DESTROY & SEED NEW" )
  params:set_action("destroy_and_seed", function() fn.seed_cells() end)

  params:add{ type = "number", id = "seed_cell_count", name = "CELL POPULATION",
    min = 0, max = 32, default = 16
  }

  params:add{ type = "number", id = "note_range_min", name = "NOTE RANGE MIN",
    min = 0, max = 100, default = 40
  }
  params:set_action("note_range_min", function(x) params:set("note_range_max", util.clamp(params:get("note_range_max"), x, 100)) end)

  params:add{ type = "number", id = "note_range_max", name = "NOTE RANGE MAX",
    min = 0, max = 100, default = 60
  }
  params:set_action("note_range_max", function(x) params:set("note_range_min", util.clamp(params:get("note_range_min"), 0, x)) end)

  params:add_separator("")
  params:add_separator("ARC BINDINGS")

  parameters.arc_binding_labels = {}
  for i = 1, #config.arc_bindings do
    parameters.arc_binding_labels[i] = config.arc_bindings[i].label
  end
  for i = 1, 4 do
    local id = "arc_encoder_" .. i
    params:add_option(id , "ENCODER " .. i, parameters.arc_binding_labels)
    params:set_action(id, function(index) _arc:bind(i, config.arc_bindings[index].id) end)
    params:set(id, i)
  end
  parameters.arc_orientations = { 0, 90, 180, 270 }
  params:add_option("arc_orientation", "ROTATION", parameters.arc_orientations)
  params:set_action("arc_orientation", function(index) _arc:set_orientation(parameters.arc_orientations[index]) end)

  params:add_separator("")
  params:add_separator("STRUCTURES")

  parameters.structures = {}
  for k,v in pairs(structures:all_names()) do
    parameters.structures[v] = false
    local id = "structure_" .. v
    params:add_option(id, v, {"ENABLED", "DISABLED"})
    params:set_action(id, function(index)
      parameters.structures[id] = index == 1 and true or false
      structures:scan()
      structures:delete_disabled()
    end)
  end

  params:add_separator("")
  params:add_separator("<<< !!! DANGER ZONE !!! >>>")

  parameters.danger_zone_clock_sync_options = {0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1, 1.125, 1.25, 1.375, 1.5, 1.625, 1.75, 1.875, 2}
  parameters.danger_zone_clock_sync_value = 1
  params:add_option("danger_zone_clock_sync", "clock.sync(x)", parameters.danger_zone_clock_sync_options, 8)
  params:set_action("danger_zone_clock_sync", function(index) parameters.danger_zone_clock_sync_value = parameters.danger_zone_clock_sync_options[index] end)


  params:default()
  params:bang()
end

return parameters