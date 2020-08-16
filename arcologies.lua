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
  fn.init()
  counters.init()
  g.init()
  graphics.init()
  keeper.init()
  menu.init()
  page.init()
  parameters.init()
  sound.init()
  audio:pitch_off()
  deleting, selecting_note, selecting_seed = false, false, false
  grid_dirty, screen_dirty  = false, false
  key_counter, enc_counter = {{},{},{}}, {{},{},{}}
  for e = 1, 3 do counters:reset_enc(e) end
  counters.ui:start()
  counters.music:start()
  counters.grid:start()
  clock.run(counters.redraw_clock)
  clock.run(g.grid_redraw_clock)
  page:select(1)
  -- fn.seed_cells()
  dev:scene(1)
  redraw()
end

function redraw()
  if not fn.dirty_screen() then return end
  graphics:setup()
  page:render()
  graphics:teardown()
  fn.dirty_screen(false)
end

function enc(n, d)
  if n == 1 then
    page:scroll(d)
  elseif n == 2 then
    menu:scroll(d)
  elseif n == 3 then
    menu:scroll_value(d)
  end
  fn.dirty_screen(true)
end

function key(k, z)
  fn.is_deleting(k == 3 and z == 1 and true or false)
  if z == 1 then
    key_counter[k] = clock.run(fn.long_press, k)
  elseif z == 0 then
    if key_counter[k] then
      clock.cancel(key_counter[k])
      if k == 2 then
        sound:toggle_playback()
        keeper:deselect_cell()
      elseif k == 3 then
        if keeper.is_cell_selected then
          keeper:delete_cell(keeper.selected_cell_id)
        end
      end
      fn.dirty_screen(true)
    end
  end
end

function cleanup()
  g.all(0)
  poll:clear_all()
end