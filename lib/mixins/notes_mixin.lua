-- requires state index
notes_mixin = {}

notes_mixin.init = function(self)

  self.setup_notes = function(self, count)
    self.note_count = (count == nil) and 1 or count
    self:register_save_key("note_count")
    self.note_count_key = "NOTE COUNT" -- code key, not music key...
    self.max_note_count = 8
    self.note_key = "NOTE" -- code key, not music key...
    for i = 1, self.max_note_count do
      self["note_" .. i .. "_key"] = "NOTE #" .. i
    end
    self.notes = {}
    self:register_save_key("notes")
    self.sub_menu_items = {}
    self:register_save_key("sub_menu_items")
    if self.note_count == 1 then
      self.notes[1] = sound:get_reasonable_note()
    else
      for i = 1, self.note_count do
        local note = sound:get_random_note(params:get("note_range_min") / 100, params:get("note_range_max") / 100)
        self:set_note(note, i)
      end
    end
    self:register_menu_getter(self.note_key, self.note_menu_getter)
    self:register_menu_setter(self.note_key, self.note_menu_setter)
    for i = 1, self.max_note_count do
      self:register_menu_getter(self["note_" .. i .. "_key"], self["note_" .. i .. "_menu_getter"])
      self:register_menu_setter(self["note_" .. i .. "_key"], self["note_" .. i .. "_menu_setter"])
    end
    self:register_menu_getter(self.note_count_key, self.note_count_menu_getter)
    self:register_menu_setter(self.note_count_key, self.note_count_menu_setter)
  end

  self.note_menu_setter   = function(self, i) popup:launch("note", i, "enc", 3, 1) end
  self.note_1_menu_setter = function(self, i) popup:launch("note", i, "enc", 3, 1) end
  self.note_2_menu_setter = function(self, i) popup:launch("note", i, "enc", 3, 2) end
  self.note_3_menu_setter = function(self, i) popup:launch("note", i, "enc", 3, 3) end
  self.note_4_menu_setter = function(self, i) popup:launch("note", i, "enc", 3, 4) end
  self.note_5_menu_setter = function(self, i) popup:launch("note", i, "enc", 3, 5) end
  self.note_6_menu_setter = function(self, i) popup:launch("note", i, "enc", 3, 6) end
  self.note_7_menu_setter = function(self, i) popup:launch("note", i, "enc", 3, 7) end
  self.note_8_menu_setter = function(self, i) popup:launch("note", i, "enc", 3, 8) end

  self.note_menu_getter   = function(self) return self:note_to_menu_string(1) end
  self.note_1_menu_getter = function(self) return self:note_to_menu_string(1) end
  self.note_2_menu_getter = function(self) return self:note_to_menu_string(2) end
  self.note_3_menu_getter = function(self) return self:note_to_menu_string(3) end
  self.note_4_menu_getter = function(self) return self:note_to_menu_string(4) end
  self.note_5_menu_getter = function(self) return self:note_to_menu_string(5) end
  self.note_6_menu_getter = function(self) return self:note_to_menu_string(6) end
  self.note_7_menu_getter = function(self) return self:note_to_menu_string(7) end
  self.note_8_menu_getter = function(self) return self:note_to_menu_string(8) end

  self.note_to_menu_string = function(self, index)
    local prefix = (self.state_index == index and self.note_count > 1) and "> " or ""
    return prefix .. self:get_note_name(index)
  end

  self.get_note_name = function(self, index)
    if self.notes[index] ~= nil then
      return mu.note_num_to_name(self.notes[index], true)
    end
  end

  self.set_note = function(self, note, index)
    local i = index ~= nil and index or 1
    self.notes[i] = note
    self.callback("set_note")
  end

  self.browse_notes = function(self, delta, index)
    local snap = sound:snap_note(self.notes[index])
    local scale_index = fn.table_find(sound.scale_notes, snap)
    local note = sound.scale_notes[util.clamp(scale_index + delta, 1, #sound.scale_notes)]
    self:set_note(note, index)
  end

  self.get_note_count = function(self)
    return self.note_count
  end

  self.set_note_count = function(self, i)
    self.note_count = util.clamp(i, 1, self.max_note_count)
    self.callback(self, "set_note_count")
  end

  self.note_count_menu_getter = function(self)
    return self:get_note_count()
  end

  self.note_count_menu_setter = function(self, i)
    self:set_note_count(self.note_count + i)
  end

  self.inject_notes_into_menu = function(self, items)
    if self:has("NOTES") then
      local note_position = fn.table_find(items, "NOTES")
      if type(note_position) == "number" then
        table.remove(items, note_position)
        if self.note_count == 1 then
          table.insert(items, note_position, "NOTE")
        elseif  self.note_count > 1 then
          local notes_submenu_items = self:get_notes_submenu_items()
          for i = 1, self.note_count do
            table.insert(items, note_position + (i - 1), notes_submenu_items[i]["menu_item"])
          end
        end
      end
    end
    return items
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