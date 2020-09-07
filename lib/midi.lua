m = {}

function m.init()
  m.devices = {}
  if config.outputs.midi == true then
    m.devices[1] = midi.connect(1)
    m.devices[2] = midi.connect(2)
    m.devices[3] = midi.connect(3)
    m.devices[4] = midi.connect(4)
  end
  m.notes = {}
end

function m:setup()
  for k, note in pairs(self.notes) do
    note.duration = note.duration - 1
    if note.duration <= 0 then
      self.devices[note.device]:note_off(note.note)
      table.remove(self.notes, k)
    end
  end
end

function m:play(note, velocity, duration, device)
    self:register_note(note, device, duration)
    self.devices[device]:note_off(note)
    self.devices[device]:note_on(note, velocity)
end

function m:register_note(note, device, duration)
  local n = {
    note = note,
    device = device,
    duration = duration,
    generation = counters.music.generation
  }
  table.insert(self.notes, n)
end

return m