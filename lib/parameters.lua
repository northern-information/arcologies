local parameters = {}

function parameters.init()
  params:bang()
  params:set("bpm", math.random(20, 240))
end

params:add_separator("ARCOLOGIES")

params:add{ type = "number", id = "bpm", name = "BPM",
  min = 20, max = 240, default = 120,
  action = function(x) parameters.bpm_listener(x) end
}

function parameters.bpm_listener(x)
  parameters.bpm_to_seconds = 60 / x
end

params:add{ type = "number", id = "seed", name = "SEED",
  min = 0, max = math.floor(fn.grid_width() * fn.grid_height() / 4), default = 5
}
params:hide("seed")

return parameters