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
  outer_face.reverse!
  outer_face.pushpull(depth)  
end


def frame_with_inputbox
  prompts = ['Breite', 'Höhe', 'Dicke', 'Tiefe']
  values = [20, 20, 5, 5]
  result = UI.inputbox prompts, values, "Create Frame"
  frame(*result)
end

unless file_loaded? File.basename(__FILE__) 
  UI.menu("Plug-Ins").add_item("Draw Frame") do 
    frame_with_inputbox
  end
end

file_loaded File.basename(__FILE__) 
