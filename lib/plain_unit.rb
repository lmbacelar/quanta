require_relative 'core_extensions/integer'
require_relative 'core_extensions/numeric'

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

  def * other
    multiply_or_divide :*, other
  end

  def / other
    multiply_or_divide :/, other
  end

  def ** other
    other = other.base_value if other.is_a?(QuantityValue) && other.unitless?
    raise TypeError unless other.is_a? Numeric
    PlainUnit.new label_for(:**, other),
                  name_for( :**, other),
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
    when :*  then [label, '.', other.label    ].join.to_sym
    when :/  then [label, '/', other.label    ].join.to_sym
    when :** then other == 1 ? label : [label, other.to_superscript].join.to_sym
    end
  end

  def name_for operator, other
    case operator
      when :*  then [name,        other.name].join(' ').strip
      when :/  then [name, 'per', other.name].join(' ').strip
      when :** then [name, {1=>'', 2=>'squared', 3=>'cubed'}.fetch(other){"raised to #{other}"}].join(' ').strip
    end
  end

  def units_for operator, other
    case operator
    when :* then [ { self => 1 }, { other =>  1 } ]
    when :/ then [ { self => 1 }, { other => -1 } ]
    end
  end
end
