require 'moonbase/player'

include Moonbase

describe Player, 'being created' do
  it 'supports valid parameters' do
    lambda do
      Player.new(:name => 'hi')
    end.should_not raise_exception
  end
end
