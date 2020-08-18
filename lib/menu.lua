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

  -- home
  if page.active_page == 1 then
    if s == fn.playback() then
      sound:set_playback(d)
    elseif s == "SEED" then
      popup:launch("seed", d, "enc", 3)
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
    if s == "STRUCTURE" then
      popup:launch("structure", d, "enc", 3)
    elseif s == "OFFSET" then
      keeper.selected_cell:cycle_offset(d)
    elseif s == "NOTE" then
      popup:launch("note", d, "enc", 3)
    elseif s == "VELOCITY" then
      keeper.selected_cell:set_velocity(keeper.selected_cell.velocity + d)
    elseif s == "METABOLISM" then
      keeper.selected_cell:set_metabolism(keeper.selected_cell.metabolism + d)
    elseif s == "DOCS" then
      print("DOCS...")
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