class Value
  include Comparable

  attr_reader :value, :unit
  def initialize value, unit
    raise TypeError, 'value has to be numeric' unless value.is_a? Numeric
    @value = value.to_f
    @unit = unit
    freeze
  end

  def to_s
    "#{value.to_s} #{unit.to_s}"
  end

  def <=> other
    other.is_a?(Value) && unit == other.unit && value <=> other.value
  end

  def hash
    [Value, value, unit].hash
  end
  alias_method :eql?, :==

  def + other
    add_or_subtract :+, other
  end

  def - other
    add_or_subtract :-, other
  end

  def add_or_subtract operator, other
    raise TypeError unless other.is_a? Value
    raise TypeError unless unit == other.unit
    result = value.send operator, other.value
    Value.new result, unit
  end

  def * other
    multiply_or_divide :*, other
  end

  def / other
    multiply_or_divide :/, other
  end

  def multiply_or_divide operator, other
    raise TypeError unless other.is_a? Numeric
    result = value.send operator, other
    Value.new result, unit
  end
end
