require 'sketchup'

def rahmen(breite, hoehe, tiefe, dicke)
  modell = Sketchup.active_model
  gruppe = modell.entities.add_group
  aussenflaeche = gruppe.entities.add_face(
    [0,0,0],
    [breite, 0,0],
    [breite, hoehe, 0],
    [0, hoehe, 0]
  )
  innenflaeche = gruppe.entities.add_face(
    [dicke, dicke, 0],
    [breite - dicke, dicke, 0],
    [breite - dicke, hoehe - dicke, 0],
    [dicke, hoehe - dicke, 0]
  )
  innenflaeche.erase!
  aussenflaeche.reverse!
  aussenflaeche.pushpull(tiefe)  
end


def rahmen_mit_dialog
  namen = ['Breite', 'Hoehe', 'Tiefe', 'Dicke']
  werte = [20, 20, 5, 5]
  resultat = UI.inputbox namen, werte, "Rahmen erstellen"
  rahmen(*resultat)
end

unless file_loaded? File.basename(__FILE__) 
  UI.menu("Plug-Ins").add_item("Rahmen erstellen") do 
    rahmen_mit_dialog
  end
end

file_loaded File.basename(__FILE__) 
