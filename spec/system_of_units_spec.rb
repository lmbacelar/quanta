require_relative '../lib/system_of_units'
require_relative '../lib/system_of_quantities'
require_relative 'examples/plain_units'

describe SystemOfUnits do

  include_context :plain_unit_examples

  let(:soq   ) { SystemOfQuantities.new :soq }
  let(:sou   ) { SystemOfUnits.new :sou, system_of_quantities: soq }
  let(:si    ) { SystemOfUnits.new(:isq, name: 'International System of Units').load_si }

  context 'Instance' do
    context 'Creation' do
      it 'should have a label, a name, a collection of prefixes, a collection of units and a system of quantities' do
        expect(sou.label               ).to eq :sou
        expect(sou.name                ).to eq 'sou'
        expect(sou.prefixes            ).to respond_to :each
        expect(sou.units               ).to respond_to :each
        expect(sou.system_of_quantities).to eq soq
      end

      it 'allows individual addition of prefixes' do
        expect{ sou.add_prefix :mili, 'm', 1.0e-3 }.to change{ sou.prefixes.count }.by 1
      end

      it 'allows bulk addition of prefixes' do
        expect {
          sou.configure do
            add_prefix :mili,  'm',     1.0e-3
          end
        }.to change{ sou.prefixes.count }.by 1
      end

      it 'allows individual addition of units' do
        soq.add :length, nil
        expect{ sou.add_unit :m, 'meter', 1.0, :length }.to change{ sou.units.count }.by 1
      end

      it 'knows how to create itself according to the International System of Units' do
        expect(si.prefixes.count     ).to eq 28
        expect(si.base_units.count   ).to be 8
        expect(si.derived_units.count).to be 160
        expect(si.units.count        ).to be 168
      end
    end
  end
end