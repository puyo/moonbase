require 'moonbase/order'
require 'moonbase/buildings'
require 'moonbase/projectiles'

include Moonbase

describe Order do
  describe 'creation' do
    it 'supports valid parameters' do
      lambda do
        SkipOrder.new
      end.should_not raise_exception
      lambda do
        ShootOrder.new(:from => Hub.new, 
                       :projectile_class => Bomb,
                       :direction => 20.0, 
                       :power => 30.0)
      end.should_not raise_exception
    end
  end
end
