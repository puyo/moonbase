require 'rubygems' rescue nil
require 'rubygame'

include Rubygame
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'moonbase/game'

module Moonbase
  class Main
    include EventHandler::HasEventHandler

    def initialize
      super()
      Rubygame.init
      TTF.setup
      Surface.autoload_dirs = [ File.dirname(__FILE__) + '/data' ]

      create_screen
      create_background
      create_clock
      create_queue
      create_game
      create_hooks
    end

    def create_screen
      @screen = Screen.open([800, 600])
      @screen.title = 'Moonbase'
      #@screen.show_cursor = false
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
      #@queue.ignore = [Rubygame::Events::MouseMoved]
    end

    def create_game
      @game = Game.new
      # pass on events not handled here
      append_hook :owner => @game,
        :trigger => Rubygame::EventTriggers::YesTrigger.new,
        :action => Rubygame::EventActions::MethodAction.new(:handle)
    end

    def create_hooks
      make_magic_hooks({
        Rubygame::Events::InputFocusGained => :update_screen,
        Rubygame::Events::WindowUnminimized => :update_screen,
        Rubygame::Events::WindowExposed => :update_screen,
        Rubygame::Events::QuitRequested => :quit,
        :escape => :on_quit,
        :q => :on_quit,
        #:tick => :update_framerate,
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
      @queue.each do |event|
        handle(event)
      end
    end

    def on_quit
      puts 'Quitting...'
      throw :quit
    end

    def loop
      catch(:quit) do
        Kernel.loop { step }
      end
    end
  end
end

if $0 == __FILE__
  main = Moonbase::Main.new
  main.loop
end
