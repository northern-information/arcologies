local keeper = {}

function keeper.init()  
  keeper.is_cell_selected = false
  keeper.selected_cell_id = ''
  keeper.selected_cell_x = ''
  keeper.selected_cell_y = ''
  keeper.selected_cell = {}
  keeper.cells = {}
end

function keeper:get_cell(id)
   for k,v in pairs(self.cells) do
    if v.id == id then
      return v
    end
  end
  return false
end

function keeper:cell_exists(id)
  for k,v in pairs(self.cells) do
    if v.id == id then
      return true
    end
  end
  return false
end
function keeper:create_cell(x, y)
  local new_cell = Cell:new(x, y, generation())
  table.insert(self.cells, new_cell)
  return new_cell
end

function keeper:delete_cell(id)
  for k,v in pairs(self.cells) do
    if v.id == id then
      table.remove(self.cells, k)
      self:deselect_cell()
    end
  end
end

function keeper:delete_all_cells()
  self.deselect_cell()
  self.cells = {}
end

function keeper:select_cell(x, y)
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

function keeper:deselect_cell()
  self.is_cell_selected = false
  self.selected_cell_id = ''
  self.selected_cell_x = ''
  self.selected_cell_y = ''
  dirty_grid(true)
  dirty_screen(true)
end

<<<<<<< HEAD
return keeper
=======
return keeper
>>>>>>> 3ce2d2b842dcaeff41f0c5083a56409dbe0ebab9
