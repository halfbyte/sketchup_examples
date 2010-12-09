require 'sketchup'
require 'werkzeuge'
module JK
  class ScrewThread
    include JK::Werkzeuge
    def initialize(inner_radius, outer_radius, length, lead, angle)
      @inner_radius = inner_radius.to_f
      @outer_radius = outer_radius.to_f
      @length = length.to_f
      @lead = lead.to_f
      @angle = angle.to_f
      
      @definition = modell.definitions.add "Screw Thread"
  		@definition.insertion_point = Geom::Point3d.new(0, 0, 0)
  		
      create_cylinder
      create_thread
    end
    def self.dialog
      dialog = UI::WebDialog.new("Schraubgewinde", false, 'screw-thread-dialog', 600, 600)
      dialog.set_file(File.join(File.dirname(__FILE__), 'html', 'screw_thread_form.html'))
      dialog.show
      dialog.add_action_callback("screw_thread_fill_defaults") do |dialog, params|
        puts "fill_defaults"
        dialog.execute_script("screw_thread_fill_defaults(#{10},#{13},#{20},#{4},#{60})")
      end
      
      dialog.add_action_callback("screw_thread_cancel") do |dialog, params|
        dialog.close
      end
      
      dialog.add_action_callback("screw_thread_create") do |dialog, params|
        puts params.inspect
        
        inner_radius = dialog.get_element_value("inner_radius").to_f
        outer_radius = dialog.get_element_value("outer_radius").to_f
        length = dialog.get_element_value("length").to_f
        lead = dialog.get_element_value("lead").to_f
        angle = dialog.get_element_value("angle").to_f
        dialog.close
        ScrewThread.new(inner_radius,outer_radius, length, lead, angle).place_component
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
      thickness = @outer_radius - @inner_radius
      z_diff = thickness / Math::tan(@angle / 180 * Math::PI)
      
      mesh = Geom::PolygonMesh.new 
      
      i = -1
      inner_points = []
      top_points = []
      bottom_points = []
      z = - (@lead * 2)
      
      
      
      
      while z < (@length + (@lead * 2))
        
        i += 1
        z += z_step 
        
        alpha = step * i
        top_radius = @inner_radius + thickness
        bottom_radius = @inner_radius + thickness
        inner_radius = @inner_radius
        
        tangens = Math::tan(@angle / 180 * Math::PI)
        #puts tangens
        z_bottom = z - z_diff
        z_top = z + z_diff        

        if z < 0 && z_top < 0 && z_bottom < 0 && z_bottom + (z_diff * 24) < 0
          puts "alles < null"
          next
        end



        if z_bottom < 0
          z_bottom = 0
          bottom_radius = @inner_radius + ((z - z_bottom) * tangens)
        end
        if z_bottom > @length
          z_bottom = @length
        end

        if z_top > @length
          z_top = @length
          top_radius = @inner_radius + ((z_top - z) * tangens)
        end


        
        if z_top < 0
          z_top = 0
        end
        
        # middle
        z_middle = z
        if z_middle > @length
          z_middle = @length
          inner_radius = @inner_radius + ((z_diff - (z_middle - z_bottom)) * tangens)
          puts(z_diff - (z_middle - z_bottom))
        end
        
        
        
        if z_middle < 0
          z_middle = 0
          inner_radius = @inner_radius + ((z_diff - z_top) * tangens)
        
        end
        # adding points
        if z_bottom <= z_middle && z_top >= z_middle && z_bottom < @length && z_top > 0
          inner_points << mesh.add_point([Math.cos(alpha) * inner_radius, Math.sin(alpha) * inner_radius, z_middle ])
        else
          inner_points << nil
        end
        if z_middle <= @length && z_top != z_bottom
          top_points << mesh.add_point([Math.cos(alpha) * top_radius, Math.sin(alpha) * top_radius, z_top ])
        else
          top_points << nil
        end
        if z_middle >= 0 && (z + z_diff - (z_step * 25)) <= @length 
          bottom_points << mesh.add_point([Math.cos(alpha) * bottom_radius, Math.sin(alpha) * bottom_radius, z_bottom ])
        else
          bottom_points << nil
        end
        
        # outer_points << mesh.add_point([Math.sin(alpha) * @outer_radius, Math.cos(alpha) * @outer_radius, z ])
        # inner_points_top << mesh.add_point([Math.sin(alpha) * @inner_radius, Math.cos(alpha) * @inner_radius, z_top])
        # inner_points_bottom << mesh.add_point([Math.sin(alpha) * @inner_radius, Math.cos(alpha) * @inner_radius, z_bottom])
        
       
      end
      (inner_points.length - 1).times do |i|
        if (inner_points[i] && top_points[i] && inner_points[i + 1] && top_points[i + 1])
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
        end
        if (inner_points[i] && bottom_points[i] && inner_points[i+1] && bottom_points[i+1])
          mesh.add_polygon([
            inner_points[i], 
            inner_points[i+1],
            bottom_points[i]
          
          ])
          mesh.add_polygon([
            inner_points[i+1],
            bottom_points[i+1],
            bottom_points[i]
          ])    
        end
        if bottom_points[i] && top_points[i - 24] && bottom_points[i+1] && top_points [i - 23]
          mesh.add_polygon([
            bottom_points[i], 
            bottom_points[i + 1],
            top_points[i - 24]
            
          ])
          mesh.add_polygon([
            bottom_points[i + 1],
            top_points[i - 23], 
            top_points[i - 24]
          ])        
        end
      end
      
     
      
      
      
      @definition.entities.add_faces_from_mesh(mesh, 0)
      
      
    end
    
    def place_component
      modell.place_component @definition
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
