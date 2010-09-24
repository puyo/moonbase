require 'moonbase/player'
require 'moonbase/map'
require 'moonbase/order'
require 'moonbase/vector3d'
require 'moonbase/map_view'
require 'moonbase/hub'
require 'moonbase/hub_view'
require 'moonbase/bomb'
require 'moonbase/bomb_view'
require 'moonbase/shadow'
require 'moonbase/create_phase'
require 'moonbase/orders_phase'
require 'moonbase/move_phase'
require 'moonbase/quit_phase'
require 'moonbase/viewport'
require 'moonbase/logger'
require 'rubygame'

module Moonbase
  class Game
    include Rubygame
    include EventHandler::HasEventHandler
    include Moonbase::Logger

    attr_reader :map, :phase, :hubs, :bombs

    def initialize(opts = {})
      set_phase CreatePhase
      @mode = :hotseat
      @players = {}
      @map = nil
      @hotseat_player = nil

      @bomb_views = Hash.new {|h, k| h[k] = [] }
      create_sprite_group
      create_game_demo
      create_pressed_hooks
      create_released_hooks
      make_magic_hooks({
        :tick => proc { |target, event| target.tick(event.milliseconds) },
        :mouse_left => :on_mouse_click,
      })
      append_hook :owner => self, :trigger => EventTriggers::MouseMoveTrigger.new, :action => EventActions::MethodAction.new(:on_mouse_move)
      start
    end

    def players
      @players.values
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
      logger.debug { "game.hotseat_player = #{player}" }
      @hotseat_player = player
    end

    def tick(milliseconds)
      if @phase == OrdersPhase
        on_tick_orders(milliseconds)
      elsif @phase == MovePhase
        on_tick_move(milliseconds)
      end
    end

    def bombs
      players.map(&:bombs).flatten
    end

    def hubs
      players.map(&:hubs).flatten
    end

    def on_tick_move(milliseconds)
      bombs.each do |bomb|
        bomb.on_tick(milliseconds)
      end
      check_collisions
      start_turn if not still_moving?
    end

    def start_turn
      set_phase OrdersPhase
      hotseat_start if @mode == :hotseat
      players.each{|p| p.on_turn_start(self) }
    end

    def still_moving?
      bombs.size > 0
    end

    def on_tick_orders(milliseconds)
      if @mode == :hotseat
        @hotseat_player.request_order(self)
        if @hotseat_player.order
          next_player = players.find{|p| p.order.nil? }
          set_hotseat_player(next_player) if next_player
        end
      else
        players.each do |player|
          player.request_order(self)
        end
      end
      if not awaiting_orders?
        process_orders
        set_phase MovePhase
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
      id = player.id = (@players.keys.max || 0).next
      @players[id] = player
    end

    def add_hub(hub)
      hub.owner.hubs.push(hub)
      view = HubView.new(hub, @map_view)
      @sprite_group.push(view)
    end

    def add_bomb(bomb)
      bomb.owner.bombs.push(bomb)
      shadow = Shadow.new(bomb, @map_view)
      @sprite_group.push(shadow)
      view = BombView.new(bomb, @map_view)
      @sprite_group.push(view)
      @bomb_views[bomb].push view, shadow
    end

    def destroy_bomb(bomb)
      bomb.owner.bombs.delete(bomb)
      @bomb_views[bomb].each do |sprite|
        @sprite_group.delete(sprite)
      end
    end

    def set_order(player, order)
      player.order = order
    end

    def remove_player(player)
      @players.delete(player.id)
      if @players.empty?
        set_phase QuitPhase
      end
    end

    def map=(map)
      @map = map
      @viewport = Viewport.new
      @map_view = MapView.new(map, @viewport)
      @sprite_group.push(@map_view)
    end

    private

    def set_phase(phase)
      logger.debug { "game.phase = #{phase}" }
      @phase = phase
    end

    def create_sprite_group
      @sprite_group = Sprites::Group.new
      class << @sprite_group
        include Rubygame
        include EventHandler::HasEventHandler
        def on_draw(event)
          dirty_rects = draw(event.screen)
          event.screen.update_rects(dirty_rects)
        end
        def on_undraw(event)
          undraw(event.screen, event.background)
        end
      end
      @sprite_group.extend(Sprites::UpdateGroup)
      @sprite_group.make_magic_hooks({
        Moonbase::Events::DrawSprites => :on_draw,
        Moonbase::Events::UndrawSprites => :on_undraw,
        :tick => proc { |group, event| group.each{|s| s.update(event.milliseconds) } },
      })
      add_sprite_hooks(@sprite_group)
    end

    def create_pressed_hooks
      make_magic_hooks({
        :up    => map_scroll_hook(:vy, -1),
        :down  => map_scroll_hook(:vy,  1),
        :left  => map_scroll_hook(:vx, -1),
        :right => map_scroll_hook(:vx,  1),
      })
    end

    def create_released_hooks
      make_magic_hooks({
        Moonbase::Events.released(:up   ) => map_scroll_hook(:vy,  1),
        Moonbase::Events.released(:down ) => map_scroll_hook(:vy, -1),
        Moonbase::Events.released(:left ) => map_scroll_hook(:vx,  1),
        Moonbase::Events.released(:right) => map_scroll_hook(:vx, -1),
      })
    end

    def map_scroll_hook(coord, diff)
      proc { @map_view.send("#{coord}=", @map_view.send(coord) + diff) }
    end

    def create_game_demo
      p1 = Moonbase::Player.new(:name => 'P1', :color => [255, 0, 0])
      p2 = Moonbase::Player.new(:name => 'P2', :color => [64, 64, 255])
      add_player(p1)
      add_player(p2)
      map = Map.new(:width => 100, :height => 100)
      self.map = map
      h1 = Hub.new(:position => Vector3D.new(500, 100, 0), :owner => p1)
      add_hub(h1)
      h2 = Hub.new(:position => Vector3D.new(450, 300, 0), :owner => p2)
      add_hub(h2)
    end

    def on_mouse_click(event)
      return unless @phase == OrdersPhase
      coords = @map_view.surface_position(event.pos)
      coords[2] = 0 # ground is flat for now
      @hotseat_player.hubs.each do |hub|
        if hub.collision?(coords)
          hub.selected = !hub.selected
        else
          hub.selected = false
        end
      end
    end

    def on_mouse_move(event)
    end

    def check_collisions
      bombs.each do |bomb|
        if bomb.position.h < @map.height_at([bomb.position.x, bomb.position.y])
          destroy_bomb(bomb)
        end
      end
    end

    def add_sprite_hooks(*objects)
      objects.each do |object|
        append_hook :owner => object,
          :trigger => EventTriggers::YesTrigger.new,
          :action => EventActions::MethodAction.new(:handle)
      end
    end
  end
end
