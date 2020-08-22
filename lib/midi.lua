m = {}

function m.init()
  -- midi initialization
  if config.outputs.midi == 1 then
    print("midi on")
  --   sound.midi_out = midi.connect(1)
  end
end

function m:play(note)
    -- self.midi_out:note_off this cell
    -- self.midi_out:note_on(note)
end

return m