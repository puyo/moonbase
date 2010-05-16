$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'moonbase/game'

game = Moonbase::Game.new :players => [
  Player.new(:name => 'P1'),
  Player.new(:name => 'P2'),
]
game.setup
loop { game.tick }

