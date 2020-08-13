local sound = {}

function sound.init()
  sound.meter = 16
  sound.playback = 0
  sound.default_out = 0
  sound.default_out_name = ""
  sound.default_out_names = {"AUDIO", "MIDI", "CROW", "iiJF"}
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
  sound:set_default_out(1)
  sound:set_scale(sound.default_scale)
end

function sound:cycle_meter(i)
  self.meter = util.clamp(self.meter + i, 1, 16)
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
  dirty_screen(true)
end

function sound:build_scale()
  -- left off here...
  self.notes_in_this_scale = mu.generate_scale_of_length(self.current_root, self.current_scale, 127)
  local num_to_add = 127 - #self.notes_in_this_scale
  for i = 1, num_to_add do
    table.insert(self.notes_in_this_scale, self.notes_in_this_scale[127 - num_to_add])
  end
  -- local new_scale = mu.generate_scale_of_length(self.current_root, self.current_scale, 127)
  -- local num_to_add = 127 - #new_scale
  -- print(#new_scale)
  -- self.notes_in_this_scale = {}
  -- for i = 1, num_to_add do
  --   table.insert(self.notes_in_this_scale, new_scale[127 - num_to_add])
  -- end
end

function sound:set_scale(i)
  self.current_scale = util.clamp(i, 1, #self.current_scale_names)
  self.current_scale_name = sound.current_scale_names[sound.current_scale]
  self:build_scale()
end

function sound:cycle_root(i)
  self.current_root = f.cycle(self.current_root + i, 1, 12)
end

function sound:set_default_out(i)
  sound.default_out = i
  sound.default_out_name = sound.default_out_names[sound.default_out]
end

function sound:play(note, velocity)
  engine.hz(mu.note_num_to_freq(note))
end

return sound