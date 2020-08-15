local menu = {}

function menu.init()
  menu.threshold = 6
  menu:reset()
end

function menu:reset()
  self.show_all = true
  self.items = {}
  self.focus_item = ""
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

  -- -- analysis
  -- elseif p == 3 then
  --   -- nothing to change here

  -- -- signal density
  -- elseif p == 4 then
  --   -- nothing to change here
  -- end
  -- fn.dirty_screen(true)


end

function menu:add_item(string)
  self.items[#self.items + 1] = string
end

function menu:focus(string)
  self.focus_item = string
  self.show_all = false
  self:render()
end

function menu:focus_off()
  self.focus_item = ""
  self.show_all = true
end

function menu:render()
  self:highlight(self.selected_item)

  for i = 1, #self.items do
    graphics:text(2, 10 + (i * 8) - (self.offset * 8), self.items[i])
  end
  
  -- indicate when more menu items are available above
  if self.offset > 0 then
    -- pop the ellipses once we start to scroll down
    graphics:rect(0, 7, 51, 14, 0) 
    graphics:text(2, 18, "...")
  else
    -- top mask to stop the text from running over the title bar
    graphics:rect(0, 7, 51, 5, 0)
  end

  -- indicate when menu items are available below
  if #self.items > self.threshold and self.selected_item ~= #self.items then
    graphics:rect(0, 59, 51, 14, 0) 
    graphics:text(2, 64, "...")
  end
end

function menu:highlight(i)
  graphics:rect(0, ((i - 1) * 8) + 12 - (self.offset * 8), 51, 7, 2)
end

return menu