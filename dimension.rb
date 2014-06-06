class Dimension

  # 
  # Instance Methods
  #
  attr_accessor :label, :name, :symbol, :dimensions
  def initialize label, name: label.to_s, symbol: label.to_s.upcase, dimensions: nil
    raise TypeError, 'dimensions must be nil or a Hash' unless dimensions.nil? || 
                                                               dimensions.is_a?(Hash)
    @label      = label
    @name       = name
    @symbol     = symbol
    @dimensions = dimensions || { self => 1 }
    freeze
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

  def to_s
    return symbol if base?
    return dimensions.map do |dimension, index|
      index == 1 ? dimension.symbol : "#{dimension.symbol}^#{index}"
    end.join ' . '
  end

  def == other
    hash == other.hash
  end

  def hash
    [Dimension, label, name, symbol].concat(
      Array(dimensions).map { |dimension, pow| 
        [dimension.label, dimension.name, dimension.symbol, pow] 
      }
    ).hash
  end
  alias_method :eql?, :==

  def equivalent_to? other
    dimensions.hash == other.dimensions.hash
  end

  def / other
    multiply_or_divide :/, other
  end

  def * other
    other = Dimension.one if other.is_a? Numeric
    raise TypeError unless other.is_a? Dimension

    # Special cases. Only required for performance enhancement.
    return self.clone  if other.one?
    return other.clone if self.one?

    new_label      = "#{label.to_s}_#{other.label.to_s}".to_sym
    new_name       = "#{name} #{other.name}"
    new_symbol     = "#{symbol} . #{other.symbol}"
    new_dimensions = dimensions.merge(other.dimensions) do |_, pow, other_pow|
      pow + other_pow
    end.delete_if{ |_, pow| pow == 0 }

    Dimension.new new_label, name: new_name, symbol: new_symbol, dimensions: new_dimensions
  end

  def / other
    other = Dimension.one if other.is_a? Numeric
    raise TypeError unless other.is_a? Dimension

    # Special cases. Only required for performance enhancement.
    return self.clone       if other.one?
    return other.reciprocal if self.one?

    new_label      = "#{label.to_s}_per_#{other.label.to_s}".to_sym
    new_name       = "#{name} per #{other.name}"
    new_symbol     = "#{symbol} / #{other.symbol}"
    new_dimensions = dimensions.merge(other.reciprocal_dimensions) do |_, pow, other_pow|
      pow + other_pow
    end.delete_if{ |_, pow| pow == 0 }

    Dimension.new new_label, name: new_name, symbol: new_symbol, dimensions: new_dimensions
  end

  def ** other
    raise TypeError unless other.is_a? Numeric

    # Special cases. Only required for performance enhancement.
    return self.clone      if other ==  1
    return self.reciprocal if other == -1
    return Dimension.one   if other ==  0 || self.one?

    new_label      = "#{label.to_s}_#{other.to_s}".to_sym
    new_name       = "#{name} raised to power #{other.to_s}"
    new_symbol     = "#{symbol}^#{other.to_s}"
    new_dimensions = Hash[dimensions.map{ |dim, pow| [dim, (pow * other).to_i] }].delete_if{ |_, pow| pow == 0 }

    Dimension.new new_label, name: new_name, symbol: new_symbol, dimensions: new_dimensions

  end


  def coerce other
    raise TypeError, "#{other.class} can't be coerced to Dimension" unless other.is_a? Numeric
    return Dimension.one, self
  end

  def reciprocal_dimensions
    Hash[dimensions.map{ |k, v| [k, v*-1] }]
  end

  def reciprocal
    Dimension.new "per_#{label}".to_sym, 
                  name: "per #{name}", 
                  symbol: "1 / #{symbol}", 
                  dimensions: reciprocal_dimensions
  end

  #
  # Class Methods
  #
  def self.one
    Dimension.new :one, symbol: '1', dimensions: {}
  end

end
