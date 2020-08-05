local parameters = {}

params:add{ type = "number", id = "playback", min = 0, max = 1, default = 0 }
params:hide("playback")

params:add{ type = "number", id = "bpm", min = 20, max = 240, default = 120,
  action = function(x) parameters.bpm_listener(x) end
}
params:hide("bpm")

params:add{ type = "number", id = "static_animation", min = 0, max = 1, default = 0,
  action = function(x) parameters.static_animation_listener(x) end
}
params:hide("static_animation")

params:add{ type = "number", id = "enc_confirm_index", min = 1, max = 43, default = 1,
  action = function(x) parameters.enc_confirm_index_listener(x) end
}
params:hide("enc_confirm_index")

params:add{ type = "number", id = "page_structure", min = 1, max = 3, default = 1 }
params:hide("page_structure")

params:add{ type = "number", id = "page_metabolism", min = 1, max = 16, default = 4 }
params:hide("page_metabolism")

params:add{ type = "number", id = "page_sound", min = 1, max = 144, default = 73 }
params:hide("page_sound")

function parameters.init()
  params:bang()
  params:set("bpm", math.random(20, 240))
end

function parameters.bpm_listener(x)
  parameters.bpm_to_seconds = 60 / x
end

function parameters.enc_confirm_index_listener(x)
  parameters.enc_confirm_index = x
end

function parameters.static_animation_listener(x)
  parameters.static_animation_value = (x == 0) and "C" or "S"
end

function parameters.toggle_status()
  if params:get("playback") == 0 then
    params:set("playback", 1)
  else
   params:set("playback", 0)
  end
end

return parameters