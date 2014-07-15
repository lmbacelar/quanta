require_relative '../../examples/quantity_values'

module SI
  module Unit
    describe Arithmetic do
      include_context :quantity_value_examples

      context 'Comparison' do
        it 'can compare itself to other units of the same quantity' do
          other_metre = metre.clone
          expect(metre <=> inch       ).to eq  1 
          expect(metre <=> other_metre).to eq  0
          expect(metre <=> mile       ).to eq -1 
          expect(psi   <=> pascal     ).to eq  1 
        end

        it 'can compare itself to other units of different quantity' do
          expect(metre  <=> second).to eq false
          expect(metre  <=> newton).to eq false
          expect(pascal <=> newton).to eq false
        end

        it 'knows if it is between other units' do
          expect(metre.between? inch, mile).to be_true
          expect(kilometre_per_hour.between? metre_per_hour, metre_per_second).to be_true
        end

        it 'returns nil when compared to non unit' do
          expect(metre <=> 'not a unit').to be_nil
          expect(psi   <=> 'not a unit').to be_nil
        end
      end

      context 'Multiplication and Division' do
        it 'defaults multiplication result label, name according to units labels, names' do
          expect((metre * second).label   ).to eq :"m.s"
          expect((metre * second).name    ).to eq 'metre second'
          expect((metre / second).label   ).to eq :"m/s"
          expect((metre / second).name    ).to eq 'metre per second'
          expect((unitless / second).label).to eq :"/s"
          expect((unitless / second).name ).to eq 'per second'
          expect((pound_force / squared_inch).label).to eq :"lbf/in²"
          expect((pound_force / squared_inch).name ).to eq 'pound force per squared inch'
        end

        it 'can multiply itself by other unit' do
          expect((inch * second).factor             ).to eq inch.factor * second.factor
          expect(metre * metre                      ).to be_same_kind_as are
          expect(kilogram * metre_per_second_squared).to be_same_kind_as newton
          expect(squared_metre * metre              ).to be_same_kind_as cubic_metre
          expect(pascal * squared_metre             ).to be_same_kind_as newton
        end

        it 'defines multiplication as cumutative' do
          expect(inch * second         ).to be_same_kind_as(second * inch)
          expect(pascal * squared_metre).to be_same_kind_as(squared_metre * pascal)
        end

        it 'can divide itself by other unit' do
          expect((inch / second).factor).to eq inch.factor / second.factor
          expect((pound / squared_inch).factor).to eq pound.factor / (inch.factor ** 2)
          expect(metre    / metre      ).to be_same_kind_as unitless
          expect(are      / metre      ).to be_same_kind_as metre
          expect(unitless / second     ).to be_same_kind_as hertz
          expect(metre / metre_second  ).to be_same_kind_as hertz
          expect(newton / kilogram     ).to be_same_kind_as metre_per_second_squared
          expect(newton / squared_metre).to be_same_kind_as pascal
        end

        it 'raises Type Error when multiplied by a non Unit' do
          expect{ metre * 'not a unit' }.to raise_error TypeError
          expect{ metre * 2            }.to raise_error TypeError
          expect{ psi   * :not_a_unit  }.to raise_error TypeError
        end

        it 'raises Type Error when divided by a non Unit' do
          expect{ metre / 'not a unit' }.to raise_error TypeError
          expect{ metre / 2            }.to raise_error TypeError
          expect{ psi   / :not_a_unit  }.to raise_error TypeError
        end
      end

      context 'Exponentiation' do
        it 'defaults power result label, name according to unit label, name' do
          expect((metre ** -2      ).label).to eq :"/m²"
          expect((metre ** -1      ).label).to eq :"/m"
          expect((metre **  0      ).label).to eq :m⁰
          expect((metre **  1      ).label).to eq :m
          expect((metre **  2      ).label).to eq :m²
          expect((metre **  11     ).label).to eq :m¹¹
          expect((metre ** -2      ).name ).to eq 'per metre squared'
          expect((metre ** -1      ).name ).to eq 'per metre'
          expect((metre **  0      ).name ).to eq 'metre raised to 0'
          expect((metre **  1      ).name ).to eq 'metre'
          expect((metre **  2      ).name ).to eq 'metre squared'
          expect((metre **  3      ).name ).to eq 'metre cubed'
          expect((metre **  11     ).name ).to eq 'metre raised to 11'
          expect((psi   **  2      ).label).to eq :psi²
        end

        it 'can power itself to positive integers' do
          expect(metre ** 2).to be_same_kind_as are
          expect((inch ** 2).factor).to eq inch.factor ** 2
          expect((psi  ** 2).factor).to eq psi.factor ** 2
        end

        it 'can power itself to zero' do
          expect(metre    ** 0).to be_same_kind_as unitless
          expect(unitless ** 0).to be_same_kind_as unitless
          expect(psi      ** 0).to be_same_kind_as unitless
          expect((inch ** 0).factor).to eq 1
        end

        it 'can power itself to negative integers' do
          expect(second   ** -1).to be_same_kind_as hertz
          expect(unitless ** -1).to be_same_kind_as unitless
          expect((inch ** -2).factor).to eq inch.factor ** -2
        end

        it 'can power itself to floats' do
          expect(are ** 0.5).to be_same_kind_as metre
          expect(squared_metre ** 0.5).to be_same_kind_as metre
          expect((are ** 0.5).factor).to eq are.factor ** 0.5
          expect((squared_metre ** 0.5).factor).to eq squared_metre.factor ** 0.5
        end

        it 'can power itself to unitless quantity value' do
          expect(metre ** two).to eq (metre ** 2)
          expect(psi   ** two).to eq (psi   ** 2)
        end

        it 'raises Type Error when powered to non Numeric' do
          expect{ metre ** 'not a number' }.to raise_error TypeError
          expect{ metre ** metre          }.to raise_error TypeError
          expect{ psi   ** :not_a_number  }.to raise_error TypeError
        end
      end
    end
  end
end

