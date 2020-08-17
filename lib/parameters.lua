local parameters = {}

function parameters.init()
  params:add_separator("ARCOLOGIES")

  parameters.bpm_to_seconds = 0
  params:add{ type = "number", id = "bpm", name = "BPM",
    min = 20, max = 240, default = 120,
    action = function(x) parameters.bpm_to_seconds = 60 / x end
  }

  params:add{ type = "number", id = "seed", name = "SEED",
    min = 0, max = math.floor(fn.grid_width() * fn.grid_height() / 4), default = 13
  }
  params:hide("seed")

  params:add_option("crow_out", "CROW", {"ENABLED", "DISABLED"}, 1)
  params:add_option("just_friends_out", "JUST FRIENDS", {"ENABLED", "DISABLED"}, 1)
  params:add_option("midi_out", "MIDI", {"ENABLED", "DISABLED"}, 1)
  
  parameters.is_splash_screen_on = true
  params:add_option("splash_screen", "SPLASH SCREEN", {"ENABLED", "DISABLED"})
  params:set_action("splash_screen", function(x) parameters.is_splash_screen_on = x == 1 and true or false end)

  params:default()
  params:bang()
  params:set("bpm", math.random(20, 240))
end

return parameters