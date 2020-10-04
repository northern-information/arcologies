_arc = {}
_arc.device = arc.connect()

function _arc.init()
  _arc.orientation = 0
  _arc.bindings = {}
  _arc.encs = {{},{},{},{}}

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
      -- fn.dirty_arc(false)
    end
    clock.sleep(1/30)
  end
end

function _arc:arc_redraw()
  for n = 1, 4 do
     local enc = self.encs[n]
     local style = (enc.style == "variable" and enc.binding_id == "norns_e3") and menu:adaptor("style") or enc.style
        if style == "divided"         then self:draw_divided_segment(enc)
    elseif style == "scaled"          then self:draw_scaled_segment(enc)
    elseif style == "glowing_segment" then self:draw_glowing_segment(enc)
    elseif style == "glowing_divided" then self:draw_glowing_divided(enc)
    elseif style == "sweet_sixteen"   then self:draw_sweet_sixteen(enc)
    elseif style == "glowing_boolean" then self:draw_glowing_boolean(enc)
    elseif style == "standby"         then print("todo standby")
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
  if enc.style == "variable" then
print(enc.enc_id, enc.value, enc.sensitivity(), delta)
    value = enc.value + (enc.sensitivity() * delta)
    self.encs[enc.enc_id].value = util.clamp(value, enc.min(), enc.max())
    enc.value_setter(_arc:map_to_segment(enc))
  else
    if enc.style_wrap then
      value = fn.cycle(enc.value + (enc.sensitivity() * delta), enc.min(), enc.max())
    else
      value = enc.value + (enc.sensitivity() * delta)
    end
    self.encs[enc.enc_id].value = util.clamp(value, enc.min(), enc.max())
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
  local segment_size = 64 / enc.max_getter()
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

function fn.shift_table(t, shift_amount)
  for i = 1, shift_amount do
    local last_value = t[#t]
    table.insert(t, 1, last_value)
    table.remove(t, #t)
  end
  return t
end

function _arc:draw_glowing_divided(enc)
  self:clear_ring(enc.enc_id)
  local segment_size = enc.style_max / enc.max()
  local segments = {}
  for i = 1, enc.max() do
    local from_raw = enc.style_offset() + (segment_size * (i - 1))
    local from = self:cycle_degrees(from_raw)
    local to =  self:cycle_degrees(from_raw + segment_size)
    segments[i] = {}
    segments[i].from = self:degs_to_rads(from, enc.style_snap)
    segments[i].to = self:degs_to_rads(to, enc.style_snap)
  end
  segment = self:validate_segment(segments[self:map_to_segment(enc)])
  if segment.valid then
    _arc.device:segment(enc.enc_id, segment.from, segment.to, math.random(10, 15))
  end
end

function _arc:draw_divided_segment(enc)
  self:clear_ring(enc.enc_id)
  local segment_size = enc.style_max / enc.max()
  local segments = {}
  for i = 1, enc.max() do
    local from_raw = enc.style_offset() + (segment_size * (i - 1))
    local from = self:cycle_degrees(from_raw)
    local to =  self:cycle_degrees(from_raw + segment_size)
    segments[i] = {}
    segments[i].from = self:degs_to_rads(from, enc.style_snap)
    segments[i].to = self:degs_to_rads(to, enc.style_snap)
  end
  self:draw_segment(enc.enc_id, self:validate_segment(segments[self:map_to_segment(enc)]))
end

function _arc:draw_scaled_segment(enc)
  local max = (enc.style_max == 360) and 359.9 or enc.style_max -- compensate for circles, 0 == 360, etc.
  local from = enc.style_offset()
  local to = self:cycle_degrees(util.linlin(0, 360, 0, enc.style_max, self:scale_to_degrees(enc)) + enc.style_offset())
  local segment = {}
  segment.from = self:degs_to_rads(from, enc.style_snap)
  segment.to = self:degs_to_rads(to, enc.style_snap)
  self:draw_segment(enc.enc_id, self:validate_segment(segment))
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
  local segment_size = 360 / enc.max()
  local test = util.linlin(enc.min(), enc.max(), 0, 360, enc.value)
  if enc.value == 0 and enc.min() == 0 then
    return 0
  elseif test == 360 then -- compensate for circles, 0 == 360, etc.
    return enc.max()
  else
    local match = 1
    for i = 1, enc.max() do
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
  return util.linlin(enc.min(), enc.max(), 0, 360, enc.value)
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
    enc_id         = args.enc_id,
    binding_id     = args.binding_id,
    value          = args.value,
    min            = args.min,
    max            = args.max,
    value_getter   = args.value_getter,
    value_setter   = args.value_setter,
    min_getter     = args.min_getter,
    max_getter     = args.max_getter,
    sensitivity    = args.sensitivity,
    style_wrap     = args.style_wrap,
    style          = args.style,
    style_wrap     = args.style_wrap,
    style_max      = args.style_max,
    style_offset   = args.style_offset,
    style_snap     = args.style_snap,
    takeover       = false,
    takeover_clock = nil
  }
end

-- make available a binding
function _arc:register_binding(args)
  self.bindings[args.binding_id] = {
    binding_id         = args.binding_id,
    value_getter       = args.value_getter,
    value_setter       = args.value_setter,
    min_getter         = args.min_getter,
    max_getter         = args.max_getter,
    sensitivity_getter = args.sensitivity_getter,
    offset_getter      = args.offset_getter
  }
end

-- configure each available binding
function _arc:register_all_available_bindings()
  _arc:register_binding({
    binding_id         = "norns_e1",
    value_setter       = function(x) page:select(x) end,
    value_getter       = function()  return page.active_page end,
    min_getter         = function()  return 1 end,
    max_getter         = function()  return page:get_page_count() end,
    sensitivity_getter = function()  return .05 end,
    offset_getter      = function()  return 240 end

  })
  _arc:register_binding({
    binding_id         = "norns_e2",
    value_setter       = function(x) menu:select_item(x) end,
    value_getter       = function()  return menu:get_selected_item() end,
    min_getter         = function()  return menu:get_item_count_minimum() end,
    max_getter         = function()  return menu:get_item_count() end,
    sensitivity_getter = function()  return .02 end,
    offset_getter      = function()  return 240 end

  })
  _arc:register_binding({
    binding_id         = "norns_e3",
    value_setter       = function(x) menu:adaptor("value_setter", x) end,
    value_getter       = function()  return menu:adaptor("value_getter") end,
    min_getter         = function()  return menu:adaptor("min") end,
    max_getter         = function()  return menu:adaptor("max") end,
    sensitivity_getter = function()  return menu:adaptor("sensitivity") end,
    offset_getter      = function()  return menu:adaptor("offset") end
  })
  _arc:register_binding({
    binding_id         = "bpm",
    value_getter       = menu.arc_styles.BPM.value_getter,
    value_setter       = menu.arc_styles.BPM.value_setter,
    min_getter         = function() return menu.arc_styles.BPM.min end,
    max_getter         = function() return menu.arc_styles.BPM.max end,
    sensitivity_getter = function() return menu.arc_styles.BPM.sensitivity end,
    offset_getter      = function() return menu.arc_styles.BPM.offset end
  })
end

function _arc:bind(n, binding_id)
  if init_done ~= true then return end -- the rest of arcologies needs to load before _arc.lua
  local match = false
  local b = {
    enc_id        = n,
    binding_id    = binding_id,
    value         = 0,
    min           = self.bindings[binding_id].min_getter,
    max           = self.bindings[binding_id].max_getter,
    value_getter  = self.bindings[binding_id].value_getter,
    value_setter  = self.bindings[binding_id].value_setter,
    min_getter    = self.bindings[binding_id].min_getter,
    max_getter    = self.bindings[binding_id].max_getter,
    sensitivity   = self.bindings[binding_id].sensitivity_getter,
    style         = "divided",
    style_offset  = self.bindings[binding_id].offset_getter,
    style_wrap    = false,
    style_max     = 360,
    style_snap    = false
  }

  if binding_id == "norns_e1" or binding_id == "norns_e2" then
    match = true
    b["value"]        = 1
    b["style_max"]    = 240
    b["style_snap"]   = true

  elseif binding_id == "norns_e3" then
    match = true
    b["style"] = "variable"

  elseif binding_id == "bpm" then
    match = true
    b["style"] = menu.arc_styles.BPM.style

  end
  
  if match then
    self:init_enc(b)
    fn.dirty_arc(true)
  end
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