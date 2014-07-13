require_relative '../../examples/si/units'

module SI
  module Unit
    describe Common do
      include_context :unit_examples
      
      context 'Inspection' do
        it 'knows if it is unitless' do
          expect(meter              ).not_to be_unitless
          expect(unitless           ).to     be_unitless
          expect(milimeter_per_meter).to     be_unitless
          expect(newton             ).not_to be_unitless
        end

        it 'knows if it is a base unit' do
          expect(meter ).to     be_base
          expect(newton).not_to be_base
        end

        it 'knows if it is a derived unit' do
          expect(meter ).not_to be_derived
          expect(newton).to     be_derived
        end

        it 'knows if it has the same kind as other unit' do
          expect(meter           ).to     be_same_kind_as milimeter
          expect(meter           ).to     be_same_kind_as inch
          expect(meter           ).not_to be_same_kind_as second
          expect(meter_per_second).to     be_same_kind_as kilometer_per_hour
          expect(newton          ).not_to be_same_kind_as psi
        end
      end

      context 'Output' do
        it 'converts itself to String' do
          expect(meter.to_s).to eq 'm'
          expect(meter_per_second.to_s).to eq 'm/s'
        end
      end
    end
  end
end
