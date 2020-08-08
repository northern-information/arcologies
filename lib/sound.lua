local sound = {}

function sound.init() end

function sound:play(note, velocity)
  engine.hz(mu.note_num_to_freq(note))
end

return sound