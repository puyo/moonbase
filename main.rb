require 'rubygems' rescue nil
require 'rubygame'
include Rubygame
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'moonbase/game'
require 'moonbase/player'
require 'moonbase/game_view'
require 'moonbase/map_view'

module Moonbase
  class Main
    include EventHandler::HasEventHandler

    def initialize
      Rubygame.init
      TTF.setup
      Surface.autoload_dirs = [ File.dirname(__FILE__) + '/data' ]

      create_screen
      create_background
      create_clock
      create_queue
      create_players
      create_map
      create_game
      create_hooks
    end

    def create_screen
      @screen = Screen.open([800, 600])
      @screen.title = 'Moonbase'
      @screen.show_cursor = false
    end

    def create_background
      @background = Surface.new(@screen.size)
      @background.fill(Color::ColorRGB.new([0.1, 0.2, 0.35]))
    end

    def create_clock
      @clock = Clock.new
      @clock.target_framerate = 50
      @clock.calibrate
      @clock.enable_tick_events
    end

    def create_queue
      @queue = EventQueue.new
      @queue.enable_new_style_events
      @queue.ignore = [Rubygame::Events::MouseMoved]
    end

    def create_players
      @players = [
        Moonbase::Player.new(:name => 'P1'),
        Moonbase::Player.new(:name => 'P2'),
      ]
    end

    def create_map
      @map = Map.new(:width => 100, :height => 100)
      h1 = Hub.new(:owner => @players[0], :position => Vector3D.new(0, 0, 0))
      h2 = Hub.new(:owner => @players[1], :position => Vector3D.new(50, 50, 0))
      create_building(h1)
      create_building(h2)

      @map_view = MapView.new(@map)
      @map_view.make_magic_hooks({
        Moonbase::Events.pressed(:up   )  => proc { |owner, event| owner.vy = -1 },
        Moonbase::Events.pressed(:down )  => proc { |owner, event| owner.vy =  1 },
        Moonbase::Events.pressed(:left )  => proc { |owner, event| owner.vx = -1 },
        Moonbase::Events.pressed(:right)  => proc { |owner, event| owner.vx =  1 },
        Moonbase::Events.released(:up   ) => proc { |owner, event| owner.vy = 0 },
        Moonbase::Events.released(:down ) => proc { |owner, event| owner.vy = 0 },
        Moonbase::Events.released(:left ) => proc { |owner, event| owner.vx = 0 },
        Moonbase::Events.released(:right) => proc { |owner, event| owner.vx = 0 },
      })

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
        :tick         => :update,
        Moonbase::Events::DrawSprites   => :on_draw,
        Moonbase::Events::UndrawSprites => :on_undraw,
      })
      register(grp, @map_view)
    end

    def create_game
      @game = Moonbase::Game.new :players => @players, :map => @map
      @game.buildings.each do |player, list|
        list.each do |building|
          p [player, building]
          #@building_views.push(BuildingView.new(:building => building, :owner => player))
        end
      end

      @game_view = GameView.new(@game)
    end

    def create_hooks
      make_magic_hooks({
        :escape  =>  :quit,
        :q       =>  :quit,
        :s       =>  :toggle_smooth,
        Rubygame::Events::QuitRequested     =>  :quit,
        Rubygame::Events::InputFocusGained  => :update_screen,
        Rubygame::Events::WindowUnminimized => :update_screen,
        Rubygame::Events::WindowExposed     => :update_screen,
        #:tick             => :update_framerate
      })
    end

    def create_building(building)
    end

    def create_projectile(klass, owner, building, velocity)
      projectile = klass.new(:position => building.position,
                             :velocity => velocity)
      view = ProjectileView.new(bomb)
      view.make_magic_hooks({
        Events::DrawSprites => :on_draw,
        :tick => :on_update,
      })
    end

    def update_screen
      @screen.update
    end

    def step
      @queue << Events::UndrawSprites.new(@screen, @background)
      @queue.fetch_sdl_events
      @queue << @clock.tick
      @queue << Events::DrawSprites.new(@screen)
      @screen.update
      @queue.each{|event| handle(event) }
    end

    def quit
      puts 'Quitting...'
      throw :quit
    end

    def loop
      catch(:quit) do
        Kernel.loop { step }
      end
    end

    def register( *objects )
      objects.each do |object|
        append_hook :owner => object,
          :trigger => Rubygame::EventTriggers::YesTrigger.new,
          :action  => Rubygame::EventActions::MethodAction.new(:handle)
      end
    end
  end
end

if $0 == __FILE__
  main = Moonbase::Main.new
  main.loop
end
