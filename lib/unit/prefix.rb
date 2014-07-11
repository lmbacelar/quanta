module Unit
  class Prefix
    attr_reader :label, :factor, :name, :symbol, :factor
    def initialize label, name = '', factor = 1.0, options = {}
      raise TypeError unless factor.is_a? Numeric
      @label  = label
      @factor = factor
      @name   = name
      @symbol = options.fetch(:symbol) { label.to_s.tr_s '_', ' ' }
      freeze
    end

    alias_method :to_s, :symbol
  end
end
