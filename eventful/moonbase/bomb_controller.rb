module Moonbase
  module BombController
    def bombs
      @bombs ||= []
    end

    def add_bomb(bomb)
      bombs.push(bomb)
      update_hook = on(:update) do |dt|
        bomb.update(dt)
      end
    end
  end
end
