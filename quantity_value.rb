class QuantityValue
  include Comparable

  attr_reader :value, :unit, :prefix
  def initialize value, unit, prefix = nil
    raise TypeError, 'value has to be numeric' unless value.is_a? Numeric
    @value  = value.to_f
    @unit   = unit
    @prefix = prefix
    freeze
  end

  def to_s
    "#{value.to_s} #{prefix.to_s}#{unit.to_s}"
  end

  def <=> other
    other.is_a?(QuantityValue) && 
    unit.same_kind_as?(other.unit) && 
    base_value <=> other.base_value
  end

  def hash
    [QuantityValue, value, unit, prefix].hash
  end
  alias_method :eql?, :==

  def + other
    add_or_subtract :+, other
  end

  def - other
    add_or_subtract :-, other
  end

  def add_or_subtract operator, other
    raise TypeError unless other.is_a? QuantityValue
    raise TypeError unless unit.same_kind_as? other.unit
    result = (base_value.send operator, other.base_value) / factor
    QuantityValue.new result, unit, prefix
  end

protected
  def factor 
    unit.factor * ( prefix ? prefix.factor : 1 )
  end

  def base_value
    value * factor
  end

end

