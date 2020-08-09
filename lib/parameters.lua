local parameters = {}

params:add_separator("ARCOLOGIES")

params:add{ type = "number", id = "bpm", min = 20, max = 240, default = 120,
  action = function(x) parameters.bpm_listener(x) end
}
params:hide("bpm")

function parameters.init()
  params:bang()
  params:set("bpm", math.random(20, 240))
end

function parameters.bpm_listener(x)
  parameters.bpm_to_seconds = 60 / x
end



return parameters