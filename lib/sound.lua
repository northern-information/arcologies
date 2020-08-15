local sound = {}

function sound.init()
  sound.meter = 16
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


function sound:play(note, velocity)
  engine.hz(mu.note_num_to_freq(mu.snap_note_to_array(note, sound.notes_in_this_scale)))
end

return sound