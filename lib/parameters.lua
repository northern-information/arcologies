parameters = {}

function parameters.init()

  params:add_separator("- A R C O L O G I E S -")

  params:add_trigger("save", "< SAVE" )
  params:set_action("save", function(x) te.enter(filesystem.save) end)

  params:add_trigger("load", "> LOAD" )
  params:set_action("load", function(x) fs.enter(norns.state.data, filesystem.load) end)

  params:add_trigger("midi_panic", "> MIDI PANIC!" )
  params:set_action("midi_panic", function() m:panic() end)

  params:add_option("crypts_directory", "CRYPT(S)", filesystem.crypts_names, 1)
  params:set_action("crypts_directory", function(index) filesystem:set_crypt(index) end)

  params:add{ type = "number", id = "kudzu_aggression", name = "KUDZU AGGRESSION",
    min = 0, max = 10, default = 1
  }

  params:add{ type = "number", id = "kudzu_crumble_multiple", name = "KUDZU CRUMBLE MULTIPLE",
    min = 1, max = 100, default = 1
  }

  params:add_trigger("kudzu_crumble", "> KUDZU CRUMBLE" )
  params:set_action("kudzu_crumble", function() keeper:crumble_kudzu() end)

  params:add_option("jf_i2c_mode", "JF I2C MODE", {"1", "0"})
  params:set_action("jf_i2c_mode", function(index) crow.ii.jf.mode(index == 1 and 1 or 0) end)

  params:add_option("jf_i2c_tuning", "JF I2C TUNING", {"440 Hz", "432 Hz"})
  params:set_action("jf_i2c_tuning", function(index) crow.ii.jf.god_mode(index == 2 and 1 or 0) end)

  params:add{ type = "number", id = "popup_patience", name = "POPUP PATIENCE",
    min = 0.5, max = 4.0, default = 0.5,
  }

  parameters.is_designer_jump_on = true
  params:add_option("designer_jump", "DESIGNER JUMP", {"ENABLED", "DISABLED"})
  params:set_action("designer_jump", function(index) parameters.is_designer_jump_on = index == 1 and true or false end)

  parameters.is_splash_screen_on = true
  params:add_option("splash_screen", "SPLASH SCREEN", {"ENABLED", "DISABLED"})
  params:set_action("splash_screen", function(index) parameters.is_splash_screen_on = index == 1 and true or false end)

  params:add_separator("- S E E D -")

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

  parameters.seed_structures = {}
  for k,v in pairs(structures:all()) do
    parameters.seed_structures[v] = false
    local id = "seed_structure_" .. v
    params:add_option(id, v, {"ENABLED", "DISABLED"})
    params:set_action(id, function(index) parameters.seed_structures[id] = index == 1 and true or false end)
  end

  params:default()
  params:bang()
end

return parameters