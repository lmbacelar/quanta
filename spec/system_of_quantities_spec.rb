require_relative '../lib/quantity'
require_relative '../lib/system_of_quantities'

describe SystemOfQuantities do
        
  subject(:soq) { SystemOfQuantities          }

  context 'Properties' do
    it 'should have a label, a name, and a collection of quantities' do
      soq.label = :c_g_s
      soq.name  = 'Centimeter Gram Second'
      expect(soq.label     ).to eq :c_g_s
      expect(soq.name      ).to eq 'Centimeter Gram Second'
      expect(soq.quantities).to respond_to :each
    end
  end

  context 'International System of Quantities' do
    before(:each) { SystemOfQuantities.load_isq }

    it 'knows how to create itself according to the International System of Quantities' do
      expect(soq.base_quantities.count).to eq 8
      expect(soq.quantities.count     ).to eq 60
    end
  end

  context 'Addition' do
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

    it 'raises TypeError when adding quantity based on unkown quantities' do
      expect{ soq.add :quantity, { unknown: 1 } }.to raise_error TypeError
    end
  end

  context 'Retrieval' do
    before(:each) { SystemOfQuantities.load_isq }
    it 'returns quantity for known quantity' do
      mass = Quantity.new :mass, nil, symbol: 'M'
      expect(soq.quantity_for mass  ).to eq mass
      expect(soq.quantity_for :mass ).to eq mass
      expect(soq.quantity_for 'Mass').to eq mass
      expect(soq.quantity_for 'M'   ).to eq mass
    end

    it 'returns quantities using dynamic finders' do
      expect(soq.mass).to eq soq.quantity_for :mass
    end

    it 'raises TypeError for unknown quantity' do
      unknown = Quantity.new :unknown
      expect{ soq.quantity_for unknown   }.to raise_error TypeError
      expect{ soq.quantity_for :unknown  }.to raise_error TypeError
      expect{ soq.quantity_for 'Unknown' }.to raise_error TypeError
    end

    it 'raises TypeError for incorrect type of quantity' do
      expect{ soq.quantity_for [] }.to raise_error TypeError
    end
  end
end
