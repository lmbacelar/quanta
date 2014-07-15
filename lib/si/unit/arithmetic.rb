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
        Unit::Composite.new [label, '.', other.label    ].join.to_sym,
                            [name,        other.name].join(' ').strip,
                            { self => 1 } , { other => 1 }
      end

      def / other
        raise TypeError unless other.is_a? Unit
        Unit::Composite.new [label, '/', other.label    ].join.to_sym,
                            [name, 'per', other.name].join(' ').strip,
                            { self => 1 } , { other => -1 }
      end

      def ** other
        other = other.base_value if other.is_a?(QuantityValue) && other.unitless?
        raise TypeError unless other.is_a? Numeric
        Unit::Composite.new other == 1 ? label : [label, other.to_superscript].join.to_sym,
                            [name, {1=>'',2=>'squared',3=>'cubed'}.fetch(other){"raised to #{other}"}].join(' ').strip,
                            { self => other }
      end
    end
  end
end
