class Prefix
  attr_reader :label, :factor, :name, :symbol, :factor
  def initialize label, symbol = '', factor = 1.0, options = {}
    raise TypeError unless factor.is_a? Numeric
    @label  = label
    @factor = factor
    @symbol = symbol
    @name   = options.fetch(:name)   { label.to_s.tr_s '_', ' ' }
    freeze
  end
end
