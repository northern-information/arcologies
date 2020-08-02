local page = {}

function page.init()
  page.active_page = 1
  page_items = {}
  page_items[1] = 2
  page_items[2] = 4
  page_items[3] = 4
  page_items[4] = 6
  page_items[5] = 4
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
    else
      print('not yet implemented')
    end

-- structures
  elseif p == 2 then
    print('not yet implemented')

  elseif p == 3 then
    print('not yet implemented')

  -- settings
  elseif p == 4 then
    if s == 1 then
      params:set("Arbitrary1", util.clamp(params:get("Arbitrary1") + d, 0, 1000))
    elseif s == 2 then
      params:set("Arbitrary2", util.clamp(params:get("Arbitrary2") + d, 0, 1000))
    elseif s == 3 then
      params:set("Arbitrary3", util.clamp(params:get("Arbitrary3") + d, 0, 1000))
    elseif s == 4 then
      params:set("Arbitrary4", util.clamp(params:get("Arbitrary4") + d, 0, 1000))
    elseif s == 5 then
      params:set("Arbitrary5", util.clamp(params:get("Arbitrary5") + d, 0, 1000))
    elseif s == 6 then
      params:set("Arbitrary6", util.clamp(params:get("Arbitrary6") + d, 0, 1000))
    else
      print('not yet implemented')
    end
  elseif p == 5 then
    print('not yet implemented')
  else
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
  elseif i == 4 then
    self:four()
  elseif i == 5 then
    self:five()
  else
    print('not yet implemented')
  end
end

-- swiss
-- self.ui.graphics:rect(0, 11, 40, 55)
-- self.ui.graphics:rect(44, 11, 40, 55)
-- self.ui.graphics:rect(88, 11, 40, 55)  

function page:two()
  -- item menu
  local y = ((self.selected_item - 1) * 8) + 13
  self.ui.graphics:rect(88, 11, 40, 55)
  self.ui.graphics:rect(88, y, 39, 9, 0)
  self.ui.graphics:rect(84, y + 4, 6, 1, 15)
  menu_status = params:get("Status") == 0 and "READY" or "PLAYING"
  if self.selected_item == 1 then 
    self.ui.graphics:text_right(self.right_edge, 20, menu_status, 15)  
    self.ui.graphics:text_right(self.right_edge, 28, "BPM", 0)
  else
    self.ui.graphics:text_right(self.right_edge, 20, menu_status, 0)  
    self.ui.graphics:text_right(self.right_edge, 28, "BPM", 15)
  end

  -- values
  local status
  if params:get("Status") == 0 then 
    status = self.ui.ready_animation(math.fmod(self.music_location, 10))
  else
    status = self.ui.playing_animation(math.fmod(self.music_location, 10))
  end
  self.ui.graphics:bpm(self.left_edge, 56, params:get("BPM"))
  self.ui.graphics:text(self.left_edge, 32, math.fmod(self.music_location, 4) + 1, 15)
  self.ui.graphics:text(self.left_edge + 8, 32, status)  
end

function page:one()
  self.ui.graphics:cell(5, 20)
end

function page:three()
  self.ui.graphics:hive(5, 20)
end

function page:four()
  local y = ((self.selected_item - 1) * 8) + 14
  self.ui.graphics:rect(3, y, self.right_edge, 7, 2)
  for i = 1,6 do
    local param = "Arbitrary" .. i
    local yi = ((i - 1) * 8) + page.rows_start
    self.ui.graphics:text(self.left_edge, yi, param)
    self.ui.graphics:text_right(self.right_edge, yi, params:get(param))
  end
end

function page:five()
  self.ui.graphics:shrine(5, 20)
end

return page