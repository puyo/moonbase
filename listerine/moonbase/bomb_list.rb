module Moonbase
  class BombList
    def initialize
      @bombs = []
    end

    def add(bomb)
      @bombs.push(bomb)
    end

    def update(dt)
      @bombs.each{|b| b.update(dt) }
    end
  end
end
