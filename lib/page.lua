local page = {}

function page.init()
  page.active_page = 1
  page.selected_item = 1
  page_items = {}
  page_items[1] = 2
  page_items[2] = 4
  page_items[3] = 0
  page.items = page_items[page.active_page]
end




function page:change_selected_item_value(d)

  local cache
  local p = page.active_page  
  local s = page.selected_item

  -- home
  if p == 1 then
    if s == 1 then
      cache = params:get("playback")
      params:set("playback", util.clamp(d, 0, 1))
      cache_check(cache, params:get("playback"))
    elseif s == 2 then
      cache = params:get("bpm")
      params:set("bpm", util.clamp(params:get("bpm") + d, 20, 240))
      cache_check(cache, params:get("bpm"))
    end

  -- structures
  elseif p == 2 then
    if s == 1 then
      cache = params:get("page_structure")
      params:set("page_structure", util.clamp(params:get("page_structure") + d, 1, 4))
      cache_check(cache, params:get("page_structure"))
    elseif s == 2 then
      cache = params:get("page_metabolism")
      params:set("page_metabolism", util.clamp(params:get("page_metabolism") + d, 1, 16))
      cache_check(cache, params:get("page_structure"))
    elseif s == 3 then
      cache = params:get("page_sound")
      params:set("page_sound", util.clamp(params:get("page_sound") + d, 1, 144))
      cache_check(cache, params:get("page_structure"))
    end

  -- analysis
  elseif p == 3 then
    print('not yet implemented')
  end

end







function page:render()
  local cache_active_page = self.active_page
  local cache_selected_item = self.selected_item
  self.active_page = page.active_page
  self.selected_item = page.selected_item
  graphics:top_menu()
  graphics:select_tab(self.active_page)
  graphics:top_message()
  graphics:page_name(dictionary.pages[self.active_page])
  if self.active_page == 1 then
    self:one()
  elseif self.active_page == 2 then
    self:two()
  elseif self.active_page == 3 then
    self:three()
  end
  cache_check(cache_active_page, self.active_page)
  cache_check(cache_selected_item, self.selected_item)
end











-- home
function page:one()
  graphics:panel()
  graphics:menu_highlight(self.selected_item)
  graphics:text(2, 18, params:get("playback") == 0 and "READY" or "PLAYING")  
  graphics:text(2, 26, "BPM")
  graphics:bpm(55, 39, params:get("bpm"), 0)
  if params:get("playback") == 0 then
    graphics:icon(56, 44, "||", 1)
  else
    local ml = generation_fmod(4)
    graphics:icon(56, 44, ml, (ml == 1) and 1 or 0)
  end
  if is_deleting() then
    graphics:icon(76, 44, "!!", 1)
  else
    graphics:icon(76, 44, "X", 0)
  end
end









-- structures
function page:two()
  graphics:panel()
  graphics:menu_highlight(self.selected_item)
  graphics:cell_id()
  if not keeper.is_cell_selected then
    graphics:cell()
    graphics:draw_ports()
    graphics:structure_disable()
    graphics:metabolism_disable()
    graphics:sound_disable()
    graphics:velocity_disable()
  elseif keeper.selected_cell.structure == 1 then
    graphics:hive()
    graphics:draw_ports()
    graphics:structure_type(dictionary.structures[1])
    graphics:structure_enable()
    graphics:metabolism_enable()
    graphics:sound_disable()
    graphics:velocity_disable()
  elseif keeper.selected_cell.structure == 2 then
    graphics:gate()
    graphics:draw_ports(-5)
    graphics:structure_type(dictionary.structures[2])
    graphics:structure_enable()
    graphics:metabolism_disable()
    graphics:sound_disable()
    graphics:velocity_disable()
  elseif keeper.selected_cell.structure == 3 then
    graphics:shrine()
    graphics:draw_ports()    
    graphics:structure_type(dictionary.structures[3])
    graphics:structure_enable()
    graphics:metabolism_disable()
    graphics:sound_enable()
    graphics:velocity_enable()
  end
end





-- analysis
function page:three()
  graphics:analysis()
end



return page