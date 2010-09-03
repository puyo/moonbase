require 'moonbase/bomb'

include Moonbase

describe Bomb do
  before(:each) do
    @bomb = Bomb.new(:position => [0,0,0], :velocity => [100,100,100])
  end

  context '#update_position' do
    it 'should fall under gravity' do
      old_height = @bomb.velocity[2]
      @bomb.update(1)
      new_height = @bomb.velocity[2]
      new_height.should < old_height
    end
  end
end
