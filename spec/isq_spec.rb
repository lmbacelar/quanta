require_relative '../lib/isq'
require_relative '../lib/isq/quantity'

describe ISQ do

  context 'Properties' do
    it 'should have a label, a name, and a collection of quantities' do
      ISQ.label = :isq
      ISQ.name  = 'International System Of Quantities'
      expect(ISQ.label     ).to eq :isq
      expect(ISQ.name      ).to eq 'International System Of Quantities'
      expect(ISQ.quantities).to respond_to :each
    end
  end

  context 'International System of Quantities' do
    before(:each) { ISQ.load }

    it 'knows how to create itself according to the International System of Quantities' do
      expect(ISQ.base_quantities.count).to eq 8
      expect(ISQ.quantities.count     ).to eq 60
    end
  end

  context 'Addition' do
    it 'allows individual addition of base or known quantities' do
      expect{ ISQ.add :length,   nil,    symbol: 'L' }.to change{ ISQ.quantities.count }.by 1
      expect{ ISQ.add :diameter, { length: 1 }       }.to change{ ISQ.quantities.count }.by 1
    end

    it 'allows bulk addition of quantities' do
      expect {
        ISQ.configure do
          add :mass, nil, symbol: 'M'
        end
      }.to change{ ISQ.quantities.count }.by 1
    end

    it 'raises TypeError when adding quantity based on unkown quantities' do
      expect{ ISQ.add :quantity, { unknown: 1 } }.to raise_error TypeError
    end
  end

  context 'Retrieval' do
    before(:each) { ISQ.load }
    it 'returns quantity for known quantity' do
      mass = ISQ::Quantity.new :mass, nil, symbol: 'M'
      expect(ISQ.quantity_for mass  ).to eq mass
      expect(ISQ.quantity_for :mass ).to eq mass
      expect(ISQ.quantity_for 'Mass').to eq mass
      expect(ISQ.quantity_for 'M'   ).to eq mass
    end

    it 'returns quantities using dynamic finders' do
      expect(ISQ.mass).to eq ISQ.quantity_for :mass
    end

    it 'raises TypeError for unknown quantity' do
      unknown = ISQ::Quantity.new :unknown
      expect{ ISQ.quantity_for unknown   }.to raise_error TypeError
      expect{ ISQ.quantity_for :unknown  }.to raise_error TypeError
      expect{ ISQ.quantity_for 'Unknown' }.to raise_error TypeError
    end

    it 'raises TypeError for incorrect type of quantity' do
      expect{ ISQ.quantity_for [] }.to raise_error TypeError
    end
  end
end