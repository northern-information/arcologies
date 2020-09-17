dev = {}

function dev:scene(i)

  if i == 1 then
    
    -- page:select(1)
    -- menu:select_item(2)
    -- params:set("clock_source", 2)    
    -- counters:toggle_playback()

  elseif i == 2 then
    -- sound:set_random_root()
    -- sound:set_random_scale()

    
    -- keeper:select_cell(8, 4)
    -- kc():open_port("w")

    keeper:select_cell(4, 4)
    kc():change("KUDZU") 
    -- kc().generation = 1   
    -- kc():open_port("e")
    -- kc():open_port("s")
    -- kc():open_port("w")
    page:select(2)
    -- -- menu:select_item(5)
    -- -- keeper:deselect_cell()
    -- params:set("clock_tempo", 120)
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


function rerun()
  norns.script.load(norns.state.script)
end

function kc()
    return keeper.selected_cell
end


return dev