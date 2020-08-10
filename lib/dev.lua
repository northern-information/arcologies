local dev = {}

function dev.init() end

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