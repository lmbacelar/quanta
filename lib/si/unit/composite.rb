module SI
  module Unit
    class Composite
      include Common
      include Arithmetic

      attr_reader :units 
      def initialize label, name, *units
        raise TypeError, 'units cannot be empty' if units.flatten.empty?
        raise TypeError, 'units must be an Enumerable of Unit => Numeric Hashes' unless units.extend(List).valid?
        @label    = label || units.label
        @name     = name  || units.name
        @units    = units
        @factor   = units.factor
        @quantity = units.quantity
        @hash     = [self.class, label, name, units].hash
        freeze
      end

      def plain?
        false
      end

      def composite?
        true
      end
    end
  end
end
