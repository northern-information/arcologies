-- k1: exit  e1: navigate
--
--
--      e2: select    e3: change
--
--    k2: play      k3: delete
--
--
-- ........................................
-- l.llllllll.co/arcologies

include("arcologies/lib/includes")

function init()
  parameters.init() 
  fn.init()         
  counters.init()    
  g.init()          
  glyphs.init()
  graphics.init()   
  keeper.init()
  menu.init()       
  page.init()     
  popup.init() 
  sound.init()
  audio:pitch_off()
  grid_dirty, screen_dirty, splash_break = false, false, false
  k1, k2, k3 = 0, 0, 0
  key_counter, enc_counter = {{},{},{}}, {{},{},{}}
  for i = 1, 3 do
    norns.encoders.set_sens(i, 16)
    counters:reset_enc(i)
  end
  counters.ui:start()
  counters.music:start()
  counters.grid:start()
  clock.run(counters.redraw_clock)
  clock.run(g.grid_redraw_clock)
  page:select(parameters.is_splash_screen_on and 0 or 1)
  fn.seed_cells()
  sound:toggle_playback()
  dev:scene(4)
  redraw()
end

function redraw()
  if not fn.dirty_screen() then return end
  page:render()
  fn.dirty_screen(false)
end

function enc(e, d)
  fn.break_splash(true)
  -- e1 only ever scrolls between pages
  if e == 1 then
    page:scroll(d)  
  -- e2 only ever scrolls the page menu     
  elseif e == 2 then
    menu:scroll(d)
  -- e3 only ever changes the menu value     
  elseif e == 3 then
    menu:scroll_value(d) 
  end
  fn.dirty_screen(true)
end

function key(k, z)
  -- always store the key states
  if k == 1 then k1 = z end
  if k == 2 then k2 = z end
  if k == 3 then k3 = z end
  if z == 1 then
    -- detect long press
    key_counter[k] = clock.run(fn.long_press, k)
  elseif z == 0 then
    fn.break_splash(true)
    -- detect short press
    if key_counter[k] then 
      -- cancel long press counter
      clock.cancel(key_counter[k]) 
      -- short k1 is the default exit to norns
      if k == 1 then
      -- short k2 only ever toggles playback               
      elseif k == 2 then           
        sound:toggle_playback()
      -- short k3 only ever deletes the selected cell
      elseif k == 3 then
        keeper:delete_cell()
      end
      fn.dirty_screen(true)
    end
  end
end

function cleanup()
  fn.cleanup()
end