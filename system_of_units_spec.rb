require_relative 'system_of_units'

describe SystemOfUnits do

  let(:soq) { double }
  let(:sou) { SystemOfUnits.new(:sou, system_of_quantities: soq ) }
  let(:si ) { SystemOfUnits.new(:isq, name: 'International System of Units').load_si }

  context 'Instance' do
    context 'Creation' do
      it 'should have a label, a name, a collection of prefixes, a collection of units and a system of quantities' do
        soq = double
        cgs = SystemOfUnits.new :c_g_s, system_of_quantities: soq
        expect(cgs.label               ).to eq :c_g_s
        expect(cgs.name                ).to eq 'c g s'
        expect(cgs.prefixes            ).to respond_to :each
        expect(cgs.units               ).to respond_to :each
        expect(cgs.system_of_quantities).to eq soq
      end

      # it 'allows individual addition of quantities' do
      #   expect{ soq.add :mass,   nil,    symbol: 'M' }.to change{ soq.quantities.count }.by 1
      #   expect{ soq.add :length, length, symbol: 'L' }.to change{ soq.quantities.count }.by 1
      #   expect{ soq.add :radius, length              }.to change{ soq.quantities.count }.by 1
      # end

      # it 'allows bulk addition of quantities' do
      #   expect {
      #     soq.configure do
      #       add :mass, nil, symbol: 'M'
      #     end
      #   }.to change{ soq.quantities.count }.by 1
      # end

      # it 'knows how to create itself according to the International System of Quantities' do
      #   expect(isq.base_quantities.count).to eq 7
      # end
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
