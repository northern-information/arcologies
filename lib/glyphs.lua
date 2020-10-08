glyphs = {}

function glyphs.init()
  glyphs.available = structures:all_names()
  glyphs.shimmer_index = 1
  glyphs.shimmer_1 = { 0, 1, 2, 3, 4, 3, 2, 1 }
  glyphs.shimmer_2 = { 1, 2, 3, 4, 3, 2, 1, 0 }
  glyphs.shimmer_3 = { 2, 3, 4, 3, 2, 1, 0, 1 }
  glyphs.shimmer_4 = { 3, 4, 3, 2, 1, 0, 1, 2 }
end

function glyphs:draw_glyph(s, x, y, l)
  if self[string.lower(s)] ~= nil then
    assert(load("glyphs:" .. string.lower(s) .. "(...)"))(x, y, l)
  else
    glyphs:cell(x, y, l)
  end
end

function glyphs:draw_small_glyph(s, x, y, l)
  if self["small_" .. string.lower(s)] ~= nil then
    assert(load("glyphs:" .. "small_" .. string.lower(s) .. "(...)"))(x, y, l)
  else
    glyphs:small_cell(x, y, l)
  end
end

function glyphs:random(x, y, l, jitter)
  local r = math.random(1, #structures:all_names())
  if jitter then
    x = x + math.random(-1, 1)
    y = y + math.random(-1, 1)
  end
  self:draw_glyph(structures:all_names()[r], x, y, l)
end

function glyphs:small_random(x, y, l, jitter)
  local r = math.random(1, #structures:all_names())
  if jitter then
    x = x + math.random(-1, 1)
    y = y + math.random(-1, 1)
  end
  self:draw_small_glyph(structures:all_names()[r], x, y, l)
end

function glyphs:test()
  graphics:title_bar_and_tabs() 
  local x = 32
  local y = 20
  local l = 15
  self:bounding_box(x, y, l)
  self:cloakroom(x, y, l)
  self:small_cloakroom(x+60, y, l)
end

function glyphs:bounding_box(x, y, l)
  graphics:mlrs(x, y-2, 22, 0, 5)
  graphics:mlrs(x, y+29, 22, 0, 5)
  graphics:mlrs(x-2, y, 0, 26, 5)
  graphics:mlrs(x+25, y, 0, 26, 5)
end

function glyphs:cell(x, y, l)
  self:left_wall(x, y, l)
  self:right_wall(x, y, l)
  self:roof(x, y, l)
  self:floor(x, y, l)
end

function glyphs:stubby(x, y, l)
  glyphs:cell(x, y, l)
  graphics:rect(x+3, y+4, 2, 4, l)
  graphics:rect(x+9, y+4, 2, 4, l)
  graphics:rect(x+6, y+12, 2, 4, l)
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
  self:second_floor(x, y, l)
  self:floor(x, y, l)
  graphics:rect(x, y, 2, 8, l)
  graphics:rect(x+5, y, 2, 8, l)
  graphics:rect(x+10, y, 2, 8, l)
  graphics:rect(x+15, y, 2, 14, l)
  graphics:rect(x+20, y, 2, 8, l)
  graphics:rect(x, y, 7, 2, l)
  graphics:rect(x+5, y+6, 7, 2, l)
  graphics:rect(x+10, y, 10, 2, l)
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

function glyphs:uxb(x, y, l)
  self:three_quarter_left_wall(x, y, l)
  self:three_quarter_right_wall(x, y, l)
  self:kasagi(x, y, l)
  self:second_floor(x, y, l)
  self:column(x, y, l)
end

function glyphs:casino(x, y, l)
  self:half_left_wall(x, y, l)
  self:half_right_wall(x, y, l)
  self:partial_roof(x, y, l)
  self:floor(x, y, l)
  self:third_floor(x, y, l)
  self:second_floor(x, y, l)
  self:upper_column(x, y, l)
end

function glyphs:tunnel(x, y, l)
  self:left_wall(x, y, l)
  self:tunnel_left_wall(x, y, l)
  self:right_wall(x, y, l)
  self:tunnel_right_wall(x, y, l)
  self:partial_roof(x, y, l)
  self:lesser_bell(x, y, l)
end

function glyphs:aviary(x, y, l)
  self:crow(x, y, l)
  graphics:rect(x+14, y, 8, 2, l)  
  graphics:rect(x, y+18, 2, 8, l)
  self:right_wall(x, y, l)
  self:floor(x, y, l)
end

function glyphs:forest(x, y, l)
  self:crow(x, y, l)
  self:foundation(x, y, l)
  graphics:rect(x, y+14, 2, 12, l)
  graphics:rect(x+5, y+18, 2, 8, l)
  graphics:rect(x+10, y+20, 2, 6, l)
  graphics:rect(x+15, y+11, 2, 15, l)
  self:three_quarter_right_wall(x, y, l)
end

function glyphs:hydroponics (x, y, l)
  self:three_quarter_left_wall(x, y, l)
  self:three_quarter_right_wall(x, y, l)
  self:tunnel_left_wall(x, y, l)
  self:tunnel_right_wall(x, y, l)
  self:partial_roof(x, y, l)
  self:partial_third_floor(x, y, l)
  self:partial_second_floor(x, y, l)
  self:partial_floor(x, y, l)
  graphics:rect(x-5, y+18, 2, 8, l)
  graphics:rect(x+10, y+20, 2, 6, l)
  graphics:rect(x+25, y+18, 2, 8, l)
end

function glyphs:fracture(x, y, l)
  self:foundation(x, y, l)
  graphics:rect(x, y-2, 2, 8, l)
  graphics:rect(x, y+4, 12, 2, l)
  graphics:rect(x+10, y+4, 2, 12, l)
  graphics:rect(x+10, y+14, 12, 2, l)
  graphics:rect(x+20, y+16, 2, 10, l)
  graphics:rect(x+20, y-2, 2, 10, l)
  graphics:rect(x, y+14, 2, 12, l)
end


function glyphs:mirage(x, y, l)
  self.shimmer_index = fn.cycle(counters.ui.quarter_frame % 8 + 1, 1, 8)
  graphics:rect(x+12 + self.shimmer_1[self.shimmer_index], y, 10 - self.shimmer_3[self.shimmer_index], 2, l)
  graphics:rect(x+8  + self.shimmer_2[self.shimmer_index], y+6, 8 - self.shimmer_4[self.shimmer_index], 2, l)
  graphics:rect(x+6 + self.shimmer_3[self.shimmer_index], y+12, 13 - self.shimmer_2[self.shimmer_index], 2, l)
  graphics:rect(x   + self.shimmer_4[self.shimmer_index], y+18, 22 - self.shimmer_1[self.shimmer_index], 2, l)
  self:foundation(x, y, l)
end

function glyphs:institution(x, y, l)
  self:cell(x, y, l)
  graphics:rect(x+6, y+6, 10, 2, l)
  graphics:rect(x+5, y+18, 2, 8, l)
  graphics:rect(x+5, y+18, 2, 8, l)
  graphics:rect(x+10, y+18, 2, 8, l)
  graphics:rect(x+15, y+18, 2, 8, l)
end

function glyphs:spomenik(x, y, l)
  self:basement(x, y, l)
  self:floor(x, y, l)
  self:second_floor(x, y, l)
  graphics:rect(x+10, y+18, 2, 8, l)
  graphics:rect(x, y+12, 2, 8, l)
  graphics:rect(x+20, y+12, 2, 8, l)
  graphics:rect(x+6, y, 2, 14, l)
  graphics:rect(x+14, y, 2, 14, l)
  graphics:rect(x, y, 8, 2, l)
  graphics:rect(x+14, y, 8, 2, l)
end

function glyphs:auton(x, y, l)
  self:roof(x, y, l)
  self:left_wall(x, y, l)
  self:right_wall(x, y, l)
  graphics:rect(x, y+12, 8, 2, l)
  graphics:rect(x+14, y+12, 8, 2, l)
  graphics:rect(x+8, y+18, 6, 2, l)
end

function glyphs:kudzu(x, y, l)
  graphics:rect(x+5, y, 2, 8, l)
  graphics:rect(x+20, y, 2, 8, l)
  graphics:rect(x+5, y, 17, 2, l)
  graphics:rect(x, y+6, 17, 2, l)
  graphics:rect(x, y+6, 2, 8, l)
  graphics:rect(x+15, y+6, 2, 8, l)
  graphics:rect(x+5, y+12, 17, 2, l)  
  graphics:rect(x+20, y+12, 2, 14, l)
  graphics:rect(x+5, y+12, 2, 8, l)  
  graphics:rect(x, y+18, 12, 2, l)
  graphics:rect(x, y+18, 2, 8, l)  
  graphics:rect(x+10, y+18, 2, 8, l)  
end

function glyphs:windfarm(x, y, l)
  graphics:rect(x, y+6, 12, 2, l)
  graphics:rect(x+10, y, 2, 8, l) 
  graphics:rect(x+7, y, 5, 2, l) 
  graphics:rect(x+5, y+12, 17, 2, l)
  graphics:rect(x+20, y+6, 2, 8, l) 
  graphics:rect(x+17, y+6, 5, 2, l) 
  graphics:rect(x, y+18, 17, 2, l) 
  graphics:rect(x+15, y+18, 2, 8, l) 
  graphics:rect(x+12, y+24, 5, 2, l)
end

function glyphs:prairie(x, y, l)
  self:extended_floor(x, y, l)
  self:basement(x, y, l)
  graphics:rect(x, y+14, 2, 2, l)
  graphics:rect(x+10, y+14, 2, 2, l)
  graphics:rect(x+20, y+14, 2, 2, l)
  graphics:rect(x+5, y+20, 2, 2, l)
  graphics:rect(x+15, y+20, 2, 2, l)
  graphics:rect(x+10, y+26, 2, 2, l)
end

function glyphs:cloakroom(x, y, l)
  self:roof(x, y, l)
  graphics:rect(x, y, 2, 20, l)
  self:three_quarter_right_wall(x, y, l)
  self:basement(x, y, l)
  graphics:rect(x, y+6, 9, 2, l)
  graphics:rect(x+13, y+6, 9, 2, l)
  graphics:rect(x, y+12, 9, 2, l)
  graphics:rect(x+13, y+12, 9, 2, l)
  graphics:rect(x, y+18, 9, 2, l)
  graphics:rect(x+13, y+18, 9, 2, l)
end

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

function glyphs:upper_column(x, y, l)
  graphics:rect(x+10, y, 2, 14, l)
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

function glyphs:partial_third_floor(x, y, l)
  graphics:rect(x+5, y+6, 12, 2, l)
end

function glyphs:second_floor(x, y, l)
  graphics:rect(x, y+12, 22, 2, l)
end

function glyphs:partial_second_floor(x, y, l)
  graphics:rect(x+5, y+12, 12, 2, l)
end

function glyphs:extended_floor(x, y, l)
  graphics:rect(x-5, y+18, 32, 2, l)
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

function glyphs:crow(x, y, l)
  graphics:rect(x, y, 2, 8, l)
  graphics:rect(x, y, 8, 2, l)
  graphics:rect(x+5, y+5, 2, 8, l)
  graphics:rect(x+5, y+5, 8, 2, l)
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
  local y_adjust = keeper.selected_cell:is("PRAIRIE") and 30 or 28
  graphics:rect(x+10, y+y_adjust, 2, 4, l)
  graphics:rect(x+9, y+y_adjust, 4, 2, l)
end

function glyphs:west_port(x, y, l)
  graphics:rect(x-6, y+13, 4, 2, l)
  graphics:rect(x-4, y+12, 2, 4, l)
end

function glyphs:small_signals(x, y, l)
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

function glyphs:small_stubby(x, y, l)
  glyphs:small_cell(x, y, l)
  graphics:mlrs(x+2, y+1, 0, 2, l)
  graphics:mlrs(x+4, y+1, 0, 2, l)
  graphics:mlrs(x+3, y+4, 0, 1, l)
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
  self:small_second_floor(x, y, l)
  self:small_floor(x, y, l)
  graphics:mlrs(x-1, y-1, 1, 3, l)
  graphics:mlrs(x+1, y-1, 1, 3, l)
  graphics:mlrs(x+3, y-1, 1, 4, l)
  graphics:mlrs(x+5, y-1, 1, 3, l)
  graphics:mlrs(x-1, y-1, 3, 1, l)
  graphics:mlrs(x+1, y+1, 3, 1, l)
  graphics:mlrs(x+3, y-1, 3, 1, l)
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

function glyphs:small_uxb(x, y, l)
  self:small_three_quarter_left_wall(x, y, l)
  self:small_three_quarter_right_wall(x, y, l)
  self:small_kasagi(x, y, l)
  self:small_second_floor(x, y, l)
  self:small_column(x, y, l)
end

function glyphs:small_casino(x, y, l)
  self:small_half_left_wall(x, y, l)
  self:small_half_right_wall(x, y, l)
  self:small_partial_roof(x, y, l)
  self:small_floor(x, y, l)
  self:small_third_floor(x, y, l)
  self:small_second_floor(x, y, l)
  self:small_upper_column(x, y, l)
end

function glyphs:small_tunnel(x, y, l)
  self:small_left_wall(x-1, y, l)
  self:small_tunnel_left_wall(x-1, y, l)
  self:small_right_wall(x+1, y, l)
  self:small_tunnel_right_wall(x+1, y, l)
  graphics:mls(x+1, y, x+4, y, l)
  graphics:mlrs(x+2, y+3, 1, 2, l)
end

function glyphs:small_aviary(x, y, l)
  self:small_crow(x, y, l)
  graphics:mlrs(x+4, y-1, 2, 1, l)
  self:small_right_wall(x, y, l)
  graphics:mlrs(x-1, y+5, 1, 3, l)
  self:small_floor(x, y, l)
end

function glyphs:small_forest(x, y, l)
  self:small_crow(x, y, l)
  self:small_foundation(x, y, l)
  graphics:mlrs(x-1, y+4, 1, 3, l)
  graphics:mlrs(x+1, y+6, 1, 2, l)
  graphics:mlrs(x+3, y+4, 1, 3, l)
  self:small_three_quarter_right_wall(x, y, l)
end

function glyphs:small_hydroponics(x, y, l)
  self:small_tunnel_left_wall(x-1, y, l)
  self:small_tunnel_right_wall(x+1, y, l)
  graphics:mls(x+1, y, x+4, y, l)
  graphics:mls(x+1, y+2, x+4, y+2, l)
  graphics:mls(x+1, y+4, x+4, y+4, l)
  graphics:mls(x+1, y+6, x+4, y+6, l)
  graphics:mls(x+3, y+6, x+3, y+8, l)
  graphics:mls(x-1, y+1, x-1, y+8, l)
  graphics:mls(x+7, y+1, x+7, y+8, l)
end

function glyphs:small_fracture(x, y, l)
  self:small_foundation(x, y, l)
  graphics:mlrs(x-1, y-1, 1, 3, l)
  graphics:mlrs(x-1, y+1, 4, 1, l)
  graphics:mlrs(x+2, y+1, 1, 4, l)
  graphics:mlrs(x+2, y+4, 4, 1, l)
  graphics:mlrs(x+5, y+4, 1, 4, l)
  graphics:mlrs(x+5, y-1, 1, 3, l)
  graphics:mlrs(x-1, y+4, 1, 3, l)
end

function glyphs:small_mirage(x, y, l)
  graphics:mls(x+3, y, x+6, y, l)
  graphics:mls(x+1, y+2, x+4, y+2, l)
  graphics:mls(x+3, y+4, x+7, y+4, l)
  self:small_floor(x, y, l)
  self:small_foundation(x, y, l)
end

function glyphs:small_institution(x, y, l)
  self:small_cell(x, y, l)
  graphics:mls(x+1, y+2, x+4, y+2, l)
  graphics:mlrs(x+1, y+6, 1, 2, l)
  graphics:mlrs(x+3, y+6, 1, 2, l)
end

function glyphs:small_spomenik(x, y, l)
  self:small_basement(x, y, l)
  self:small_floor(x, y, l)
  self:small_second_floor(x, y, l)
  graphics:mls(x-1, y, x+2, y, l)
  graphics:mls(x+2, y-1, x+2, y+4, l)
  graphics:mls(x+3, y, x+6, y, l)
  graphics:mls(x+4, y-1, x+4, y+4, l)
  graphics:mls(x, y+3, x, y+6, l)
  graphics:mls(x+6, y+3, x+6, y+6, l)
  graphics:mls(x+3, y+5, x+3, y+8, l)
end

function glyphs:small_auton(x, y, l)
  self:small_roof(x, y, l)
  self:small_left_wall(x, y, l)
  self:small_right_wall(x, y, l)
  graphics:mls(x, y+4, x+2, y+4, l)
  graphics:mls(x+3, y+4, x+6, y+4, l)
  graphics:mls(x+1, y+6, x+4, y+6, l)
end

function glyphs:small_kudzu(x, y, l)
  graphics:mlrs(x, y-1, 7, 1, l)  
  graphics:mlrs(x-2, y+1, 7, 1, l)  
  graphics:mlrs(x, y+3, 7, 1, l)  
  graphics:mlrs(x-2, y+5, 5, 1, l)
  graphics:mlrs(x, y, 1, 2, l)
  graphics:mlrs(x+6, y, 1, 2, l)
  graphics:mlrs(x-2, y+2, 1, 2, l)
  graphics:mlrs(x+4, y+2, 1, 2, l)
  graphics:mlrs(x, y+3, 1, 2, l)
  graphics:mlrs(x-2, y+5, 1, 3, l)
  graphics:mlrs(x+2, y+5, 1, 3, l)  
  graphics:mlrs(x+6, y+3, 1, 5, l)
end

function glyphs:small_windfarm(x, y, l)
  graphics:mlrs(x+1, y, 2, 0, l)
  graphics:mlrs(x+3, y-1, 0, 3, l)   
  graphics:mlrs(x-1, y+2, 4, 0, l) 
  graphics:mlrs(x+1, y+4, 5, 0, l)
  graphics:mlrs(x+6, y+1, 0, 3, l) 
  graphics:mlrs(x+4, y+2, 2, 0, l) 
  graphics:mlrs(x+4, y+5, 0, 3, l)
  graphics:mlrs(x-1, y+6, 5, 0, l) 
  graphics:mlrs(x+2, y+8, 2, 0, l) 
end

function glyphs:small_prairie(x, y, l)
  y = y - 1
  self:small_extended_floor(x, y-1, l)
  self:small_basement(x, y, l)
  graphics:rect(x-2, y+2, 1, 1, l)
  graphics:rect(x+2, y+2, 1, 1, l)
  graphics:rect(x+6, y+2, 1, 1, l)
  graphics:rect(x, y+5, 1, 1, l)
  graphics:rect(x+4, y+5, 1, 1, l)
  graphics:rect(x+2, y+8, 1, 1, l)
end


function glyphs:small_cloakroom(x, y, l)
  self:small_roof(x, y, l)
  graphics:mlrs(x, y, 0, 5, l)
  self:small_three_quarter_right_wall(x, y, l)
  self:small_basement(x, y, l)
  graphics:mlrs(x-1, y+2, 3, 0, l)
  graphics:mlrs(x+3, y+2, 3, 0, l)
  graphics:mlrs(x-1, y+4, 3, 0, l)
  graphics:mlrs(x+3, y+4, 3, 0, l)
  graphics:mlrs(x-1, y+6, 3, 0, l)
  graphics:mlrs(x+3, y+6, 3, 0, l)
end

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

function glyphs:small_upper_column(x, y, l)
  graphics:mlrs(x+2, y, 1, 3, l)
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
  graphics:mls(x+1, y, x+4, y, l)
end

function glyphs:small_third_floor(x, y, l)
  graphics:mls(x-1, y+2, x+6, y+2, l)
end

function glyphs:small_second_floor(x, y, l)
  graphics:mls(x-1, y+4, x+6, y+4, l)
end

function glyphs:small_extended_floor(x, y, l)
  graphics:mls(x-3, y+6, x+8, y+6, l)
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

function glyphs:small_crow(x, y, l)
  graphics:mlrs(x-1, y-1, 1, 3, l)
  graphics:mlrs(x-1, y-1, 3, 1, l)
  graphics:mlrs(x+1, y+1, 1, 3, l)
  graphics:mlrs(x+1, y+1, 3, 1, l)
end

return glyphs