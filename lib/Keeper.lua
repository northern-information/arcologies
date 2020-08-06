Keeper = {}

function Keeper:new()
  local k = setmetatable({}, { __index = Keeper })
  
  k.is_cell_selected = false
  k.selected_cell_id = ''
  k.selected_cell_x = ''
  k.selected_cell_y = ''
  k.selected_cell = {}
  k.cells = {}
  
  return k
end




-- getters

function Keeper:get_cell(id)
   for k,v in pairs(self.cells) do
    if v.id == id then
      return v
    end
  end
  return false
end

function Keeper:cell_exists(id)
  for k,v in pairs(self.cells) do
    if v.id == id then
      return true
    end
  end
  return false
end





-- create / delete
function Keeper:create_cell(x, y)
  local new_cell = Cell:new(x, y, core.counters.music.location) -- replace generation with function?
  table.insert(self.cells, new_cell)
  return new_cell
end

function Keeper:delete_cell(id)
  for k,v in pairs(self.cells) do
    if v.id == id then
      table.remove(self.cells, k)
      self:deselect_cell()
    end
  end
end

function Keeper:delete_all_cells()
  self.deselect_cell()
  self.cells = {}
end






-- select / deselect
function Keeper:select_cell(x, y)
  local id = id(x, y)
  if self:cell_exists(id) then
    self.selected_cell = self:get_cell(id)
  else
    self.selected_cell = self:create_cell(x, y)
  end
  self.is_cell_selected = true
  self.selected_cell_id = self.selected_cell.id
  self.selected_cell_x = self.selected_cell.x
  self.selected_cell_y = self.selected_cell.y
  dirty_grid(true)
  dirty_screen(true)
end

function Keeper:deselect_cell()
  self.is_cell_selected = false
  self.selected_cell_id = ''
  self.selected_cell_x = ''
  self.selected_cell_y = ''
  dirty_grid(true)
  dirty_screen(true)
end
