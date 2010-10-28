# First we pull in the standard API hooks.
require 'sketchup'

# Show the Ruby Console at startup so we can
# see any programming errors we may make.
#Sketchup.send_action "showRubyPanel:"

# Add a menu item to launch our plugin.
UI.menu("PlugIns").add_item("Draw stairs 2") {
  draw_stairs
}

def draw_stairs
  # Get "handles" to our model and the Entities collection it contains.
  model = Sketchup.active_model
  entities = model.entities

  # Create a series of "points", each a 3-item array containing x, y, and z.
  pt1 = [0, 0, 0]
  pt2 = [15, 0, 0]
  pt3 = [15, 9, 0]
  pt4 = [0, 9, 0]
  
  # Call methods on the Entities collection to draw stuff.
  new_face = entities.add_face(pt1, pt2, pt3, pt4)
  new_face.pushpull(-3)
end