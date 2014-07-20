require_relative '../core_extensions/integer'
require_relative '../core_extensions/numeric'

module Quanta
  module ISQ
    class Quantity
      def self.dimension_one
        Quantity.new :dimension_one, {}, symbol: '1'
      end

      attr_accessor :label, :dimensions, :name, :symbol
      def initialize label, dimensions, options = {}
        @label      = label.to_sym
        @name       = options.fetch(:name)   { label.to_s.tr_s '_', '  ' }
        @symbol     = options.fetch(:symbol) { label.to_s.upcase         }
        @dimensions = dimensions || { @label => 1 }
        raise TypeError, 'dimensions must be a hash' unless @dimensions.is_a? Hash
        freeze
      end

      def to_s
        #
        # TODO: link to ISQ to extract each quantity's symbol
        #
        return symbol if base?
        dimensions.map do |quantity, index|
          index == 1 ? quantity.symbol : "#{quantity.symbol}^#{index}"
        end.join ' . '
      end

      def base?
        dimensions == { label => 1 }
      end

      def derived?
        !base?
      end

      def dimension_one?
        dimensions == {}
      end

      def == other
        hash == other.hash
      end

      def hash
        [Quantity, label, name, symbol, dimensions].hash
      end
      alias_method :eql?, :==

      def same_kind_as? other
        if base?
          label == other.label
        else
          dimensions == other.dimensions
        end
      end

      def reciprocal
        self ** -1
      end

      def * other
        multiply_or_divide :*, other
      end

      def / other
        multiply_or_divide :/, other
      end

      def ** other
        raise TypeError unless other.is_a? Numeric
        return Quantity.dimension_one if other ==  0 || self.dimension_one?
        return self.clone             if other ==  1

        new_dimensions = Hash[dimensions.map{ |dim, pow| [dim, (pow * other).to_i] }].delete_if{ |_, pow| pow == 0 }
        Quantity.new label_for(:**, other), new_dimensions
      end

      def coerce other
        raise TypeError, "#{other.class} can't be coerced to Quantity" unless other.is_a? Numeric
        return Quantity.dimension_one, self
      end

    protected
      def multiply_or_divide operator, other
        return self.clone        if other.is_a? Numeric
        raise TypeError          unless other.is_a? Quantity
        return self.clone        if other.dimension_one?
        other = other.reciprocal if operator == :/
        return other.clone       if self.dimension_one?

        new_dimensions = dimensions.merge(other.dimensions) do |_, pow, other_pow|
          pow + other_pow
        end.delete_if{ |_, pow| pow == 0 }
        Quantity.new label_for(operator, other), new_dimensions
      end

      def label_for operator, other=nil
        case operator
        when :*  then [self.label, other.label].sort.join('.').to_sym
        when :/  then [self.label, other.label].sort.join('/').to_sym
        when :** then [self.label, other.to_superscript].join.to_sym
        else raise TypeError, 'unexpected operator'
        end
      end
    end
  end
end
