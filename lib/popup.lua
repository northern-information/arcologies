popup = {}

function popup.init()
  popup.active = false
  popup.input = "" -- key or enc
  popup.number = 0
  popup.current_attribute = ""
  popup.current_value = ""
  popup.key_timer = 0
  popup.messages = config.popup_messages
  popup.note_number = nil
end

-- attribute    we are changing
-- value        from the encoder / key
-- input        enc or key
-- number       which enc or key
-- note_number  if this is a note, which one are we changing
function popup:launch(attribute, value, input, number, note_number)
  self.current_attribute = attribute
  self.current_value = value
  self.input = input
  self.number = number
  self.note_number = note_number or nil
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
  graphics:set_message(s)
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
    popup.key_timer = config.settings.delete_all_length * 10
    while popup.key_timer > 0 and keys[3] == 1 do
      popup:title_message(popup.messages[popup.current_attribute]["start"])
      popup.key_timer = popup.key_timer - 1
      fn.dirty_screen(true)
      clock.sleep(1/10)
    end
    if keys[3] == 0 then
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
  clock.sleep(params:get("popup_patience"))
  enc_counter[popup.number]["waiting"] = false
  enc_counter[popup.number]["this_clock"] = nil
  popup:done()
  fn.dirty_screen(true)
end

function popup:change()
  if self.current_attribute == "structure" then
    keeper.selected_cell:set_structure_by_key(keeper.selected_cell.structure_key + self.current_value)
    self:title_message(keeper.selected_cell.structure_value)
  end

  if self.current_attribute == "note" then
    keeper.selected_cell:browse_notes(self.current_value, self.note_number)
    self:title_message("MIDI " .. keeper.selected_cell.notes[self.note_number])
  end

end

function popup:render()
  if self.current_attribute == "structure" then
    graphics:structure_palette(keeper.selected_cell.structure_key)
  elseif self.current_attribute == "delete_all"
    then graphics:deleting_all(self.key_timer)
  elseif self.current_attribute == "note" then
    graphics:piano(self.note_number)
  end
end

function popup:done()
  self.active = false

  if self.current_attribute == "structure" then
    self:title_message(self.messages.structure.done .. " " .. keeper.selected_cell.structure_value)
    menu:reset()
    menu:set_items(keeper.selected_cell:menu_items())
    menu:select_item_by_name("STRUCTURE")
  elseif self.current_attribute == "delete_all" then
    keeper:delete_all_cells()
  elseif self.current_attribute == "note" then
    self:title_message(self.messages.note.done .. " " .. keeper.selected_cell:get_note_name(self.note_number))
  end

end

return popup