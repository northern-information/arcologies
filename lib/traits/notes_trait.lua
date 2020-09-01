notes_trait = {}

notes_trait.init = function(self)

  self.setup_notes = function(self, count)
    self.note_count = 1
    self.notes = {}
    self.sub_menu_items = {}
    count = count == nil and 1 or count
    self.note_count = count
    if self.note_count == 1 then
      self.notes[1] = sound:get_reasonable_note()
    else
      for i = 1, self.note_count do
        local note = sound:get_random_note(.4, .6)
        self:set_note(note, i)
      end
    end
  end

  self.set_note = function(self, note, index)
    local i = index ~= nil and index or 1
    self.notes[i] = note
    self.callback('set_note')
  end

  self.browse_notes = function(self, delta, index)
    local snap = sound:snap_note(self.notes[index])
    local scale_index = fn.table_find(sound.scale_notes, snap)
    local note = sound.scale_notes[util.clamp(scale_index + delta, 1, #sound.scale_notes)]
    self:set_note(note, index)
  end

  self.get_note = function(self, index)
    return mu.note_num_to_name(self.notes[self.index], true)
  end

  self.get_note_name = function(self, index)
    if self.notes[index] ~= nil then
      return mu.note_num_to_name(self.notes[index], true)
    end
  end

  self.get_notes_submenu_items = function(self)
    local items = {}
    for i = 1, self.note_count do
      items[i] = {}
      items[i]["menu_item"] = "NOTE #" .. i
      items[i]["menu_value"] = self:get_note_name(i)
    end
    return items
  end

end

