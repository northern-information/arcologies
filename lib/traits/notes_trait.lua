-- requires state_index
notes_trait = {}
notes_trait.init = function(self)
    self.note_count = 1
    self.notes = {72, 72, 72, 72, 72, 72, 72, 72}
    self.set_note = function(self, note, index)
      local index = index ~= nil and index or 1
      self.notes[index] = note
      self.callback('set_note')
    end 
    self.browse_notes = function(self, delta, index)
      local snap = sound:snap_note(self.notes[index])
      local scale_index = fn.table_find(sound.scale_notes, snap)
      local note = sound.scale_notes[util.clamp(scale_index + delta, 1, #sound.scale_notes)]
      self:set_note(note, index)
    end
    self.set_note_count = function(self, i)
      self.note_count = i
    end
    self.get_note = function(self)
      return mu.note_num_to_name(self.notes[self.index], true)
    end
    self.get_note_name = function(self, index)
      return mu.note_num_to_name(self.notes[index], true)
    end
end

