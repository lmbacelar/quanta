class Unit
  include Comparable

  attr_reader :label, :name, :symbol, :factor, :scale, :quantity
  def initialize label, name = '', factor = 1.0, quantity = Quantity.new, options = {}
    raise TypeError, 'factor must be numeric'      unless factor.is_a?   Numeric
    raise TypeError, 'quantity must be a quantity' unless quantity.is_a? Quantity
    @label    = label
    @name     = name
    @symbol   = options.fetch(:symbol) { label.to_s.tr_s '_', ' ' }
    @factor   = factor
    @scale    = options.fetch(:scale)  { 0.0 }
    raise TypeError, 'scale must be numeric'       unless scale.is_a?    Numeric
    @quantity = quantity
    freeze
  end

  def self.unitless
    Unit.new :unitless, '', 1.0, Quantity.one
  end
  
  def base?
    quantity.base? && factor == 1.0 && scale == 0.0
  end

  def derived?
    !base?
  end

  def to_s
    label.to_s
  end

  def same_kind_as? other
    quantity.same_kind_as? other.quantity
  end

  def <=> other
    other.is_a?(Unit) && quantity.same_kind_as?(other.quantity) && factor <=> other.factor
  end

  def hash
    [Unit, label, name, symbol, factor, scale, quantity].hash
  end
  alias_method :eql?, :==

  def ** other
    term_for = { 2 => 'squared', 3 => 'cubed' }
    Unit.new [label, term_for.fetch(other) { "^#{other}" }].join(' ').to_sym,
             [name,  term_for.fetch(other) { "^#{other}" }].join(' '),
             factor ** other,
             quantity ** other
  end

  def * other
    multiply_or_divide :*, other
  end

  def / other
    multiply_or_divide :/, other
  end


protected
  def multiply_or_divide operator, other
    raise TypeError unless other.is_a? Unit
    term_for = { :* => '', :/ => 'per' }
    Unit.new [label, term_for[operator], other.label].join(' ').to_sym,
             [name,  term_for[operator], other.name ].join(' '),
             factor.send(operator, other.factor),
             quantity.send(operator, other.quantity)
  end
end
