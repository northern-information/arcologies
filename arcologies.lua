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

         mu = require("musicutil")                 -- ships with norns
         tu = require("tabutil")                   -- ships with norns 
      graph = require("graph")                     -- ships with norns 
engine.name = "PolyPerc"                           -- default engine
              include("arcologies/lib/Cell")       -- the core concept of arcologies
              include("arcologies/lib/Signal")     -- emitted by Cells
         fn = include("arcologies/lib/functions")  -- global functions
   counters = include("arcologies/lib/counters")   -- clocks, metros, timing
          g = include("arcologies/lib/g")          -- grid interactions and leds
   graphics = include("arcologies/lib/graphics")   -- all norns screen rendinger
     keeper = include("arcologies/lib/keeper")     -- state machine for Cells and Signals
       page = include("arcologies/lib/page")       -- controller for norns pages
      sound = include("arcologies/lib/sound")      -- all sound, midi, samples
 parameters = include("arcologies/lib/parameters") -- exposed norns parameters


function init()
  audio:pitch_off()
  fn.init()
  counters.init()
  g.init()
  graphics.init()  
  keeper.init()
  page.init()  
  parameters.init()
  sound.init()
  deleting, selecting_note = false, false
  grid_dirty, screen_dirty= true, true
  key_counter, enc_counter = {{},{},{}}, {{},{},{}}
  clock.run(counters.redraw_clock)
  clock.run(g.grid_redraw_clock)
  for e = 1, 3 do counters:reset_enc(e) end
  page:select(1)
  fn.seed_cells()
  sound:toggle_playback()
  
  -- cell designer
  page:select(2)
  keeper:select_cell(2, 2)
  keeper.selected_cell:open_port("e")
  keeper.selected_cell.structure = 2
  page.selected_item = 3
  
  -- signal density
  -- page:select(4)  

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
    page:select(util.clamp(page.active_page + d, 1, #page.titles))
    if page.active_page ~= 2 then
      keeper:deselect_cell()
    end
  elseif n == 2 then
    page.selected_item = util.clamp(page.selected_item + d, 1, page.items)
  else
    page:change_selected_item_value(d)
  end
  fn.dirty_screen(true) -- todo make sure i'm not over doing it with these
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