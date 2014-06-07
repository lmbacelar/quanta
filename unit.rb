class Unit
  attr_reader :label, :name, :symbol, :factor, :quantity
  def initialize label, symbol = '', factor = 1.0, quantity = Quantity.new, options = {}
    raise TypeError, 'factor must be numeric'      unless factor.is_a?   Numeric
    raise TypeError, 'quantity must be a Quantity' unless quantity.is_a? Quantity
    @label    = label
    @symbol   = symbol
    @factor   = factor
    @quantity = quantity
    @name     = options.fetch(name) { label.to_s.tr_s '_', ' ' }
    freeze
  end

  def base?
    quantity.base? && factor == 1.0
  end
end
