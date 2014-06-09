class Unit
  attr_reader :label, :name, :symbol, :factors, :quantity
  def initialize label, name = '', factors = [1.0, 0.0], quantity = Quantity.new, options = {}
    factors = Array(factors)
    factors << 0.0 if factors.count == 1
    factors.each{ |factor| raise TypeError, 'factor must be numeric' unless factor.is_a? Numeric }
    raise TypeError, 'quantity must be a Quantity' unless quantity.is_a? Quantity
    @label    = label
    @name     = name
    @symbol   = options.fetch(symbol) { label.to_s.tr_s '_', ' ' }
    @factors  = factors
    @quantity = quantity
    freeze
  end

  def base?
    quantity.base? && factors == [1.0, 0.0]
  end

  def derived?
    !base?
  end
end
