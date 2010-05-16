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
      player = mock('test player')
      player.stub!(:energy).and_return(0)
      player.should_receive(:request_order).and_return(SkipOrder.new)
      game = Game.new(:players => [player])
      game.setup
      game.awaiting_orders?.should be_true
      game.tick # requested orders, obtained orders, processed orders
    end

    it 'causes projectiles to move' do
      player = mock('test player')
      building = Hub.new(:position => Vector3D.origin)
      order = ShootOrder.new(:from => building, :direction => 0, :power => 10, :projectile_class => Bomb)
      player.should_receive(:request_order).and_return(order)
      game = Game.new(:players => [player])
      game.setup
      game.tick # orders
      game.projectiles.should_not be_empty
      game.tick # projectile moved
    end

    it 'returns to orders phase once projectiles are finished'
  end
end
