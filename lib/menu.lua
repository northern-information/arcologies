local menu = {}

function menu.init()
  menu.threshold = 6
  menu:reset()
end

function menu:reset()
  self.show_all = true
  self.items = {}
  self.focus_item = ""
  self.focus_on = false
  self.focus_index = 0
  self.selected_item = 1
  self.selected_item_string = ""
  self.offset = 0
end

function menu:scroll(d)
  self:select_item(util.clamp(self.selected_item + d, 1, #self.items))
end

function menu:select_item(i)
  self.selected_item = i == nil and self.selected_item or i
  self.selected_item_string  = self.items[self.selected_item]
  self.offset = self.selected_item > self.threshold and self.selected_item - self.threshold or 0
end

function menu:set_items(items)
  self.items = items
end

function menu:scroll_value(d)
  local s = self.selected_item_string
  print(s)
  print(d)
  -- home
  if page.active_page == 1 then
    if s == fn.playback() then
      sound:set_playback(d)
    elseif s == "SEED" then
      fn.set_seed(params:get("seed") + d)
    elseif s == "BPM" then
      params:set("bpm", util.clamp(params:get("bpm") + d, 20, 240))
    elseif s == "METER" then
      sound:cycle_meter(d)
    elseif s == "ROOT" then
      sound:cycle_root(d)
    elseif s == "SCALE" then
      sound:set_scale(sound.current_scale + d)
    end

  -- cell designer
  elseif page.active_page == 2 then
    -- if not keeper.is_cell_selected then return end

    if s == "STRUCTURE" then
      fn.select_cell_structure(d)

    elseif s == "OFFSET" then
      keeper.selected_cell:cycle_offset(d)

    elseif s == "NOTE" then
      fn.select_cell_note(d)

    elseif s == "VELOCITY" then
      keeper.selected_cell:set_velocity(keeper.selected_cell.velocity + d)

    elseif s == "DOCS" then
      print("DOCS...")
    
    end
  
  -- analysis
  elseif page.active_page == 3 then
    -- nothing to change here
  end

end

function menu:add_item(string)
  self.items[#self.items + 1] = string
end

function menu:focus(string)
  self.focus_item = string
  self.focus_on = true
  self.focus_index = fn.table_find(self.items, string)
end

function menu:focus_off()
  self.focus_item = ""
  self.focus_on = false
  self.focus_index = 0
end

function menu:render_no_values()
  self:render(false)
end

-- ok im throwing in the towel for tonight. just added focus index so when you scroll thorugh
-- structures on the cell page i'll be able to make that stick. i think this will be the only
-- instance where this is a thing but i sorta want to make it maintainable...

function menu:render(bool)
  local render_values = (bool == nil) and true or bool
  local item_level = 15  
  -- rectangular highlight
  graphics:rect(0, ((self.selected_item - 1) * 8) + 12 - (self.offset * 8), 51, 7, 2)
  -- iterate through items and control focus
  for i = 1, #self.items do
    if self.focus_on then
      item_level = self.items[i] == self.focus_item and 15 or 0
    end
    local offset = 10 + (i * 8) - (self.offset * 8)
    -- menu item
    graphics:text(2, offset, self.items[i], item_level)
    -- panel value for cell designer
    if page.active_page == 2 and self.items[i] ~= "STRUCTURE" and render_values then
      graphics:text(56, offset, keeper.selected_cell:get_menu_value_by_attribute(self.items[i]), 0)
    end
  end
  -- indicate when more menu items are available above
  if self.offset > 0 then
    -- pop the ellipses once we start to scroll down
    graphics:rect(0, 7, 51, 14, 0) 
    graphics:text(2, 18, "...", item_level)
  else
    -- top mask to stop the text from running over the title bar
    graphics:rect(0, 7, 51, 5, 0)
  end
  -- indicate when menu items are available below
  if #self.items > self.threshold and self.selected_item ~= #self.items then
    graphics:rect(0, 59, 51, 14, 0) 
    graphics:text(2, 64, "...", item_level)
  end
end

return menu