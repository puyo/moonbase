$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'moonbase/game'

include Moonbase

game = Game.new :players => [
  Player.new(:name => 'P1'),
  Player.new(:name => 'P2'),
]
game.setup
loop { break if not game.tick }
