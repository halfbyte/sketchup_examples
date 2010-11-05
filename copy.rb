require 'sketchup'

def copy(num, distance, axis, direction = 1)
  if group = group_from_selection
    model.start_operation "Copy and Translate"
    num.times do |i|
      copy = group.copy
      trans = case(axis)
      when :x
        [distance * i * direction, 0, 0]
      when :y
        [0, distance * i * direction, 0]
      when :z
        [0, 0, distance * i * direction]
      end
      transformation = Geom::Transformation.translation(trans)
      copy.transform!(transformation)
    end
    model.commit_operation
  else
    UI.messagebox "Sie haben nichts gutes selektiert, was kopiert werden könnte", MB_OK
  end
end


def copy_with_dialog
  prompts = ['Anzahl', 'Abstand', 'Achse', 'Richtung']
  values = [10, 10,'x', 'forward']
  options = [nil, nil, 'x|y|z', 'forward|backwards']
  result = UI.inputbox prompts, values, options, "Create Frame"
  num, distance, axis, direction = result
  direction = direction == 'forward' ? 1 : -1
  copy(num, distance, axis.to_sym, direction)
end

def group_from_selection
  if model.selection.length > 1
    model.entities.add_group(model.selection)
  elsif model.selection.first.is_a?(Sketchup::Group)
    model.selection.first
  else
    nil
  end
end

def model
  Sketchup.active_model
end


  UI.add_context_menu_handler do |menu|
    if model.selection.length > 0
      menu.add_separator
      menu.add_item("Copy and Translate") { copy_with_dialog }
    end
  end
