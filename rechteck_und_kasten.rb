require 'sketchup'
def rechteck(breite, hoehe)
  modell = Sketchup.active_model
  entities = modell.entities
  pt1 = [0, 0, 0]
  pt4 = [0, hoehe, 0]
  pt3 = [breite, hoehe, 0]
  pt2 = [breite, 0, 0]
  neue_flaeche = entities.add_face pt1, pt2, pt3, pt4
end

def kasten(breite, hoehe, tiefe)
  flaeche = rechteck(breite, hoehe)
  flaeche.reverse!
  flaeche.pushpull(tiefe)
end