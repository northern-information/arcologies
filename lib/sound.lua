local sound = {}

function sound.init()
  sound.playback = 0
  sound.default_out = 0
  sound.default_out_name = ""
  sound.default_out_names = {"AUDIO", "MIDI", "CROW", "iiJF"}
  sound.current_scale = 0
  sound.current_scale_name = ""
  sound.current_scale_names = {}
  for i = 1, #mu.SCALES do
    table.insert(sound.current_scale_names, mu.SCALES[i].name)
  end
  sound:set_default_out(1)
  sound:set_scale(1)
end

function sound:set_playback(i)
  sound.playback = i
end

function sound:toggle_playback()
  if sound.playback == 0 then
    self:set_playback(1)
  else
    self:set_playback(0)
  end
  dirty_screen(true)
end

function sound:set_scale(i)
  sound.current_scale = i
  sound.current_scale_name = sound.current_scale_names[sound.current_scale]
end

function sound:set_default_out(i)
  sound.default_out = i
  sound.default_out_name = sound.default_out_names[sound.default_out]
end

function sound:play(note, velocity)
  -- engine.hz(mu.note_num_to_freq(note))
end

return sound