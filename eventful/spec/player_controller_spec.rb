require 'moonbase/player_controller'
require 'moonbase/emitter'

include Moonbase

describe PlayerController do
  include PlayerController
  include Emitter

  context 'on a turn event' do
    before(:each) do
      @player = mock('player')
      @player.extend(Emitter)
      @player.stub(:increase_energy)
      add_player(@player)
    end

    after(:each) do
      emit(:turn)
    end

    it "should add energy to the player" do
      @player.should_receive(:increase_energy)
    end
  end

  context 'on an orders event' do
    it 'should emit orders' do
    end
  end
end
