require 'simplecov'

SimpleCov.start do
  #add_filter '/lib/diagnostic.rb'
  #add_filter '/lib/tasks/'
end

$LOAD_PATH.push File.join(File.dirname(__FILE__), '..')

require 'moonbase/moonbase'
