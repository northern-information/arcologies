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
  self.selected_item = 1
  self.offset = 0
end

function menu:scroll(d)
  self.selected_item = util.clamp(self.selected_item + d, 1, #self.items)
  self.offset = self.selected_item > self.threshold and self.selected_item - self.threshold or 0
end

function menu:set_items(items)
  self.items = items
end

function menu:scroll_value(d)
  local p = page.active_page
  local s = self.selected_item

  -- home
  if p == 1 then
    if s == 1 then
      sound:set_playback(d)
    elseif s == 2 then
      fn.set_seed(params:get("seed") + d)
    elseif s == 3 then
      params:set("bpm", util.clamp(params:get("bpm") + d, 20, 240))
    elseif s == 4 then
      sound:cycle_meter(d)
    elseif s == 5 then
      sound:cycle_root(d)
    elseif s == 6 then
      sound:set_scale(sound.current_scale + d)
    end

  -- -- cell designer
  -- elseif p == 2 then
  --   if not keeper.is_cell_selected then return end

  --   if s == 1 then
  --     keeper.selected_cell:cycle_structure(d)

  --   elseif s == 2 then
  --     keeper.selected_cell:cycle_offset(d)

  --   elseif s == 3 then
  --     fn.select_cell_note(d)

  --   elseif s == 4 then
  --     keeper.selected_cell:set_velocity(keeper.selected_cell.velocity + d)

  --   end

  -- analysis
  elseif p == 3 then
    -- nothing to change here
  end

end

function menu:add_item(string)
  self.items[#self.items + 1] = string
end

function menu:focus(string)
  self.focus_item = string
  self.focus_on = true
end

function menu:focus_off()
  self.focus_item = ""
  self.focus_on = false
end

function menu:render()
  local item_level = 15  
  -- rectangular highlight
  graphics:rect(0, ((self.selected_item - 1) * 8) + 12 - (self.offset * 8), 51, 7, 2)
  -- iterate through items and control focus
  for i = 1, #self.items do
    if self.focus_on then
      item_level = self.items[i] == self.focus_item and 15 or 0
    end
    graphics:text(2, 10 + (i * 8) - (self.offset * 8), self.items[i], item_level)
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