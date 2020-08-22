-- requires state_index
notes_trait = {}
notes_trait.init = function(self)
    self.note_count = 1
    self.notes = {72, 72, 72, 72, 72, 72, 72, 72}
    self.set_note = function(self, note, index)
      local index = index ~= nil and index or 1
      self.notes[index] = sound.notes_in_this_scale[util.clamp(note, 1, #sound.notes_in_this_scale)]
      self.callback(self, 'set_notes')
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

