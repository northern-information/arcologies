c = {}

function c.init()
  if config.outputs.crow then
    crow.init()
    crow.clear()
    crow.reset()
    crow.output[2].action = "pulse(.025, 5, 1)"
    crow.output[4].action = "pulse(.025, 5, 1)"
  end
  if config.outputs.jf and config.outputs.crow then
    crow.ii.pullup(true)
    crow.ii.jf.mode(1)
  end
end

function c:jf(note, duration)
  crow.ii.jf.play_note((note - 60) / 12, 5)
end

function c:play(note, pair)
  local output_pairs = {{1,2},{3,4}}
  crow.output[output_pairs[pair][1]].volts = (note - 60) / 12
  crow.output[output_pairs[pair][2]].execute()
end

return c