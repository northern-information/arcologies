popup = {}

function popup.init()
  popup.active = false
  popup.current_attribute = ""
  popup.current_value = ""
  popup.messages = {
    ["seed"] = {
      ["start"] = "SEEDING...",
      ["abort"] = "ABORTED SEED",
      ["done"] = "SEEDED"
    },
    ["note"] = {
      ["start"] = "NOTE...",
      ["abort"] = "ABORTED",
      ["done"] = "CHOSE"
    }
  }

end

function popup:launch(attribute, value)
  self.current_attribute = attribute
  self.current_value = value
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
  self:title_message(self.messages[self.current_attribute]["start"])
  if enc_counter[3]["this_clock"] ~= nil then
    clock.cancel(enc_counter[3]["this_clock"])
    counters:reset_enc(3)
  end
  self:change()
  fn.dirty_screen(true)
  if enc_counter[3]["this_clock"] == nil then
    enc_counter[3]["this_clock"] = clock.run(self.wait)
  end
end

function popup:wait()
  enc_counter[3]["waiting"] = true
  clock.sleep(graphics.ui_wait_threshold)
  enc_counter[3]["waiting"] = false
  enc_counter[3]["this_clock"] = nil
  popup:done()
  popup.active = false
  fn.dirty_screen(true)
end

function popup:change()
  if self.current_attribute == "seed" then
    params:set("seed", params:get("seed") + self.current_value)
  end
  if self.current_attribute == "note" then
    keeper.selected_cell:set_note(fn.temp_note() + self.current_value)
  end
end

function popup:render()
  if self.current_attribute == "seed" then
    menu:focus("SEED")
    graphics:seed()
  end
  if self.current_attribute == "note" then
    menu:focus("NOTE")
    graphics:piano(keeper.selected_cell.note)
  end
end

function popup:done()
  menu:focus_off()
  if self.current_attribute == "seed" then self:done_seed() end
  if self.current_attribute == "note" then self:done_note() end
  if self.current_attribute == "structure" then self:done_structure() end
end

function popup:done_seed()
 fn.seed_cells()
end

function popup:done_note()
  self:title_message(self.messages.note.done .. " " .. keeper.selected_cell:get_note_name())
end

function popup:done_structure()
  print("done note")
end

return popup