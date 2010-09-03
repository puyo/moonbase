require 'moonbase/logger'

module Moonbase
  module Emitter
    def emit(event, *args)
      Moonbase.logger.debug { "#{self}.emit#{[event, *args].inspect}" }
      hooks[event].each{|h| h.call(*args) }
    end

    def on(event, &block)
      hooks[event] << block
      return block
    end

    def remove_hook(event, block)
      hooks[event].delete(block)
    end

    def remove_all_hooks
      hooks.clear
    end

    private

    def hooks
      if defined? @hooks
        @hooks
      else
        @hooks = Hash.new {|h, k| h[k] = [] }
      end
    end
  end
end
