require 'rubygame'

module Moonbase
  class HubView
    include Rubygame
    include Sprites::Sprite

    def initialize(game, hub, map_view)
      super()
      @game = game
      @hub = hub
      @map_view = map_view
      @image = Surface.new([100, 100], 0)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha
      @color = hub.owner.color
      @t = 0
      @rect = @image.make_rect
      redraw
      update_rect
    end

    def update(milliseconds)
      @t += milliseconds
      while @t > 1000
        @t -= 1000
      end
      redraw
      update_rect
    end

    def redraw
      @image.fill([0, 0, 0])
      redraw_selection if @hub.selected and @game.hotseat_player == @hub.owner
      redraw_hub
    end

    private

    def self.hub_bitmap
      @hub_bitmap ||= Surface.load('data/hub.png')
      @hub_bitmap.to_display_alpha
      @hub_bitmap
    end

    def self.selection_base_bitmap
      @selection_base_bitmap ||= Surface.load('data/selection.png')
      @selection_base_bitmap.to_display_alpha
      @selection_base_bitmap
    end

    def redraw_selection
      angle = @hub.angle + 180.0
      zoom = [1, 0.5]
      smooth = true
      selection = self.class.selection_base_bitmap
      selection = selection.rotozoom(angle, 1, smooth) # rotate
      selection = selection.zoom(zoom, smooth) # zoom
      selection.blit(@image, [(@image.width - selection.width)/2, (@image.height - selection.height)/2])
    end

    def redraw_hub
      hub = self.class.hub_bitmap
      hub.blit(@image, [(@image.width - hub.width)/2, (@image.height - hub.height)/2])
    end

    def update_rect
      @rect.topleft = @map_view.image_position(@image, [@hub.position.x, @hub.position.y, 0])
    end
  end
end
