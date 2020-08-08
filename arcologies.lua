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
-- v0.0.1

               include("arcologies/lib/Cell")               
               include("arcologies/lib/functions")               
    counters = include("arcologies/lib/counters")
  dictionary = include("arcologies/lib/dictionary")
           g = include("arcologies/lib/g")
    graphics = include("arcologies/lib/graphics")
      keeper = include("arcologies/lib/keeper")
        page = include("arcologies/lib/page")  
  parameters = include("arcologies/lib/parameters")
          tu = require("tabutil")
  grid_dirty = true
screen_dirty = true

function init()
  audio:pitch_off()
  counters.init()
  dictionary.init()
  g.init()
  graphics.init()  
  keeper.init()
  page.init()  
  parameters.init()
  select_page(3)
  redraw()
end

function redraw()
  if not dirty_screen() then return end
  graphics:setup()
  page:render()
  graphics:teardown()
  dirty_screen(false)
end

function key(k, z)
  if k == 2 and z == 1 then
    parameters.toggle_playback()
    keeper:deselect_cell()
  end
  if k == 3 and z == 1 then
    if keeper.is_cell_selected then
      keeper:delete_cell(keeper.selected_cell_id)
    end
  end
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

function cleanup()
  g.all(0)
  poll:clear_all()
end