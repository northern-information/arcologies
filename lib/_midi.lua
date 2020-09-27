_midi = {}

function _midi.init()
  _midi.devices = {}
  _midi.devices[1] = midi.connect(1)
  _midi.devices[2] = midi.connect(2)
  _midi.devices[3] = midi.connect(3)
  _midi.devices[4] = midi.connect(4)
  _midi.notes = {}
end

function _midi:setup()
  for k, note in pairs(self.notes) do
    note.duration = note.duration - 1
    if note.duration <= 0 then
      self.devices[note.device]:note_off(note.note, note.velocity, note.channel)
      table.remove(self.notes, k)
    end
  end
end

function _midi:play(note, velocity, channel, duration, device)
    local transposed_note = sound:transpose_note(note)
    self:register_note(transposed_note, velocity, channel, duration, device)
    self.devices[device]:note_off(transposed_note, velocity, channel)
    self.devices[device]:note_on(transposed_note, velocity, channel)
end

function _midi:register_note(tranposed_note, velocity, channel, duration, device)
  local new = {
    note = tranposed_note,
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

function _midi:all_off()
  for note = 1, 127 do
    for channel = 1, 16 do
      for device = 1, 4 do
        _midi.devices[device]:note_off(note, 0, channel)
      end
    end
  end
end

return _midi