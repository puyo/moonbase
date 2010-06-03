$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'moonbase/game'
require 'rubygems' rescue nil
require 'rubygame'

include Rubygame

module Moonbase
  def self.pressed(key)
    key
  end

  def self.released(key)
    EventTriggers::KeyReleaseTrigger.new(key)
  end

  module Events
    class DrawSprites
      attr_accessor :screen

      def initialize(screen)
        @screen = screen
      end
    end

    class UndrawSprites
      attr_accessor :screen, :background

      def initialize(screen, background)
        @screen, @background = screen, background
      end
    end
  end

  class BombView
    include EventHandler::HasEventHandler

    attr_accessor :vx, :vy

    def initialize(game, bomb)
      @game = game
      @bomb = bomb
      make_magic_hooks({
        Events::DrawSprites => :on_draw,
        :tick => :on_update,
      })
    end

    def on_update(tick_event)
      @bomb.update(tick_event.seconds)
    end

    def on_draw(event)
    end
  end

  class MapView
    include EventHandler::HasEventHandler
    include Sprites::Sprite

    attr_accessor :vx, :vy

    def vy=(y)
      @vy = y
      p y
    end

    def initialize(map)
      @vx, @vy = 0, 0
      @scroll_x = 0
      @scroll_y = 0
      @tile_size = 16
      @map = map

      make_magic_hooks({
        Moonbase.pressed(:up   )  => proc { |owner, event| owner.vy = -1 },
        Moonbase.pressed(:down )  => proc { |owner, event| owner.vy =  1 },
        Moonbase.pressed(:left )  => proc { |owner, event| owner.vx = -1 },
        Moonbase.pressed(:right)  => proc { |owner, event| owner.vx =  1 },
        Moonbase.released(:up   ) => proc { |owner, event| owner.vy = 0 },
        Moonbase.released(:down ) => proc { |owner, event| owner.vy = 0 },
        Moonbase.released(:left ) => proc { |owner, event| owner.vx = 0 },
        Moonbase.released(:right) => proc { |owner, event| owner.vx = 0 },

        :tick => :on_tick,
        Events::DrawSprites => :on_draw,
        Events::UndrawSprites => :on_undraw,
      })

      @image = Surface.new([100, 100])

      (0..@map.width).each do |i|
        (0..@map.height).each do |j|
          px = i.to_f / @map.width
          py = j.to_f / @map.height
          g = 16
          gh = 8
          sx = (i + j) * g
          sy = (i - j) * gh
          ## + w*gh
          @image.draw_line([sx + g, sy],        [sx, sy + gh],       [px*255,py*255,255])
          @image.draw_line([sx, sy + gh],       [sx + g, sy + g],    [px*255,py*255,255])
          @image.draw_line([sx + g, sy + g],    [sx + 2*g, sy + gh], [px*255,py*255,255])
          @image.draw_line([sx + 2*g, sy + gh], [sx + g, sy],        [px*255,py*255,255])
        end
      end
    end

    def rect
      r = @image.make_rect
      r.x = @scroll_x
      r.y = @scroll_y
      r
    end

    def on_tick(tick_event)
      @scroll_x += @vx
      @scroll_y += @vy
    end

    def on_draw(event)
      dirty_rects = draw(event.screen)
      event.screen.update
      #event.screen.update_rects(dirty_rects)
    end

    def on_undraw(event)
      undraw(event.screen, event.background)
    end
  end

  class GameView
    def initialize(main, game)
      @game = game
      @map_view = MapView.new(@game.map)
      main.append_hook(:owner => @map_view, 
                       :trigger => EventTriggers::YesTrigger.new, 
                       :action  => EventActions::MethodAction.new(:handle))
    end
  end

  class Main
    include EventHandler::HasEventHandler

    def initialize
      Rubygame.init
      TTF.setup

      Surface.autoload_dirs = [ File.dirname(__FILE__) + '/data' ]

      @screen = Screen.open([800, 600])
      @screen.title = 'Moonbase'
      @screen.show_cursor = false

      @background = Surface.new(@screen.size)
      @background.fill(Color::ColorRGB.new([0.1, 0.2, 0.35]))

      @clock = Clock.new
      @clock.target_framerate = 50
      @clock.calibrate
      @clock.enable_tick_events

      @queue = EventQueue.new
      @queue.enable_new_style_events
      @queue.ignore = [Rubygame::Events::MouseMoved]

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

      @game = Moonbase::Game.new :players => [
        Moonbase::Player.new(:name => 'P1'),
        Moonbase::Player.new(:name => 'P2'),
      ]
      @game.setup

      @game_view = GameView.new(self, @game)
    end

    def update_screen
      @screen.update
    end

    # Do everything needed for one frame.
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
        Kernel.loop do
          step
        end
      end
    end
  end
end

if $0 == __FILE__
  main = Moonbase::Main.new
  main.loop
end
