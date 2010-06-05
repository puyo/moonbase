require 'moonbase/game'
require 'moonbase/projectiles'

include Moonbase

describe Game do
  describe 'creation' do
    it 'supports valid parameters' do
      lambda do
        new_game_with_players Player.new(:name => 'Test')
      end.should_not raise_exception
    end
  end

  def new_game_with_players(*players)
    map = Map.new
    Game.new(:players => players, :map => map)
  end

  def new_skippy
    skippy = mock('skippy')
    skippy.stub!(:energy).and_return(0)
    skippy.should_receive(:request_order).and_return(SkipOrder.new)
    skippy
  end

  def new_shoota
    shoota = mock('shoota')
    order = ShootOrder.new(:from => Vector3D.origin,
                           :direction => 0, 
                           :power => 10, 
                           :projectile_class => Bomb)
    shoota.should_receive(:request_order).and_return(order)
    shoota
  end

  describe 'tick' do
    it 'requests orders from players' do
      skippy = new_skippy
      game = new_game_with_players(skippy)
      game.awaiting_orders?.should be_true
      game.tick # requested orders, obtained orders, processed orders
    end

    it 'causes projectiles to move' do
      shoota = new_shoota
      game = new_game_with_players(shoota)
      game.tick # orders
      game.projectiles.should_not be_empty
      bomb = game.projectiles[shoota].first
      position0 = bomb.position.dup
      game.tick # projectile moved
      bomb.position.should_not == position0
    end

    it 'returns to orders phase once projectiles are finished' do
      skippy = new_skippy
      game = new_game_with_players(skippy)
      skippy.should_receive(:on_turn_start).with(game)
      game.tick # get orders
      game.tick # try moving, realise nothing needs to be done, go back for orders
    end

    it 'marks phase as quit if all players leave' do
      leaver = mock('leaver')
      leaver.should_receive(:request_order).and_return(QuitOrder.new)
      game = new_game_with_players(leaver)
      game.tick # get orders
      game.tick # process orders
      game.phase.should == :quit
    end
  end
end
