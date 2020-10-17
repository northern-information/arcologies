-- k1: exit  e1: navigate
--
--
--      e2: select    e3: change
--
--    k2: play      k3: delete
--
--
-- v1.2.4

include("arcologies/lib/includes")

function init()
  audio:pitch_off()
  structures.init()
  filesystem.init()
  parameters.init()
  fn.init()
  _midi.init()
  _grid.init()
  _crow.init()
  _softcut.init()
  sound.init()
  counters.init()
  glyphs.init()
  graphics.init()
  docs.init()
  page.init()
  menu.init()
  popup.init()
  keeper.init()
  api.init()
  arcology_name = "arcology" .. os.time(os.date("!*t"))
  grid_dirty, screen_dirty, splash_break, arcology_loaded = false, false, false, false
  keys, key_counter, enc_counter = {}, {{},{},{}}, {{},{},{}}
  for i = 1, 3 do
    norns.encoders.set_sens(i, 16)
    counters:reset_enc(i)
  end
  music_clock_id = clock.run(counters.conductor)
  redraw_clock_id = clock.run(counters.redraw_clock)
  grid_clock_id = clock.run(_grid.grid_redraw_clock)
  arc_clock_id = clock.run(_arc.arc_redraw_clock)
  counters.ui:start()
  counters.grid:start()
  page:select(parameters.is_splash_screen_on and 0 or 1)
  init_done = true
  _arc.init()
  structures:scan()
  if config.settings.dev_mode then dev:scene(config.settings.dev_scene) end
  redraw()
end

function redraw()
  if not fn.dirty_screen() then return end
  page:render()
  fn.dirty_screen(false)
end

function enc(e, d)
  fn.dismiss_messages()
  if e == 1 then  -- e1 only ever scrolls between pages
    page:scroll(d)
  elseif e == 2 then -- e2 only ever scrolls the page menu
    menu:scroll(d)
  elseif e == 3 then
    menu:scroll_value(d) -- e3 only ever changes the menu value
    _arc:set_glowing_endless_up(d > 0)
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
        counters:toggle_playback()
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