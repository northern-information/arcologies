local dev = {}

function dev.init() end

function dev:rx()
  return math.random(1, grid_width())
end

function dev:ry()
  return math.random(1, grid_height())
end

function dev:coin()
  return math.random(0, 1)
end

function dev:random_cell()
  keeper:select_cell(self:rx(), self:ry())
  keeper.selected_cell:set_structure(math.random(1, 3))
  local ports = { "n", "e", "s", "w" }
  for i = 1, #ports do
    if self:coin() then
      keeper.selected_cell:open_port(ports[i])
    end
  end
  keeper.selected_cell:set_sound(math.random(1, #dictionary.sounds))
end

function dev:seed_random()
  for i = 1, 20 do
    self:random_cell()
  end
  keeper:deselect_cell()
  sound:toggle_playback()
end

function dev:setup_demo()
  keeper:select_cell(2, 2)
  keeper.selected_cell:open_port("e")
  keeper:select_cell(4, 2)
  keeper.selected_cell:set_structure(3)
  keeper.selected_cell:open_port("w")
  keeper.selected_cell:open_port("s")
  keeper.selected_cell:open_port("e")
  keeper:select_cell(4, 6)
  keeper.selected_cell:set_structure(3)
  keeper.selected_cell:open_port("n")
  keeper.selected_cell:open_port("e")  
  keeper.selected_cell:open_port("s")
  keeper.selected_cell:open_port("w")
  keeper.selected_cell:set_sound(77)
  keeper:select_cell(6, 2)
  keeper.selected_cell:set_structure(3)
  keeper.selected_cell:open_port("n")
  keeper.selected_cell:open_port("e")  
  keeper.selected_cell:open_port("s")
  keeper.selected_cell:open_port("w")
  keeper.selected_cell:set_sound(74)
  keeper:select_cell(2, 6)
  keeper.selected_cell:set_structure(3)
  keeper.selected_cell:open_port("e")  
  keeper:select_cell(10, 3)
  keeper.selected_cell:set_structure(1)
  keeper.selected_cell:open_port("s")  
  keeper:select_cell(10, 8)
  keeper.selected_cell:set_structure(3)
  keeper.selected_cell:open_port("n")
  keeper.selected_cell:set_sound(70)
  keeper:select_cell(11, 4)
  keeper.selected_cell:set_structure(1)
  keeper.selected_cell:open_port("s")  
  keeper:select_cell(11, 8)
  keeper.selected_cell:set_structure(3)
  keeper.selected_cell:open_port("n")
  keeper.selected_cell:set_sound(62)
  keeper:deselect_cell()
  sound:toggle_playback()
end

return dev