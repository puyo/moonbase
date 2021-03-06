module Moonbase
  class Phase; end
  class CreatePhase < Phase; end
  class OrdersPhase < Phase
    METHOD = :update_orders
  end
  class MovePhase < Phase
    METHOD = :update_move
  end
  class QuitPhase < Phase; end

  class Mode; end
  class HotseatMode < Mode
    attr_accessor :player
    METHOD = :update_hotseat
  end

  class Game
    include Moonbase::Logger

    attr_reader :map, :phase, :hubs, :bombs, :window, :viewport

    attr_accessor :power_delta
    attr_accessor :angle_delta
    attr_accessor :power

    def initialize(opts = {})
      self.phase = CreatePhase
      @window = opts[:window]
      @mode = @hotseat = HotseatMode.new
      @player_map = {}
      @map = nil
      @power = 0
      @power_delta = 0
      @angle_delta = 0.0

      demo
      start
    end

    def demo
      p1 = Moonbase::Player.new(:name => 'P1', :color => [127, 200, 255])
      p2 = Moonbase::Player.new(:name => 'P2', :color => [255, 64, 0])
      add_player p1
      add_player p2
      add_hub Hub.new(:position => Vector3D.new(200, 200, 0), :owner => p1)
      add_hub Hub.new(:position => Vector3D.new(250, 100, 0), :owner => p2)
      @map = Map.new(:game => self, :width => 100, :height => 100)
    end

    def players
      @player_map.values
    end

    def orders
      players.map(&:order).compact
    end

    def start
      start_turn
    end

    def hotseat_start
      set_hotseat_player(players.first)
    end

    def set_hotseat_player(player)
      logger.debug { "hotseat.player = #{player.id}" }
      @hotseat.player = player
    end

    def update
      send(@phase::METHOD)
    end

    def bombs
      players.map(&:bombs).flatten
    end

    def hubs
      players.map(&:hubs).flatten
    end

    def update_move
      bombs.each(&:update)
      check_collisions
      start_turn if not still_moving?
    end

    def start_turn
      self.phase = OrdersPhase
      hotseat_start if @mode === @hotseat
      players.each{|p| p.on_turn_start(self) }
    end

    def still_moving?
      bombs.size > 0
    end

    def update_orders
      send(@mode.class::METHOD)
      if not awaiting_orders?
        process_orders
        self.phase = MovePhase
      end
    end

    def update_hotseat
      b = @hotseat.player.selected_building
      if b
        b.angle += @angle_delta
        while b.angle > 360.0
          b.angle -= 360.0
        end
        while b.angle < 0
          b.angle += 360.0
        end
        if @power_delta != 0
          self.power = @power + @power_delta
        end
      end

      if @hotseat.player.order
        next_player = players.find{|p| p.order.nil? }
        set_hotseat_player(next_player) if next_player
      end
    end

    def process_orders
      players.each do |player|
        player.order.process(self, player) if player.order
        player.order = nil
      end
    end

    def awaiting_orders?
      orders.size < players.size
    end

    def add_player(player)
      id = player.id = (@player_map.keys.max || 0).next
      @player_map[id] = player
    end

    def add_hub(hub)
      hub.game = self
      hub.owner.hubs.push(hub)
    end

    def add_bomb(bomb)
      bomb.game = self
      bomb.owner.bombs.push(bomb)
    end

    def destroy_bomb(bomb)
      bomb.owner.bombs.delete(bomb)
    end

    def set_order(player, order)
      player.order = order
    end

    def remove_player(player)
      @player_map.delete(player.id)
      self.phase = QuitPhase if @player_map.empty?
    end

    def power=(value)
      if value > 100
        value = 100
        @power_delta = -@power_delta
      end
      if value < 0
        value = 0
        @power_delta = -@power_delta
      end
      @power = value
    end

    def record_order
      @power_delta = 0
      if @power > 0
        b = @hotseat.player.selected_building
        if b
          a = b.angle - 45.0
          scale = (@power/10.0) + 5
          vel = Vector3D.new(Math.cos(self.class.deg_to_rad(a)), Math.sin(self.class.deg_to_rad(a)), 1.0).multiply_by(scale)
          bomb = Bomb.new(:owner => @hotseat.player, :position => b.position, :velocity => vel)
          @hotseat.player.order = ShootOrder.new(:projectile => bomb)
        end
        self.power = 0
      end
    end

    private

    def self.deg_to_rad(angle)
      angle * 2 * Math::PI / 360.0
    end

    def phase=(phase)
      logger.debug { "game.phase = #{phase}" }
      @phase = phase
    end

    def check_collisions
      bombs.each do |bomb|
        if bomb.position.h < @map.height_at([bomb.position.x, bomb.position.y])
          destroy_bomb(bomb)
        end
      end
    end
  end
end
