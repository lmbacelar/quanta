require_relative '../core_extensions/hash_array'

module Unit
  class Composite
    include Common
    include Arithmetic

    attr_reader :units 
    def initialize label, name, units = []
      raise TypeError, 'requires array of hashes of unit and power' unless units.is_a? Array
      raise TypeError, 'units array cannot be empty'                if     units.empty?
      @label    = label
      @name     = name
      @units    = units
      @factor   = factor_from units
      @quantity = quantity_from units
      @hash     = [self.class, label, name, units].hash
      freeze
    end

  protected
    def factor_from units
      units.extend(HashArray).map_hash{ |unit, power| unit.factor ** power }.reduce(:*)
    end

    def quantity_from units
      quantities_from(units).extend(HashArray).map_hash{ |quantity, power| quantity ** power }.reduce(:*)
    end

    def quantities_from units
      units.extend(HashArray).map_hash{ |unit, power| {unit.quantity => power} }
    end
  end
end
