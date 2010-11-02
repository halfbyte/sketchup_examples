require 'sketchup'
def frame(width, height, thickness, depth)
  model = Sketchup.active_model
  group = model.entities.add_group
  outer_face = group.entities.add_face(
    [0,0,0],
    [width, 0,0],
    [width, height, 0],
    [0, height, 0]
  )
  face = group.entities.add_face(
    [thickness, thickness, 0],
    [width - thickness, thickness, 0],
    [width - thickness, height - thickness, 0],
    [thickness, height - thickness, 0]
  )
  face.erase!
  outer_face.pushpull(depth)  
end