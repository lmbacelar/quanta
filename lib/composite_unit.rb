class CompositeUnit < Unit
  attr_reader :units 
  def initialize label, name, units = []
    raise TypeError, 'requires array of hashes of unit and power' unless units.is_a? Array
    raise TypeError, 'units array cannot be empty'                if     units.empty?
    @label    = label
    @name     = name
    @units    = units
    @factor   = factor_from units
    @quantity = quantity_from units
    super
  end

  def hash
    [CompositeUnit, label, name, factor, scale, quantity, units].hash
  end

protected
  def factor_from units
    units.map_hash{ |unit, power| unit.factor ** power }.reduce(:*)
  end

  def quantity_from units
    quantities_from(units).map_hash{ |quantity, power| quantity ** power }.reduce(:*)
  end

  def quantities_from units
    units.map_hash{ |unit, power| {unit.quantity => power} }
  end
end

#
# Adding custom mapper to Array
# map_hash maps array of hashes
#
# [{2 => 1},{4 => 2}].map_hash{ |k,v| k*v }  ====>  [2, 8]
#
class Array
  def map_hash &block
    self.map{ |hash| hash.map { |k,v| block.call(k,v) } }.flatten
  end
end