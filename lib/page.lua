local page = {}

function page.init()
  page.titles = { "ARCOLOGIES", "CELL DESIGNER" , "ANALYSIS" }
  page.active_page = 1
  page.selected_item = 1
  page_items = {}
  page_items[1] = 6
  page_items[2] = 4
  page_items[3] = 5
  page.items = page_items[page.active_page]
end

function page:select(i)
  self.active_page = i
  self.items = page_items[self.active_page]
  self.selected_item = 1
  fn.dirty_screen(true)
end

function page:change_selected_item_value(d)
  local p = page.active_page
  local s = page.selected_item

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

  -- cell designer
  elseif p == 2 then
    if not keeper.is_cell_selected then return end

    if s == 1 then
      keeper.selected_cell:cycle_structure(d)

    elseif s == 2 then
      keeper.selected_cell:cycle_offset(d)

    elseif s == 3 then
      fn.set_note(d)

    elseif s == 4 then
      keeper.selected_cell:set_velocity(keeper.selected_cell.velocity + d)

    end

  -- analysis
  elseif p == 3 then
    -- nothing to change here

  -- signal density
  elseif p == 4 then
    -- nothing to change here
  end
  fn.dirty_screen(true)
end

function page:render()
  self.active_page = page.active_page
  self.selected_item = page.selected_item
  graphics:top_menu()
  graphics:select_tab(self.active_page)
  graphics:top_message()
  graphics:page_name(self.titles[self.active_page])
  if self.active_page == 1 then
    self:home()
  elseif self.active_page == 2 then
    self:cell_designer()
  elseif self.active_page == 3 then
    graphics:analysis(self.selected_item)
  elseif self.active_page == 4 then
   graphics:signal_density(self.selected_item)
  end
  fn.dirty_screen(true)
end

function page:home()
  graphics:panel()
  graphics:menu_highlight(self.selected_item)
  if fn.is_selecting_seed() then
    graphics:text(2, 26, "SEED")
    graphics:seed()
  else
    graphics:text(2, 18, sound.playback == 0 and "READY" or "PLAYING")
    graphics:text(2, 26, "SEED")
    graphics:bpm(55, 32, params:get("bpm"), 0)
    graphics:text(2, 34, "BPM")
    graphics:text(2, 42, "METER")
    graphics:text(2, 50, "ROOT")
    graphics:text(2, 58, "SCALE")

    graphics:playback_icon(56, 35)
    graphics:icon(76, 35, sound.meter, self.selected_item == 3 and 1 or 0)

    if fn.is_deleting() then
      graphics:icon(56, 35, "D:", 1)
      graphics:icon(76, 35, "D:", 1)
    end

    -- graphics:text(98, 52, sound.default_out_name, 0)

    graphics:text(56, 61, mu.note_num_to_name(sound.current_root) .. " " .. sound.current_scale_name, 0)
    graphics:rect(126, 55, 2, 7, 15)
  end
end

function page:cell_designer()
  graphics:panel()
  graphics:menu_highlight(self.selected_item)
  if fn.is_selecting_note() then
    graphics:piano(keeper.selected_cell.note)
    graphics:sound_enable()
  else
    graphics:cell_id()
    if not keeper.is_cell_selected then
      graphics:cell()
      graphics:draw_ports()
      graphics:structure_disable()
      graphics:offset_disable()
      graphics:sound_disable()
      graphics:velocity_disable()
    elseif keeper.selected_cell.structure == 1 then
      graphics:hive()
      graphics:draw_ports()
      graphics:structure_type(keeper.selected_cell.available_structures[1])
      graphics:structure_enable()
      graphics:offset_enable()
      graphics:sound_disable()
      graphics:velocity_disable()
    elseif keeper.selected_cell.structure == 2 then
      graphics:shrine()
      graphics:draw_ports()
      graphics:structure_type(keeper.selected_cell.available_structures[2])
      graphics:structure_enable()
      graphics:offset_disable()
      graphics:sound_enable()
      graphics:velocity_enable()
    elseif keeper.selected_cell.structure == 3 then
      graphics:gate()
      graphics:draw_ports(-5)
      graphics:structure_type(keeper.selected_cell.available_structures[3])
      graphics:structure_enable()
      graphics:offset_disable()
      graphics:sound_disable()
      graphics:velocity_disable()
    end
  end
end

return page