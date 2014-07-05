require_relative 'system_of_quantities'
require_relative 'quantity'

describe SystemOfQuantities do
        
  let(:soq   ) { SystemOfQuantities.new :soq }
  let(:isq   ) { SystemOfQuantities.new(:isq, name: 'International System of Quantities').load_isq }

  context 'Instance' do
    context 'Creation' do
      it 'should have a label, a name, and a collection of quantities' do
        cgs = SystemOfQuantities.new :c_g_s
        expect(cgs.label     ).to eq :c_g_s
        expect(cgs.name      ).to eq 'c g s'
        expect(cgs.quantities).to respond_to :each
      end

      it 'allows individual addition of base or known quantities' do
        expect{ soq.add :length,   nil,    symbol: 'L' }.to change{ soq.quantities.count }.by 1
        expect{ soq.add :diameter, { length: 1 }       }.to change{ soq.quantities.count }.by 1
      end

      it 'allows bulk addition of quantities' do
        expect {
          soq.configure do
            add :mass, nil, symbol: 'M'
          end
        }.to change{ soq.quantities.count }.by 1
      end

      it 'raises Type Error when adding quantity based on unkown quantities' do
        expect{ soq.add :quantity, { unknown: 1 } }.to raise_error TypeError
      end

      it 'knows how to create itself according to the International System of Quantities' do
        expect(isq.base_quantities.count).to eq 8
        expect(isq.quantities.count     ).to eq 60
      end
    end

    context 'Retrieval' do
      it 'returns quantity for known quantity' do
        mass = Quantity.new :mass, nil, symbol: 'M'
        expect(isq.quantity_for mass  ).to eq mass
        expect(isq.quantity_for :mass ).to eq mass
        expect(isq.quantity_for 'Mass').to eq mass
        expect(isq.quantity_for 'M'   ).to eq mass
      end

      it 'returns quantities using dynamic finders' do
        expect(isq.mass).to eq isq.quantity_for :mass
      end

      it 'raises Type Error for unknown quantity' do
        unknown = Quantity.new :unknown
        expect{ isq.quantity_for unknown   }.to raise_error TypeError
        expect{ isq.quantity_for :unknown  }.to raise_error TypeError
        expect{ isq.quantity_for 'Unknown' }.to raise_error TypeError
      end

      it 'raises Type Error for incorrect type of quantity' do
        expect{ isq.quantity_for [] }.to raise_error TypeError
      end
    end
  end
end
