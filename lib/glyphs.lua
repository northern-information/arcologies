glyphs = {}

function glyphs.init()
  glyphs.available = Cell:new().structures
end

-- full-size glyphs (22 x 26)

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

function glyphs:test()
  local x = 32
  local y = 20
  local l = 15
  self:bounding_box(x, y, l)
  -- self:hive(x, y, l)
  -- self:shrine(x, y, l)
  -- self:gate(x, y, l)
  -- self:rave(x, y, l)

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


-- full-size glyph components

function glyphs:left_wall(x, y, l)
  graphics:rect(x, y, 2, 26, l)
end

function glyphs:three_quarter_left_wall(x, y, l)
  graphics:rect(x, y+6, 2, 20, l)
end

function glyphs:right_wall(x, y, l)
  graphics:rect(x+20, y, 2, 26, l)
end

function glyphs:three_quarter_right_wall(x, y, l)
  graphics:rect(x+20, y+6, 2, 20, l)
end

function glyphs:kasagi(x, y, l)
  graphics:rect(x-5, y, 32, 2, l)
end

function glyphs:roof(x, y, l)
  graphics:rect(x, y, 22, 2, l)
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

function glyphs:foundation(x, y, l)
  graphics:rect(x-5, y+24, 32, 2, l)
end

function glyphs:bell(x, y, l)
  graphics:rect(x+10, y+11, 2, 8, l)
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

-- small glyphs

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

-- small components

function glyphs:small_left_wall(x, y, l)
  graphics:mls(x, y-1, x, y+8, l)
end

function glyphs:small_right_wall(x, y, l)
  graphics:mls(x+6, y-1, x+6, y+8, l)
end

function glyphs:small_three_quarter_left_wall(x, y, l)
  graphics:mls(x, y+2, x, y+8, l)
end

function glyphs:small_three_quarter_right_wall(x, y, l)
  graphics:mls(x+6, y+2, x+6, y+8, l)
end

function glyphs:small_kasagi(x, y, l)
  graphics:mls(x-3, y, x+8, y, l)
end

function glyphs:small_roof(x, y, l)
  graphics:mls(x, y, x+6, y, l)
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

function glyphs:small_foundation(x, y, l)
  graphics:mls(x-3, y+8, x+8, y+8, l)
end

function glyphs:small_bell(x, y, l)
  graphics:mlrs(x+2, y+3, 1, 3, l)
end

return glyphs