local page = {}

function page.init()
  page.active_page = 1
  page_items = {}
  page_items[1] = 4
  page_items[2] = 3
  page_items[3] = 0
  page.selected_item = 1
  page.items = page_items[page.active_page]
  page.ui_frame = 1
  page.music_location = 1
  page.music_location_fmod = 1
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
    elseif s == 3 then
      cache = params:get("enc_confirm_index")
      params:set("enc_confirm_index", util.clamp(params:get("enc_confirm_index") + d, 1, 53))
      cache_check(cache, params:get("enc_confirm_index"))
    elseif s == 4 then
      cache = params:get("static_animation")
      params:set("static_animation", util.clamp(d, 0, 1))
      cache_check(cache, params:get("static_animation"))
      if cache ~= params:get("static_animation") then clear_static() end
    end

  -- structures
  elseif p == 2 then
    if s == 1 then
      cache = params:get("page_structure")
      params:set("page_structure", util.clamp(params:get("page_structure") + d, 1, 3))
      cache_check(cache, params:get("page_structure"))
    elseif s == 2 then
      cache = params:get("page_metabolism")
      params:set("page_metabolism", util.clamp(params:get("page_metabolism") + d, 1, 16))
      cache_check(cache, params:get("page_structure"))
    elseif s == 3 then
      cache = params:get("page_sound")
      params:set("page_sound", util.clamp(params:get("page_sound") + d, 1, 144))
      cache_check(cache, params:get("page_structure"))
    else
      print('not yet implemented')
    end

  -- analysis
  elseif p == 3 then
    print('not yet implemented')
  end


end







function page:render()
  local cache_active_page = self.active_page
  local cache_selected_item = self.selected_item
  self.active_page = core.page.active_page
  self.selected_item = core.page.selected_item
  self.ui_frame = core.counters.ui.frame
  self.music_location = core.counters.music.location
  self.music_location_fmod = math.fmod(core.counters.music.location, 10) + 1
  self.parameters = core.parameters
  self.selected_cell = core.selected_cell
  self.graphics = core.graphics
  self.dictionary = core.dictionary
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











-- arcologies
function page:one()
  self.graphics:menu_highlight(self.selected_item)
  self.graphics:text(2, 18, params:get("playback") == 0 and "READY" or "PLAYING")  
  self.graphics:text(2, 26, "BPM")
  self.graphics:text(2, 34, "RAZE " .. self.graphics:enc_confirm_animation(self.parameters.enc_confirm_index))
  self.graphics:text(2, 42,  params:get("static_animation") == 0 and "CLEAN" or "STATIC")
  self.graphics:text(56, 18, 
    (params:get("playback") == 0) and 
      self.graphics:ready_animation(self.music_location_fmod) or 
      math.fmod(self.music_location, 4) + 1 .. " " .. self.graphics:playing_animation(self.music_location_fmod)
  , 0)
  self.graphics:bpm(55, 40, params:get("bpm"), 0)
  self.graphics:icon(56, 44, "R", (self.selected_item == 3) and 1 or 0)
  self.graphics:icon(76, 44, self.parameters.static_animation_value, (self.selected_item == 4) and 1 or 0)
end









-- structures
function page:two()
  self.graphics:menu_highlight(self.selected_item)
  self.graphics:text(56, 25, params:get("page_metabolism"), 0)
  self.graphics:text(56, 33, page.dictionary.sounds[params:get("page_sound")], 0)
  self.graphics:cell_id(self.selected_cell)
  if params:get("page_structure") == 1 then
    self.graphics:hive()
    self.graphics:draw_ports()
    self.graphics:structure_type(self.dictionary.structures[1])
    self.graphics:structure_enable()
    self.graphics:metabolism_enable()
    self.graphics:sound_disable()
  elseif params:get("page_structure") == 2 then
    self.graphics:gate()
    self.graphics:structure_type(self.dictionary.structures[2])
    self.graphics:structure_enable()
    self.graphics:metabolism_disable()
    self.graphics:sound_disable()
    self.graphics:draw_ports(-5)
  elseif params:get("page_structure") == 3 then
    self.graphics:shrine()
    self.graphics:draw_ports()    
    self.graphics:structure_type(self.dictionary.structures[3])
    self.graphics:structure_enable()
    self.graphics:metabolism_disable()
    self.graphics:sound_enable()
  end
end





-- analysis
function page:three()
  self.graphics:circle(64, 32, 16, 0)
  self.graphics:circle(100, 24, 8, 0)
end



return page