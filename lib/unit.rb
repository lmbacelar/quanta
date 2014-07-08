class Unit
  include Comparable

  attr_reader :label, :name, :factor, :scale, :quantity

  def initialize *options
    freeze
  end

  def to_s
    label.to_s
  end

  def unitless?
    quantity.dimension_one?
  end

  def base?
    quantity.base? && factor == 1.0 && scale == 0.0
  end

  def derived?
    !base?
  end

  def same_kind_as? other
    # TODO: 
    #   consolidate units of CompositeUnit before comparing quantities
    #   length => 2  is not equal to length => 1, length => 1 !!!
    quantity.same_kind_as? other.quantity
  end

  def <=> other
    return nil unless other.is_a? Unit
    quantity.same_kind_as?(other.quantity) && factor <=> other.factor
  end

  alias_method :eql?, :==

end
