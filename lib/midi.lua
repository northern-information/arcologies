m = {}

function m.init()
  m.devices = {}
  if config.outputs.midi == true then
    m.devices[1] = midi.connect(1)
    m.devices[2] = midi.connect(2)
    m.devices[3] = midi.connect(3)
    m.devices[4] = midi.connect(4)
  end
end

function m:play(note, velocity, device)
    self.devices[device]:note_off(note)
    self.devices[device]:note_on(note, velocity)
end

return m