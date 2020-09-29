_arc = {}
_arc.device = arc.connect()

function _arc.init()
  _arc.orientation = 0
  _arc.bindings = {}
  _arc.encs = {}
  _arc:reset_enc_counter()

  -- each also needs to be setup in config.arc_bindings to make available to paramters.lua!
  _arc:register_binding(
    "norns_e1",
    function() return page.active_page end,
    function() return 1 end,
    function() return page:get_page_count() end
  )
  _arc:register_binding(
    "norns_e2",
    function() return menu:get_selected_item() end,
    function() return 1 end,
    function() return menu:get_item_count() end
  )
  _arc:register_binding(
    "norns_e3",
    function() return print("norns e3 todo") end,
    function() return print("norns e3 todo") end,
    function() return print("norns e3 todo") end
  )
  _arc:register_binding(
    "browse_cells",
    function() return print("browse cells todo") end,
    function() return print("browse cells todo") end,
    function() return print("browse cells todo") end
  )
  -- load up the user-defined parameters
  for i = 1, 4 do 
    _arc.encs[i] = {}
    _arc:bind(i, config.arc_bindings[params:get("arc_encoder_" .. i)].id)
  end
  -- dev
  _arc:bind(3, config.arc_bindings[params:get("arc_encoder_1")].id)
  _arc:bind(4, config.arc_bindings[params:get("arc_encoder_2")].id)

  fn.dirty_arc(true)
end


function _arc:register_binding(binding_id, value_getter, min_getter, max_getter)
  self.bindings[binding_id] = {
    binding_id = binding_id,
    value_getter = value_getter,
    min_getter = min_getter,
    max_getter = max_getter
  }
end

-- arc redefined, _arc ~= arc

function arc.delta(n, delta)
  -- this only works after the rest of arcologies loads
  if not init_done then return end

  -- end the clock for this encoder
  if arc_enc_counter ~= nil then
    clock.cancel(arc_enc_counter)
    _arc:reset_enc_counter()
  end

  -- actually update the value
  _arc:run_delta(_arc.encs[n], delta)
      if _arc.encs[n].binding == "norns_e1"     then  page:select(_arc:map_to_segment(_arc.encs[n]))
  elseif _arc.encs[n].binding == "norns_e2"     then  menu:select_item(_arc:map_to_segment(_arc.encs[n]))
  elseif _arc.encs[n].binding == "norns_e3"     then  menu:scroll_value(delta)
  elseif _arc.encs[n].binding == "browse_cells" then  print("BROWSE CELLS")
  end

  -- duplicate bindings are possible
  local duplicates = _arc:get_duplicate_bindings(n, _arc.encs[n].binding)
  for k, v in pairs(duplicates) do
    if v then
      _arc.encs[k].value = _arc.encs[n].value
    end
  end 

  fn.dirty_arc(true)

  -- start the clock for this encoder
    if arc_enc_counter == nil then
      arc_takeover = true
      arc_enc_counter = clock.run(_arc.enc_wait)
    end
end

-- _arc proper

function _arc:enc_wait()
  clock.sleep(.25)
  arc_takeover = false
  _arc:reset_enc_counter()
end

function _arc:reset_enc_counter()
  arc_enc_counter = nil 
end

function _arc.arc_redraw_clock()
  while true do
    if fn.dirty_arc() then
      _arc.device:all(0)
      _arc:arc_redraw()
      _arc.device:refresh()
      fn.dirty_arc(false)
    end
    clock.sleep(1/30)
  end
end

-- todo dynamic methods
-- todo don't redraw if old_value == new_value? fix flicker?
function _arc:arc_redraw()
  local s1 = self:get_divided_ring_segment(1)
  if s1.valid then
    _arc.device:segment(1, s1.from, s1.to, 15)
  end

  local s2 = self:get_divided_ring_segment(2)
  if s2.valid then
    _arc.device:segment(2, s2.from, s2.to, 15)
  end

  local s3 = self:get_divided_ring_segment(3)
  if s3.valid then
    _arc.device:segment(3, s3.from, s3.to, 15)
  end

  local s4 = self:get_divided_ring_segment(4)
  if s4.valid then
    _arc.device:segment(4, s4.from, s4.to, 15)
  end
end



--[[
  allow for bi-directional controls.
  this is called by other parts of arcologies to update the encoders
]]
function _arc:update_value(binding_id, value)
  if not init_done or type(value) ~= "number" then return end
  for i = 1, 4 do
    -- don't update this encoder when arc_takeover is on
    if self.encs[i].binding == binding_id and not arc_takeover then
      self.encs[i].value = util.clamp(value, self.encs[i].min(), self.encs[i].max())
    else
      print("todo - how to update all the others in the event of jumping between pages, for example")
    end
  end
  fn.dirty_arc(true)
end

--[[
  if, for whatever reason, a user wants to bind the same value to multiple
  encoders we need to manually update these as the arc_takeover will
  prevent their values from being updated
]]
function _arc:get_duplicate_bindings(enc_id, binding_id)
  local duplicates = {}
  for i = 1, 4 do
    duplicates[i] = self.encs[i].binding == binding_id and i ~= enc_id
  end
  return duplicates
end









-- bindings



function _arc:init_enc(args)
  self.encs[args.enc_id] = {
    enc_id =        args.enc_id,
    binding =       args.binding,
    value =         args.value,
    min =           args.min,
    max =           args.max,
    sensitivity =   args.sensitivity,
    wrap =          args.wrap,
    style =         args.style,
    style_args =    args.style_args,
  }
end

function _arc:bind(n, binding_id)
  if init_done ~= true then return end -- the rest of arcologies needs to load before _arc.lua
  print("binding...", binding_id)
  if binding_id == "norns_e1" then
    self:init_enc({
      enc_id =       n,
      binding =      binding_id,
      value =        1,
      min =          self.bindings[binding_id].min_getter, 
      max =          self.bindings[binding_id].max_getter, 
      sensitivity =  .01, 
      wrap =         false,
      style =        "divided", 
      style_args = {
        max =     240, 
        offset =  240,
        divisor = self.bindings[binding_id].max_getter,
        snap =    true
      }
    })
  end
  if binding_id == "norns_e2" then
    self:init_enc({
      enc_id =       n,
      binding =      binding_id,
      value =        1,
      min =          self.bindings[binding_id].min_getter, 
      max =          self.bindings[binding_id].max_getter, 
      sensitivity =  .05, 
      wrap =         false,
      style =        "divided", 
      style_args = {
        max =     240, 
        offset =  240,
        divisor = self.bindings[binding_id].max_getter,
        snap =    true
      }
    })
  end
end




function _arc:get_divided_ring_segment(i)
  local enc = self.encs[i]
  local segment_size = enc.style_args.max / enc.style_args.divisor()
  local segments = {}
  for i = 1, enc.style_args.divisor() do
    local from_raw = enc.style_args.offset + (segment_size * (i - 1))
    local from = self:cycle_degrees(from_raw)
    local to =  self:cycle_degrees(from_raw + segment_size)
    segments[i] = {}
    segments[i].from = self:degs_to_rads(from, enc.style_args.snap)
    segments[i].to = self:degs_to_rads(to, enc.style_args.snap)
  end
  return self:validate_segment(segments[self:map_to_segment(enc)])
end

--[[ 
  there appear to be a number of race conditions that 
  necessitates guarding against:
]]
function _arc:validate_segment(segment)
  if segment ~= nil and segment.from ~= nil and segment.to ~= nil then
    segment.valid = true
    return segment
  else
    return { valid = false }
  end
end

function _arc:map_to_segment(enc)
  local segment_size = 360 / enc.style_args.divisor()
  local test = util.linlin(enc.min(), enc.max(), 0, 360, enc.value)
  if test == 360 then -- compensate for circles, 0 == 360, etc.
    return enc.style_args.divisor()
  else
    local match = 1
    for i = 1, enc.style_args.divisor() do
        if (test >= segment_size * (i - 1)) and (test < segment_size * i) then
        match = i
      end
    end
    return match
  end
end

function _arc:run_delta(enc, delta)
  local value = 0
  if enc.wrap then
    value = fn.cycle(enc.value + (enc.sensitivity * delta), enc.min(), enc.max())
  else
    value = enc.value + (enc.sensitivity * delta)
  end
  self.encs[enc.enc_id].value = util.clamp(value, enc.min(), enc.max())
end


















function _arc:set_orientation(i)
  self.orietnation = i
end

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

return _arc