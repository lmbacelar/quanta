class Dimension

  # 
  # Instance Methods
  #
  attr_accessor :label, :name, :symbol, :dimensions
  def initialize label = nil, name: label.to_s, symbol: label.to_s.upcase, dimensions: nil
    raise TypeError, 'dimensions must be nil or a Hash' unless dimensions.nil? || 
                                                               dimensions.is_a?(Hash)
    @label      = label
    @name       = name
    @symbol     = symbol
    @dimensions = dimensions || { self => 1 }
    freeze
  end

  def to_s
    return symbol if base?
    dimensions.map do |dimension, index|
      index == 1 ? dimension.symbol : "#{dimension.symbol}^#{index}"
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
    [Dimension, label, name, symbol].concat(
      Array(dimensions).map { |dim, pow| [dim.label, dim.name, dim.symbol, pow] }
    ).hash
  end
  alias_method :eql?, :==

  def equivalent_to? other
    dimensions.hash == other.dimensions.hash
  end

  def reciprocal
    Dimension.new dimensions: Hash[dimensions.map{ |k, v| [k, v*-1] }]
  end

  def * other
    multiply_or_divide :*, other
  end

  def / other
    multiply_or_divide :/, other
  end

  def multiply_or_divide operator, other
    return self.clone        if other.is_a? Numeric
    raise TypeError          unless other.is_a? Dimension
    return self.clone        if other.one?
    other = other.reciprocal if operator == :/
    return other.clone       if self.one?

    new_dimensions = dimensions.merge(other.dimensions) do |_, pow, other_pow|
      pow + other_pow
    end.delete_if{ |_, pow| pow == 0 }
    Dimension.new dimensions: new_dimensions
  end

  def ** other
    raise TypeError unless other.is_a? Numeric
    return self.clone      if other ==  1
    return self.reciprocal if other == -1
    return Dimension.one   if other ==  0 || self.one?

    new_dimensions = Hash[dimensions.map{ |dim, pow| [dim, (pow * other).to_i] }].delete_if{ |_, pow| pow == 0 }
    Dimension.new dimensions: new_dimensions
  end

  def coerce other
    raise TypeError, "#{other.class} can't be coerced to Dimension" unless other.is_a? Numeric
    return Dimension.one, self
  end

  #
  # Class Methods
  #
  def self.one
    Dimension.new :one, symbol: '1', dimensions: {}
  end
end
