$LOAD_PATH.push File.dirname(__FILE__)

require 'moonbase/window'

if $0 == __FILE__
  Moonbase::Window.new.show
end
