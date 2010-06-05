require 'moonbase/building_views'

module Moonbase

  class GameView
    def initialize(main, game)
      @game = game
      @map_view = MapView.new(@game.map)

      @building_views = []

      @game.buildings.each do |player, list|
        list.each do |building|
          p [player, building]
          #@building_views.push(BuildingView.new(:building => building, :owner => player))
        end
      end

      grp = Sprites::Group.new
      grp.extend(Sprites::UpdateGroup)
      grp.push(@map_view)

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

      grp.make_magic_hooks({
        :tick         => :update,
        Moonbase::Events::DrawSprites   => :on_draw,
        Moonbase::Events::UndrawSprites => :on_undraw,
      })
      main.register(grp, @map_view)
      #main.register(*@building_views)
    end
  end
end
