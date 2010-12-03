require 'sketchup'
require 'common_tools'

include CommonTools
  
def kopieren_und_rotieren(anzahl = 10, versatz = 0,achse = :x)
  
  achsenvektor = case(achse)
  when :x; Geom::Vector3d.new(1,0,0)
  when :y; Geom::Vector3d.new(0,1,0)
  when :z; Geom::Vector3d.new(0,0,1)
  else
    Geom::Vector3d.new(1,0,0)
  end
  
  ursprung = Geom::Point3d.new(achsenvektor.to_a.map{ |p| p * versatz })
  
  modell.start_operation "Kopieren und Rotieren"
  if gruppe = gruppe_aus_auswahl
    schrittweite = 2 * Math::PI / anzahl
  
    kopien = [gruppe]
    
    # Verschiebepunkt liegt in der geometrischen Mitte der Gruppe
    punkt = gruppe.transformation.origin  
    case(achse)
    when :x
      punkt.z = punkt.z + gruppe.bounds.depth / 2
      punkt.y = punkt.y - versatz
    when :y
      punkt.z = punkt.z + gruppe.bounds.depth / 2
      punkt.x = punkt.x - versatz
    when :z
      punkt.y = punkt.y + gruppe.bounds.height / 2
      punkt.x = punkt.x - versatz
    end
    (anzahl).times do |i|
      kopie = gruppe.copy
      kopie.transform! Geom::Transformation.rotation(punkt, achsenvektor, schrittweite * i)
      kopien << kopie
    end
    ganze_gruppe = model.entities.add_group(kopien)
  else    
    UI.messagebox "Sie haben nichts gutes selektiert was kopiert werden koennte", MB_OK
  end
  model.commit_operation
end


def kopieren_und_rotieren_mit_dialog
  namen = ['Anzahl', 'Abstand', 'Achse']
  werte = [10, 10,'x']
  optionen = [nil, nil, 'x|y|z']
  resultat = UI.inputbox namen, werte, optionen, "Kopieren und Rotieren"
  anzahl, versatz, achse = resultat
  kopieren_und_rotieren(anzahl, versatz, achse.to_sym)
end


unless file_loaded? File.basename(__FILE__) 
  UI.add_context_menu_handler do |menue|
    if modell.selection.length > 0
      menue.add_separator
      menue.add_item("Kopieren und Rotieren") { kopieren_und_rotieren_mit_dialog }
    end
  end
end

file_loaded File.basename(__FILE__)