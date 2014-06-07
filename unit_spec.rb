require_relative 'unit'
require_relative 'quantity'

describe Unit do

  let(:length) { Quantity.new :length }
  let(:meter ) { Unit.new :meter, 'm', 1.0, length }
  
  context 'Creation' do
    it 'should have a label, a name, a symbol, a factor and a quantity' do
      expect(meter.label   ).to eq :meter
      expect(meter.name    ).to eq 'meter'
      expect(meter.symbol  ).to eq 'm'
      expect(meter.factor  ).to eq 1.0
      expect(meter.quantity).to eq length
    end

    it 'defaults name to label, symbol to empty, factor to 1.0 and quantity to unity' do
      unit = Unit.new :a_label
      expect(unit.name    ).to eq 'a label'
      expect(unit.symbol  ).to eq ''
      expect(unit.factor  ).to eq 1.0
      expect(unit.quantity).to eq Quantity.new
    end

    it 'raises Type Error for non numeric factor' do
      expect{ Unit.new :meter, 'm', :non_numeric }.to raise_error TypeError
    end
    
    it 'raises Type Error for non Quantity quantity' do
      expect{ Unit.new :meter, 'm', 1.0, :non_quantity }.to raise_error TypeError
    end

    it 'should be immutable' do
      expect{ meter.instance_variable_set :@label,     0 }.to raise_error
      expect{ meter.instance_variable_set :@name,      0 }.to raise_error
      expect{ meter.instance_variable_set :@symbol,    0 }.to raise_error
      expect{ meter.instance_variable_set :@factor,    0 }.to raise_error
      expect{ meter.instance_variable_set :@quantity,  0 }.to raise_error
    end
  end
end
