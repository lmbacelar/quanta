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
    PlainUnit.new :unitless, '', 1.0, Quantity.one
  end
  
  def prefixed?
    !!prefix
  end

  def to_s
    label.to_s
  end

  def hash
    [PlainUnit, label, name, symbol, factor, scale, quantity].hash
  end

  def * other
    multiply_or_divide :*, other
  end

  def / other
    multiply_or_divide :/, other
  end

  def ** other
    term_for = { 2 => 'squared', 3 => 'cubed' }
    PlainUnit.new [label, term_for.fetch(other) { "^#{other}" }].join(' ').to_sym,
                  [name,  term_for.fetch(other) { "^#{other}" }].join(' '),
                  factor ** other,
                  quantity ** other
  end


protected
  def multiply_or_divide operator, other
    raise TypeError unless other.is_a? PlainUnit
    CompositeUnit.new label_for(operator, other),
                      name_for( operator, other),
                      units_for(operator, other)
  end

  def label_for operator, other
    case operator
    when :* then [label, '.', other.label].join.to_sym
    when :/ then [label, '/', other.label].join.to_sym
    end
  end

  def name_for operator, other
    case operator
    when :* then [label, '.', other.label].join.to_sym
    when :/ then [label, '/', other.label].join.to_sym
    end
  end

  def units_for operator, other
    case operator
    when :* then [ { self => 1 }, { other =>  1 } ]
    when :/ then [ { self => 1 }, { other => -1 } ]
    end
  end
end
