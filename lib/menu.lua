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
    -- left off here friday the 18th night of september...
    if page.active_page == 2 and render_values then
      local cell = keeper.selected_cell
      local item = self.items[i]
      if item ~= nil then
        local value = keeper.selected_cell:get_menu_value_by_attribute(item)
        if value ~= nil then
          if self.items[i] ~= "STRUCTURE" then
            graphics:text(56, offset, cell:get_menu_value_by_attribute(item)(cell), 0)
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
    local cell = keeper.selected_cell
    if s == "STRUCTURE" then
      popup:launch("structure", d, "enc", 3)
    else
      cell:set_attribute_value(self.selected_item_string, d)
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