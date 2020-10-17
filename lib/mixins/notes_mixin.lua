-- requires state index
notes_mixin = {}

notes_mixin.init = function(self)

  self.setup_notes = function(self, count)
    self.note_count_key = "NOTE COUNT" -- code key, not music key...
    self.note_count = (count == nil) and 1 or count
    self.note_count_min = 1
    self.note_count_max = 8
    self.note_key = "NOTE" -- code key, not music key...
    for i = 1, self.note_count_max do
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
  end

  self.note_registrations = function(self)
    self:register_save_key("note_count")
    self:register_menu_getter(self.note_count_key, self.note_count_menu_getter)
    self:register_menu_setter(self.note_count_key, self.note_count_menu_setter)
    self:register_arc_style({
      key = self.note_count_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .05,
      offset = 240,
      wrap = false,
      snap = true,
      min = self.note_count_min,
      max = self.note_count_max,
      value_getter = self.get_note_count,
      value_setter = self.set_note_count
    })
    self:register_modulation_target({
      key = self.note_count_key,
      inc = self.note_count_increment,
      dec = self.note_count_decrement
    })

    self:register_menu_getter(self.note_key, self.note_menu_getter)
    self:register_menu_setter(self.note_key, self.note_menu_setter)
    for i = 1, 8 do
      self:register_menu_getter(self["note_" .. i .. "_key"], self["note_" .. i .. "_menu_getter"])
      self:register_menu_setter(self["note_" .. i .. "_key"], self["note_" .. i .. "_menu_setter"])
    end

    self:register_arc_style({
      key = self.note_key,
      style_getter = function() return "glowing_note" end,
      style_max_getter = function() return 360 end,
      sensitivity = .01,
      offset = 360,
      wrap = true,
      snap = true,
      min = 1,
      max = #sound:get_scale_notes(),
      value_getter = self.get_note_1,
      value_setter = self.set_note_1,
      extras = { note_number = 1 }
    })

    for i = 1, 8 do
      local key = "NOTE #" .. i
      self:register_arc_style({
        key = key,
        style_getter = function() return "glowing_note" end,
        style_max_getter = function() return 360 end,
        sensitivity = .01,
        offset = 360,
        wrap = true,
        snap = true,
        min = 1,
        max = #sound:get_scale_notes(),
        value_getter = self["get_note_" .. i],
        value_setter = self["set_note_" .. i],
        extras = { note_number = i }
      })
      self:register_modulation_target({
        key = key,
        inc = self["note_" .. i .. "_increment"],
        dec = self["note_" .. i .. "_decrement"]
      })
    end
  end

  self.note_count_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_note_count(self:get_note_count() + value)
  end

  self.note_count_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_note_count(self:get_note_count() - value)
  end

  self.note_1_increment = function(self, i) self:browse_notes(i ~= nil and i or 1, 1) end
  self.note_2_increment = function(self, i) self:browse_notes(i ~= nil and i or 1, 2) end
  self.note_3_increment = function(self, i) self:browse_notes(i ~= nil and i or 1, 3) end
  self.note_4_increment = function(self, i) self:browse_notes(i ~= nil and i or 1, 4) end
  self.note_5_increment = function(self, i) self:browse_notes(i ~= nil and i or 1, 5) end
  self.note_6_increment = function(self, i) self:browse_notes(i ~= nil and i or 1, 6) end
  self.note_7_increment = function(self, i) self:browse_notes(i ~= nil and i or 1, 7) end
  self.note_8_increment = function(self, i) self:browse_notes(i ~= nil and i or 1, 8) end

  self.note_1_decrement = function(self, i) self:browse_notes(i ~= nil and i or -1, 1) end
  self.note_2_decrement = function(self, i) self:browse_notes(i ~= nil and i or -1, 2) end
  self.note_3_decrement = function(self, i) self:browse_notes(i ~= nil and i or -1, 3) end
  self.note_4_decrement = function(self, i) self:browse_notes(i ~= nil and i or -1, 4) end
  self.note_5_decrement = function(self, i) self:browse_notes(i ~= nil and i or -1, 5) end
  self.note_6_decrement = function(self, i) self:browse_notes(i ~= nil and i or -1, 6) end
  self.note_7_decrement = function(self, i) self:browse_notes(i ~= nil and i or -1, 7) end
  self.note_8_decrement = function(self, i) self:browse_notes(i ~= nil and i or -1, 8) end

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

  -- arc getters
  self.get_note_1 = function(self) return self:get_note(1) end
  self.get_note_2 = function(self) return self:get_note(2) end
  self.get_note_3 = function(self) return self:get_note(3) end
  self.get_note_4 = function(self) return self:get_note(4) end
  self.get_note_5 = function(self) return self:get_note(5) end
  self.get_note_6 = function(self) return self:get_note(6) end
  self.get_note_7 = function(self) return self:get_note(7) end
  self.get_note_8 = function(self) return self:get_note(8) end
  
  self.get_note = function(self, i)
    return self.notes[i]
  end

  -- arc setters
  self.set_note_1 = function(self, note) return self:set_note(note, 1) end
  self.set_note_2 = function(self, note) return self:set_note(note, 2) end
  self.set_note_3 = function(self, note) return self:set_note(note, 3) end
  self.set_note_4 = function(self, note) return self:set_note(note, 4) end
  self.set_note_5 = function(self, note) return self:set_note(note, 5) end
  self.set_note_6 = function(self, note) return self:set_note(note, 6) end
  self.set_note_7 = function(self, note) return self:set_note(note, 7) end
  self.set_note_8 = function(self, note) return self:set_note(note, 8) end

  self.set_note = function(self, note, index)
    local i = index ~= nil and index or 1
    self.notes[i] = note
    self.callback("set_note")
  end

  self.note_to_menu_string = function(self, index)
    local prefix = (self.state_index == index and self.note_count > 1) and "> " or ""
    return prefix .. self:get_note_name(index)
  end

  self.get_note_name = function(self, index)
    if self.notes[index] ~= nil then
      return musicutil.note_num_to_name(self.notes[index], true)
    end
  end

  self.browse_notes = function(self, delta, index)
    local snap = sound:snap_note(self.notes[index])
    local scale_index = fn.table_find(sound.scale_notes, snap)
    local note = sound.scale_notes[util.clamp(scale_index + delta, 1, #sound.scale_notes)]
    self:set_note(note, index)
  end

  -- how many notes does this cell have? 1-8
  self.get_note_count = function(self)
    return self.note_count
  end

  -- how many notes does this cell have? 1-8
  self.set_note_count = function(self, i)
    self.note_count = util.clamp(i, self.note_count_min, self.note_count_max)
    self.callback(self, "set_note_count")
  end

  -- how many notes *are in this scale*
  self.update_note_max = function(max)
    if self.arc_styles ~= nil then
      self.arc_styles.NOTE.max = max
      for i = 1, 8 do
        self.arc_styles["NOTE #" .. i ].max = max
      end
    end
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