local parameters = {}

params:add{
  type = "number",
  id = "playback",
  min = 0,
  max = 1,
  default = 0
}
params:hide("playback")

params:add{
  type = "number",
  id = "bpm",
  min = 20,
  max = 240,
  default = 120,
  action = function(x) parameters.bpm_listener(x) end
}
params:hide("bpm")

params:add{
  type = "number",
  id = "static_animation_on",
  min = 0,
  max = 1,
  default = 1
}
params:hide("static_animation_on")

params:add{
  type = "number",
  id = "enc_confirm_index",
  min = 1,
  max = 43,
  default = 1,
  action = function(x) parameters.enc_confirm_index_listener(x) end
}
params:hide("enc_confirm_index")

-- temp until cells are up and running
params:add{ type = "number", id = "TempStructure", min = 1, max = 3, default = 1 }
params:hide("TempStructure")
params:add{ type = "number", id = "TempMetabolism", min = 1, max = 16, default = 4 }
params:hide("TempMetabolism")
params:add{ type = "number", id = "TempSound", min = 1, max = 144, default = 73 }
params:hide("TempSound")


function parameters.init()
  -- params:read(norns.state.data .. "arcologies.pset")
  params:bang()
  params:set("bpm", math.random(20, 240))
end

function parameters.bpm_listener(x)
  parameters.bpm_to_seconds = 60 / x
end

function parameters.enc_confirm_index_listener(x)
  parameters.enc_confirm_index = x
end

function parameters.toggle_status()
  if params:get("playback") == 0 then
    params:set("playback", 1)
  else
   params:set("playback", 0)
  end
end

return parameters