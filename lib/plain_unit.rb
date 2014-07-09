class PlainUnit < Unit
  attr_reader :symbol, :prefix
  def initialize label, name = '', factor = 1.0, quantity = Quantity.new, options = {}
    raise TypeError, 'factor must be numeric'      unless factor.is_a?   Numeric
    raise TypeError, 'quantity must be a quantity' unless quantity.is_a? Quantity
    @prefix   = options.fetch(:prefix) { nil }
    @label    = "#{prefix ? prefix.label  : ''}#{label}".to_sym
    @name     = "#{prefix ? prefix.name   : ''}#{name}"
    @symbol   = "#{prefix ? prefix.symbol : ''}#{options.fetch(:symbol) { label.to_s.tr_s '_', ' ' }}"
    @factor   = prefix ? prefix.factor * factor : factor
    @scale    = options.fetch(:scale)  { 0.0 }
    raise TypeError, 'scale must be numeric'       unless scale.is_a?    Numeric
    @quantity = quantity
    super
  end

  def self.unitless
    PlainUnit.new :"", '', 1.0, Quantity.dimension_one
  end
  
  def prefixed?
    !!prefix
  end

  def hash
    [PlainUnit, label, name, symbol, factor, scale, quantity].hash
  end
end
