c = {}

function c.init()
  -- crow initialization
  if config.outputs.crow then
    crow.init()
    crow.clear()
    crow.reset()
    crow.output[2].action = "pulse(.025, 5, 1)"
    crow.output[4].action = "pulse(.025, 5, 1)"
  end
end

function c.play(note)
  crow.output[1].volts = note % 12
  crow.output[2].execute()
end

return c