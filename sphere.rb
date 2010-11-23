require 'sketchup'
module JK
  class Sphere
    attr_reader :group
    include CommonTools
    
    def self.dialog
      prompts = ['Radius', 'Anzahl Segmente']
      values = [20, 10]
      result = UI.inputbox prompts, values, "Kugel"
      Sphere.new(*result).place_component
    end
    
    def initialize(radius, segments)
      @radius = radius
      @segments = segments
  		@definition = Sketchup.active_model.definitions.add "Sphere"
  		@definition.insertion_point = Geom::Point3d.new(0, 0, -@radius)
      points = points_for_sphere
      add_faces(points)
    end
    
    def place_component
      model.place_component @definition
    end
    
    def points_for_sphere
      rows = @segments / 2
      (1...(rows)).to_a.map do |row|
        (0...@segments).to_a.map do |col|
          point_for(row, col)
        end
      end      
    end
    
    def point_for(row, col)
      step = 2 * Math::PI / @segments
      [
        @radius * Math.cos(step * col) * Math.sin(step * row), 
        @radius * Math.sin(step * col) * Math.sin(step * row), 
        @radius * Math.cos(step * row)
      ]      
    end
    
    def add_faces(points)
      @segments.times do |col|
        # top
        @definition.entities.add_face([
          [0,0,@radius], 
          points.first[col],
          points.first[col-1]
        ])
        (points.size - 1).times do |row|
          # middle
          @definition.entities.add_face([
            points[row][col-1], 
            points[row][col], 
            points[row + 1][col], 
            points[row + 1][col - 1]
          ])
        end
        # bottom
        @definition.entities.add_face([
          points.last[col-1], 
          points.last[col], 
          [0,0, -@radius]
        ])
      end      
    end
    
  end
end

unless file_loaded? File.basename(__FILE__) 
  UI.menu("Plug-Ins").add_item("Kugel") do 
    JK::Sphere.dialog
  end
end
file_loaded File.basename(__FILE__) 
