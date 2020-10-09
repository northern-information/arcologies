_arc = {}
_arc.device = arc.connect()

function _arc.init()
  _arc.orientation = 0
  _arc.bindings = {}
  _arc.encs = {{},{},{},{}}
  _arc.frame, _arc.slow_frame, _arc.rotate_frame, _arc.topography_frame = 0, 0, 0, 0
  _arc.standby_up = true
  _arc.glowing_endless_up = true
  _arc.glowing_endless_cache = 1
  _arc.glowing_endless_position = 1
  _arc.glowing_endless_key = nil
  _arc.drift_direction_up = true
  _arc.structure_popup_active = false
  _arc.structure_going_up = nil
  _arc.note_popup_active = false
  _arc.note_going_up = nil

  -- each also needs to be setup in config.arc_bindings to make available to paramters.lua!
  _arc:register_all_available_bindings()

  -- bind each encoder to what the user has specified
  for n = 1, 4 do 
    _arc:bind(n, config.arc_bindings[params:get("arc_encoder_" .. n)].id)
  end

  fn.dirty_arc(true)
end

function _arc.arc_redraw_clock()
  while true do
    if fn.dirty_arc() then
      _arc:refresh_values()
      _arc:arc_redraw()
      _arc.device:refresh()
      -- fn.dirty_arc(false) -- disabled for the sparkly animations
      _arc:increment_frames()
    end
    clock.sleep(1/30)
  end
end

function _arc:increment_frames()
  self.frame = self.frame + 1
  self.slow_frame = (self.frame % 2 == 1) and self.slow_frame + 1 or self.slow_frame
  self.rotate_frame = (self.slow_frame % 64) == 0 and 64 or self.slow_frame % 64
  self.topography_frame = (self.slow_frame % 21) == 0 and 21 or self.slow_frame % 21
  self.standby_up = (self.slow_frame % 5 == 1) and not self.standby_up or self.standby_up
  if self.frame % (math.random(1, 2) == 1 and 32 or 64) == 1 then
    self.drift_direction_up = not self.drift_direction_up
  end
end

function arc.delta(n, delta)
  -- this only works after the rest of arcologies loads
  if not init_done then return end

  -- which enc are we operating on
  local enc = _arc.encs[n]

  -- end the clock for this encoder
  if enc.takeover_clock ~= nil then
    enc.takeover = false
    clock.cancel(enc.takeover_clock)
    enc.takeover_clock = nil
  end

  -- run the deltas
  _arc:run_delta(enc, delta)

  -- duplicate bindings are possible
  _arc:refresh_duplicate_bindings(enc)

  -- things done changed
  fn.dirty_arc(true)
  screen.ping()

  -- start the clock for this encoder
    if enc.takeover_clock == nil then
      _arc.encs[n].takeover = true
      enc.takeover_clock = clock.run(_arc.enc_wait, n)
    end
end

function _arc:run_delta(enc, delta)
  local value = 0

  if enc.style_getter() == "glowing_endless" then
    self:set_glowing_endless_up(delta > 0)
    value = fn.cycle(enc.value + (enc.sensitivity() * delta), enc.min_getter(), enc.max_getter() + 1)
    self.encs[enc.enc_id].value = util.clamp(value, enc.min_getter(), enc.max_getter() + 1)
    enc.value_setter(math.floor(self.encs[enc.enc_id].value))



  elseif enc.style_getter() == "glowing_fulcrum" then
    value = enc.value + (enc.sensitivity() * delta)
    self.encs[enc.enc_id].value = util.clamp(value, enc.min_getter(), enc.max_getter())
    enc.value_setter(math.floor(fn.round(self.encs[enc.enc_id].value)))



  elseif enc.style_getter() == "glowing_structure" then
    local going_up = delta > 0
    if self.structure_going_up ~= going_up then
      self.structure_going_up = going_up
    end
    -- this uses the value_cache instead of the value
    value_cache = enc.value_cache + (enc.sensitivity() * delta)
    self.encs[enc.enc_id].value_cache = util.clamp(value_cache, enc.min_getter(), enc.max_getter())
    local popup_delta = 0
    if math.floor(value_cache) ~= popup:get_cached_index() then 
      popup_delta = going_up and 1 or -1
    end
    popup:launch("structure", popup_delta, "arc", enc.enc_id)



  elseif enc.style_getter() == "glowing_note" then
    local going_up = delta > 0
    if self.note_going_up ~= going_up then
      self.note_going_up = going_up
    end 
    value = enc.value + (enc.sensitivity() * delta)
    self.encs[enc.enc_id].value = value
    local popup_delta = 0
    if going_up and math.floor(value) ~= enc.value_cache then 
      popup_delta = 1
    elseif not going_up and math.ceil(value) ~= enc.value_cache then
      popup_delta = -1
    end
    popup:launch("note", popup_delta, "arc", enc.enc_id, enc.extras().note_number)



  else
    if enc.style_getter() ~= "variable" and enc.wrap_getter() then
      value = fn.cycle(enc.value + (enc.sensitivity() * delta), enc.min_getter(), enc.max_getter())
    else
      value = enc.value + (enc.sensitivity() * delta)
    end
    self.encs[enc.enc_id].value = util.clamp(value, enc.min_getter(), enc.max_getter())
    enc.value_setter(self:map_to_segment(enc))
  end



end

function _arc.enc_wait(n)
  clock.sleep(.1)
  _arc.encs[n].takeover = false
end

function _arc:refresh_values()
  for n = 1, 4 do
    if not self.encs[n].takeover then
      self.encs[n].value = self.encs[n].value_getter()
    end
  end
end

function _arc:set_orientation(i)
  self.orientation = i
end

function _arc:set_glowing_endless_up(bool)
  self.glowing_endless_up = bool
end

function _arc:reset_glowing_endless()
  self.glowing_endless_up = true
  self.glowing_endless_cache = 1
  self.glowing_endless_position = 1
  self.glowing_endless_key = nil
end

function _arc:arc_redraw()
  for n = 1, 4 do
     local enc = self.encs[n]
     local s = enc.style_getter()
        if s == "divided"            then self:draw_divided_segment(enc)
    elseif s == "glowing_boolean"    then self:draw_glowing_boolean(enc)
    elseif s == "glowing_clock"      then self:draw_glowing_clock(enc)
    elseif s == "glowing_compass"    then self:draw_glowing_compass(enc)
    elseif s == "glowing_divided"    then self:draw_glowing_divided(enc)
    elseif s == "glowing_drift"      then self:draw_glowing_drift(enc)
    elseif s == "glowing_endless"    then self:draw_glowing_endless(enc)
    elseif s == "glowing_fulcrum"    then self:draw_glowing_fulcrum(enc)
    elseif s == "glowing_note"       then self:draw_glowing_note(enc)
    elseif s == "glowing_range"      then self:draw_glowing_range(enc)    
    elseif s == "glowing_segment"    then self:draw_glowing_segment(enc)
    elseif s == "glowing_structure"  then self:draw_glowing_structure(enc)
    elseif s == "glowing_territory"  then self:draw_glowing_territory(enc)
    elseif s == "glowing_topography" then self:draw_glowing_topography(enc)
    elseif s == "scaled"             then self:draw_scaled_segment(enc)
    elseif s == "sweet_sixteen"      then self:draw_sweet_sixteen(enc)    
    elseif s == "standby"            then self:draw_standby(enc)
                                     else self:draw_standby(enc)
    end
  end
end

function _arc:draw_segment(n, segment, level)
  if segment.valid then
    local adjusted_from = self:get_orientation_adjusted_radian(segment.from)
    local adjusted_to = self:get_orientation_adjusted_radian(segment.to)
    self.device:segment(n, adjusted_from, adjusted_to, 15)
  end
end

function _arc:get_orientation_adjusted_radian(value)
  return fn.over_cycle(self:degs_to_rads(self.orientation) + value, 0, 2 * math.pi)
end

function _arc:draw_led(n, led, level)
  self.device:led(n, self:get_orientation_adjusted_led(led), level)
end

function _arc:get_orientation_adjusted_led(value)
  return fn.over_cycle(util.linlin(0, 360, 0, 64, self.orientation) + value, 0, 64)
end



-- animations



function _arc:clear_ring(n)
  for i = 1, 64 do _arc.device:led(n, i, 0) end
end


function _arc:draw_glowing_structure(enc)
  self:clear_ring(enc.enc_id)
  if not self.structure_popup_active then
    local ring = {}
    for i = 1, 3 do
      local m = (i - 1) * 22
        ring[m + 1] = 1
        ring[m + 2] = 1
        ring[m + 3] = 2
        ring[m + 4] = 3
        ring[m + 5] = 5
        ring[m + 6] = 8
        ring[m + 7] = 13
        ring[m + 8] = 2
        ring[m + 9] = math.random(10,15)
        ring[m + 10] = 2
        ring[m + 11] = 13
        ring[m + 12] = 8
        ring[m + 13] = 5
        ring[m + 14] = 3
        ring[m + 15] = 2
        ring[m + 16] = 1
        ring[m + 17] = 1
        ring[m + 18] = 0
        ring[m + 19] = 0
        ring[m + 20] = 0
        ring[m + 21] = 0
        ring[m + 22] = 0
    end
    ring = fn.shift_table(ring, 2)
    for k, v in pairs(ring) do    
      self:draw_led(enc.enc_id, k, v)
    end
  else
    local style_max = util.linlin(1, 360, 1, 64, enc.style_max_getter())
    local segment_size = style_max / enc.max_getter()
    local segments = {}
    local cached_index = popup:get_cached_index()
    for i = 1, cached_index do
      local convert_to_led = util.linlin(0, 360, 1, 64, enc.style_offset())
      segments[i] = {}
      segments[i].from = fn.round(fn.over_cycle(convert_to_led + (segment_size * (i - 1)), 1, 64))
      segments[i].to = fn.round(segments[i].from + segment_size)
    end
    for x = segments[cached_index].from, segments[cached_index].to do
      self:draw_led(enc.enc_id, x, math.random(10, 15))
    end
  end
end

function _arc:draw_divided_segment(enc)
  self:clear_ring(enc.enc_id)
  local segment_size = enc.style_max_getter() / enc.max_getter()
  local segments = {}
  for i = 1, enc.max_getter() do
    local from_raw = enc.style_offset() + (segment_size * (i - 1))
    local from = self:cycle_degrees(from_raw)
    local to =  self:cycle_degrees(from_raw + segment_size)
    segments[i] = {}
    segments[i].from = self:degs_to_rads(from, enc.snap_getter())
    segments[i].to = self:degs_to_rads(to, enc.snap_getter())
  end
  self:draw_segment(enc.enc_id, self:validate_segment(segments[self:map_to_segment(enc)]), 15)
end

function _arc:draw_scaled_segment(enc)
  local max = (enc.style_max_getter() == 360) and 359.9 or enc.style_max_getter() -- compensate for circles, 0 == 360, etc.
  local from = enc.style_offset()
  local to = self:cycle_degrees(util.linlin(0, 360, 0, enc.style_max_getter(), self:scale_to_degrees(enc)) + enc.style_offset())
  local segment = {}
  segment.from = self:degs_to_rads(from, enc.snap_getter())
  segment.to = self:degs_to_rads(to, enc.snap_getter())
  self:draw_segment(enc.enc_id, self:validate_segment(segment), 15)
end

function _arc:draw_glowing_note(enc)
  self:clear_ring(enc.enc_id)
  if self.note_popup_active then
    local value = musicutil.note_num_to_name(enc.value_getter())
    local segments = {}
    segments[1]  = { key = "C",    position = 1,   color = "white" }
    segments[2]  = { key = "C Y",  position = 6,   color = "black" }
    segments[3]  = { key = "D",    position = 11,  color = "white" }
    segments[4]  = { key = "D Y",  position = 16,  color = "black" }
    segments[5]  = { key = "E",    position = 21,  color = "white" }
    segments[6]  = { key = "F",    position = 26,  color = "white" }
    segments[7]  = { key = "F Y",  position = 31,  color = "black" }
    segments[8]  = { key = "G",    position = 36,  color = "white" }
    segments[9]  = { key = "G Y",  position = 41,  color = "black" }
    segments[10] = { key = "A",    position = 46,  color = "white" }
    segments[11] = { key = "A Y",  position = 51,  color = "black" }
    segments[12] = { key = "B",    position = 56,  color = "white" }
    local draw = {}
    local index = 1
    local led = 0
    for k, v in pairs(segments) do
      -- each segment is 5 leds total
      for i = 1, 5 do    
        -- 5s are the margins
        if i == 5 then
          led = 0
        -- this is the selected note
        elseif v.key == value then
          led = math.random(10, 15)
        -- this is an unselected white or black key
        else
          led = v.color == "white" and 5 or 2
        end
        draw[index] = led
        index = index + 1
      end
    end
    draw[61] = 0
    draw[62] = 0
    draw[63] = 0
    draw[64] = 0
    draw = fn.shift_table(draw, 35)
    for k, v in pairs(draw) do
      self:draw_led(enc.enc_id, k, v)
    end
  else
    local value = enc.value_getter() == 0 and 1 or enc.value_getter() -- 0 will become "mute" one day
    value = fn.round(util.linlin(1, 127, 1, enc.max_getter(), value)) -- adjust for the scale
    local style_max = util.linlin(1, 360, 1, 64, enc.style_max_getter())
    local segment_size = style_max / enc.max_getter()
    local segments = {}
    for i = 1, value do
      local convert_to_led = util.linlin(0, 360, 1, 64, enc.style_offset())
      segments[i] = {}
      segments[i].from = fn.round(fn.over_cycle(convert_to_led + (segment_size * (i - 1)), 1, 64))
      segments[i].to = fn.round(segments[i].from + segment_size)
    end
    for x = segments[value].from, segments[value].to do
      self:draw_led(enc.enc_id, x, math.random(10, 15))
    end
    self:draw_led(enc.enc_id, segments[value].from - 2, math.random(1, 3))
    self:draw_led(enc.enc_id, segments[value].from - 1, math.random(2, 4))
    self:draw_led(enc.enc_id, segments[value].to + 1, math.random(2, 4))
    self:draw_led(enc.enc_id, segments[value].to + 2, math.random(1, 3))
  end
end

function _arc:draw_glowing_divided(enc)
  if enc.value_getter() > 0 then
    self:clear_ring(enc.enc_id)
    local style_max = util.linlin(1, 360, 1, 64, enc.style_max_getter())
    local segment_size = style_max / enc.max_getter()
    local segments = {}
    for i = 1, enc.value_getter() do
      local convert_to_led = util.linlin(0, 360, 1, 64, enc.style_offset())
      segments[i] = {}
      segments[i].from = fn.round(fn.over_cycle(convert_to_led + (segment_size * (i - 1)), 1, 64))
      segments[i].to = fn.round(segments[i].from + segment_size)
    end
    for x = segments[enc.value_getter()].from, segments[enc.value_getter()].to do
      self:draw_led(enc.enc_id, x, math.random(10, 15))
    end
  else
    self:draw_standby(enc)
  end
end

function _arc:draw_glowing_segment(enc)
  self:clear_ring(enc.enc_id)
  if enc.value_getter() == 0 then
    self:draw_led(enc.enc_id, fn.round(util.linlin(0, 360, 1, 64, enc.style_offset())), math.random(10, 15))
  else
    local style_max = util.linlin(1, 360, 1, 64, enc.style_max_getter())
    local segment_size = style_max / enc.max_getter()
    for i = 1, enc.value_getter() do
      local convert_to_led = util.linlin(0, 360, 1, 64, enc.style_offset())
      local from = fn.round(fn.over_cycle(convert_to_led + (segment_size * (i - 1)), 1, 64))
      local to = fn.round(from + segment_size)
      for x = from, to do
        self:draw_led(enc.enc_id, x, math.random(10, 15))
      end
    end
  end
end

function _arc:draw_glowing_range(enc)
  -- only works for selected cells for now
  -- there are no global attributes that use range and are mappable
  if not keeper.is_cell_selected then return end
  self:clear_ring(enc.enc_id)
  local from = keeper.selected_cell.arc_styles["RANGE MIN"].value_getter(keeper.selected_cell)
  local to = keeper.selected_cell.arc_styles["RANGE MAX"].value_getter(keeper.selected_cell)
  local style_max = util.linlin(1, 360, 1, 64, enc.style_max_getter())
  local from_led = fn.round(util.linlin(0, 100, 1, style_max, from))
  local to_led = fn.round(util.linlin(0, 100, 1, style_max, to))
  local ring = {}
  for i = 1, 64 do
     ring[i] = (i >= from_led) and (i <= to_led) and math.random(10, 15) or 0
  end
  ring = fn.shift_table(ring, util.linlin(0, 360, 1, 64, enc.style_offset()))
  for k, v in pairs(ring) do    
    self:draw_led(enc.enc_id, k, v)
  end
end


function _arc:draw_glowing_fulcrum(enc)
  self:clear_ring(enc.enc_id)
  if enc.value_getter() == 0 then
    self:draw_led(enc.enc_id, 63, 3)
    self:draw_led(enc.enc_id, 64, 5)
    self:draw_led(enc.enc_id, 2, 5)
    self:draw_led(enc.enc_id, 3, 3)
  else
    local style_max = util.linlin(1, 360, 1, 64, enc.style_max_getter()) / 2
    local segment_size = style_max / enc.max_getter() * math.abs(enc.value_getter())
    local ring = {}
    for i = 1, 64 do
      ring[i] = (i < segment_size) and math.random(10, 15) or 0
    end
    if enc.value_getter() < 0 then
      ring[64] = 5
      ring[63] = 3
      ring = fn.shift_table(ring, 64 + math.ceil(segment_size * -1))
    else
      ring[math.floor(segment_size) + 1] = 5
      ring[math.floor(segment_size) + 2] = 3
    end
    for k, v in pairs(ring) do    
      self:draw_led(enc.enc_id, k, v)
    end   
  end
  self:draw_led(enc.enc_id, 1, math.random(10, 15))
end

function _arc:draw_glowing_endless(enc)
  self:clear_ring(enc.enc_id)
  if self.glowing_endless_key ~= enc.key_getter() then
    self:reset_glowing_endless()      
    self.glowing_endless_key = enc.key_getter()
    self.glowing_endless_position = math.random(1, 8)
  end
  local ring = {}
  for i = 1, 64 do
    ring[i] = (i > 2 and i < 9) and math.random(10, 15) or 0
  end
  ring[2], ring[9] = 5, 5
  ring[1], ring[10] = 3, 3
  if self.glowing_endless_cache ~= math.floor(enc.value) then
    self.glowing_endless_cache = math.floor(enc.value)
    local direction = self.glowing_endless_up and 1 or -1
    self.glowing_endless_position = fn.cycle(self.glowing_endless_position + direction, 1, 8)
  end
  ring = fn.shift_table(ring, self.glowing_endless_position * 8)
  for k, v in pairs(ring) do    
    self:draw_led(enc.enc_id, k, v)
  end
end

function _arc:draw_sweet_sixteen(enc)
  self:clear_ring(enc.enc_id)
  if enc.value_getter() == 0 then
    self:draw_led(enc.enc_id, fn.round(util.linlin(0, 360, 1, 64, enc.style_offset())), math.random(10, 15))
  else
    for i = 1, enc.value_getter() do
      local convert_to_led = fn.round(util.linlin(0, 360, 1, 64, enc.style_offset()))
      local from =  fn.round(fn.over_cycle(convert_to_led + (4 * (i - 1)), 1, 64))
      local to = fn.round(from + 3)
      for x = from, to do
        local l = x == to and 3 or math.random(10, 15)
        self:draw_led(enc.enc_id, x, l)
      end
    end
  end
end

function _arc:draw_glowing_boolean(enc)
  self:clear_ring(enc.enc_id)
  local ring = {}
  for i = 1, 64 do
    if enc.value_getter() == 0 and i > 33 then
      ring[i] = math.random(2, 5)
    elseif enc.value_getter() == 1 and i <= 33 then
      ring[i] = math.random(5, 15)
    else
      ring[i] = 0
    end
  end
  local shift_amount = fn.round(util.linlin(0, 360, 1, 64, enc.style_offset()))
  ring = fn.shift_table(ring, shift_amount)
  for k, v in pairs(ring) do    
    self:draw_led(enc.enc_id, k, v)
  end
end

function _arc:draw_glowing_drift(enc)
  self:clear_ring(enc.enc_id)
  local ring = {}
  -- 1 = north/south, 2 = east/west, 3 = ???
  for i = 1, 64 do
    if enc.value_getter() ~= 3 then
      ring[i] = ((i < 16) or (i > 33 and i < 48)) and math.random(10, 15) or 0
    else
      ring[i] = (i < 16) and math.random(10, 15) or 0
    end
  end  
  if enc.value_getter() ~= 3 then
    ring = fn.shift_table(ring, ((enc.value_getter() - 1) * 16))
  else
    if self.drift_direction_up then
      ring = fn.reverse_shift_table(ring, self.rotate_frame)
    else 
      ring = fn.shift_table(ring, self.rotate_frame)
    end
  end
  -- adjust for "compass"
  ring = fn.shift_table(ring, 57)
  for k, v in pairs(ring) do    
    self:draw_led(enc.enc_id, k, v)
  end
end

function _arc:draw_glowing_compass(enc)
  self:clear_ring(enc.enc_id)
  local ring = {}
  for i = 1, 64 do
    ring[i] = (i < 16) and math.random(10, 15) or 0
  end
  -- 1 = north, 2 = east, 3 = south, 4 = west
  ring = fn.shift_table(ring, ((enc.value_getter() - 1) * 16))
  -- adjust for "compass"
  ring = fn.shift_table(ring, 57)
  for k, v in pairs(ring) do    
    self:draw_led(enc.enc_id, k, v)
  end
end

function _arc:draw_glowing_territory(enc)
  self:clear_ring(enc.enc_id)
  local ring = {}
  local shift = 0
  -- 1 = north, 2 = east, 3 = south, 4 = west
  -- 5 = n/e, 6 = s/e, 7 = s/w, 8 = n/w
  -- 9 = all, 10 = fringes
  -- matching on strings is safer here
  local t = keeper.selected_cell:territory_menu_getter(enc.value_getter())
  if t == "NORTH" or t == "EAST" or t == "SOUTH" or t =="WEST" then
    for i = 1, 64 do
      ring[i] = (i < 16) and math.random(10, 15) or 0
    end
        if t == "NORTH" then shift = 0
    elseif t == "EAST"  then shift = 1
    elseif t == "SOUTH" then shift = 2
    elseif t == "WEST"  then shift = 3
    end
  elseif t == "N/E" or t == "S/E" or t == "S/W" or t =="N/W" then
    for i = 1, 64 do
      ring[i] = i <= 32 and math.random(10, 15) or 0
    end
        if t == "N/E" then shift = 0
    elseif t == "S/E" then shift = 1
    elseif t == "S/W" then shift = 2
    elseif t == "N/W" then shift = 3
    end
  elseif t == "ALL" then
    for i = 1, 64 do
      ring[i] = math.random(10, 15)
    end
  elseif t == "FRINGES" then
    for i = 1, 64 do
      ring[i] = (i <= 8 or 
                (i > 16 and i <= 24) or 
                (i > 32 and i <= 40) or 
                (i > 48 and i <= 56)) and math.random(10, 15) or 0
    end
    ring = fn.shift_table(ring, 11)
  end
  
  
  ring = fn.shift_table(ring, (shift * 16))
  -- adjust for "compass"
  ring = fn.shift_table(ring, 57)
  for k, v in pairs(ring) do    
    self:draw_led(enc.enc_id, k, v)
  end
end

function _arc:draw_glowing_clock(enc)
  local ring = {}
  for i = 1, 64 do ring[i] = 0 end
  local l = self.slow_frame % 5
  if self.standby_up then l = util.linlin(1, 5, 5, 1, l) end
  l = l + 10
  if enc.value == 0 then
    for i = 1, 10 do ring[i] = l - i end
    ring = fn.reverse_shift_table(ring, self.rotate_frame)
  else 
    for i = 1, 10 do ring[11 - i] = l - i end
    ring = fn.shift_table(ring, self.rotate_frame)
  end
  for k, v in pairs(ring) do    
    self:draw_led(enc.enc_id, k, v)
  end
end

function _arc:draw_glowing_topography(enc)
  -- 1 = clockwise, 2 = counterclockwise, 3 = pendulum, 4 = drunk
  local value = enc.value_getter()
  local ring = {}
  for i = 1, 64 do ring[i] = 0 end
  local l = self.slow_frame % 5
  if self.standby_up then l = util.linlin(1, 5, 5, 1, l) end
  l = l + 10
  if value == 1 then
    for i = 1, 10 do ring[11 - i] = l - i end
    ring = fn.shift_table(ring, self.rotate_frame)
  elseif value == 2 then
    for i = 1, 10 do ring[i] = l - i end
    ring = fn.reverse_shift_table(ring, self.rotate_frame)
  elseif value == 3 then
    ring[21 - self.topography_frame] = 15
    for i = 1, 10 do ring[21 - self.topography_frame + i] = 15 - i end
    ring[45 + self.topography_frame] = 15
    for i = 1, 10 do ring[45 + self.topography_frame - i] = 15 - i end
  elseif value == 4 then
    for i = 1, 64 do
      ring[i] = math.random(1, 8) == 1 and math.random(l) or 0
    end
  end
  for k, v in pairs(ring) do    
    self:draw_led(enc.enc_id, k, v)
  end
end

function _arc:draw_standby(enc)
  local ring = {}
  for i = 1, 64 do ring[i] = 0 end
  local l = self.slow_frame % 5
  if self.standby_up then l = util.linlin(1, 5, 5, 1, l) end
  ring[1], ring[21], ring[42] = l, l, l
  ring = fn.reverse_shift_table(ring, self.rotate_frame)
  for k, v in pairs(ring) do    
    self:draw_led(enc.enc_id, k, v)
  end
end

-- guard against race conditions
function _arc:validate_segment(segment)
  if segment ~= nil and segment.from ~= nil and segment.to ~= nil then
    segment.valid = true
    return segment
  else
    return { valid = false }
  end
end

function _arc:map_to_segment(enc)
  local segment_size = 360 / enc.max_getter()
  local test = util.linlin(enc.min_getter(), enc.max_getter(), 0, 360, enc.value)
  if enc.value == 0 and enc.min_getter() == 0 then
    return 0
  elseif test == 360 then -- compensate for circles, 0 == 360, etc.
    return enc.max_getter()
  else
    local match = 1
    for i = 1, enc.max_getter() do
        if (test >= segment_size * (i - 1)) and (test < segment_size * i) then
        match = i
      end
    end
    return match
  end
end



-- utilities



function _arc:scale_to_radians(enc)
  return self:degs_to_rads(self:scale_to_degrees(enc), false)
end

function _arc:scale_to_degrees(enc)
  return util.linlin(enc.min_getter(), enc.max_getter(), 0, 360, enc.value)
end

function _arc:degs_to_rads(d, snap)
    if snap then
      d = self:snap_degrees_to_leds(d)
    end
    return d * (math.pi / 180)
end

function _arc:rads_to_degs(r, snap)
    local d = r * (180 / math.pi)
    if snap then
      d = self:snap_degrees_to_leds(d)
    end
    return d
end

function _arc:set_structure_popup_active(bool)
  self.structure_popup_active = bool
end

function _arc:set_note_popup_active(bool)
  self.note_popup_active = bool
end

function _arc:set_note_value_and_cache(enc_id, new_note)
  self.encs[enc_id].value_cache = new_note
  self.encs[enc_id].value = new_note
end

-- to stop arc anti-aliasing
function _arc:snap_degrees_to_leds(d)
  return util.linlin(0, 64, 0, 360, math.ceil(util.linlin(0, 360, 0, 64, d)))
end

function _arc:cycle_degrees(d)
  if d > 360 then
    return self:cycle_degrees(d - 360)
  elseif d < 0 then
    return self:cycle_degrees(360 - d)
  else
    return d
  end
end



-- bindings



-- initialize an encoder to a specific binding
function _arc:init_enc(args)
  self.encs[args.enc_id] = {
    binding_id       = args.binding_id,
    enc_id           = args.enc_id,
    extras           = args.extras or {},
    key_getter       = args.key_getter,
    max_getter       = args.max_getter,
    min_getter       = args.min_getter,
    sensitivity      = args.sensitivity,
    style_getter     = args.style_getter,
    style_max_getter = args.style_max_getter,
    style_offset     = args.style_offset,
    snap_getter      = args.snap_getter,
    takeover         = false,
    takeover_clock   = nil,
    value            = args.value,
    value_cache      = args.value,
    value_getter     = args.value_getter,
    value_setter     = args.value_setter,
    wrap_getter      = args.wrap_getter,
  }
end

-- make available a binding
function _arc:register_binding(binding)
  self.bindings[binding.binding_id] = binding
end

-- configure each available binding
function _arc:register_all_available_bindings()
  _arc:register_binding({
    binding_id         = "norns_e1",
    key_getter         = function()  return "norns_e1" end,
    max_getter         = function()  return page:get_page_count() end,
    min_getter         = function()  return 1 end,
    offset_getter      = function()  return 240 end,
    sensitivity_getter = function()  return .01 end,
    snap_getter        = function()  return true end,
    style_getter       = function()  return "divided" end,
    style_max_getter   = function()  return 240 end,
    value_getter       = function()  return page.active_page end,
    value_setter       = function(x) if x ~= page.active_page then page:select(x) end end,
    wrap_getter        = function()  return false end,
  })
  _arc:register_binding({
    binding_id         = "norns_e2",
    key_getter         = function()  return "norns_e2" end,
    max_getter         = function()  return menu:get_item_count() end,
    min_getter         = function()  return menu:get_item_count_minimum() end,
    offset_getter      = function()  return 240 end,
    sensitivity_getter = function()  return .02 end,
    snap_getter        = function()  return true end,
    style_getter       = function()  return (menu:get_item_count_minimum() == 0) and "standby" or "divided" end,
    style_max_getter   = function()  return 240 end,
    value_getter       = function()  return menu:get_selected_item() end,
    value_setter       = function(x) menu:select_item(x) end,
    wrap_getter        = function()  return false end,
  })
  _arc:register_binding({
    binding_id         = "norns_e3",
    extras             = function()  return menu:adaptor("extras") end,
    key_getter         = function()  return menu:adaptor("key") end,
    max_getter         = function()  return menu:adaptor("max") end,
    min_getter         = function()  return menu:adaptor("min") end,
    offset_getter      = function()  return menu:adaptor("offset") end,
    sensitivity_getter = function()  return menu:adaptor("sensitivity") end,
    snap_getter        = function()  return menu:adaptor("snap_getter") end,
    style_getter       = function()  return menu:adaptor("style_getter") end,
    style_max_getter   = function()  return menu:adaptor("style_max_getter") end,
    value_getter       = function()  return menu:adaptor("value_getter") end,
    value_setter       = function(x) menu:adaptor("value_setter", x) end,
    wrap_getter        = function()  return menu:adaptor("wrap_getter") end,
  })
  _arc:register_binding({
    binding_id         = "bpm",
    key_getter         = function() return menu.arc_styles.BPM.key end,
    max_getter         = function() return menu.arc_styles.BPM.max end,
    min_getter         = function() return menu.arc_styles.BPM.min end,
    offset_getter      = function() return menu.arc_styles.BPM.offset end,
    sensitivity_getter = function() return menu.arc_styles.BPM.sensitivity end,
    snap_getter        = function() return menu.arc_styles.BPM.snap end,
    style_getter       = menu.arc_styles.BPM.style_getter,
    style_max_getter   = menu.arc_styles.BPM.style_max_getter,
    value_getter       = menu.arc_styles.BPM.value_getter,
    value_setter       = menu.arc_styles.BPM.value_setter,
    wrap_getter        = function() return menu.arc_styles.BPM.wrap end,
  })
  _arc:register_binding({
    binding_id         = "transpose",
    key_getter         = function() return menu.arc_styles.TRANSPOSE.key end,
    max_getter         = function() return menu.arc_styles.TRANSPOSE.max end,
    min_getter         = function() return menu.arc_styles.TRANSPOSE.min end,
    offset_getter      = function() return menu.arc_styles.TRANSPOSE.offset end,
    sensitivity_getter = function() return menu.arc_styles.TRANSPOSE.sensitivity end,
    snap_getter        = function() return menu.arc_styles.TRANSPOSE.snap end,
    style_getter       = menu.arc_styles.TRANSPOSE.style_getter,
    style_max_getter   = menu.arc_styles.TRANSPOSE.style_max_getter,
    value_getter       = menu.arc_styles.TRANSPOSE.value_getter,
    value_setter       = menu.arc_styles.TRANSPOSE.value_setter,
    wrap_getter        = function() return menu.arc_styles.TRANSPOSE.wrap end,
  })
  _arc:register_binding({
    binding_id         = "danger_zone_clock_sync",
    key_getter         = function() return menu.arc_styles.DANGER_ZONE_CLOCK_SYNC.key end,
    max_getter         = function() return menu.arc_styles.DANGER_ZONE_CLOCK_SYNC.max end,
    min_getter         = function() return menu.arc_styles.DANGER_ZONE_CLOCK_SYNC.min end,
    offset_getter      = function() return menu.arc_styles.DANGER_ZONE_CLOCK_SYNC.offset end,
    sensitivity_getter = function() return menu.arc_styles.DANGER_ZONE_CLOCK_SYNC.sensitivity end,
    snap_getter        = function() return menu.arc_styles.DANGER_ZONE_CLOCK_SYNC.snap end,
    style_getter       = menu.arc_styles.DANGER_ZONE_CLOCK_SYNC.style_getter,
    style_max_getter   = menu.arc_styles.DANGER_ZONE_CLOCK_SYNC.style_max_getter,
    value_getter       = menu.arc_styles.DANGER_ZONE_CLOCK_SYNC.value_getter,
    value_setter       = menu.arc_styles.DANGER_ZONE_CLOCK_SYNC.value_setter,
    wrap_getter        = function() return menu.arc_styles.DANGER_ZONE_CLOCK_SYNC.wrap end,
  })
  _arc:register_binding({
    binding_id         = "crypt_directory",
    key_getter         = function() return "CRYPT DIRECTORY" end,
    max_getter         = function() return filesystem.crypts_names ~= nil and #filesystem.crypts_names or 1 end,
    min_getter         = function() return 1 end,
    offset_getter      = function() return 240 end,
    sensitivity_getter = function() return .05 end,
    snap_getter        = function() return true end,
    style_getter       = function() return "glowing_divided" end,
    style_max_getter   = function() return 240 end,
    value_getter       = function() return filesystem:get_crypt_index() end,
    value_setter       = function(args) filesystem:set_crypt_from_arc(args) end,
    wrap_getter        = function() return false end,
  })
  _arc:register_binding({
    binding_id         = "browse_cells",
    key_getter         = function() return "BROWSE CELLS" end,
    max_getter         = function() return #keeper.cells > 0 and #keeper.cells or 0 end,
    min_getter         = function() return #keeper.cells > 0 and 1 or 0 end,
    offset_getter      = function() return 240 end,
    sensitivity_getter = function() return .05 end,
    snap_getter        = function() return true end,
    style_getter       = function() return "glowing_divided" end,
    style_max_getter   = function() return 240 end,
    value_getter       = function() return keeper:get_selected_cell_index() end,
    value_setter       = function(args) keeper:set_selected_cell_index(args) end,
    wrap_getter        = function() return false end,
  })
end

function _arc:bind(n, binding_id)
  if init_done ~= true then return end -- the rest of arcologies needs to load before _arc.lua
  self:init_enc({
    value            = 0,
    binding_id       = binding_id,
    enc_id           = n,
    extras           = self.bindings[binding_id].extras,
    key_getter       = self.bindings[binding_id].key_getter,
    max_getter       = self.bindings[binding_id].max_getter,
    min_getter       = self.bindings[binding_id].min_getter,
    sensitivity      = self.bindings[binding_id].sensitivity_getter,
    snap_getter      = self.bindings[binding_id].snap_getter,
    style_getter     = self.bindings[binding_id].style_getter,
    style_max_getter = self.bindings[binding_id].style_max_getter,
    style_offset     = self.bindings[binding_id].offset_getter,
    value_getter     = self.bindings[binding_id].value_getter,
    value_setter     = self.bindings[binding_id].value_setter,
    wrap_getter      = self.bindings[binding_id].wrap_getter,
  })
  fn.dirty_arc(true)
end

--[[
  if, for whatever reason, a user wants to bind the same value to multiple
  encoders we need to manually update these as the takeovers will
  prevent their values from being updated.

  todo - make sure this also works for norns_e3 situations (i.e. bpm is mapped to e4)
]]
function _arc:refresh_duplicate_bindings(enc)
  local duplicates = {}
  for n = 1, 4 do
    duplicates[n] = self.encs[n].binding_id == enc.binding_id and n ~= enc.enc_id
    for k, v in pairs(duplicates) do
      if v then
        self.encs[k].value = self.encs[n].value
      end
    end
  end
end


return _arc