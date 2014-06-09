class Unit
  attr_reader :label, :name, :symbol, :factor, :quantity
  def initialize label, name = '', factor = 1.0, quantity = Quantity.new, options = {}
    raise TypeError, 'factor must be numeric'      unless factor.is_a?   Numeric
    raise TypeError, 'quantity must be a Quantity' unless quantity.is_a? Quantity
    @label    = label
    @name     = name
    @symbol   = options.fetch(symbol) { label.to_s.tr_s '_', ' ' }
    @factor   = factor
    @quantity = quantity
    freeze
  end

  def base?
    quantity.base? && factor == 1.0
  end
end
