require_relative '../../core_extensions/integer'
require_relative '../../core_extensions/numeric'

module SI
  module Unit
    module Arithmetic

      include Comparable

      def equal? other
        hash == other.hash
      end

      def <=> other
        return nil unless other.is_a? Unit
        quantity.same_kind_as?(other.quantity) && factor <=> other.factor
      end
      alias_method :eql?, :==

      def * other
        raise TypeError unless other.is_a? Unit
        return self  if other.unitless?
        return other if self.unitless?
        Unit::Composite.new nil, nil, { self => 1 } , { other => 1 }
      end

      def / other
        raise TypeError unless other.is_a? Unit
        return self if other.unitless?
        Unit::Composite.new nil, nil, { self => 1 } , { other => -1 }
      end

      def ** other
        other = other.base_value if other.is_a?(QuantityValue) && other.unitless?
        raise TypeError unless other.is_a? Numeric
        return self if other == 1
        Unit::Composite.new nil, nil, { self => other }
      end
    end
  end
end
