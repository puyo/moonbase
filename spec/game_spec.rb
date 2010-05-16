require 'moonbase/game'
require 'moonbase/projectiles'

include Moonbase

describe Game do
  describe 'creation' do
    it 'supports valid parameters' do
      lambda do
        Game.new(:players => [Player.new(:name => 'Test')])
      end.should_not raise_exception
    end
  end

  describe 'tick' do
    it 'requests orders from players' do
      player = mock('skippy')
      player.stub!(:energy).and_return(0)
      player.should_receive(:request_order).and_return(SkipOrder.new)
      game = Game.new(:players => [player])
      game.setup
      game.awaiting_orders?.should be_true
      game.tick # requested orders, obtained orders, processed orders
    end

    it 'causes projectiles to move' do
      player = mock('shoota')
      building = Hub.new(:position => Vector3D.origin)
      order = ShootOrder.new(:from => building, 
                             :direction => 0, 
                             :power => 10, 
                             :projectile_class => Bomb)
      player.should_receive(:request_order).and_return(order)
      game = Game.new(:players => [player])
      game.setup
      game.tick # orders
      game.projectiles.should_not be_empty
      bomb = game.projectiles[player].first
      position0 = bomb.position.dup
      game.tick # projectile moved
      bomb.position.should_not == position0
    end

    it 'returns to orders phase once projectiles are finished' do
      player = mock('skippy')
      player.should_receive(:request_order).and_return(SkipOrder.new)
      game = Game.new(:players => [player])
      player.should_receive(:on_turn_start).with(game)
      game.setup
      game.tick # get orders
      game.tick # try moving, realise nothing needs to be done, go back for orders
    end

    it 'marks phase as quit if all players leave' do
      player = mock('leaver')
      player.should_receive(:request_order).and_return(QuitOrder.new)
      game = Game.new(:players => [player])
      game.setup
      game.tick # get orders
      game.tick # process orders
      game.phase.should == :quit
    end
  end
end
