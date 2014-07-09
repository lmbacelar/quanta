require_relative 'core_extensions/integer'
require_relative 'core_extensions/numeric'

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
    quantity.same_kind_as? other.quantity
  end

  def <=> other
    return nil unless other.is_a? Unit
    quantity.same_kind_as?(other.quantity) && factor <=> other.factor
  end

  alias_method :eql?, :==

  def * other
    raise TypeError unless other.is_a? Unit
    CompositeUnit.new [label, '.', other.label    ].join.to_sym,
                      [name,        other.name].join(' ').strip,
                      [ { self => 1 } , { other => 1 } ]
  end

  def / other
    raise TypeError unless other.is_a? Unit
    CompositeUnit.new [label, '/', other.label    ].join.to_sym,
                      [name, 'per', other.name].join(' ').strip,
                      [ { self => 1 } , { other => -1 } ]
  end

  def ** other
    other = other.base_value if other.is_a?(QuantityValue) && other.unitless?
    raise TypeError unless other.is_a? Numeric
    CompositeUnit.new other == 1 ? label : [label, other.to_superscript].join.to_sym,
                      [name, {1=>'', 2=>'squared', 3=>'cubed'}.fetch(other){"raised to #{other}"}].join(' ').strip,
                      [ { self => other } ]
  end
end
