require_relative '../../lib/quanta/si'
require_relative '../../lib/quanta/isq'
require_relative 'examples/si/units/composite'

module Quanta
  describe SI do
    include_context :composite_unit_examples

    context 'Properties' do
      it 'should have a label, name, collection of prefixes, collection of units and system of quantities' do
        SI.label = :c_g_s
        SI.name  = 'Centimetre Gram Second'
        SI.isq   = ISQ
        expect(SI.label   ).to eq :c_g_s
        expect(SI.name    ).to eq 'Centimetre Gram Second'
        expect(SI.prefixes).to respond_to :each
        expect(SI.units   ).to respond_to :each
        expect(SI.isq     ).to eq ISQ
      end
    end

    context 'International System of Units' do
      before(:each) { SI.load! }

      it 'knows how to create itself according to the International System of Units' do
        expect(SI.prefixes.count      ).to eq 28
        expect(SI.base_units.count    ).to be 8
        expect(SI.derived_units.count ).to be 158
        expect(SI.units.count         ).to be 166
        expect(SI.isq).to eq ISQ
      end

      it 'accounts kilogram as a base unit' do
        expect(SI.kilogram).to be_base
      end

      it 'does not account gram as a base unit' do
        expect(SI.gram).not_to be_base
      end
    end

    context 'Clearing' do
      it 'clears itself' do
        SI.clear!
        expect(SI.prefixes     ).to be_empty
        expect(SI.base_units   ).to be_empty
        expect(SI.derived_units).to be_empty
        expect(SI.units        ).to be_empty
        expect(SI.label        ).to be_nil
        expect(SI.name         ).to be_nil
        expect(SI.isq          ).to be_nil
      end
    end

    context 'Addition' do
      context 'on an empty SI' do
        before(:each) do
          SI.clear!
          SI.isq = ISQ.load!
        end

        it 'allows individual addition of prefixes' do
          expect{ SI.add_prefix :mili, 'm', 1.0e-3 }.to change{ SI.prefixes.count }.by 1
        end
        
        it 'allows bulk addition of prefixes' do
          expect {
            SI.configure do
              add_prefix :mili,  'm',     1.0e-3
            end
          }.to change{ SI.prefixes.count }.by 1
        end

        it 'allows individual addition of units' do
          expect{ SI.add_unit :m, 'metre', 1.0, :length }.to change{ SI.units.count }.by 1
        end

        it 'allows individual addition of prefixed unit for existing prefix, unit' do
          SI.add_unit   :m, 'metre', 1.0,   :length
          SI.add_prefix :m, 'mili',  1.0e-3
          expect{ SI.add_prefixed_unit :milimetre }.to change{ SI.units.count }.by 1
          expect( SI.units.map &:label ).to include :mm
        end

        it 'allows individual addition of composite units for existing plain units' do
          SI.load_prefixes!
          SI.load_units! :base
          expect{ SI.add_composite_unit :"kg.m" }.to change{ SI.units.count }.by(1)
          expect( SI.units.map{ |u| u.label }   ).to include :"kg.m"
          expect{ SI.add_composite_unit :"kg.m/s²" }.to change{ SI.units.count }.by(1)
          expect( SI.units.map{ |u| u.label }   ).to include :"kg.m/s²"
          expect{ SI.add_composite_unit :"/s" }.to change{ SI.units.count }.by(1)
          expect( SI.units.map{ |u| u.label }   ).to include :"/s"
        end
      end

      context 'on a populated SI' do
        before(:each) { SI.load! }

        it 'does not add already existing prefixes' do
          expect{ SI.add_prefix :mili, 'm', 1.0e-3 }.not_to change{ SI.prefixes.count }
        end

        it 'does not add already existing units' do
          expect{ SI.add_unit :m, 'metre', 1.0, :length }.not_to change{ SI.units.count }
        end

        it 'does not add already existing prefixed unit' do
          SI.add_prefixed_unit :milimetre
          expect{ SI.add_prefixed_unit :milimetre }.not_to change{ SI.units.count }
        end

        it 'does not add already existing composite unit' do
          SI.add_composite_unit :"kg.m/s²"
          expect{ SI.add_composite_unit :"kg.m/s²" }.not_to change{ SI.units.count }
        end

        it 'does not prefix already prefixed unit' do
          SI.add_prefixed_unit :milimetre
          expect{ SI.add_prefixed_unit :kilomilimetre }.to raise_error TypeError
          expect{ SI.add_prefixed_unit :milikilogram  }.to raise_error TypeError
        end

        it 'prefixes gram' do
          expect{ SI.add_prefixed_unit :miligram }.to change{ SI.units.count }.by(1)
        end

        it 'dynamically adds unexisting prefixed units when first accessed' do
          expect{ SI.unit_for :milimetre }.to change{ SI.units.count }.by(1)
          expect{ SI.unit_for :mg        }.to change{ SI.units.count }.by(1)
        end

        it 'dynamically adds unexisting composite units when first accessed' do
          expect{ SI.unit_for :"kg.m/s²" }.to change{ SI.units.count }.by(1)
        end
      end
    end

    context 'Retrieval' do
      before(:each) { SI.load! }
      it 'returns unit for known unit' do
        expect(SI.unit_for metre  ).to eq metre
        expect(SI.unit_for :m     ).to eq metre
        expect(SI.unit_for 'metre').to eq metre
        expect(SI.unit_for 'm'    ).to eq metre
      end

      it 'returns prefix for known prefix' do
        expect(SI.prefix_for mili  ).to eq mili
        expect(SI.prefix_for :m    ).to eq mili
        expect(SI.prefix_for 'mili').to eq mili
        expect(SI.prefix_for 'm'   ).to eq mili
      end

      it 'returns units using dynamic finders' do
        expect(SI.metre    ).to eq SI.unit_for   :metre
        expect(SI.milimetre).to eq SI.unit_for   :milimetre
        expect(SI.micro    ).to eq SI.prefix_for :micro
      end

      it 'raises TypeError for unknown unit' do
        qty  = ISQ::Quantity.new :qty, nil
        unit = SI::Unit::Plain.new :unit, 'unit', 1.0, qty
        expect{ SI.unit_for unit   }.to raise_error TypeError
        expect{ SI.unit_for :unit  }.to raise_error TypeError
        expect{ SI.unit_for 'unit' }.to raise_error TypeError
      end

      it 'raises TypeError for incorrect type of unit' do
        expect{ SI.unit_for [] }.to raise_error TypeError
      end

      it 'raises TypeError for unknown prefix' do
        prefix = SI::Unit::Prefix.new :prefix, 'prefix', 1.0
        expect{ SI.prefix_for prefix   }.to raise_error TypeError
        expect{ SI.prefix_for :prefix  }.to raise_error TypeError
        expect{ SI.prefix_for 'prefix' }.to raise_error TypeError
      end

      it 'raises TypeError for incorrect type of prefix' do
        expect{ SI.prefix_for [] }.to raise_error TypeError
      end
    end
  end
end
