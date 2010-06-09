require 'moonbase/buildings'
require 'moonbase/vector3d'

include Moonbase

describe Hub do
  describe 'creation' do
    it 'supports valid parameters' do
      lambda do
        Hub.new(:position => Vector3D.origin, :owner => Player.new(:name => 'hi'))
      end.should_not raise_exception
    end
  end
end
