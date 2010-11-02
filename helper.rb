def reload!
  Dir[File.expand_path(File.dirname(__FILE__)) + "/*.rb"].map do |file|
    puts "reloading #{file}"
    load file
  end.inject(true) {|memo, entry| memo && entry}
  
  
end