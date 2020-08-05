function select_page(x)
  core.page.active_page = x
  core.page.items = page_items[page.active_page]
  core.page.selected_item = 1
end

function create_cell(x, y)
  c = Cell:new(x, y, core.music_counter.location)
  core.Field:add_cell(c)
end

function select_cell(x, y)
  core.selected_cell = {x, y}
  local cell_exists = core.Field:lookup(x, y)
  if not cell_exists then
    create_cell(x, y)
  end
  core.g:refresh()
end

function cell_is_selected()
  return (#core.selected_cell == 2) and true or false
end

function led_blink_selected_cell()
  -- if not cell_is_selected() then return end

  -- if core.grid_counter.frame % 15 == 0 then
  --   core.selected_cell_on = not core.selected_cell_on
  -- end

  -- local level = (core.selected_cell_on == false) and core.graphics.levels["h"] or core.graphics.levels["l"]
  -- core.g:led(core.selected_cell[1], core.selected_cell[2], level)
end

function deselect_cell()
  core.selected_cell = {}
  core.selected_cell_on = false
  core.g:refresh()
end

function get_microframe()
  return core.ui_counter.microframe
end