require 'moonbase/wind'

include Moonbase

describe Wind do
  describe 'creation' do
    it 'supports valid parameters' do
      lambda do
        Wind.new
      end.should_not raise_exception
    end
  end
end
