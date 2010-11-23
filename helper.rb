require 'sketchup'
module JK
  module ExampleHelper
    include Sketchup
    def self.reload!
      Dir[File.expand_path(File.dirname(__FILE__)) + "/*.rb"].map do |file|
        puts "reloading #{file}"
        load file
      end.inject(true) {|memo, entry| memo && entry}  
    end
  end
end
unless file_loaded? File.basename(__FILE__)
  UI.menu("Plug-Ins").add_separator
  UI.menu("Plug-Ins").add_item("Beispiele Neuladen") do
    JK::ExampleHelper::reload!
  end
end

file_loaded File.basename(__FILE__)
