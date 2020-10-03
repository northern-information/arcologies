menu = {}

function menu.init()
  menu.threshold = 6
  menu:reset()
end

function menu:reset()
  self.show_all = true
  self.items = {}
  self.item_count = 0
  self.selected_item = 1
  self.selected_item_string = ""
  self.offset = 0
  docs:set_active(false)
end

function menu:render(bool)
  local render_values = (bool == nil) and true or bool
  -- rectangular highlight
  graphics:rect(0, ((self.selected_item - 1) * 8) + 12 - (self.offset * 8), 51, 7, 2)
  for i = 1, #self.items do
    local item = self.items[i]
    if item ~= nil then
      local offset = 10 + (i * 8) - (self.offset * 8)
      -- menu item
      graphics:text(2, offset, item, 15)
      -- exception for external tempo control
      if not fn.is_clock_internal() and item == "BPM" then
        graphics:text(2, offset, item, 5)
        graphics:mls(2, offset - 2, 40, offset - 2, 15)
      end
      -- all values come from the mixins
      if page.active_page == 2 and render_values then
        graphics:text(56, offset, keeper.selected_cell:get_menu_value_by_attribute(item)(keeper.selected_cell), 0)
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
    keeper.selected_cell:set_attribute_value(s, d)
  -- analysis
  elseif page.active_page == 3 then
    -- nothing to change here
  end
end

function menu:scroll(d)
  self:select_item(util.clamp(self.selected_item + d, 1, #self.items))
end

function menu:select_item(i)
  if page.active_page == 3 then keeper:deselect_cell() end
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
  self.item_count = #items
end

function menu:get_item_count()
  return self.item_count
end

function menu:get_selected_item()
  return self.selected_item
end

function menu:get_selected_item_string()
  return self.selected_item_string
end

function menu:handle_scroll_bpm(d)
  if fn.is_clock_internal() then
    params:set("clock_tempo", params:get("clock_tempo") + d)
  else
    graphics:set_message("EXTERNAL CONTROL ON", counters.default_message_length)
  end
end

function menu:adaptor(lookup, x)
 if keeper.is_cell_selected then
    local c = keeper.selected_cell
    local s = self:get_selected_item_string()
    local match = fn.key_find(c.arc_styles, s)
    if match then
          if lookup == "style"        then return c.arc_styles[s].style
      elseif lookup == "sensitivity"  then return c.arc_styles[s].sensitivity
      elseif lookup == "min"          then return c.arc_styles[s].min
      elseif lookup == "max"          then return c.arc_styles[s].max
      elseif lookup == "value_getter" then return c.arc_styles[s].value_getter(c)
      elseif lookup == "value_setter" then return c.arc_styles[s].value_setter(c, x)
      elseif lookup == "menu_getter"  then return c.arc_styles[s].menu_getter(c)
      elseif lookup == "menu_setter"  then return c.arc_styles[s].menu_setter(c, x)
      end
    end
  end 
end

return menu