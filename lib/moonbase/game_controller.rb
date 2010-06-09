require 'moonbase/game'
require 'moonbase/map_view'
require 'moonbase/building_views'

module Moonbase
  class GameController
    include EventHandler::HasEventHandler

    def initialize
      @building_views = Hash.new {|h, k| h[k] = [] }
      create_sprite_group
      create_game
      create_pressed_hooks
      create_released_hooks
    end

    private

    def create_sprite_group
      @grp = Sprites::Group.new
      class << @grp
        include EventHandler::HasEventHandler
        def on_draw(event)
          dirty_rects = draw(event.screen)
          event.screen.update_rects(dirty_rects)
        end
        def on_undraw(event)
          undraw(event.screen, event.background)
        end
      end
      @grp.extend(Sprites::UpdateGroup)
      @grp.make_magic_hooks({
        Moonbase::Events::DrawSprites => :on_draw,
        Moonbase::Events::UndrawSprites => :on_undraw,
        :tick => :update,
      })
      add_sprite_hooks(@grp)
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

    def create_game
      @game = Game.new
      create_game_demo
    end

    # game_controller.new_game
    # game_controller.add_player
    # game_controller.add_building
    # game_controller.add_building
    # game_controller.generate_map
    # game_controller.start

    def create_game_demo
      p1 = Moonbase::Player.new(:name => 'P1')
      p2 = Moonbase::Player.new(:name => 'P2')
      add_player(p1)
      add_player(p2)
      map = Map.new(:width => 100, :height => 100)
      set_map map
      h1 = Hub.new(:position => Map.coordinate_3d([500, 500]), :owner => p1)
      add_building(h1)
    end
    
    def set_map(map)
      @game.map = map
      @map_view = MapView.new(map)
      @grp.push(@map_view)
    end

    def add_player(player)
      @game.add_player(player)
    end

    def add_building(building)
      @game.add_building(building)
      view = BuildingView.new(building)
      @building_views[building] = view
      @grp.push(view)
    end

    def on_projectile_create(projectile)
    end

    def add_sprite_hooks(*objects)
      objects.each do |object|
        append_hook :owner => object,
          :trigger => Rubygame::EventTriggers::YesTrigger.new,
          :action => Rubygame::EventActions::MethodAction.new(:handle)
      end
    end
  end
end
