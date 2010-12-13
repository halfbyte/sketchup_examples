require 'sketchup'
def rechteck(breite, tiefe)
  modell = Sketchup.active_model
  entities = modell.entities
  pt1 = [0, 0, 0]
  pt2 = [0, tiefe, 0]
  pt3 = [breite, tiefe, 0]
  pt4 = [breite, 0, 0]
  neue_flaeche = entities.add_face pt1, pt2, pt3, pt4
end

def kasten(breite, tiefe, hoehe)
  flaeche = rechteck(breite, tiefe)
  flaeche.reverse!
  flaeche.pushpull(hoehe)
end