local parameters = {}

params:add{
  type = "number",
  id = "Status",
  min = 0,
  max = 1,
  default = 0
}

params:add{
  type = "number",
  id = "BPM",
  min = 20,
  max = 240,
  default = 120,
  action = function(x) parameters.bpm_listener(x) end
}

params:add{ type = "number", id = "Arbitrary1", min = 0, max = 1000, default = 500 }
params:add{ type = "number", id = "Arbitrary2", min = 0, max = 1000, default = 500 }
params:add{ type = "number", id = "Arbitrary3", min = 0, max = 1000, default = 500 }
params:add{ type = "number", id = "Arbitrary4", min = 0, max = 1000, default = 500 }
params:add{ type = "number", id = "Arbitrary5", min = 0, max = 1000, default = 500 }
params:add{ type = "number", id = "Arbitrary6", min = 0, max = 1000, default = 500 }

function parameters.init()
  params:bang()
  params:set("BPM", math.random(20, 240))
end

function parameters.bpm_listener(x)
  parameters.bpm_to_seconds = 60 / x
end

function parameters.toggle_status()
  if params:get("Status") == 0 then
    params:set("Status", 1)
  else
   params:set("Status", 0)
  end
end

return parameters