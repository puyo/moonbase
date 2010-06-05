require 'moonbase/game'
require 'moonbase/game_view'
require 'moonbase/map_view'

module Moonbase
  class GameController
    include EventHandler::HasEventHandler

    def initialize
      create_game
      create_map_view
      create_map_view_sprite_group
      create_pressed_hooks
      create_released_hooks
    end

    private

    def create_map_view
      @map_view = MapView.new(@game.map)
    end

    def create_map_view_sprite_group
      grp = Sprites::Group.new
      class << grp
        include EventHandler::HasEventHandler
        def on_draw(event)
          dirty_rects = draw(event.screen)
          event.screen.update_rects(dirty_rects)
        end
        def on_undraw(event)
          undraw(event.screen, event.background)
        end
      end
      grp.extend(Sprites::UpdateGroup)
      grp.push(@map_view)
      grp.make_magic_hooks({
        Moonbase::Events::DrawSprites => :on_draw,
        Moonbase::Events::UndrawSprites => :on_undraw,
        :tick => :update,
      })
      add_sprite_hooks(grp)
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
      @game = game_demo
      @game.buildings.each do |player, list|
        list.each do |building|
          p [player, building]
          #@building_views.push(BuildingView.new(:building => building, :owner => player))
        end
      end
    end

    def game_demo
      players = [
        Moonbase::Player.new(:name => 'P1'),
        Moonbase::Player.new(:name => 'P2'),
      ]
      map = Map.new(:width => 100, :height => 100)
      #h1 = Hub.new(:owner => players[0], :position => Vector3D.new(0, 0, 0))
      #h2 = Hub.new(:owner => players[1], :position => Vector3D.new(50, 50, 0))
      #create_building(h1)
      #create_building(h2)
      Game.new(:map => map, :players => players)
    end

    def on_building_create(building)
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
