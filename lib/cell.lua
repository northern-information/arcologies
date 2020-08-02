local cell = {}

function cell.init()
  cell.selected = {}
end

function cell.is_selected()
  return (#cell.selected == 2) and true or false
end

return cell