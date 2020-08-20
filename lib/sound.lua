local sound = {}

function sound.init()
  sound.length = 16
  sound.playback = 0
  sound.default_root = 12
  sound.current_root = 12
  sound.default_scale = 0
  sound.current_scale = 0
  sound.current_scale_name = ""
  sound.current_scale_names = {}
  sound.notes_in_this_scale = {}
  for i = 1, #mu.SCALES do
    table.insert(sound.current_scale_names, mu.SCALES[i].name)
  end
  sound:set_scale(sound.default_scale)

  -- crow initialization
  if params:get("crow_out") == 1 then
    print("crow on")
    -- crow.init()
    -- crow.clear()
    -- crow.reset()
    -- crow.output[2].action = "pulse(.025, 5, 1)"
    -- crow.output[4].action = "pulse(.025, 5, 1)"
  end

  -- midi initialization
  if params:get("midi_out") == 1 then
    print("midi on")
  --   sound.midi_out = midi.connect(1)
  end
end

function sound:cycle_length(i)
  self.length = util.clamp(self.length + i, 1, 16)
end

function sound:set_playback(i)
  self.playback = util.clamp(i, 0, 1)
end

function sound:toggle_playback()
  if sound.playback == 0 then
    self:set_playback(1)
  else
    self:set_playback(0)
  end
  fn.dirty_screen(true)
end

function sound:set_scale(i)
  self.current_scale = util.clamp(i, 1, #self.current_scale_names)
  self.current_scale_name = sound.current_scale_names[sound.current_scale]
  self:build_scale()
end

function sound:cycle_root(i)
  self.current_root = fn.cycle(self.current_root + i, 1, 12)
  self:build_scale()
end

function sound:build_scale()
  self.notes_in_this_scale = mu.generate_scale_of_length(self.current_root, self.current_scale, 127)
end


function sound:play(note, velocity, out)
  if out == "crow" then
    crow.output[1].volts = mu.snap_note_to_array(note, sound.notes_in_this_scale) -- % 12
    crow.output[2].execute()
  elseif out =="midi" then
    -- self.midi_out:note_off this cell
    self.midi_out:note_on(mu.snap_note_to_array(note, sound.notes_in_this_scale))
  else
    engine.hz(mu.note_num_to_freq(mu.snap_note_to_array(note, sound.notes_in_this_scale)))
  end
end

return sound