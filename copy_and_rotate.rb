require 'sketchup'
require 'common_tools'

include CommonTools
  
def copy_and_rotate(num = 10, offset = 0,axis = :x)
  
  axis_vector = case(axis)
  when :x; Geom::Vector3d.new(1,0,0)
  when :y; Geom::Vector3d.new(0,1,0)
  when :z; Geom::Vector3d.new(0,0,1)
  else
    Geom::Vector3d.new(1,0,0)
  end
  
  origin = Geom::Point3d.new(axis_vector.to_a.map{ |p| p * offset })
  puts origin.to_a.inspect
  
  model.start_operation "CopyRotator"
  if group = group_from_selection
    step = 2 * Math::PI / num
  
    copies = [group]
    
    # setting origin of rotation to middle of object / offset
    point = group.transformation.origin  
    case(axis)
    when :x
      point.z = point.z + group.bounds.depth / 2
      point.y = point.y - offset
    when :y
      point.z = point.z + group.bounds.depth / 2
      point.x = point.x - offset
    when :z
      point.y = point.y + group.bounds.height / 2
      point.x = point.x - offset
    end
    (num).times do |i|
      copy = group.copy
      copy.transform! Geom::Transformation.rotation(point, axis_vector, step * i)
      copies << copy
    end
    whole_group = model.entities.add_group(copies)
  else    
    UI.messagebox "Sie haben nichts gutes selektiert, was kopiert werden könnte", MB_OK
  end
  model.commit_operation
end


def copy_and_rotate_with_dialog
  prompts = ['Anzahl', 'Abstand', 'Achse']
  values = [10, 10,'x']
  options = [nil, nil, 'x|y|z']
  result = UI.inputbox prompts, values, options, "Rotatations-Kopie"
  num, distance, axis, direction = result
  copy_and_rotate(num, distance, axis.to_sym)
end


unless file_loaded? File.basename(__FILE__) 
  UI.add_context_menu_handler do |menu|
    if model.selection.length > 0
      menu.add_separator
      menu.add_item("Rotationskopie") { copy_and_rotate_with_dialog }
    end
  end
end

file_loaded File.basename(__FILE__) 