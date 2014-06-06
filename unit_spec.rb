require_relative 'unit'

describe Unit do

  let(:meter) { Unit.new label: :meter, name: 'meter', symbol: 'm', factor: 1, dimension: :length }
  
  context 'Creation' do
    it 'should have a label, a name, a symbol, a factor and a dimension' do
      expect(meter.label    ).to eq :meter
      expect(meter.name     ).to eq 'meter'
      expect(meter.symbol   ).to eq 'm'
      expect(meter.factor   ).to eq 1.0
      expect(meter.dimension).to eq :length
    end

    it 'defaults name to label, factor to 1.0 and dimension to unity' do
      unit = Unit.new label: :meter, symbol: 'm'
      expect(unit.name     ).to eq unit.label.to_s
      expect(unit.factor   ).to eq 1.0
      expect(unit.dimension).to eq :unity
    end

    it 'raises Type Error for non numeric factor' do
      expect{ Unit.new label: :meter, symbol: 'm', factor: 'non numeric' }.to raise_error TypeError
    end
    
    it 'should be immutable' do
      expect{ meter.instance_variable_set :@label,      0 }.to raise_error
      expect{ meter.instance_variable_set :@name,       0 }.to raise_error
      expect{ meter.instance_variable_set :@symbol,     0 }.to raise_error
      expect{ meter.instance_variable_set :@factor,     0 }.to raise_error
      expect{ meter.instance_variable_set :@dimension,  0 }.to raise_error
    end
  end
end
