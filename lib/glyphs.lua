glyphs = {}

function glyphs.init()
  glyphs.available = config.structures
end

-- full-size glyphs (22 x 26)

function glyphs:test()
  graphics:title_bar_and_tabs() 
  local x = 32
  local y = 20
  local l = 15
  self:bounding_box(x, y, l)

  -- self:hive(x, y, 5)
  -- self:shrine(x, y, l)
  -- self:gate(x, y, l)
  -- self:rave(x, y, l)
  -- self:dome(x, y, l)
  -- self:hive(x, y, l)
  -- self:maze(x, y, l)
  -- self:crypt(x, y, 5)
  -- self:vale(x, y, l)
  self:solarium(x, y, l)
  -- self:tunnel(x, y, l)
  

  -- self:small_hive(x+60, y, 5)
  -- self:small_shrine(x+60, y, l)
  -- self:small_signal(x+60, y, l)
  -- self:small_dome(x+60, y, l)
  -- self:small_topiary(x+60, y, 15)
  -- self:small_maze(x+60, y, l)
  -- self:small_crypt(x+60, y, l)
  self:small_solarium(x+60, y, l)
  -- self:small_vale(x+60, y, l)

  -- self:left_wall(x, y, l)
  -- self:right_wall(x, y, l)
  -- self:three_quarter_left_wall(x, y, l)
  -- self:three_quarter_right_wall(x, y, l)
  -- self:roof(x, y, l)
  -- self:third_floor(x, y, l)
  -- self:second_floor(x, y, l)
  -- self:floor(x, y, l)
  -- self:kasagi(x, y, l)
  -- self:foundation(x, y, l)

  -- self:north_port(x, y, l)
  -- self:east_port(x, y, l)
  -- self:south_port(x, y, l)
  -- self:west_port(x, y, l)
end

function glyphs:bounding_box(x, y, l)
  graphics:mlrs(x, y-2, 22, 0, 5)
  graphics:mlrs(x, y+29, 22, 0, 5)
  graphics:mlrs(x-2, y, 0, 26, 5)
  graphics:mlrs(x+25, y, 0, 26, 5)
end


function glyphs:random(x, y, l, jitter)
  local r = math.random(1, #config.structures)
  if jitter then
    x = x + math.random(-1, 1)
    y = y + math.random(-1, 1)
  end
      if r == 1 then self:cell(x, y, l)
  elseif r == 2 then self:hive(x, y, l)
  elseif r == 3 then self:shrine(x, y, l)
  elseif r == 4 then self:gate(x, y, l)
  elseif r == 5 then self:rave(x, y, l)
  elseif r == 6 then self:topiary(x, y, l)
  elseif r == 7 then self:dome(x, y, l)
  elseif r == 8 then self:maze(x, y, l)
  elseif r == 9 then self:crypt(x, y, l)
  elseif r == 10 then self:vale(x, y, l)
  end
end

function glyphs:cell(x, y, l)
  self:left_wall(x, y, l)
  self:right_wall(x, y, l)
  self:roof(x, y, l)
  self:floor(x, y, l)
end

function glyphs:hive(x, y, l)
  self:cell(x, y, l)
  self:third_floor(x, y, l)
  self:second_floor(x, y, l)
end

function glyphs:shrine(x, y, l)
  self:left_wall(x, y, l)
  self:right_wall(x, y, l)
  self:roof(x, y, l)
  self:third_floor(x, y, l)
  self:bell(x, y, l)
end

function glyphs:gate(x, y, l)
  self:three_quarter_left_wall(x, y, l)
  self:three_quarter_right_wall(x, y, l)
  self:kasagi(x, y, l)
  self:third_floor(x, y, l)
  self:second_floor(x, y, l)
end

function glyphs:rave(x, y, l)
  self:left_wall(x, y, l)
  self:three_quarter_right_wall(x, y, l)
  self:roof(x, y, l)
  self:third_floor(x, y, l)
  self:foundation(x, y, l)
end

function glyphs:topiary(x, y, l)
  self:half_left_wall(x, y, l)
  self:half_right_wall(x, y, l)
  self:shrub(x, y, l)
  self:second_floor(x, y, l)
  self:floor(x, y, l)
end

function glyphs:dome(x, y, l)
  self:cell(x, y, l)
  self:column(x, y, l)
end

function glyphs:maze(x, y, l)
  self:roof(x, y, l)
  self:third_floor(x, y, l)
  self:second_floor(x, y, l)
  graphics:rect(x+10, y+18, 12, 2, l)
  self:basement(x, y, l)
  self:half_left_wall(x, y, l)
  graphics:rect(x, y, 2, 8, l)
  graphics:rect(x+20, y+6, 2, 8, l)
  graphics:rect(x+20, y+18, 2, 8, l)
end

function glyphs:crypt(x, y, l)
  self:left_wall(x, y, l)
  self:tunnel_left_wall(x, y, l)
  self:right_wall(x, y, l)
  self:tunnel_right_wall(x, y, l)
  self:partial_floor(x, y, l)
  self:outer_partial_roof(x, y, l)
  graphics:rect(x+9, y, 4, 2, l)
  graphics:rect(x+9, y+6, 4, 2, l)
  graphics:rect(x+9, y+12, 4, 2, l)
end

function glyphs:vale(x, y, l)
  self:third_floor(x, y, l)
  self:foundation(x, y, l)
  graphics:rect(x+9, y, 13, 2, l)
  graphics:rect(x+20, y, 2, 8, l)
  graphics:rect(x+15, y, 2, 26, l)  
end

function glyphs:solarium(x, y, l)
  self:three_quarter_left_wall(x, y, l)
  self:three_quarter_right_wall(x, y, l)
  self:tunnel_left_wall(x, y, l)
  self:tunnel_right_wall(x, y, l)
  self:floor(x, y, l)
  self:bell(x, y, l)
end

function glyphs:tunnel(x, y, l)
  self:left_wall(x, y, l)
  self:tunnel_left_wall(x, y, l)
  self:right_wall(x, y, l)
  self:tunnel_right_wall(x, y, l)
  self:partial_roof(x, y, l)
  self:lesser_bell(x, y, l)
end

-- full-size glyph components

function glyphs:left_wall(x, y, l)
  graphics:rect(x, y, 2, 26, l)
end

function glyphs:three_quarter_left_wall(x, y, l)
  graphics:rect(x, y+6, 2, 20, l)
end

function glyphs:half_left_wall(x, y, l)
  graphics:rect(x, y+12, 2, 14, l)
end

function glyphs:tunnel_left_wall(x, y, l)
  graphics:rect(x+5, y, 2, 20, l)
end

function glyphs:right_wall(x, y, l)
  graphics:rect(x+20, y, 2, 26, l)
end

function glyphs:three_quarter_right_wall(x, y, l)
  graphics:rect(x+20, y+6, 2, 20, l)
end

function glyphs:half_right_wall(x, y, l)
  graphics:rect(x+20, y+12, 2, 14, l)
end

function glyphs:tunnel_right_wall(x, y, l)
  graphics:rect(x+15, y, 2, 20, l)
end

function glyphs:column(x, y, l)
  graphics:rect(x+10, y, 2, 20, l)
end

function glyphs:kasagi(x, y, l)
  graphics:rect(x-5, y, 32, 2, l)
end

function glyphs:roof(x, y, l)
  graphics:rect(x, y, 22, 2, l)
end

function glyphs:outer_partial_roof(x, y, l)
  graphics:rect(x, y, 7, 2, l)
  graphics:rect(x+15, y, 7, 2, l)
end

function glyphs:partial_roof(x, y, l)
  graphics:rect(x+5, y, 12, 2, l)
end

function glyphs:third_floor(x, y, l)
  graphics:rect(x, y+6, 22, 2, l)
end

function glyphs:second_floor(x, y, l)
  graphics:rect(x, y+12, 22, 2, l)
end

function glyphs:floor(x, y, l)
  graphics:rect(x, y+18, 22, 2, l)
end

function glyphs:partial_floor(x, y, l)
  graphics:rect(x+5, y+18, 12, 2, l)
end

function glyphs:basement(x, y, l)
  graphics:rect(x, y+24, 22, 2, l)
end

function glyphs:foundation(x, y, l)
  graphics:rect(x-5, y+24, 32, 2, l)
end

function glyphs:bell(x, y, l)
  graphics:rect(x+10, y+12, 2, 8, l)
end

function glyphs:lesser_bell(x, y, l)
  graphics:rect(x+10, y+12, 2, 6, l)
end

function glyphs:north_port(x, y, l)
  graphics:rect(x+10, y-6, 2, 4, l)
  graphics:rect(x+9, y-4, 4, 2, l)
end

function glyphs:east_port(x, y, l)
  graphics:rect(x+24, y+13, 4, 2, l)
  graphics:rect(x+24, y+12, 2, 4, l)
end

function glyphs:south_port(x, y, l)
  graphics:rect(x+10, y+28, 2, 4, l)
  graphics:rect(x+9, y+28, 4, 2, l)
end

function glyphs:west_port(x, y, l)
  graphics:rect(x-6, y+13, 4, 2, l)
  graphics:rect(x-4, y+12, 2, 4, l)
end

function glyphs:shrub(x, y, l)
  graphics:rect(x, y, 2, 8, l)
  graphics:rect(x+5, y, 2, 8, l)
  graphics:rect(x+10, y, 2, 8, l)
  graphics:rect(x+15, y, 2, 14, l)
  graphics:rect(x+20, y, 2, 8, l)
  graphics:rect(x, y, 7, 2, l)
  graphics:rect(x+5, y+6, 7, 2, l)
  graphics:rect(x+10, y, 10, 2, l)
end

-- small glyphs

function glyphs:small_random(x, y, l, jitter)
  local r = math.random(1, #config.structures)
  if jitter then
    x = x + math.random(-1, 1)
    y = y + math.random(-1, 1)
  end
      if r == 1 then self:small_cell(x, y, l)
  elseif r == 2 then self:small_hive(x, y, l)
  elseif r == 3 then self:small_shrine(x, y, l)
  elseif r == 4 then self:small_gate(x, y, l)
  elseif r == 5 then self:small_rave(x, y, l)
  elseif r == 6 then self:small_topiary(x, y, l)
  elseif r == 7 then self:small_dome(x, y, l)
  elseif r == 8 then self:small_maze(x, y, l)
  elseif r == 9 then self:small_crypt(x, y, l)
  elseif r == 10 then self:small_vale(x, y, l)
  end
end

function glyphs:small_signal(x, y, l)
  graphics:mlrs(x-1, y-1, 3, 3, l)
  graphics:mlrs(x+2, y+3, 4, -4, l)
  graphics:mlrs(x+3, y+3, 0, 5, l)
end

function glyphs:small_cell(x, y, l)
  self:small_left_wall(x, y, l)
  self:small_right_wall(x, y, l)
  self:small_roof(x, y, l)
  self:small_floor(x, y, l)
end

function glyphs:small_hive(x, y, l)
  self:small_cell(x, y, l)
  self:small_third_floor(x, y, l)
  self:small_second_floor(x, y, l)
end

function glyphs:small_shrine(x, y, l)
  self:small_left_wall(x, y, l)
  self:small_right_wall(x, y, l)
  self:small_roof(x, y, l)
  self:small_third_floor(x, y, l)
  self:small_bell(x, y, l)
end

function glyphs:small_gate(x, y, l)
  self:small_three_quarter_left_wall(x, y, l)
  self:small_three_quarter_right_wall(x, y, l)
  self:small_kasagi(x, y, l)
  self:small_third_floor(x, y, l)
  self:small_second_floor(x, y, l)
end

function glyphs:small_rave(x, y, l)
  self:small_left_wall(x, y, l)
  self:small_three_quarter_right_wall(x, y, l)
  self:small_roof(x, y, l)
  self:small_third_floor(x, y, l)
  self:small_foundation(x, y, l)
end

function glyphs:small_topiary(x, y, l)
  self:small_half_left_wall(x, y, l)
  self:small_half_right_wall(x, y, l)
  self:small_shrub(x, y, l)
  self:small_second_floor(x, y, l)
  self:small_floor(x, y, l)
end

function glyphs:small_dome(x, y, l)
  self:small_cell(x, y, l)
  self:small_column(x, y, l)
end

function glyphs:small_maze(x, y, l)
  self:small_roof(x, y, l)
  self:small_third_floor(x, y, l)
  self:small_second_floor(x, y, l)
  graphics:mlrs(x-1, y, 1, 2, l)
  self:small_basement(x, y, l)
  self:small_half_left_wall(x, y, l)
  graphics:mlrs(x+5, y+2, 1, 2, l)
  graphics:mlrs(x+5, y+5, 1, 2, l)
  graphics:mlrs(x+2, y+5, 3, 1, l)
end

function glyphs:small_crypt(x, y, l)
  self:small_left_wall(x-1, y, l)
  self:small_tunnel_left_wall(x-1, y, l)
  self:small_right_wall(x+1, y, l)
  self:small_tunnel_right_wall(x+1, y, l)
  self:small_partial_floor(x, y, l)
  self:small_outer_partial_roof(x, y, l)
  graphics:mlrs(x+2, y, 1, 0, l)
  graphics:mlrs(x+2, y+2, 1, 0, l)
  graphics:mlrs(x+2, y+4, 1, 0, l)
end

function glyphs:small_vale(x, y, l)
  self:small_third_floor(x, y, l)
  self:small_foundation(x, y, l)
  graphics:mls(x+4, y-1, x+4, y+8, l)
  graphics:mls(x+6, y-1, x+6, y+2, l)
  graphics:mlrs(x+2, y, 4, 0, l)
end

function glyphs:small_solarium(x, y, l)
  self:small_three_quarter_left_wall(x-1, y, l)
  self:small_three_quarter_right_wall(x+1, y, l)
  self:small_tunnel_left_wall(x-1, y, l)
  self:small_tunnel_right_wall(x+1, y, l)
  self:small_floor(x, y, l)
  self:small_bell(x, y, l)
end

function glyphs:small_tunnel(x, y, l)
  self:small_left_wall(x, y, l)
  self:small_tunnel_left_wall(x, y, l)
  self:small_right_wall(x, y, l)
  self:small_tunnel_right_wall(x, y, l)
  self:small_partial_roof(x, y, l)
end

-- small components

function glyphs:small_left_wall(x, y, l)
  graphics:mls(x, y-1, x, y+8, l)
end

function glyphs:small_three_quarter_left_wall(x, y, l)
  graphics:mls(x, y+2, x, y+8, l)
end

function glyphs:small_tunnel_left_wall(x, y, l)
  graphics:mls(x+2, y-1, x+2, y+6, l)
end

function glyphs:small_half_left_wall(x, y, l)
  graphics:mls(x, y+3, x, y+8, l)
end

function glyphs:small_right_wall(x, y, l)
  graphics:mls(x+6, y-1, x+6, y+8, l)
end

function glyphs:small_three_quarter_right_wall(x, y, l)
  graphics:mls(x+6, y+2, x+6, y+8, l)
end

function glyphs:small_right_wall(x, y, l)
  graphics:mls(x+6, y-1, x+6, y+8, l)
end

function glyphs:small_half_right_wall(x, y, l)
  graphics:mls(x+6, y+3, x+6, y+8, l)
end

function glyphs:small_tunnel_right_wall(x, y, l)
  graphics:mls(x+4, y-1, x+4, y+6, l)
end

function glyphs:small_column(x, y, l)
  graphics:mlrs(x+2, y, 1, 6, l)
end

function glyphs:small_kasagi(x, y, l)
  graphics:mls(x-3, y, x+8, y, l)
end

function glyphs:small_roof(x, y, l)
  graphics:mls(x-1, y, x+6, y, l)
end

function glyphs:small_outer_partial_roof(x, y, l)
  graphics:mls(x-1, y, x+1, y, l)
  graphics:mls(x+4, y, x+7, y, l)
end

function glyphs:small_partial_roof(x, y, l)
  graphics:mls(x+2, y, x+4, y, l)
end

function glyphs:small_third_floor(x, y, l)
  graphics:mls(x-1, y+2, x+6, y+2, l)
end

function glyphs:small_second_floor(x, y, l)
  graphics:mls(x-1, y+4, x+6, y+4, l)
end

function glyphs:small_floor(x, y, l)
  graphics:mls(x-1, y+6, x+6, y+6, l)
end

function glyphs:small_partial_floor(x, y, l)
  graphics:mls(x, y+6, x+5, y+6, l)
end

function glyphs:small_basement(x, y, l)
  graphics:mls(x-1, y+8, x+6, y+8, l)
end

function glyphs:small_foundation(x, y, l)
  graphics:mls(x-3, y+8, x+8, y+8, l)
end

function glyphs:small_bell(x, y, l)
  graphics:mlrs(x+2, y+3, 1, 3, l)
end

function glyphs:small_shrub(x, y, l)
    graphics:mlrs(x-1, y-1, 1, 3, l)
    graphics:mlrs(x+1, y-1, 1, 3, l)
    graphics:mlrs(x+3, y-1, 1, 4, l)
    graphics:mlrs(x+5, y-1, 1, 3, l)
    graphics:mlrs(x-1, y-1, 3, 1, l)
    graphics:mlrs(x+1, y+1, 3, 1, l)
    graphics:mlrs(x+3, y-1, 3, 1, l)
end


return glyphs