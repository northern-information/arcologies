local g = grid.connect()

function g.init()
  clock.run(grid_redraw_clock)
end

function grid_redraw_clock()
  while true do
    clock.sleep(1 / 30)
    if dirty_grid() == true then
      grid_redraw()
      dirty_grid(false)
    end
  end
end


function grid_redraw()
  g:all(0)
  led_blink_selected_cell()
  g:refresh()
end

function g.key(x,y,z)
  if z == 1 then
    select_cell(x, y)
    select_page(2)
    print(x,y)
  end
  dirty_grid(true)
end

function led_blink_selected_cell()
  if not cell_is_selected() then return end

  local level = (core.selected_cell_on == false) and core.graphics.levels["h"] or core.graphics.levels["l"]
  g:led(core.selected_cell[1], core.selected_cell[2], level)
end

return g