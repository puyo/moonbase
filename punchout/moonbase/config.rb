require 'yaml'
require 'hash-to-ostruct'

module Moonbase
  Config = YAML.load_file('config/moonbase.yml').to_ostruct
end

