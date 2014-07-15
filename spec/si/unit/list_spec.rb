require_relative '../../examples/si/units'

module SI
  module Unit
    describe List do
      include_context :unit_examples
      let(:units                 ) { units = [{ kilogram =>  1 }, { metre => 1 }, { second   => -2 }] }
      let(:shuffled_units        ) { units = [{ second   => -2 }, { metre => 1 }, { kilogram => 1  }] }
      let(:numerator_only_units  ) { units = [{ kilogram =>  1 }, { metre => 1 }                    ] }
      let(:denominator_only_units) { units = [                                    { second   => -2 }] }

      context 'Creation' do
        it 'derives label from labels of units' do
          expect( units.extend(List).label                  ).to eq :"kg.m/s²"
          expect( shuffled_units.extend(List).label         ).to eq :"kg.m/s²"
          expect( numerator_only_units.extend(List).label   ).to eq :"kg.m"
          expect( denominator_only_units.extend(List).label ).to eq :"/s²"
        end

        it 'derives name from names of units' do
          expect( units.extend(List).name                 ).to eq 'kilogram metre per second squared'
          expect( shuffled_units.extend(List).name        ).to eq 'kilogram metre per second squared'
          expect( numerator_only_units.extend(List).name  ).to eq 'kilogram metre'
          expect( denominator_only_units.extend(List).name).to eq 'per second squared'
        end

        it 'derives factor from factors of units' do
          expect(kilometre_per_hour.factor).to eq 1000.0/3600.0
        end

        it 'derives quantity from units' do
          expect(metre_per_second.quantity).to be_same_kind_as velocity
          expect(newton.quantity          ).to be_same_kind_as force
        end
      end

      context 'Inspection' do
        it 'retrieves numerator units from list' do
          expect( units.extend(List).numerator ).to eq [{ kilogram => 1 }, { metre => 1 }]
        end

        it 'retrieves denominator units from list' do
          expect( units.extend(List).denominator ).to eq [{ second => -2 }]
        end

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
