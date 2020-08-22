local sound = {}

function sound.init()
  sound.length = config.settings.length
  sound.playback = config.settings.playback
  sound.root = config.settings.root
  sound.scale = config.settings.scale
  sound.octaves = config.settings.octaves
  sound.scale_name = ""
  sound.scale_names = {}
  for k,v in pairs(mu.SCALES) do sound.scale_names[k] = mu.SCALES[k].name end
  sound.scale_notes = {}
  sound:set_scale(sound.scale)
end

function sound:snap_note(note)
  return mu.snap_note_to_array(note, self.scale_notes)
end

function sound:cycle_length(i)
  self.length = util.clamp(self.length + i, 1, 16)
end

function sound:set_playback(i)
  self.playback = util.clamp(i, 0, 1)
end

function sound:toggle_playback()
  if self.playback == 0 then
    self:set_playback(1)
  else
    self:set_playback(0)
  end
  fn.dirty_screen(true)
end

function sound:set_scale(i)
  self.scale = util.clamp(i, 1, #self.scale_names)
  self.scale_name = sound.scale_names[sound.scale]
  self:build_scale()
end

function sound:cycle_root(i)
  self.root = fn.cycle(self.root + i, 0, 12)
  self:build_scale()
end

function sound:build_scale()
  self.scale_notes =  mu.generate_scale(self.root, self.scale_name, self.octaves)
end

function sound:print_scale()
  for i = 1, #self.scale_notes do
    print(self.scale_notes[i], mu.note_num_to_name(self.scale_notes[i]))
  end
end


function sound:play(note, velocity, out)
  if out == "crow" then
    -- crow things
  elseif out =="midi" then
    -- midi things
  else
    engine.hz(mu.note_num_to_freq(self:snap_note(note)))
  end
end

return sound