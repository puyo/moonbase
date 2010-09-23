require 'moonbase/order'
require 'moonbase/hub'
require 'moonbase/bomb'

include Moonbase

describe Order do
  describe 'creation' do
    it 'supports valid parameters' do
      lambda do
        SkipOrder.new
      end.should_not raise_exception
      lambda do
        ShootOrder.new(:from => Vector3D.new(0, 0, 0),
                       :projectile_class => Bomb,
                       :direction => 20.0,
                       :power => 30.0)
      end.should_not raise_exception
    end
  end
end