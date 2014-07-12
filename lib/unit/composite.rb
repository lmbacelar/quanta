module Unit
  class Composite
    include Common
    include Arithmetic

    attr_reader :units 
    def initialize label, name, *units
      raise TypeError, 'units cannot be empty' if units.flatten.empty?
      raise TypeError, 'units must be an Enumerable of Unit => Numeric Hashes' unless units.extend(List).valid?
      @label    = label
      @name     = name
      @units    = units
      @factor   = units.factor
      @quantity = units.quantity
      @hash     = [self.class, label, name, units].hash
      freeze
    end
  end
end
