local page = {}

function page.init()
  page.active_page = 1
  page_items = {}
  page_items[1] = 5
  page_items[2] = 3
  page_items[3] = 0
  page.selected_item = 1
  page.items = page_items[page.active_page]
  page.ui_frame = 0
  page.music_location = 0
  page.left_edge = 2
  page.right_edge = 126
  page.rows_start = 20
end

-- this is probably a really dumb way to do this?
function page:change_selected_item_value(d)

  local p = page.active_page  
  local s = page.selected_item

  -- home
  if p == 1 then
    if s == 1 then
      params:set("Status", util.clamp(d, 0, 1))
    elseif s == 2 then
      params:set("BPM", util.clamp(params:get("BPM") + d, 20, 240))
    elseif s == 3 then
      print('not yet implemented')
    elseif s == 4 then
      print('not yet implemented')
    elseif s == 5 then
      params:set("Static", util.clamp(d, 0, 1))
    end

  -- structures
  elseif p == 2 then
    if s == 1 then
      params:set("TempStructure", util.clamp(params:get("TempStructure") + d, 1, 3))
    elseif s == 2 then
      params:set("TempMetabolism", util.clamp(params:get("TempMetabolism") + d, 1, 16))
    elseif s == 3 then
      params:set("TempSound", util.clamp(params:get("TempSound") + d, 1, 144))
    else
      print('not yet implemented')
    end

  -- analysis
  elseif p == 3 then
    print('not yet implemented')
  end
end

function page:render(i, s, f, l)
  self.selected_item = s
  self.ui_frame = f
  self.music_location = l
  if i == 1 then
    self:one()
  elseif i == 2 then
    self:two()
  elseif i == 3 then
    self:three()
  end
end

-- home
function page:one()
  -- menu
  local y = ((self.selected_item - 1) * 8) + 11
  self.ui.graphics:rect(0, y, 51, 7, 2)
  menu_status = params:get("Status") == 0 and "READY" or "PLAYING"
  static_status = params:get("Static") == 0 and "CLEAN" or "STATIC"
  self.ui.graphics:text(self.left_edge, 17, menu_status, 15)  
  self.ui.graphics:text(self.left_edge, 25, "BPM", 15)
  self.ui.graphics:text(self.left_edge, 33, "SEED", 15)
  self.ui.graphics:text(self.left_edge, 41, "RAZE", 15)
  self.ui.graphics:text(self.left_edge, 49,  static_status, 15)

  -- panel
  self.ui.graphics:rect(54, 11, 84, 55)
  self.ui.graphics:panel_static()


  -- values
  local hud_x = 64
  local hud_y = 25
  local status
  if params:get("Status") == 0 then
    status = self.ui.ready_animation(math.fmod(self.music_location, 10))
  else
    status = self.ui.playing_animation(math.fmod(self.music_location, 10))
    self.ui.graphics:text(hud_x, hud_y, math.fmod(self.music_location, 4) + 1, 0)
  end
  
  self.ui.graphics:text(hud_x + 8, hud_y, status, 0)
  self.ui.graphics:bpm(hud_x-1, hud_y+25, params:get("BPM"), 0)
end









-- cell
function page:two()
  -- menu
  local y = ((self.selected_item - 1) * 8) + 11
  self.ui.graphics:rect(0, y, 51, 7, 2)
  self.ui.graphics:text(self.left_edge, 17, "STRUCTURE", 15)  

  -- panels
  self.ui.graphics:rect(54, 11, 88, 55)
  self.ui.graphics:panel_static()

  -- structure & port values  
  local temp_structure = params:get("TempStructure")
  local structure_x = 94
  local structure_y = 26
  local adjust = 0
  if temp_structure == 1 then
    self.ui.graphics:hive(structure_x, structure_y)
    self.ui.graphics:text(54 + 2, 17, "HIVE", 0)
    self.ui.graphics:text(self.left_edge, 25, "METABOLISM", self.ui.graphics.levels["h"])
    -- unused attributes by this structure
    self.ui.graphics:text(self.left_edge, 33, "SOUND", self.ui.graphics.levels["l"])
    self.ui.graphics:mls(0, 31, 51, 31, self.ui.graphics.levels["m"])
  elseif temp_structure == 2 then
    self.ui.graphics:gate(structure_x, structure_y)
    self.ui.graphics:text(54 + 2, 17, "GATE", 0)
    -- unused attributes by this structure
    self.ui.graphics:text(self.left_edge, 25, "METABOLISM", self.ui.graphics.levels["l"])
    self.ui.graphics:mls(0, 23, 51, 23, self.ui.graphics.levels["m"])
    self.ui.graphics:text(self.left_edge, 33, "SOUND", self.ui.graphics.levels["l"])
    self.ui.graphics:mls(0, 31, 51, 31, self.ui.graphics.levels["m"])
    adjust = -5
  elseif temp_structure == 3 then
    self.ui.graphics:shrine(structure_x, structure_y)
    self.ui.graphics:mls(0, 23, 51, 23, 2)
    self.ui.graphics:text(54 + 2, 17, "SHRINE", 0)
    self.ui.graphics:text(self.left_edge, 33, "SOUND", self.ui.graphics.levels["h"])
    -- unused attributes by this structure
    self.ui.graphics:text(self.left_edge, 25, "METABOLISM", self.ui.graphics.levels["l"])
    self.ui.graphics:mls(0, 23, 51, 23, self.ui.graphics.levels["m"])
  end

  self.ui.graphics:north_port(structure_x, structure_y, adjust)
  self.ui.graphics:east_port(structure_x, structure_y)
  self.ui.graphics:south_port(structure_x, structure_y)
  self.ui.graphics:west_port(structure_x, structure_y)

  -- remaining values
  self.ui.graphics:text(54 + 2, 25, params:get("TempMetabolism"), 0)
  self.ui.graphics:text(54 + 2, 33, page.dictionary.sounds[params:get("TempSound")], 0)
  self.ui.graphics:text(54 + 2, 55, "NESW", 0)
  self.ui.graphics:text(54 + 2, 63, "X16Y8", 0)


end




function page:three()
  self.ui.graphics:circle(64, 32, 16, 15)
  self.ui.graphics:circle(100, 24, 8, 15)
end



return page