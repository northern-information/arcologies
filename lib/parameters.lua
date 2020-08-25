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

  params:add_separator("C R Y P T S")
  local crypts_names = { "arcologies/crypt" }
  for i = 1, #filesystem.crypts_names do
    crypts_names[1 + i] = filesystem.crypts_names[i]
  end
  params:add_option("crypts_directory", "SELECT", crypts_names, 1)
  params:set_action("crypts_directory", function(x) filesystem:set_crypt(x == 1 and "default" or crypts_names[x]) end)

  params:default()
  params:bang()
end

return parameters