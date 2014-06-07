require_relative 'system_of_units'
require_relative 'unit'
require_relative 'prefix'
require_relative 'system_of_quantities'
require_relative 'quantity'

describe SystemOfUnits do

  let(:soq   ) { double }
  let(:sou   ) { SystemOfUnits.new :sou, system_of_quantities: soq }
  let(:si    ) { SystemOfUnits.new(:isq, name: 'International System of Units', system_of_quantities: nil).load_si }
  let(:length) { Quantity.new :length }
  let(:meter ) { Unit.new :meter, 'm', 1.0, length }
  let(:mili  ) { Prefix.new :mili, 'm', 1.0e-3 }

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
        expect{ sou.add_prefix mili }.to change{ sou.prefixes.count }.by 1
      end

      it 'allows bulk addition of prefixes and units' do
        expect {
          sou.configure do
            add_prefix :mili,  'm', 1.0e-3
            add_unit   :meter, 'm', 1.0, Quantity.new(:length)
          end
        }.to change{ sou.prefixes.count }.by 1
      end

      it 'allows individual addition of units' do
        expect{ sou.add_unit :mili, 'm', 1.0e-3, length }.to change{ sou.units.count }.by 1
        expect{ sou.add_unit meter                      }.to change{ sou.units.count }.by 1
      end

      it 'knows how to create itself according to the International System of Units' do
        expect(si.prefixes.count  ).to eq 28
        expect(si.base_units.count).to be 7
      end
    end

    # context 'Retrieval' do
    #   it 'returns quantity for known quantity' do
    #     mass = Quantity.new :mass, nil, symbol: 'M'
    #     expect(isq.quantity_for mass  ).to eq mass
    #     expect(isq.quantity_for :mass ).to eq mass
    #     expect(isq.quantity_for 'Mass').to eq mass
    #     expect(isq.quantity_for 'M'   ).to eq mass
    #   end

    #   it 'returns quantities using dynamic finders' do
    #     expect(isq.mass).to eq isq.quantity_for :mass
    #   end

    #   it 'returns nil for unknown quantity' do
    #     unknown = Quantity.new :unknown
    #     expect(isq.quantity_for unknown  ).to be_nil
    #     expect(isq.quantity_for :unknown ).to be_nil
    #     expect(isq.quantity_for 'Unknown').to be_nil
    #   end

    #   it 'raises Type Error for incorrect type of quantity' do
    #     expect{ isq.quantity_for [] }.to raise_error TypeError
    #   end
    # end
  end
end
