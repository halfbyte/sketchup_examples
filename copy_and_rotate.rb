require 'sketchup'

class CopyAndRotate
  
  def self.reload
    puts "reload"
    load File.expand_path(__FILE__)
  end
  
  include Sketchup
  def self.copy_and_rotate(num = 10, offset = 0,axis = :x)
    
    axis_vector = case(axis)
    when :x; Geom::Vector3d.new(1,0,0)
    when :y; Geom::Vector3d.new(0,1,0)
    when :z; Geom::Vector3d.new(0,0,1)
    else
      Geom::Vector3d.new(1,0,0)
    end
    
    origin = Geom::Point3d.new(axis_vector.to_a.map{ |p| p * offset })
    puts origin.to_a.inspect
    
    model = Sketchup.active_model
    if model.selection.length == 0
      UI.messagebox "To use this Plugin, select some shapes", MB_OK
      return false
    end

    model.start_operation "CopyRotator"

    group = if model.selection.length > 1
      model.entities.add_group(model.selection)
    elsif model.selection.first.is_a?(Group)
      model.selection.first
    else
      nil
    end
    
    if group.nil?
      UI.messagebox "Nichts gutes Selektiert", MB_OK
      return false
    end
    
    step = 2 * Math::PI / num
    
    copies = []
    
    (num).times do |i|
      copy = group.copy
      point = group.transformation.origin
      
      case(axis)
      when :x
        point.z = point.z + group.bounds.depth / 2
        point.y = point.y - offset
      when :y
        point.z = point.z + group.bounds.depth / 2
        point.x = point.x - offset
      when :z
        point.y = point.y + group.bounds.height / 2
        point.x = point.x - offset
      end
      
      #point.z = point.z + group.bounds.depth / 2
      
      copy.transform! Geom::Transformation.rotation(point, axis_vector, step * i)
      copies << copy
    end
    whole_group = model.entities.add_group(copies)
    
    model.commit_operation
    
  end
    
end