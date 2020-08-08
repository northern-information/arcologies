local parameters = {}

params:add_separator("ARCOLOGIES")

params:add{ type = "number", id = "grid_width", default = 16 }
-- params:hide("grid_width")

params:add{ type = "number", id = "grid_height", default = 8 }
-- params:hide("grid_height")

params:add{ type = "number", id = "playback", min = 0, max = 1, default = 0 }
-- params:hide("playback")

params:add{ type = "number", id = "bpm", min = 20, max = 240, default = 120,
  action = function(x) parameters.bpm_listener(x) end
}
-- params:hide("bpm")

function parameters.init()
  params:bang()
  params:set("bpm", math.random(20, 240))
end

function parameters.bpm_listener(x)
  parameters.bpm_to_seconds = 60 / x
end

function parameters.toggle_playback()
  if params:get("playback") == 0 then
    params:set("playback", 1)
  else
   params:set("playback", 0)
  end
  dirty_screen(true)
end

return parameters