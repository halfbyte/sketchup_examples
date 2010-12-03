desc "Hook in das Sketchup-Plugins-Verzeichnis installieren"
task :install_hook do
  
  plattform = (Object::RUBY_PLATFORM =~ /mswin/i) ? :windows : ((Object::RUBY_PLATFORM =~ /darwin/i) ? :mac : :other)
  
  installationspfad = if plattform == :windows
    "C:/Program Files/Google/Google SketchUp 8/Plugins"
  elsif platform == :mac
    "/Library/Application Support/Google SketchUp 8/SketchUp/Plugins"
  else
    raise "Keine von Sketchup unterstützte Plattform"
  end
  
  dieser_pfad = File.expand_path(File.dirname(__FILE__))
  
  File.open(File.join(installationspfad, "load_examples.rb"), 'wb') do |datei|
    datei.puts "# basisverzeichnis und lib zum load_path hinzufuegen"
    datei.puts "$LOAD_PATH.unshift('#{dieser_pfad}')"
    datei.puts "$LOAD_PATH.unshift('#{File.join(dieser_pfad, 'lib')}')"
    datei.puts "# alle beispiele laden"
    datei.puts "require_all('#{dieser_pfad}')"
  end
  
  puts "Hook ist installiert. Sie muessen Sketchup jetzt neu starten."
  
  
end