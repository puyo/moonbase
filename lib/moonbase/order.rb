module Moonbase
  class Order
  end

  class SkipOrder < Order
  end

  class ShootOrder < Order
    attr_reader :from, :projectile_class, :direction, :power
    def initialize(opts = {})
      @from = opts[:from] || raise('Must specify which building to shoot from') # building
      @direction = opts[:direction] || raise('Must specify shoot direction')
      @projectile_class = opts[:projectile_class] || raise('Must specify projectile class to shoot')
      @power = opts[:power] || raise('Must specify shoot power')
    end
  end
end
