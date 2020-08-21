popup = {}

function popup.init()
  popup.active = false
  popup.input = "" -- key or enc
  popup.number = 0
  popup.current_attribute = ""
  popup.current_value = ""
  popup.key_timer = 0
  popup.note_message = { 
      ["start"] = "NOTE...",
      ["abort"] = "ABORTED",
      ["done"] = "CHOSE"
  }
  popup.messages = {
    ["seed"] = {
      ["start"] = "SEEDING...",
      ["abort"] = "ABORTED SEED",
      ["done"] = "SEEDED"
    },
    ["delete_all"] = {
      ["start"] = "DELETING ALL IN...",
      ["abort"] = "ABORTED",
      ["done"] = "DELETED ALL CELLS"
    },
    ["structure"] = {
      ["start"] = "",
      ["abort"] = "",
      ["done"] = "CHOSE"
    },
    ["note1"] = popup.note_message,
    ["note2"] = popup.note_message,
    ["note3"] = popup.note_message,
    ["note4"] = popup.note_message,
    ["note5"] = popup.note_message,
    ["note6"] = popup.note_message,
    ["note7"] = popup.note_message,
    ["note8"] = popup.note_message
  }
end

function popup:launch(attribute, value, input, number)
  self.current_attribute = attribute
  self.current_value = value
  self.input = input
  self.number = number
  self.active = true
  self:start()
end

function popup:is_active()
  return self.active
end

function popup:attribute(s)
  return self.current_attribute == s
end

function popup:title_message(s)
  graphics:set_message(s, counters.default_message_length)
end

function popup:start()

  -- encoders wait for a period after you stop spinning
  if self.input == "enc" then
    self:title_message(self.messages[self.current_attribute]["start"])
    if enc_counter[self.number]["this_clock"] ~= nil then
      clock.cancel(enc_counter[self.number]["this_clock"])
      counters:reset_enc(self.number)
    end
    self:change()
    fn.dirty_screen(true)
    if enc_counter[self.number]["this_clock"] == nil then
      enc_counter[self.number]["this_clock"] = clock.run(self.enc_wait)
    end

  -- keys give you time to cancel
  elseif self.input == "key" then
    clock.run(self.key_wait)
  end
end

function popup:key_wait()
  if popup.current_attribute == "delete_all" then
    popup.key_timer = 40
    while popup.key_timer > 0 and k3 == 1 do
      popup:title_message(popup.messages[popup.current_attribute]["start"])
      popup.key_timer = popup.key_timer - 1
      fn.dirty_screen(true)
      clock.sleep(1/10)
    end
    if k3 == 0 then
      popup.active = false
      popup:title_message(popup.messages.delete_all.abort)
    else
      popup:title_message(popup.messages.delete_all.done)
      popup:done()
    end
    fn.dirty_screen(true)
  end
end

function popup:enc_wait()
  enc_counter[popup.number]["waiting"] = true
  clock.sleep(graphics.ui_wait_threshold)
  enc_counter[popup.number]["waiting"] = false
  enc_counter[popup.number]["this_clock"] = nil
  popup:done()
  fn.dirty_screen(true)
end

function popup:change()
  if self.current_attribute == "seed" then
    params:set("seed", params:get("seed") + self.current_value)
  elseif self.current_attribute == "structure" then
    keeper.selected_cell:set_structure(keeper.selected_cell.structure_key + self.current_value)
    self:title_message(keeper.selected_cell.structure_value)
  elseif self.current_attribute == "note1" then
    keeper.selected_cell:set_note(fn.temp_note(1) + self.current_value, 1)
    self:title_message("MIDI " .. keeper.selected_cell.notes[1])
  elseif self.current_attribute == "note2" then
    keeper.selected_cell:set_note(fn.temp_note(2) + self.current_value, 2)
    self:title_message("MIDI " .. keeper.selected_cell.notes[2])
  elseif self.current_attribute == "note3" then
    keeper.selected_cell:set_note(fn.temp_note(3) + self.current_value, 3)
    self:title_message("MIDI " .. keeper.selected_cell.notes[3])
  elseif self.current_attribute == "note4" then
    keeper.selected_cell:set_note(fn.temp_note(4) + self.current_value, 4)
    self:title_message("MIDI " .. keeper.selected_cell.notes[4])
  elseif self.current_attribute == "note5" then
    keeper.selected_cell:set_note(fn.temp_note(5) + self.current_value, 5)
    self:title_message("MIDI " .. keeper.selected_cell.notes[5])
  elseif self.current_attribute == "note6" then
    keeper.selected_cell:set_note(fn.temp_note(6) + self.current_value, 6)
    self:title_message("MIDI " .. keeper.selected_cell.notes[6])
  elseif self.current_attribute == "note7" then
    keeper.selected_cell:set_note(fn.temp_note(7) + self.current_value, 7)
    self:title_message("MIDI " .. keeper.selected_cell.notes[7])
  elseif self.current_attribute == "note8" then
    keeper.selected_cell:set_note(fn.temp_note(8) + self.current_value, 8)
    self:title_message("MIDI " .. keeper.selected_cell.notes[8])
  end
end

function popup:render()
      if self.current_attribute == "seed" then graphics:seed()
  elseif self.current_attribute == "note1" then graphics:piano(1)
  elseif self.current_attribute == "note2" then graphics:piano(2)
  elseif self.current_attribute == "note3" then graphics:piano(3)
  elseif self.current_attribute == "note4" then graphics:piano(4)
  elseif self.current_attribute == "note5" then graphics:piano(5)
  elseif self.current_attribute == "note6" then graphics:piano(6)
  elseif self.current_attribute == "note7" then graphics:piano(7)
  elseif self.current_attribute == "note8" then graphics:piano(8)
  elseif self.current_attribute == "structure" then graphics:structure_palette(keeper.selected_cell.structure_key)
  elseif self.current_attribute == "delete_all" then graphics:deleting_all(self.key_timer)
  end
end

function popup:done()
  self.active = false
  if self.current_attribute == "seed" then 
    fn.seed_cells()
    if params:get("seed") == 0 then
      self:title_message(self.messages.seed.abort)
    else
      self:title_message(self.messages.seed.done .. " " .. params:get("seed"))
    end
  elseif self.current_attribute == "note1" then
    self:title_message(self.messages.note1.done .. " " .. keeper.selected_cell:get_note_name(1))
  elseif self.current_attribute == "note2" then
    self:title_message(self.messages.note2.done .. " " .. keeper.selected_cell:get_note_name(2))
  elseif self.current_attribute == "note3" then
    self:title_message(self.messages.note3.done .. " " .. keeper.selected_cell:get_note_name(3))
  elseif self.current_attribute == "note4" then
    self:title_message(self.messages.note4.done .. " " .. keeper.selected_cell:get_note_name(4))
  elseif self.current_attribute == "note5" then
    self:title_message(self.messages.note5.done .. " " .. keeper.selected_cell:get_note_name(5))
  elseif self.current_attribute == "note6" then
    self:title_message(self.messages.note6.done .. " " .. keeper.selected_cell:get_note_name(6))
  elseif self.current_attribute == "note7" then
    self:title_message(self.messages.note7.done .. " " .. keeper.selected_cell:get_note_name(7))
  elseif self.current_attribute == "note8" then
    self:title_message(self.messages.note8.done .. " " .. keeper.selected_cell:get_note_name(8))
  elseif self.current_attribute == "structure" then
    self:title_message(self.messages.structure.done .. " " .. keeper.selected_cell.structure_value)
    menu:reset()
    menu:set_items(keeper.selected_cell:menu_items())
    menu:select_item_by_name("STRUCTURE")
  elseif self.current_attribute == "delete_all" then
    keeper:delete_all_cells()
  end
end

return popup