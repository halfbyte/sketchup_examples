module JK
  module Werkzeuge
    def gruppe_aus_auswahl
      if modell.selection.length > 1
        modell.entities.add_group(modell.selection)
      elsif modell.selection.first.is_a?(Sketchup::Group) || modell.selection.first.is_a?(Sketchup::ComponentInstance)
        modell.selection.first
      else
        nil
      end
    end

    def modell
      Sketchup.active_model
    end
  end
end