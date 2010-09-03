require 'spec_helper'
require 'moonbase/bomb_list'

include Moonbase

describe BombList do

  context 'on an update event' do
    before(:each) do
      @bomb = mock('bomb')
      @bomb.extend(Emitter)
      @list = BombList.new
      @list.add(@bomb)
    end
  end
end
