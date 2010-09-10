require 'moonbase/game'
require 'moonbase/map_view'
require 'moonbase/building_views'
require 'moonbase/projectiles'
require 'moonbase/projectile_views'
require 'moonbase/shadow'

module Moonbase
  class GameController
    include EventHandler::HasEventHandler

    def initialize
      @projectile_views = Hash.new {|h, k| h[k] = [] }
      create_sprite_group
      create_game
      create_pressed_hooks
      create_released_hooks
      make_magic_hooks({
        :tick => :on_tick,
        :mouse_left => :on_click,
      })
      append_hook :owner => self,
        :trigger => EventTriggers::MouseMoveTrigger.new,
        :action => EventActions::MethodAction.new(:on_mouse_move)
    end

    private

    def create_sprite_group
      @sprite_group = Sprites::Group.new
      class << @sprite_group
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
        :tick => :update,
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

    def create_game
      @game = Game.new
      create_game_demo
      @game.start
    end

    def create_game_demo
      p1 = Moonbase::Player.new(:name => 'P1', :color => [255, 0, 0])
      p2 = Moonbase::Player.new(:name => 'P2', :color => [64, 64, 255])
      add_player(p1)
      add_player(p2)
      map = Map.new(:width => 100, :height => 100)
      set_map map
      h1 = Hub.new(:position => Vector3D.new(0, 0, 0), :owner => p1)
      add_building(h1)
      h2 = Hub.new(:position => Vector3D.new(32, 32, 0), :owner => p2)
      add_building(h2)
      b1 = Bomb.new(:position => Vector3D.new(0, 0, 0),
                    :velocity => Vector3D.new(-4, 2, 20),
                    :owner => p1)
      add_projectile(b1)
    end

    def set_map(map)
      @game.map = map

      @map_view = MapView.new(map)
      @sprite_group.push(@map_view)
    end

    def add_player(player)
      @game.add_player(player)
    end

    def add_building(building)
      @game.add_building(building)

      view = BuildingView.new(building, @map_view)
      @sprite_group.push(view)
    end

    def add_projectile(projectile)
      @game.add_projectile(projectile)

      shadow = Shadow.new(projectile, @map_view)
      @sprite_group.push(shadow)
      view = ProjectileView.new(projectile, @map_view)
      @sprite_group.push(view)
      @projectile_views[projectile].push view, shadow
    end

    def destroy_projectile(projectile)
      @game.destroy_projectile(projectile)
      @projectile_views[projectile].each do |sprite|
        @sprite_group.delete(sprite)
      end
    end

    def on_tick(event)
      ms = event.milliseconds
      @game.on_tick(ms)
      check_collisions

      # view hooks are currently handled by add_sprite_hooks
    end

    def on_click(event)
      get_building_clicked(event.pos)
    end

    def on_mouse_move(event)
      @map_view.select_tile(event.pos)
    end

    def get_building_clicked(pos)
      @game.each_building do |building|
        p building
      end
    end

    def check_collisions
      @game.each_projectile do |projectile|
        if projectile.position.h < @game.map.height(projectile.position.x, projectile.position.y)
          destroy_projectile(projectile)
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
