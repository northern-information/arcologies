dev = {}

function dev:scene(i)

  if i == 1 then
    
    -- page:select(1)
    -- menu:select_item(2)
    -- params:set("clock_source", 2)    
    -- counters:toggle_playback()

  elseif i == 2 then
    keeper:select_cell(4, 4)
    kc():change("TOPIARY") 
    kc():set_note(74, 1)
    kc():set_note(72, 2)
    kc():set_note(72, 3)
    kc():set_note(72, 4)
    kc():set_note(72, 5)
    kc():set_note(72, 6)
    kc():set_note(72, 7)
    kc():set_note(72, 8)
    page:select(2)
    counters:toggle_playback()

  elseif i == 3 then
    fn.seed_cells()
    counters:toggle_playback()
    keeper:select_cell(1, 1)
    kc():open_port("e")
    kc():open_port("w")
    keeper:deselect_cell()
    keeper:select_cell(4, 1)
    kc():set_metabolism(1)
    kc():change("SOLARIUM")
    kc():open_port("e")
    kc():open_port("w")
    page:select(3)


  elseif i == 4 then
    -- params:set("seed_cell_count", 15)
    -- fn.seed_cells()
    page:select(4)
   
    -- counters:toggle_playback()

  else
    print('else block')

  end
end




function kc()
    return keeper.selected_cell
end


return dev