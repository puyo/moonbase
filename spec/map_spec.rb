require 'moonbase/map'

describe Moonbase::Map do
  describe 'creation' do
    it 'supports valid parameters' do
      lambda do
        Map.new(:players => [])
      end.should_not raise_exception
    end
  end
end
