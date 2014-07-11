class QuantityValue
  include Comparable

  attr_reader :value, :unit
  def initialize value, unit, prefix = nil
    raise TypeError, 'value has to be numeric' unless value.is_a? Numeric
    @value  = value.to_f
    @unit   = unit
    freeze
  end

  def to_s
    "#{value.to_s} #{unit.to_s}"
  end

  def unitless?
    unit.unitless?
  end

  def base_value
    value * unit.factor
  end

  def <=> other
    other.is_a?(QuantityValue) && 
    unit.same_kind_as?(other.unit) && 
    base_value <=> other.base_value
  end

  def hash
    [QuantityValue, value, unit].hash
  end
  alias_method :eql?, :==

  def + other
    add_or_subtract :+, other
  end

  def - other
    add_or_subtract :-, other
  end

  def * other
    multiply_or_divide :*, other
  end

  def / other
    multiply_or_divide :/, other
  end

  def coerce other
    raise TypeError, "#{other.class} can't be coerced to QuantityValue" unless other.is_a? Numeric
    return QuantityValue.new(other.to_f, Unit::Plain.unitless), self
  end

protected
  def add_or_subtract operator, other
    raise TypeError unless other.is_a? QuantityValue
    raise TypeError unless unit.same_kind_as? other.unit
    result = (base_value.send operator, other.base_value) / unit.factor
    QuantityValue.new result, unit
  end

  def multiply_or_divide operator, other
    other = QuantityValue.new(other.to_f, Unit::Plain.unitless) if other.is_a? Numeric
    raise TypeError unless other.is_a? QuantityValue
    result_value = value.send operator, other.value
    result_unit  = unit.send  operator, other.unit
    QuantityValue.new result_value, result_unit
  end
end
