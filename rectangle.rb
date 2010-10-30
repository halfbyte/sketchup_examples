require 'sketchup'
def create_rectangle(width, height)
  model = Sketchup.active_model
  entities = model.entities
  pt1 = [0, 0, 0]
  pt4 = [0, height, 0]
  pt3 = [width, height, 0]
  pt2 = [width, 0, 0]
  new_face = entities.add_face pt1, pt2, pt3, pt4
end

def create_box(width, height, depth)
  face = create_rectangle(width, height)
  face.reverse!
  face.pushpull(depth)
end