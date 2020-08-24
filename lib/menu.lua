local menu = {}

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

function menu:scroll(d)
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

function menu:scroll_value(d)
  local s = self.selected_item_string

  -- home
  if page.active_page == 1 then
    if s == fn.playback() then
      sound:set_playback(d)
    elseif s == "SEED" then
      popup:launch("seed", d, "enc", 3)
    elseif s == "BPM" then
      params:set("bpm", util.clamp(params:get("bpm") + d, 20, 240))
    elseif s == "LENGTH" then
      sound:cycle_length(d)
    elseif s == "ROOT" then
      sound:cycle_root(d)
      keeper:update_all_notes()
    elseif s == "SCALE" then
      sound:set_scale(sound.scale + d)
      keeper:update_all_notes()
    end

  -- cell designer
  elseif page.active_page == 2 then
    if s == "STRUCTURE" then
      popup:launch("structure", d, "enc", 3)
    elseif s == "OFFSET" then
      keeper.selected_cell:set_offset(keeper.selected_cell.offset + d)
    elseif s == "VELOCITY" then
      keeper.selected_cell:set_velocity(keeper.selected_cell.velocity + d)
    elseif s == "METABOLISM" then
      keeper.selected_cell:set_metabolism(keeper.selected_cell.metabolism + d)
    elseif s == "INDEX" then
      keeper.selected_cell:cycle_state_index(d)
    elseif s == "PROBABILITY" then
      keeper.selected_cell:set_probability(keeper.selected_cell.probability + d)
    elseif s == "PULSES" then
      keeper.selected_cell:set_pulses(keeper.selected_cell.pulses + d)
    elseif s == "LEVEL" then
      keeper.selected_cell:set_level(keeper.selected_cell.level + d)
    elseif s == "DOCS" then
      -- selecting docs automatically toggles them on
    elseif s == "NOTE" then
      popup:launch("note1", d, "enc", 3)
    elseif s == "NOTE #1" then
      popup:launch("note1", d, "enc", 3)
    elseif s == "NOTE #2" then
      popup:launch("note2", d, "enc", 3)
    elseif s == "NOTE #3" then
      popup:launch("note3", d, "enc", 3)
    elseif s == "NOTE #4" then
      popup:launch("note4", d, "enc", 3)
    elseif s == "NOTE #5" then
      popup:launch("note5", d, "enc", 3)
    elseif s == "NOTE #6" then
      popup:launch("note6", d, "enc", 3)
    elseif s == "NOTE #7" then
      popup:launch("note7", d, "enc", 3)
    elseif s == "NOTE #8" then
      popup:launch("note8", d, "enc", 3)
    else
      print("Error: No match for " .. s)
    end

  -- analysis
  elseif page.active_page == 3 then
    -- nothing to change here
  end

end

function menu:render(bool)
  local render_values = (bool == nil) and true or bool
  local item_level = 15
  -- rectangular highlight
  graphics:rect(0, ((self.selected_item - 1) * 8) + 12 - (self.offset * 8), 51, 7, 2)
  -- iterate through items
  for i = 1, #self.items do
    local offset = 10 + (i * 8) - (self.offset * 8)
    -- menu item
    graphics:text(2, offset, self.items[i], item_level)

    -- panel value for cell designer
    if page.active_page == 2 and render_values then
      local item = self.items[i]
      if item ~= nil then
        local value = keeper.selected_cell:get_menu_value_by_attribute(item)
        if value ~= nil then
          if keeper.selected_cell:is("TOPIARY")
            and string.find(self.items[i], "NOTE")
            and string.find(self.items[i], keeper.selected_cell.state_index) then
            graphics:text(56, offset, "> " .. value, 0)
          elseif self.items[i] == "PROBABILITY" or self.items[i] == "LEVEL" then
            graphics:text(56, offset, value .. "%", 0)
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

return menu