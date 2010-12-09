require 'sketchup'
require 'werkzeuge'

include JK::Werkzeuge

def kopieren_und_verschieben(anzahl, abstand, achse, richtung = 1)
  if gruppe = gruppe_aus_auswahl
    modell.start_operation "Kopieren und Verschieben"
    anzahl.times do |i|
      kopie = gruppe.copy
      translation = case(achse)
      when :x
        [abstand * i * richtung, 0, 0]
      when :y
        [0, abstand * i * richtung, 0]
      when :z
        [0, 0, abstand * i * richtung]
      end
      puts translation.inspect
      transformation = Geom::Transformation.translation(translation)
      kopie.transform!(transformation)
    end
    modell.commit_operation
  else
    UI.messagebox "Sie haben nichts gutes selektiert, was kopiert werden koennte", MB_OK
  end
end


def kopieren_und_verschieben_mit_dialog
  namen = ['Anzahl', 'Abstand', 'Achse', 'Richtung']
  vorgabewerte = [10, 10,'x', 'forward']
  optionen = [nil, nil, 'x|y|z', 'vorwaerts|rueckwaerts']
  resultat = UI.inputbox namen, vorgabewerte, optionen, "Kopieren und Verschieben"
  anzahl, abstand, achse, richtung = resultat
  richtung = richtung == 'vorwaerts' ? 1 : -1
  kopieren_und_verschieben(anzahl, abstand, achse.to_sym, richtung)
end


unless file_loaded? File.basename(__FILE__) 
  UI.add_context_menu_handler do |menue|
    if modell.selection.length > 0
      menue.add_separator
      menue.add_item("Kopieren und Verschieben") { kopieren_und_verschieben_mit_dialog }
    end
  end
end

file_loaded File.basename(__FILE__) 