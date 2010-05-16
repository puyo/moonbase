require 'moonbase/buildings'

include Moonbase

describe Hub do
  describe 'creation' do
    it 'supports valid parameters' do
      lambda do
        Hub.new
      end.should_not raise_exception
    end
  end
end
