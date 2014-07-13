require_relative '../../examples/si/units'

module SI
  module Unit
    describe List do
      include_context :unit_examples

      context 'Creation' do
        it 'derives factor from factors of units' do
          expect(kilometre_per_hour.factor).to eq 1000.0/3600.0
        end

        it 'derives quantity from units' do
          expect(metre_per_second.quantity).to be_same_kind_as velocity
          expect(newton.quantity          ).to be_same_kind_as force
        end
      end

      context 'Inspection' do
        it 'is valid for Enumerable of hashes of Unit => Numeric' do
          expect( [{ unitless => 1 }].extend(List)  ).to be_valid
          expect( [{ metre => 1 }, { metre => -1 }].extend(List)  ).to be_valid
          expect( [{ metre => 1 }, { metre => -2 }].extend(List)  ).to be_valid
          expect( [{ metre => 1 }, { second => -1 }].extend(List) ).to be_valid
        end

        it 'is invalid for empty units' do
          expect( [].extend(List)  ).not_to be_valid
        end

        it 'is invalid for non Unit units' do
          expect( [:non_unit].extend(List)          ).not_to be_valid
          expect( [{ :non_unit => 1 }].extend(List) ).not_to be_valid
        end

        it 'is invalid for non indexed units' do
          expect( [metre].extend(List)   ).not_to be_valid
          expect( [[metre]].extend(List) ).not_to be_valid
        end

        it 'is invalid for units indexed to non numeric' do
          expect( [{ metre => :non_numeric }].extend(List) ).not_to be_valid
        end
      end
    end
  end
end
