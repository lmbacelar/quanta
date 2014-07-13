module SI
  module Unit
    module List
      def valid?
        self.is_a?(Enumerable) and
        self.map{ |object| object.is_a? Hash }.reduce(:&) and
        self.map_unit{ |unit, power| unit.is_a?(Unit) && power.is_a?(Numeric) }.reduce(:&)
      end

      def factor
        self.map_unit{ |unit, power| unit.factor ** power }.reduce(:*)
      end

      def quantity
        quantities.map_unit{ |quantity, power| quantity ** power }.reduce(:*)
      end

      def quantities
        self.map_unit{ |unit, power| {unit.quantity => power} }.extend(Unit::List)
      end

      protected
      def map_unit &block
        self.map{ |hash| hash.map { |unit, power| block.call(unit, power) } }.flatten
      end
    end
  end
end
