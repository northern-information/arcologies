menu = {}

function menu.init()
  menu.threshold = 6
  menu.arc_styles = {}
  menu:register_arc_styles()
  menu:reset()
end

function menu:reset()
  self.show_all = true
  self.items = {}
  self.item_count = 0
  self.selected_item = self:get_item_count_minimum()
  self.selected_item_string = ""
  self.offset = 0
  docs:set_active(false)
end

function menu:get_item_count_minimum()
  if page:get_page_title() == "DESIGNER" and not keeper.is_cell_selected then
    return 0
  else
    return 1
  end
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
      if page:get_page_title() == "DESIGNER" and render_values then
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
  if page.active_page == 1 then -- note the name of page 1 can change
        if s == fn.playback() then counters:set_playback(d)
    elseif s == "BPM"         then self:handle_scroll_bpm(d, "delta")
    elseif s == "LENGTH"      then sound:cycle_length(d)
    elseif s == "ROOT"        then sound:cycle_root(d)
    elseif s == "SCALE"       then sound:cycle_scale(d)
    elseif s == "TRANSPOSE"   then sound:cycle_transpose(d)
    end
  -- cell designer
  elseif page:get_page_title() == "DESIGNER" then
    keeper.selected_cell:set_attribute_value(s, d)
  -- analysis
  elseif page:get_page_title() == "ANALYSIS" then
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

function menu:handle_scroll_bpm(value, mode)
  if fn.is_clock_internal() then
    if mode == "delta" then
      params:set("clock_tempo", params:get("clock_tempo") + value)
    elseif mode == "absolute" then
      params:set("clock_tempo", value)
    end
  else
    graphics:set_message("EXTERNAL CONTROL ON", counters.default_message_length)
  end
end

function menu:adaptor(lookup, args)
  local s = self:get_selected_item_string()
  if keeper.is_cell_selected and page:get_page_title() == "DESIGNER" then
    local c = keeper.selected_cell
    local match = fn.key_find(c.arc_styles, s)
    if match then
          if lookup == "style"         then return c.arc_styles[s].style
      elseif lookup == "sensitivity"   then return c.arc_styles[s].sensitivity
      elseif lookup == "min"           then return c.arc_styles[s].min
      elseif lookup == "max"           then return c.arc_styles[s].max
      elseif lookup == "offset"        then return c.arc_styles[s].offset
      elseif lookup == "value_getter"  then return c.arc_styles[s].value_getter(c)
      elseif lookup == "value_setter"  then return c.arc_styles[s].value_setter(c, args)
      end
    end
  else
    local match = fn.key_find(self.arc_styles, s)
    if match then
          if lookup == "style"         then return self.arc_styles[s].style
      elseif lookup == "sensitivity"   then return self.arc_styles[s].sensitivity
      elseif lookup == "min"           then return self.arc_styles[s].min
      elseif lookup == "max"           then return self.arc_styles[s].max
      elseif lookup == "offset"        then return self.arc_styles[s].offset
      elseif lookup == "value_getter"  then return self.arc_styles[s].value_getter()
      elseif lookup == "value_setter"  then return self.arc_styles[s].value_setter(args)
      end
    end
  end
end

function menu:register_arc_styles()
  self.arc_styles["READY"] = {
    key = "READY",
    style = "glowing_boolean",
    sensitivity = .5,
    min = 0,
    max = 1,
    offset = 0,
    value_getter = function() return counters:get_playback() end,
    value_setter = function(args) return counters:set_playback(args) end
  }
  self.arc_styles["PLAYING"] = {
    key = "PLAYING",
    style = self.arc_styles["READY"].style,
    sensitivity = self.arc_styles["READY"].sensitivity,
    min = self.arc_styles["READY"].min,
    max = self.arc_styles["READY"].max,
    offset = self.arc_styles["READY"].offset,
    value_getter = self.arc_styles["READY"].value_getter,
    value_setter = self.arc_styles["READY"].value_setter
  }
  self.arc_styles["BPM"] = {
    key = "BPM",
    style = "glowing_segment",
    sensitivity = .5,
    min = 1,
    max = 300,
    offset = 180,
    value_getter = function() return params:get("clock_tempo") end,
    value_setter = function(args) menu:handle_scroll_bpm(args, "absolute") end
  }
  self.arc_styles["LENGTH"] = {
    key = "LENGTH",
    style = "sweet_sixteen",
    sensitivity = .05,
    min = 1,
    max = 16,
    offset = 180,
    value_getter = function() return sound:get_length() end,
    value_setter = function(args) sound:set_length(args) end
  }
  self.arc_styles["ROOT"] = {
    key = "ROOT",
    style = "glowing_divided",                                      -- todo infinite scroll
    sensitivity = .05,
    min = 1,
    max = 12,
    offset = 0,
    value_getter = function() return sound:get_root() end,
    value_setter = function(args) sound:cycle_root(args) end          -- todo cycle
  }
  self.arc_styles["SCALE"] = {
    key = "SCALE",
    style = "glowing_divided",
    sensitivity = .05,
    min = 1,
    max = #sound.scale_names,
    offset = 0,
    value_getter = function() return sound:get_scale() end,
    value_setter = function(args) sound:cycle_scale(args) end
  }
  self.arc_styles["TRANSPOSE"] = {
    key = "TRANSPOSE",
    style = "glowing_segment",
    sensitivity = .05,
    min = -6,                                                     -- todo support negative min
    max = 6,
    offset = 0,
    value_getter = function() return sound:get_transpose() end,
    value_setter = function(args) sound:set_transpose(args) end
  }
  self.arc_styles["DOCS"] = {
    key = "DOCS",
    style = "standby",                                   -- todo standby
    sensitivity = 0,
    min = 0,
    max = 0,
    offset = 0,
    value_getter = function() return end,
    value_setter = function(args) end
  }
end

return menu