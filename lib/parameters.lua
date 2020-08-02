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

params:add{
  type = "number",
  id = "Static",
  min = 0,
  max = 1,
  default = 1
}

params:add{
  type = "number",
  id = "TempStructure",
  min = 1,
  max = 3,
  default = 1
}

params:add{
  type = "number",
  id = "TempMetabolism",
  min = 1,
  max = 16,
  default = 4
}

params:add{
  type = "number",
  id = "TempSound",
  min = 1,
  max = 144,
  default = 73
}

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