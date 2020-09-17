menu = {}

function menu.init()
  menu.threshold = 6
  menu:reset()
end

function menu:reset()
  self.show_all = true
  self.items = {}
  self.selected_item = 1
  self.selected_item_string = ""
  self.offset = 0
  docs:set_active(false)
end

function menu:render(bool)
  local render_values = (bool == nil) and true or bool
  -- rectangular highlight
  graphics:rect(0, ((self.selected_item - 1) * 8) + 12 - (self.offset * 8), 51, 7, 2)
  -- iterate through items
  for i = 1, #self.items do
    local offset = 10 + (i * 8) - (self.offset * 8)
    -- menu item
    graphics:text(2, offset, self.items[i], 15)
    if not fn.is_clock_internal() and self.items[i] == "BPM" then
      graphics:text(2, offset, self.items[i], 5)
      graphics:mls(2, offset - 2, 40, offset - 2, 15)
    end

    -- panel value for cell designer
    if page.active_page == 2 and render_values then
      local item = self.items[i]
      if item ~= nil then
        local value = keeper.selected_cell:get_menu_value_by_attribute(item)
        if value ~= nil then
          if (keeper.selected_cell:is("TOPIARY") or keeper.selected_cell:is("CASINO") or keeper.selected_cell:is("FOREST") or keeper.selected_cell:is("AUTON"))
            and string.find(self.items[i], "NOTE")
            and string.find(self.items[i], keeper.selected_cell.state_index) then
            graphics:text(56, offset, "> " .. value, 0)
          elseif self.items[i] == "PROBABILITY" 
              or self.items[i] == "LEVEL"
              or self.items[i] == "RANGE MIN"
              or self.items[i] == "RANGE MAX" then
            graphics:text(56, offset, value .. "%", 0)
          elseif self.items[i] == "NET INCOME"  then
            graphics:text(56, offset, ">" .. value .. ".0gDq", 0)
          elseif self.items[i] == "INTEREST"  then
            graphics:text(56, offset, "=" .. value .. "%(#7)", 0)
          elseif self.items[i] == "TAXES"  then
            graphics:text(56, offset,"<:" ..  value .. ":GdQ", 0)
          elseif self.items[i] == "DEPRECIATE"  then
            graphics:text(56, offset, value .. "0kVE", 0)
          elseif self.items[i] == "AMORTIZE"  then
            graphics:text(56, offset, value .. "99ll9c", 0)
          elseif self.items[i] == "CROW OUT"  then
            graphics:text(56, offset, (value == 1 and "1/2" or "3/4"), 0)
          elseif self.items[i] == "DEFLECT"  then
            graphics:text(56, offset, keeper.selected_cell:get_deflect_value(), 0)
          elseif self.items[i] == "DRIFT"  then
            graphics:text(56, offset, keeper.selected_cell:get_drift_value(), 0)
          elseif self.items[i] == "TERRITORY"  then
            graphics:text(56, offset, keeper.selected_cell:get_territory_value(), 0)
          elseif self.items[i] == "OPERATOR"  then
            graphics:text(56, offset, keeper.selected_cell:get_operator_value(), 0)
          elseif self.items[i] ~= "STRUCTURE" then
            graphics:text(56, offset, value, 0)
          end
        end
      end
    end
  end
  -- indicate when more menu items are available above
  if self.offset > 0 then
    -- pop the ellipses once we start to scroll down
    graphics:rect(0, 7, 51, 14, 0)
    graphics:text(2, 18, "...", 15)
    graphics:rect(54, 11, 40, 8, 15)
  else
    -- top mask to stop the text from running over the title bar
    graphics:rect(0, 7, 51, 5, 0)
  end
  -- indicate when menu items are available below
  if #self.items > self.threshold and self.selected_item ~= #self.items then
    graphics:rect(0, 59, 51, 14, 0)
    graphics:text(2, 64, "...", 15)
    graphics:rect(54, 59, 40, 5, 15)
  end
end

function menu:handle_scroll_bpm(d)
  if fn.is_clock_internal() then
    params:set("clock_tempo", params:get("clock_tempo") + d)
  else
    graphics:set_message("EXTERNAL CONTROL ON", counters.default_message_length)
  end
end

function menu:scroll_value(d)
  local s = self.selected_item_string

  -- home
  if page.active_page == 1 then
        if s == fn.playback() then counters:set_playback(d)
    elseif s == "BPM"         then self:handle_scroll_bpm(d)
    elseif s == "LENGTH"      then sound:cycle_length(d)
    elseif s == "ROOT"        then sound:cycle_root(d)
    elseif s == "SCALE"       then sound:set_scale(sound.scale + d)
    elseif s == "TRANSPOSE"   then sound:cycle_transpose(d)
    end

  -- cell designer
  elseif page.active_page == 2 then
        if s == "AMORTIZE"     then keeper.selected_cell:set_amortize(keeper.selected_cell.amortize + d)
    elseif s == "CAPACITY"     then keeper.selected_cell:set_capacity(keeper.selected_cell.capacity + d)
    elseif s == "CHANNEL"      then keeper.selected_cell:set_channel(keeper.selected_cell.channel + d)
    elseif s == "CHARGE"       then keeper.selected_cell:set_charge(keeper.selected_cell.charge + d)
    elseif s == "CROW OUT"     then keeper.selected_cell:set_crow_out(keeper.selected_cell.crow_out + d)
    elseif s == "CRUMBLE"      then keeper.selected_cell:set_crumble(keeper.selected_cell.crumble + d)
    elseif s == "DEFLECT"      then keeper.selected_cell:set_deflect(keeper.selected_cell.deflect + d)
    elseif s == "DEPRECIATE"   then keeper.selected_cell:set_depreciate(keeper.selected_cell.depreciate + d)
    elseif s == "DEVICE"       then keeper.selected_cell:set_device(keeper.selected_cell.device + d)
    elseif s == "DOCS"         then -- selecting docs automatically toggles them on
    elseif s == "DRIFT"        then keeper.selected_cell:set_drift(keeper.selected_cell.drift + d)
    elseif s == "DURATION"     then keeper.selected_cell:set_duration(keeper.selected_cell.duration + d)
    elseif s == "INDEX"        then keeper.selected_cell:cycle_state_index(d)
    elseif s == "INTEREST"     then keeper.selected_cell:set_interest(keeper.selected_cell.interest + d)
    elseif s == "LEVEL"        then keeper.selected_cell:set_level(keeper.selected_cell.level + d)
    elseif s == "METABOLISM"   then keeper.selected_cell:set_metabolism(keeper.selected_cell.metabolism + d)
    elseif s == "NET INCOME"   then keeper.selected_cell:set_net_income(keeper.selected_cell.net_income + d) 
    elseif s == "NETWORK"      then keeper.selected_cell:set_network(keeper.selected_cell.network_key + d) 
    elseif s == "NOTE COUNT"   then keeper.selected_cell:set_note_count(keeper.selected_cell.note_count + d) 
    elseif s == "NOTE"         then popup:launch("note1", d, "enc", 3) -- "i'm the same as #1!?!"
    elseif s == "NOTE #1"      then popup:launch("note1", d, "enc", 3) -- "always have been."
    elseif s == "NOTE #2"      then popup:launch("note2", d, "enc", 3)
    elseif s == "NOTE #3"      then popup:launch("note3", d, "enc", 3)
    elseif s == "NOTE #4"      then popup:launch("note4", d, "enc", 3)
    elseif s == "NOTE #5"      then popup:launch("note5", d, "enc", 3)
    elseif s == "NOTE #6"      then popup:launch("note6", d, "enc", 3)
    elseif s == "NOTE #7"      then popup:launch("note7", d, "enc", 3)
    elseif s == "NOTE #8"      then popup:launch("note8", d, "enc", 3)
    elseif s == "OFFSET"       then keeper.selected_cell:set_offset(keeper.selected_cell.offset + d)
    elseif s == "OPERATOR"     then keeper.selected_cell:set_operator(keeper.selected_cell.operator + d)
    elseif s == "PROBABILITY"  then keeper.selected_cell:set_probability(keeper.selected_cell.probability + d)
    elseif s == "PULSES"       then keeper.selected_cell:set_pulses(keeper.selected_cell.pulses + d)
    elseif s == "RANGE MAX"    then keeper.selected_cell:set_range_max(keeper.selected_cell.range_max + d)
    elseif s == "RANGE MIN"    then keeper.selected_cell:set_range_min(keeper.selected_cell.range_min + d)
    elseif s == "STRUCTURE"    then popup:launch("structure", d, "enc", 3)
    elseif s == "TAXES"        then keeper.selected_cell:set_taxes(keeper.selected_cell.taxes + d)
    elseif s == "TERRITORY"    then keeper.selected_cell:set_territory(keeper.selected_cell.territory + d)
    elseif s == "VELOCITY"     then keeper.selected_cell:set_velocity(keeper.selected_cell.velocity + d)
    else print("Error: No match for cell attribute " .. s)
    end

  -- analysis
  elseif page.active_page == 3 then
    -- nothing to change here
  end

end

function menu:scroll(d)
  if page.active_page == 3 then keeper:deselect_cell() end
  self:select_item(util.clamp(self.selected_item + d, 1, #self.items))
end

function menu:select_item(i)
  self.selected_item = i == nil and self.selected_item or i
  self.selected_item_string  = self.items[self.selected_item]
  self.offset = self.selected_item > self.threshold and self.selected_item - self.threshold or 0
  docs:set_active(self.selected_item_string == "DOCS")
end

function menu:select_item_by_name(name)
  menu:select_item(fn.table_find(self.items, name) or 1)
end

function menu:set_items(items)
  self.items = items
end

return menu