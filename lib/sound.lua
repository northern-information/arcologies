sound = {}

function sound.init()
  sound.length = config.settings.length
  sound.root = config.settings.root
  sound.scale = config.settings.scale
  sound.octaves = config.settings.octaves
  sound.transpose = 0
  sound.scale_name = ""
  sound.scale_names = {}
  for k,v in pairs(mu.SCALES) do sound.scale_names[k] = mu.SCALES[k].name end
  sound.scale_notes = {}
  sound:set_scale(sound.scale)
end

function sound:cycle_transpose(i)
  self.transpose = util.clamp(self.transpose + i, -6, 6)
end

function sound:transpose_note(note)
  return note + (self.transpose * 12)
end

function sound:set_scale(i)
  self.scale = util.clamp(i, 1, #self.scale_names)
  self.scale_name = sound.scale_names[sound.scale]
  self:build_scale()
  if init_done then
    keeper:update_all_notes()
  end
end

function sound:build_scale()
  self.scale_notes =  mu.generate_scale(self.root, self.scale_name, self.octaves)
end

function sound:snap_note(note)
  return mu.snap_note_to_array(note, self.scale_notes)
end

function sound:cycle_length(i)
  self.length = util.clamp(self.length + i, 1, 16)
end

function sound:cycle_root(i)
  self.root = fn.cycle(self.root + i, 0, 12)
  self:build_scale()
  if init_done then
    keeper:update_all_notes()
  end
end

function sound:set_random_root()
  self:cycle_root(math.random(0, 12))
end

function sound:set_random_scale()
  self:set_scale(math.random(1, #self.scale_names))
end

function sound:get_random_note(range_min, range_max)
  if range_min > range_max then
    range_min = 0
    range_max = 1
  end
  local count = #self.scale_notes
  local key = util.clamp(math.random(math.floor(count * range_min), math.floor(count * range_max)), 1, count)
  return sound.scale_notes[key]
end

-- get a middle of the road root note
function sound:get_reasonable_note()
  local root_notes = {}
  for i = 1, 12 do root_notes[i] = self.root + (i * 12) end
  return root_notes[math.floor(#root_notes / 2)]
end

function sound:play(note, velocity)
  engine.amp(velocity / 127)
  engine.hz(mu.note_num_to_freq(self:snap_note(self:transpose_note(note))))
end

return sound