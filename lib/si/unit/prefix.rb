module SI
  module Unit
    class Prefix
      include Comparable

      attr_reader :label, :factor, :name, :symbol, :hash
      def initialize label, name = '', factor = 1.0, options = {}
        raise TypeError unless factor.is_a? Numeric
        @label  = label
        @factor = factor.to_f
        @name   = name
        @symbol = options.fetch(:symbol) { label.to_s.tr_s '_', ' ' }
        @hash   = [self.class, label, factor, name, symbol].hash
        freeze
      end

      alias_method :to_s, :symbol

      def <=> other
        return nil unless other.is_a? self.class
        factor <=> other.factor 
      end
      alias_method :eql?, :==
    end
  end
end
