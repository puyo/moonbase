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
    end

    def map_scroll_hook(dx, dy)
      proc do |view, event|
        view.vx, view.vy = dx, dy
      end
    end

    def create_map_view
      @map_view = MapView.new(@game.map)
      stop = map_scroll_hook(0, 0)
      @map_view.make_magic_hooks({
        :up    => map_scroll_hook( 0, -1),
        :down  => map_scroll_hook( 0,  1),
        :left  => map_scroll_hook(-1,  0),
        :right => map_scroll_hook( 1,  0),
        Moonbase::Events.released(:up   ) => stop,
        Moonbase::Events.released(:down ) => stop,
        Moonbase::Events.released(:left ) => stop,
        Moonbase::Events.released(:right) => stop,
      })
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
      register(grp, @map_view)
    end

    def create_game
      @game = create_game_demo
      @game.buildings.each do |player, list|
        list.each do |building|
          p [player, building]
          #@building_views.push(BuildingView.new(:building => building, :owner => player))
        end
      end
      @game_view = GameView.new(@game)
    end

    def create_game_demo
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

    # TODO: WTF does this do?
    def register(*objects)
      objects.each do |object|
        append_hook :owner => object,
          :trigger => Rubygame::EventTriggers::YesTrigger.new,
          :action => Rubygame::EventActions::MethodAction.new(:handle)
      end
    end
  end
end
