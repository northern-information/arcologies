m = {}

function m.init()
  m.devices = {}
  m.devices[1] = midi.connect(1)
  m.devices[2] = midi.connect(2)
  m.devices[3] = midi.connect(3)
  m.devices[4] = midi.connect(4)
  m.notes = {}
end

function m:setup()
  for k, note in pairs(self.notes) do
    note.duration = note.duration - 1
    if note.duration <= 0 then
      self.devices[note.device]:note_off(note.note, note.velocity, note.channel)
      table.remove(self.notes, k)
    end
  end
end

function m:play(note, velocity, channel, duration, device)
    self:register_note(note, velocity, channel, duration, device)
    self.devices[device]:note_off(note, velocity, channel)
    self.devices[device]:note_on(note, velocity, channel)
end

function m:register_note(note, velocity, channel, duration, device)
  local new = {
    note = note,
    velocity = velocity,
    channel = channel,
    duration = duration,
    device = device,
    generation = counters.music_generation
  }
  for k, registered_note in pairs(self.notes) do
    if registered_note.note == new.note
    and registered_note.channel == new.channel
    and registered_note.device == new.device then
      table.remove(self.notes, k)
    end
  end
  table.insert(self.notes, new)
end

function m:panic()
  m:all_off()
end

function m:all_off()
  for i = 1, 127 do
    for d = 1, 4 do
      m.devices[d]:note_off(i)
    end
  end
end

function m:cleanup()
  m:all_off()
  for i = 1, 4 do
    m.devices[i]:disconnect()
  end
end

return m