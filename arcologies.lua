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
-- GNU GPL v3.0

include("arcologies/lib/includes")

function init()
  audio:pitch_off()
  filesystem.init()
  parameters.init()
  fn.init()
  m.init()
  g.init()
  c.init()
  s.init()
  sound.init()
  counters.init()
  glyphs.init()
  graphics.init()
  docs.init()
  page.init()
  menu.init()
  popup.init()
  keeper.init()
  grid_dirty, screen_dirty, splash_break = false, false, false
  keys, key_counter, enc_counter = {}, {{},{},{}}, {{},{},{}}
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
  init_done = true
  if config.settings.dev_mode then dev:scene(config.settings.dev_scene) end
  redraw()
end

function redraw()
  if not fn.dirty_screen() then return end
  page:render()
  fn.dirty_screen(false)
end

function enc(e, d)
  fn.break_splash(true)
  if e == 1 then  -- e1 only ever scrolls between pages
    page:scroll(d)
  elseif e == 2 then -- e2 only ever scrolls the page menu
    menu:scroll(d)
  elseif e == 3 then
    menu:scroll_value(d) -- e3 only ever changes the menu value
  end
  fn.dirty_screen(true)
end

function key(k, z)
  keys[k] = z -- always store the key states
  if z == 1 then -- detect long press
    key_counter[k] = clock.run(fn.long_press, k)
  elseif z == 0 then -- detect short press
    fn.break_splash(true)
    if key_counter[k] then -- cancel long press counter
      clock.cancel(key_counter[k])
       -- short k1 is the default exit to norns
      if k == 2 then -- short k2 only ever toggles playback
        sound:toggle_playback()
      elseif k == 3 then -- short k3 only ever deletes the selected cell
        keeper:delete_cell()
      end
      fn.dirty_screen(true)
    end
  end
end

function cleanup()
  fn.cleanup()
end