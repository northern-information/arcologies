local page = {}

function page.init()
  page.titles = { "ARCOLOGIES", "CELL DESIGNER" , "ANALYSIS" }
  page.active_page = 1
end

function page:scroll(d)
  self:select(util.clamp(page.active_page + d, 1, #page.titles))
end

function page:select(i)
  self.active_page = i
  if page.active_page ~= 2 then
    keeper:deselect_cell()
  end
  menu:reset()
  fn.dirty_screen(true)
end

function page:render()
  if fn.no_grid() then page:error(1) return end
  if self.active_page == 1 then
    self:home()
  -- elseif self.active_page == 2 then
  --   self:cell_designer()
  elseif self.active_page == 3 then
    self:analysis()
  end
  graphics:title_bar()
  graphics:select_tab(self.active_page)
  graphics:top_message()
  graphics:page_name(self.titles[self.active_page])  
  fn.dirty_screen(true)
end

function page:home()
  local playback = sound.playback == 0 and "READY" or "PLAYING"
  menu:set_items({
    playback,
    "SEED",
    "BPM", 
    "METER", 
    "ROOT", 
    "SCALE"
  })
  menu:render()
  graphics:panel()
  if fn.is_selecting_seed() then
    menu:focus("SEED")
    graphics:seed()
  else
    menu:focus_off()
    graphics:bpm(55, 32, params:get("bpm"), 0)
    graphics:playback_icon(56, 35)
    graphics:icon(76, 35, sound.meter, menu.selected_item == 4 and 1 or 0)
    if fn.is_deleting() then
      graphics:icon(56, 35, "D:", 1)
      graphics:icon(76, 35, "D:", 1)
    end
    graphics:text(56, 61, mu.note_num_to_name(sound.current_root) .. " " .. sound.current_scale_name, 0)
    graphics:rect(126, 55, 2, 7, 15)
  end
end

function page:cell_designer()
  -- graphics:panel()
  -- -- graphics:menu_highlight(menu.selected_item)
  -- if fn.is_selecting_note() then
  --   graphics:piano(keeper.selected_cell.note)
  --   graphics:sound_enable()
  -- else
  --   if not keeper.is_cell_selected then
  --     graphics:cell()
  --     graphics:draw_ports()
  --     graphics:structure_disable()
  --     graphics:offset_disable()
  --     graphics:sound_disable()
  --     graphics:velocity_disable()
  --   elseif keeper.selected_cell.structure == 1 then
  --     graphics:hive()
  --     graphics:draw_ports()
  --     graphics:structure_type(keeper.selected_cell.available_structures[1])
  --     graphics:structure_enable()
  --     graphics:offset_enable()
  --     graphics:sound_disable()
  --     graphics:velocity_disable()
  --   elseif keeper.selected_cell.structure == 2 then
  --     graphics:shrine()
  --     graphics:draw_ports()
  --     graphics:structure_type(keeper.selected_cell.available_structures[2])
  --     graphics:structure_enable()
  --     graphics:offset_disable()
  --     graphics:sound_enable()
  --     graphics:velocity_enable()
  --   elseif keeper.selected_cell.structure == 3 then
  --     graphics:gate()
  --     graphics:draw_ports(-5)
  --     graphics:structure_type(keeper.selected_cell.available_structures[3])
  --     graphics:structure_enable()
  --     graphics:offset_disable()
  --     graphics:sound_disable()
  --     graphics:velocity_disable()
  --   end
  -- end
end

function page:analysis()
  menu:set_items({
    "HIVES",
    "SHRINES", 
    "GATES", 
    "SIGNALS"
  })
  graphics:analysis(menu.selected_item)
end

function page:error(code)
  if code == 1 then
    graphics:rect(1, 1, 128, 64, 15)
    graphics:text_center(64, 30, "PLEASE CONNECT A", 0)
    graphics:text_center(64, 42, "MONOME VARIBRIGHT GRID.", 0)
  end
end

return page