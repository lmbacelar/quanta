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

  def * other
    label   = "#{label.to_s} #{other.label.to_s}".to_sym
    name    = "#{name} #{other.name}"
    debugger
    fct     = factor * other.factor
    qty     = quantity * other.quantity
    Unit.new label, name, fct, qty
  end

end
