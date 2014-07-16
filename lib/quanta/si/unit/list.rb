module Quanta
  module SI
    module Unit
      module List
        def valid?
          self.is_a?(Enumerable) and
          self.map{ |object| object.is_a? Hash }.reduce(:&) and
          self.map_unit{ |unit, power| unit.is_a?(Unit) && power.is_a?(Numeric) }.reduce(:&)
        end

        def label
          numerator_label   = numerator.map_unit  { |unit, power| label_for unit, power     }.sort.join('.')
          denominator_label = denominator.map_unit{ |unit, power| label_for unit, power.abs }.sort.join('.')
          "#{numerator_label}#{'/' unless denominator_label.empty?}#{denominator_label}".to_sym
        end

        def name
          numerator_name   = numerator.map_unit  { |unit, power| name_for unit, power     }.sort.join(' ')
          denominator_name = denominator.map_unit{ |unit, power| name_for unit, power.abs }.sort.join(' ')
          "#{numerator_name}#{' per ' unless denominator_name.empty?}#{denominator_name}".strip
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

        def numerator
          self.map_unit{ |unit, power| { unit => power } if power >= 0 }.compact.extend(Unit::List)
        end

        def denominator
          self.map_unit{ |unit, power| { unit => power } if power <  0 }.compact.extend(Unit::List)
        end

        protected
        def map_unit &block
          self.map{ |hash| hash.map { |unit, power| block.call(unit, power) } }.flatten
        end

        def label_for unit, power
          power == 1 ? unit.label : "#{unit.label}#{power.to_superscript}".to_sym
        end

        def name_for unit, power
          unit.name + {1=>'',2=>' squared',3=>' cubed'}.fetch(power){" raised to #{power}"}
        end
      end
    end
  end
end
