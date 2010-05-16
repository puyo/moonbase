require 'moonbase/player'
require 'moonbase/buildings'
require 'moonbase/wind'

module Moonbase
  class Map
    def initialize(opts = {})
      @width = opts[:width] || 100.0
      @height = opts[:height] || 100.0
      @players = opts[:players] || raise("Must specify players to the map")
      @buildings = []
      @wind = Wind.new(:direction => 0, :force => 0)
    end

    def self.create_predefined(game)
      map = new(:width => 100.0,
                :height => 100.0,
                :players => game.players)
      h1 = Hub.new(:x => 0.0,  :y => 0.0)
      h2 = Hub.new(:x => 50.0, :y => 50.0)
      game.add_building(game.players[0], h1)
      game.add_building(game.players[1], h2)
    end
  end
end
