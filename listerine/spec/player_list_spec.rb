require 'spec_helper'
require 'moonbase/player'

include Moonbase

describe PlayerList do

  context '#start_turn' do
    before(:each) do
      @player = mock('player')
      @player.stub(:increase_energy)
      @list = PlayerList.new
      @list.add(@player)
    end

    after(:each) do
      @list.start_turn
    end

    it "should add energy to the player" do
      @player.should_receive(:increase_energy)
    end
  end
end
