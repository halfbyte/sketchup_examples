module JK
  class ScrewThread
    def initialize(inner_radius, outer_radius, length, lead, angle)
      @inner_radius = inner_radius.to_f
      @outer_radius = outer_radius.to_f
      @length = length.to_f
      @lead = lead.to_f
      @angle = angle.to_f
      
      @definition = Sketchup.active_model.definitions.add "Screw Thread"
  		@definition.insertion_point = Geom::Point3d.new(0, 0, 0)
  		
      create_cylinder
      create_thread
    end
    def self.dialog
      dialog = UI::WebDialog.new("Schraubgewinde", false, 'screw-thread-dialog', 600, 600)
      dialog.set_file(File.join(File.dirname(__FILE__), 'html', 'screw_thread_form.html'))
      dialog.show_modal
      dialog.add_action_callback("screw_thread_fill_defaults") do |dialog, params|
        puts "fill_defaults"
        dialog.execute_script("screw_thread_fill_defaults(#{20},#{22},#{20},#{10},#{60})")
      end
      
      dialog.add_action_callback("screw_thread_cancel") do |dialog, params|
        dialog.close
      end
      
      dialog.add_action_callback("screw_thread_create") do |dialog, params|
        puts params.inspect
        
        # inner_radius = dialog.get_element_value("inner_radius").to_f
        # outer_radius = dialog.get_element_value("outer_radius").to_f
        # length = dialog.get_element_value("length").to_f
        # lead = dialog.get_element_value("lead").to_f
        # angle = dialog.get_element_value("angle").to_f
        # dialog.close
        # ScrewThread.new(inner_radius,outer_radius, length, lead, angle).place_component
      end
    end
        
    def create_cylinder
      circle = @definition.entities.add_circle([0,0,0], [0,0,1], @inner_radius, 24)
      face = @definition.entities.add_face circle
      face.pushpull(-@length)
    end
   
    def create_thread
      step = 2 * Math::PI / 24.0
      z_step = @lead.to_f / 24.0
      
      z_diff = (@outer_radius - @inner_radius) / Math::tan(@angle / 180 * Math::PI)
      
      mesh = Geom::PolygonMesh.new 
      
      i = 0
      inner_points = []
      top_points = []
      bottom_points = []
      z = 0
      
      
      
      while z < @length do
        z = z_step * i
        alpha = step * i
        z_bottom = z - z_diff
        if z_bottom < 0
          z_bottom = 0
          # TODO: anpassung radius für diesen fall damit Winkel konstant bleibt.
        end
        z_top = z + z_diff
        z_top = @length if (z_top > @length)
        
        inner_points << mesh.add_point([Math.sin(alpha) * @inner_radius, Math.cos(alpha) * @inner_radius, z ])
        top_points << mesh.add_point([Math.sin(alpha) * @outer_radius, Math.cos(alpha) * @outer_radius, z_top ])
        bottom_points << mesh.add_point([Math.sin(alpha) * @outer_radius, Math.cos(alpha) * @outer_radius, z_bottom ])
        
        # outer_points << mesh.add_point([Math.sin(alpha) * @outer_radius, Math.cos(alpha) * @outer_radius, z ])
        # inner_points_top << mesh.add_point([Math.sin(alpha) * @inner_radius, Math.cos(alpha) * @inner_radius, z_top])
        # inner_points_bottom << mesh.add_point([Math.sin(alpha) * @inner_radius, Math.cos(alpha) * @inner_radius, z_bottom])
        
        i += 1
      end
      (inner_points.length - 1).times do |i|
        mesh.add_polygon([
          inner_points[i], 
          top_points[i], 
          inner_points[i+1]
        ])
        mesh.add_polygon([
          inner_points[i+1],
          top_points[i], 
          top_points[i+1]
        ])
        mesh.add_polygon([
          inner_points[i], 
          bottom_points[i], 
          inner_points[i+1]
        ])
        mesh.add_polygon([
          inner_points[i+1],
          bottom_points[i], 
          bottom_points[i+1]
        ])        
        if i >= 24
          mesh.add_polygon([
            bottom_points[i], 
            top_points[i - 24], 
            bottom_points[i + 1]
          ])
          mesh.add_polygon([
            bottom_points[i + 1],
            top_points[i - 23], 
            top_points[i - 24]
          ])        
        else
          # special solution.
        end
      end
      
      
      # mesh.add_polygon(inner_points_bottom.first, inner_points_top.first, outer_points.first)
      # mesh.add_polygon(inner_points_bottom.last, inner_points_top.last, outer_points.last)
      @definition.entities.add_faces_from_mesh(mesh, 0)
      
      
    end
    
    def place_component
      model.place_component @definition
    end
    
   
    
  end
end

# JK::ScrewThread.new(20,22, 100, 5, 60)

unless file_loaded? File.basename(__FILE__) 
  UI.menu("Plug-Ins").add_item("Gewinde") do 
    JK::ScrewThread.dialog
  end
end
file_loaded File.basename(__FILE__) 
