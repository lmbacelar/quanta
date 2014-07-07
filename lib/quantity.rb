class Quantity
  #
  # Class Methods
  #
  def self.one
    Quantity.new :one, {}, symbol: '1'
  end

  # 
  # Instance Methods
  #
  attr_accessor :quantity, :name, :symbol, :dimensions
  def initialize quantity = nil, dimensions_or_quantity = nil, options = {}
    @quantity   = quantity
    @name       = options.fetch(:name)   { quantity.to_s.tr_s '_', '  ' }
    @symbol     = options.fetch(:symbol) { quantity.to_s.upcase }
    @dimensions = case dimensions_or_quantity 
      when NilClass  then { self => 1 }
      when Hash      then dimensions_or_quantity
      when Quantity  then dimensions_or_quantity.dimensions
      else raise TypeError, 'dimensions_or_quantity must be nil, a hash or a quantity'
    end
    freeze
  end

  def to_s
    return symbol if base?
    dimensions.map do |quantity, index|
      index == 1 ? quantity.symbol : "#{quantity.symbol}^#{index}"
    end.join ' . '
  end

  def base?
    dimensions == { self => 1 }
  end

  def derived?
    !base?
  end

  def one?
    dimensions == {}
  end

  def == other
    hash == other.hash
  end

  def hash
    [Quantity, quantity, name, symbol].concat(
      Array(dimensions).map { |dim, pow| [dim.quantity, dim.name, dim.symbol, pow] }
    ).hash
  end
  alias_method :eql?, :==

  def same_kind_as? other
    dimensions.hash == other.dimensions.hash
  end

  def reciprocal
    Quantity.new nil, Hash[dimensions.map{ |k, v| [k, v*-1] }]
  end

  def * other
    multiply_or_divide :*, other
  end

  def / other
    multiply_or_divide :/, other
  end

  def ** other
    raise TypeError unless other.is_a? Numeric
    return Quantity.one    if other ==  0 || self.one?
    return self.clone      if other ==  1
    return self.reciprocal if other == -1

    new_dimensions = Hash[dimensions.map{ |dim, pow| [dim, (pow * other).to_i] }].delete_if{ |_, pow| pow == 0 }
    Quantity.new nil, new_dimensions
  end

  def coerce other
    raise TypeError, "#{other.class} can't be coerced to Quantity" unless other.is_a? Numeric
    return Quantity.one, self
  end

protected
  def multiply_or_divide operator, other
    return self.clone        if other.is_a? Numeric
    raise TypeError          unless other.is_a? Quantity
    return self.clone        if other.one?
    other = other.reciprocal if operator == :/
    return other.clone       if self.one?

    new_dimensions = dimensions.merge(other.dimensions) do |_, pow, other_pow|
      pow + other_pow
    end.delete_if{ |_, pow| pow == 0 }
    Quantity.new nil, new_dimensions
  end
end
