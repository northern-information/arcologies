_arc = {}
_arc.device = arc.connect()

function _arc.init()
  _arc.orientation = 0
  _arc.bindings = {}
  _arc.encs = {{},{},{},{}}
  _arc.frame, _arc.slow_frame, _arc.rotate_frame = 0, 0, 0
  _arc.standby_up = true

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
  self.standby_up = (self.slow_frame % 5 == 1) and not self.standby_up or self.standby_up
end

function _arc:arc_redraw()
  for n = 1, 4 do
     local enc = self.encs[n]
     local style = enc.style_getter()
        if style == "divided"         then self:draw_divided_segment(enc)
    elseif style == "scaled"          then self:draw_scaled_segment(enc)
    elseif style == "glowing_segment" then self:draw_glowing_segment(enc)
    elseif style == "glowing_divided" then self:draw_glowing_divided(enc)
    elseif style == "glowing_compass" then self:draw_glowing_compass(enc)
    elseif style == "sweet_sixteen"   then self:draw_sweet_sixteen(enc)
    elseif style == "glowing_boolean" then self:draw_glowing_boolean(enc)
    elseif style == "glowing_clock"   then self:draw_glowing_clock(enc)
    elseif style == "standby"         then self:draw_standby(enc)
                                      else self:draw_standby(enc)
    end
  end
end

function _arc:draw_segment(n, segment)
  if segment.valid then
    _arc.device:segment(n, segment.from, segment.to, 15)
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
  if enc.style_getter() == "variable" then
print(enc.enc_id, enc.value, enc.sensitivity(), delta)
    value = enc.value + (enc.sensitivity() * delta)
    self.encs[enc.enc_id].value = util.clamp(value, enc.min_getter(), enc.max_getter())
    enc.value_setter(_arc:map_to_segment(enc))
  else
    if enc.wrap_getter() then
      value = fn.cycle(enc.value + (enc.sensitivity() * delta), enc.min_getter(), enc.max_getter())
    else
      value = enc.value + (enc.sensitivity() * delta)
    end
    self.encs[enc.enc_id].value = util.clamp(value, enc.min_getter(), enc.max_getter())
    enc.value_setter(_arc:map_to_segment(enc))
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

-- todo
function _arc:set_orientation(i)
  self.orientation = i
end



-- animations



function _arc:clear_ring(n)
  for i = 1, 64 do
    _arc.device:led(n, i, 0)
  end
end

function _arc:draw_sweet_sixteen(enc)
  self:clear_ring(enc.enc_id)
  for i = 1, enc.value do
    local convert_to_led = fn.round(util.linlin(0, 360, 1, 64, enc.style_offset()))
    local from =  fn.round(fn.over_cycle(convert_to_led + (4 * (i - 1)), 1, 64))
    local to = fn.round(from + 3)
    for x = from, to do
      local l = x == to and 3 or math.random(10, 15)
      _arc.device:led(enc.enc_id, x, l)
    end
  end
end

function _arc:draw_glowing_segment(enc)
  self:clear_ring(enc.enc_id)
  local style_max = util.linlin(1, 360, 1, 64, enc.style_max_getter())
  local segment_size = style_max / enc.max_getter()
  for i = 1, enc.value_getter() do
    local convert_to_led = util.linlin(0, 360, 1, 64, enc.style_offset())
    local from = fn.round(fn.over_cycle(convert_to_led + (segment_size * (i - 1)), 1, 64))
    local to = fn.round(from + segment_size)
    for x = from, to do
      _arc.device:led(enc.enc_id, x, math.random(10, 15))
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
    _arc.device:led(enc.enc_id, k, v)
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
    _arc.device:led(enc.enc_id, k, v)
  end
end

function _arc:draw_glowing_divided(enc)
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
  segment = self:validate_segment(segments[self:map_to_segment(enc)])
  if segment.valid then
    _arc.device:segment(enc.enc_id, segment.from, segment.to, math.random(10, 15))
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
  self:draw_segment(enc.enc_id, self:validate_segment(segments[self:map_to_segment(enc)]))
end

function _arc:draw_scaled_segment(enc)
  local max = (enc.style_max_getter() == 360) and 359.9 or enc.style_max_getter() -- compensate for circles, 0 == 360, etc.
  local from = enc.style_offset()
  local to = self:cycle_degrees(util.linlin(0, 360, 0, enc.style_max_getter(), self:scale_to_degrees(enc)) + enc.style_offset())
  local segment = {}
  segment.from = self:degs_to_rads(from, enc.snap_getter())
  segment.to = self:degs_to_rads(to, enc.snap_getter())
  self:draw_segment(enc.enc_id, self:validate_segment(segment))
end

function _arc:draw_glowing_clock(enc)
  local ring = {}
  for i = 1, 64 do ring[i] = 0 end
  local l = self.slow_frame % 5
  if self.standby_up then l = util.linlin(1, 5, 5, 1, l) end
  l = l + 10
    
  if enc.value == 0 then
    for i = 1, 10 do
      ring[i] = l - i
    end
    ring = fn.reverse_shift_table(ring, self.rotate_frame)
  else 
    for i = 1, 10 do
      ring[11 - i] = l - i
    end
    ring = fn.shift_table(ring, self.rotate_frame)
  end
  for k, v in pairs(ring) do    
    _arc.device:led(enc.enc_id, k, v)
  end
end

function _arc:draw_standby(enc)
  local ring = {}
  for i = 1, 64 do ring[i] = 0 end
  local l = self.slow_frame % 5
  if self.standby_up then l = util.linlin(1, 5, 5, 1, l) end
  ring[1], ring[17], ring[33], ring[49] = l, l, l, l
  ring = fn.reverse_shift_table(ring, self.rotate_frame)
  for k, v in pairs(ring) do    
    _arc.device:led(enc.enc_id, k, v)
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
    return d * (3.14 / 180)
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
    max_getter         = function()  return page:get_page_count() end,
    min_getter         = function()  return 1 end,
    offset_getter      = function()  return 240 end,
    sensitivity_getter = function()  return .05 end,
    snap_getter        = function()  return true end,
    style_getter       = function()  return "divided" end,
    style_max_getter   = function()  return 240 end,
    value_getter       = function()  return page.active_page end,
    value_setter       = function(x) page:select(x) end,
    wrap_getter        = function()  return false end,
  })
  _arc:register_binding({
    binding_id         = "norns_e2",
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
end

function _arc:bind(n, binding_id)
  if init_done ~= true then return end -- the rest of arcologies needs to load before _arc.lua
  self:init_enc({
    value            = 0,
    binding_id       = binding_id,
    enc_id           = n,
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