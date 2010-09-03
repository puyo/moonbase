require 'moonbase/game'

include Moonbase

describe Game do
  before(:each) do
    @game = Game.new
    @players = [mock('player 1'), mock('player 2')]
    @players.each do |p|
      p.extend(Emitter)
      p.stub(:increase_energy)
      p.stub(:request_order)
      p.stub(:order)
      @game.add_player(p)
    end
  end

  it 'should be in the create phase initially' do
    @game.phase.should == :create
  end

  context 'once started' do
    before(:each) do
      @game.start
    end

    it 'should enter the orders phase' do
      @game.phase.should == :orders
    end

    it 'should enter the action phase once all orders are in' do
      provide_all_orders
      @game.phase.should == :action
    end
  end

  context 'in the action phase' do
    before(:each) do
      @game.start
      provide_all_orders
      @bomb = mock('bomb')
      @game.add_bomb(@bomb)
    end

    it 'should emit updates to move the game objects' do
      @bomb.should_receive(:update).with(1)
      @game.update(1)
    end

    it 'should detect collisions'
  end
end

def provide_all_orders
  @players.each do |player|
    player.stub(:order).and_return(mock('order'))
    player.emit(:order)
  end
end
