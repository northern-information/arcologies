local parameters = {}

function parameters.init()
  params:add_separator("A R C O L O G I E S")

  parameters.bpm_to_seconds = 0
  params:add{ type = "number", id = "bpm", name = "BPM",
    min = 20, max = 240, default = 120,
    action = function(x) parameters.bpm_to_seconds = 60 / x end
  }

  params:add{ type = "number", id = "seed", name = "SEED",
    min = 0, max = 32, default = 16
  }
  params:hide("seed")

  parameters.is_splash_screen_on = true
  params:add_option("splash_screen", "SPLASH SCREEN", {"ENABLED", "DISABLED"})
  params:set_action("splash_screen", function(x) parameters.is_splash_screen_on = x == 1 and true or false end)

  params:default()
  params:bang()
end

return parameters