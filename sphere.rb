require 'sketchup'
module JK
  class Kugel
    attr_reader :gruppe
    include CommonTools
    
    def self.dialog
      namen = ['Radius', 'Anzahl Segmente']
      werte = [20, 10]
      resultat = UI.inputbox namen, werte, "Kugel"
      Kugel.new(*resultat).komponente_platzieren
    end
    
    def initialize(radius, segmente)
      @radius = radius
      @segmente = segmente
      #puts "#{@radius}, #{@segmente}"
      @definition = Sketchup.active_model.definitions.add "Kugel"
      @definition.insertion_point = Geom::Point3d.new(0, 0, -@radius)
      punkte = punkte_fuer_kugel
      flaechen_hinzufuegen(punkte)
    end
    
    def komponente_platzieren
      modell.place_component @definition
    end
    
    def punkte_fuer_kugel
      reihen = @segmente / 2
      (1...(reihen)).to_a.map do |reihe|
        (0...@segmente).to_a.map do |spalte|
          punkte_fuer(reihe, spalte)
        end
      end      
    end
    
    def punkte_fuer(reihe, spalte)
      schrittweite = 2 * Math::PI / @segmente
      [
        @radius * Math.cos(schrittweite * spalte) * Math.sin(schrittweite * reihe), 
        @radius * Math.sin(schrittweite * spalte) * Math.sin(schrittweite * reihe), 
        @radius * Math.cos(schrittweite * reihe)
      ]      
    end
    
    def flaechen_hinzufuegen(punkte)
      @segmente.times do |spalte|
        # top
        @definition.entities.add_face([
          [0,0,@radius], 
          punkte.first[spalte],
          punkte.first[spalte-1]
        ])
        (punkte.size - 1).times do |reihe|
          # middle
          @definition.entities.add_face([
            punkte[reihe][spalte-1], 
            punkte[reihe][spalte], 
            punkte[reihe + 1][spalte], 
            punkte[reihe + 1][spalte - 1]
          ])
        end
        # bottom
        @definition.entities.add_face([
          punkte.last[spalte-1], 
          punkte.last[spalte], 
          [0,0, -@radius]
        ])
      end      
    end
    
  end
end

unless file_loaded? File.basename(__FILE__) 
  UI.menu("Plug-Ins").add_item("Kugel") do 
    JK::Kugel.dialog
  end
end
file_loaded File.basename(__FILE__) 
