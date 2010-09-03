require 'moonbase/player'

include Moonbase

describe Player, 'being created' do
  it 'supports valid parameters' do
    lambda do
      Player.new(:name => 'hi')
    end.should_not raise_exception
  end

  it 'starts with 11 energy' do
    p = Player.new(:name => 'test')
    p.energy.should == 11
  end

  it 'grows energy each turn' do
    p = Player.new(:name => 'test')
    e0 = p.energy
    game = mock('game')
    p.on_turn_start(game)
    p.energy.should > e0
  end

  it 'sets orders on game' do
    # probably only for AI, but anyway
    p = Player.new(:name => 'test')
    game = mock('game')
    game.should_receive(:set_order)
    p.request_order(game)
  end
end
