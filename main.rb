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

      @players = [
        Moonbase::Player.new(:name => 'P1'),
        Moonbase::Player.new(:name => 'P2'),
      ]

      @game = Moonbase::Game.new :players => @players
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

    def register( *objects )
      objects.each do |object|
        append_hook( :owner   => object,
                    :trigger => Rubygame::EventTriggers::YesTrigger.new,
                    :action  => Rubygame::EventActions::MethodAction.new(:handle) )
      end
    end
  end
end

if $0 == __FILE__
  main = Moonbase::Main.new
  main.loop
end
