desc "install hook into Sketchup folder"
task :install_hook do
  
  platform = (Object::RUBY_PLATFORM =~ /mswin/i) ? :windows : ((Object::RUBY_PLATFORM =~ /darwin/i) ? :mac : :other)
  
  install_path = if platform == :windows
    "C:/Program Files/Google/Google SketchUp 8/Plugins"
  elsif platform == :mac
    "/Library/Application Support/Google SketchUp 8/SketchUp/Plugins"
  else
    raise "Not on a supported platform. Doh."
  end
  
  this_path = File.expand_path(File.dirname(__FILE__))
  
  File.open(File.join(install_path, "load_examples.rb"), 'wb') do |file|
    file.puts "# require all examples"
    file.puts "require_all('#{this_path}')"
    file.puts "# add base dir and lib to load path for easier debugging"
    file.puts "$LOAD_PATH.unshift('#{this_path}')"
    file.puts "$LOAD_PATH.unshift('#{File.join(this_path, 'lib')}')"
  end
  
  puts "installed hook. you need to restart SketchUp now!"
  
  
end