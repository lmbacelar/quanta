module Unit
  class Plain
    include Common
    include Arithmetic

    attr_reader :symbol, :prefix

    def initialize label, name = '', factor = 1.0, quantity = ISQ::Quantity.new, options = {}
      raise TypeError, 'factor must be numeric'      unless factor.is_a?   Numeric
      raise TypeError, 'quantity must be a quantity' unless quantity.is_a? ISQ::Quantity
      @prefix   = options.fetch(:prefix) { nil }
      @label    = "#{prefix ? prefix.label  : ''}#{label}".to_sym
      @name     = "#{prefix ? prefix.name   : ''}#{name}"
      @symbol   = "#{prefix ? prefix.symbol : ''}#{options.fetch(:symbol) { label.to_s.tr_s '_', ' ' }}"
      @factor   = prefix ? prefix.factor * factor : factor
      @scale    = options.fetch(:scale)  { 0.0 }
      raise TypeError, 'scale must be numeric'       unless scale.is_a?    Numeric
      @quantity = quantity
      @hash     = [self.class, label, name, symbol, factor, scale, quantity].hash
      freeze
    end

    def self.unitless
      new :"", '', 1.0, ISQ::Quantity.dimension_one
    end
    
    def prefixed?
      !!prefix
    end
  end
end
