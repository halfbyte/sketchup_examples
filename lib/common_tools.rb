module CommonTools
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
end