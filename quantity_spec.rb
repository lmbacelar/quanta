require_relative 'quantity'

describe Quantity do

  let(:one_meter) { Quantity.new 1, :meter }

  context 'Creation' do
    it 'should have a value and a unit' do
      expect(one_meter.value).to eq 1
      expect(one_meter.unit ).to eq :meter
    end

    it 'raises Type Error for non numeric :value' do
      expect{ Quantity.new 'non numeric', :meter }.to raise_error TypeError
    end
    
    it 'should be immutable' do
      expect{ one_meter.instance_variable_set :@value, 0 }.to raise_error
      expect{ one_meter.instance_variable_set :@unit,  0 }.to raise_error
    end
  end

  context 'Output' do
    it 'converts itself to String' do
      expect(one_meter.to_s).to eq '1.0 meter'
    end
  end
  
  context 'Comparison' do
    it 'can compare itself to other quantities of the same unit' do
      two_meters = Quantity.new 2, :meter 
      expect(one_meter <=> two_meters).to eq -1 
    end

    it 'can compare itself to other quantities of different unit' do
      one_kilogram = Quantity.new 1, :kilogram
      expect(one_meter <=> one_kilogram).to eq false
    end

    it 'knows if it is between other quantities' do
      zero_meters = Quantity.new 0, :meter
      two_meters  = Quantity.new 2, :meter
      expect(one_meter.between? zero_meters, two_meters).to be_true
    end

    it 'implements hash equality based on value, unit' do
      a_hash = { one_meter => :hash_value }
      expect(a_hash[Quantity.new(1, :meter)]).to eq :hash_value
    end
  end

  context 'Addition and Subtraction' do
    it 'can add quantities of the same unit' do
      two_meters = Quantity.new 2, :meter
      expect(one_meter + two_meters).to eq Quantity.new(3, :meter)
    end

    it 'can subtract quantities of the same unit' do
      two_meters = Quantity.new 2, :meter
      expect(one_meter - two_meters).to eq Quantity.new(-1, :meter)
    end

    it 'raises TypeError when added to non quantity' do
      expect{ one_meter + 3 }.to raise_error TypeError
    end

    it 'raises TypeError when added to quantity with different unit' do
      one_kilogram = Quantity.new 1, :kilogram
      expect{ one_meter + one_kilogram }.to raise_error TypeError
    end

    it 'raises TypeError when subtracted to non quantity' do
      expect{ one_meter - 3 }.to raise_error TypeError
    end

    it 'raises TypeError when subtracted to quantity with different unit' do
      one_kilogram = Quantity.new 1, :kilogram
      expect{ one_meter - one_kilogram }.to raise_error TypeError
    end
  end

  context 'Multiplication and Division' do
    it 'can multiply itself by a numeric' do
      two_meters =  Quantity.new 2, :meter
      expect(one_meter * 2).to eq two_meters
    end

    it 'can divide itself by a numeric' do
      two_meters =  Quantity.new 2, :meter
      expect(two_meters / 2).to eq one_meter
    end

    it 'raises TypeError when multiplied by non-numeric' do
      expect{ one_meter * 'not a number' }.to raise_error TypeError
    end

    it 'raises TypeError when divided by non-numeric' do
      expect{ one_meter / 'not a number' }.to raise_error TypeError
    end
  end

end

