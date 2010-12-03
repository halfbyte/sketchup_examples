require 'sketchup'
module JK
  module BeispielHelper
    include Sketchup
    def self.neu_laden!
      Dir[File.expand_path(File.dirname(__FILE__)) + "/*.rb"].map do |datei|
        puts "lade #{datei} neu."
        load datei
      end.inject(true) {|memo, entry| memo && entry}  
    end
  end
end
unless file_loaded? File.basename(__FILE__)
  UI.menu("Plug-Ins").add_separator
  UI.menu("Plug-Ins").add_item("Beispiele Neuladen") do
    JK::BeispielHelper::neu_laden!
  end
end

file_loaded File.basename(__FILE__)
