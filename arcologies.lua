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
-- <3 @tyleretters
-- v0.5.0-beta

               include("arcologies/lib/Cell")               
               include("arcologies/lib/Signal")               
               include("arcologies/lib/functions")               
    counters = include("arcologies/lib/counters")
         dev = include("arcologies/lib/dev")
  dictionary = include("arcologies/lib/dictionary")
           g = include("arcologies/lib/g")
    graphics = include("arcologies/lib/graphics")
      keeper = include("arcologies/lib/keeper")
        page = include("arcologies/lib/page")  
  parameters = include("arcologies/lib/parameters")
       sound = include("arcologies/lib/sound")
          mu = require("musicutil")
          tu = require("tabutil")
 engine.name = "PolyPerc"

function init()
  audio:pitch_off()
  counters.init()
  dictionary.init()
  dev.init()
  g.init()
  graphics.init()  
  keeper.init()
  page.init()  
  parameters.init()
  sound.init()
  deleting = false
  grid_dirty, screen_dirty = true, true
  key_counter = {{},{},{}}
  clock.run(counters.redraw_clock)
  select_page(1)
  dev:setup_demo()
  redraw()
end

function redraw()
  if not dirty_screen() then return end
  graphics:setup()
  page:render()
  graphics:teardown()
  dirty_screen(false)
end

function enc(n, d)
  if n == 1 then
    select_page(util.clamp(page.active_page + d, 1, #dictionary.pages))
    if page.active_page ~= 2 then
      keeper:deselect_cell()
    end
  elseif n == 2 then
    page.selected_item = util.clamp(page.selected_item + d, 1, page.items)
  else
    page:change_selected_item_value(d)
  end
end

function key(k,z)
  is_deleting(k == 3 and z == 1 and true or false)
  if z == 1 then
    key_counter[k] = clock.run(long_press, k)
  elseif z == 0 then
    if key_counter[k] then
      clock.cancel(key_counter[k])
      if k == 2 then
        parameters.toggle_playback()
        keeper:deselect_cell()
      elseif k == 3 then
        if keeper.is_cell_selected then
          keeper:delete_cell(keeper.selected_cell_id)
        end
      end
      dirty_screen(true)
    end
  end
end

function cleanup()
  g.all(0)
  poll:clear_all()
end