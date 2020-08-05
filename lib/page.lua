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
  page.enc_confirm_index = 1
  page.left_edge = 2
  page.right_edge = 126
  page.rows_start = 20
  page.structure_x = 94
  page.structure_y = 26
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
      cache = params:get("static_animation_on")
      params:set("static_animation_on", util.clamp(d, 0, 1))
      cache_check(cache, params:get("static_animation_on"))
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
      params:set("page_sound", util.clamp(params:get("page_ound") + d, 1, 144))
      cache_check(cache, params:get("page_structure"))
    else
      print('not yet implemented')
    end

  -- analysis
  elseif p == 3 then
    print('not yet implemented')
  end


end







function page:render(core)
  local cache_active_page = self.active_page
  local cache_selected_item = self.selected_item
  self.active_page = core.page.active_page
  self.selected_item = core.page.selected_item
  self.ui_frame = core.counters.ui.frame
  self.music_location = core.counters.music.location
  self.music_location_fmod = math.fmod(core.counters.music.location, 10) + 1
  self.enc_confirm_index = core.parameters.enc_confirm_index
  self.selected_cell = core.selected_cell
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
  self.graphics:text(self.left_edge, 18, params:get("playback") == 0 and "READY" or "PLAYING")  
  self.graphics:text(self.left_edge, 26, "BPM")
  self.graphics:text(self.left_edge, 34, "RAZE " .. self.graphics:enc_confirm_animation(self.enc_confirm_index))
  self.graphics:text(self.left_edge, 42,  params:get("static_animation_on") == 0 and "CLEAN" or "STATIC")
  self.graphics:text(56, 18, 
    (params:get("playback") == 0) and 
      self.graphics:ready_animation(self.music_location_fmod) or 
      math.fmod(self.music_location, 4) + 1 .. " " .. self.graphics:playing_animation(self.music_location_fmod)
  , 0)
  self.graphics:bpm(55, 40, params:get("bpm"), 0)
  self.graphics:icon(76, 44, "S", (self.selected_item == 4) and 1 or 0)
  self.graphics:icon(56, 44, "R", (self.selected_item == 3) and 1 or 0)
end









-- structures
function page:two()
  self.graphics:menu_highlight(self.selected_item)
  self.graphics:text(56, 25, params:get("page_metabolism"), 0)
  self.graphics:text(56, 33, page.dictionary.sounds[params:get("page_sound")], 0)
  self:cell_id()
  if params:get("page_structure") == 1 then
    self.graphics:hive(self.structure_x, self.structure_y)
    self:draw_ports()
    self:structure_type(self.dictionary.structures[1])
    self:structure_enable()
    self:metabolism_enable()
    self:sound_disable()
  elseif params:get("page_structure") == 2 then
    self.graphics:gate(self.structure_x, self.structure_y)
    self:structure_type(self.dictionary.structures[2])
    self:structure_enable()
    self:metabolism_disable()
    self:sound_disable()
    self:draw_ports(-5)
  elseif params:get("page_structure") == 3 then
    self.graphics:shrine(self.structure_x, self.structure_y)
    self:draw_ports()    
    self:structure_type(self.dictionary.structures[3])
    self:structure_enable()
    self:metabolism_disable()
    self:sound_enable()
  end
end








function page:three()
  self.graphics:circle(64, 32, 16, 15)
  self.graphics:circle(100, 24, 8, 15)
end









function page:cell_id()
  local id = "NONE"
  if #self.selected_cell == 2 then
    id = "X" .. self.selected_cell[1] .. "Y" .. self.selected_cell[2] 
  end
  self.graphics:text(56, 63, id, 0)
end

function page:draw_ports(adjust)
  self.graphics:text(56, 55, "NESW", 0)
  self.graphics:north_port(self.structure_x, self.structure_y, (adjust or 0))
  self.graphics:east_port(self.structure_x, self.structure_y)
  self.graphics:south_port(self.structure_x, self.structure_y)
  self.graphics:west_port(self.structure_x, self.structure_y)
end

function page:structure_type(s)
    self.graphics:text(56, 18, s, 0)
end

function page:structure_enable()
  self.graphics:text(self.left_edge, 18, "STRUCTURE", 15)  
end

function page:metabolism_enable()
    self.graphics:text(self.left_edge, 26, "METABOLISM", self.graphics.levels["h"])
end

function page:metabolism_disable()
  self.graphics:text(self.left_edge, 26, "METABOLISM", self.graphics.levels["l"])
  self.graphics:mls(0, 24, 51, 23, self.graphics.levels["m"])
end

function page:sound_enable()
  self.graphics:text(self.left_edge, 34, "SOUND", self.graphics.levels["h"])
end

function page:sound_disable()
  self.graphics:text(self.left_edge, 34, "SOUND", self.graphics.levels["l"])
  self.graphics:mls(0, 32, 51, 31, self.graphics.levels["m"])
end

return page