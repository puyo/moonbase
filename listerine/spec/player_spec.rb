require 'spec_helper'
require 'moonbase/player'

include Moonbase

describe Player do
  before :each do
    @player = Player.new(:name => 'test')
  end

  context '#energy' do
    it 'should start at 11' do
      @player.energy.should == 11
    end

    it 'should grow' do
      proc { @player.increase_energy }.should change(@player, :energy).by_at_least(1)
    end
  end
end
