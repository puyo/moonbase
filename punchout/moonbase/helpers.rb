module Moonbase
  def self.image(*args)
    Gosu::Image.new(*args)
  end

  def self.rgba(*args)
    Gosu::Color.rgba(*args)
  end
end
