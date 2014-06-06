class Unit
  attr_accessor :label, :name, :symbol, :factor, :dimension
  def initialize label:, name: label.to_s, factor: 1.0, symbol:, dimension: :unity
    raise TypeError, 'factor has to be numeric' unless factor.is_a? Numeric
    @label     = label
    @name      = name
    @symbol    = symbol
    @factor    = factor
    @dimension = dimension
    freeze
  end
end
