require_relative 'unit'
require_relative 'quantity'

describe Unit do

  let(:length) { Quantity.new :length }
  let(:meter ) { Unit.new :m, 'meter', [1.0, 0.0], length }
  
  context 'Creation' do
    it 'should have a label, a name, a symbol, a factors array and a quantity' do
      expect(meter.label   ).to eq :m
      expect(meter.name    ).to eq 'meter'
      expect(meter.symbol  ).to eq 'm'
      expect(meter.factors ).to eq [1.0, 0.0]
      expect(meter.quantity).to eq length
    end

    it 'defaults name to label, symbol to label, factors array to [1.0, 0.0] and quantity to base' do
      unit = Unit.new :a_label
      expect(unit.name    ).to eq ''
      expect(unit.symbol  ).to eq 'a label'
      expect(unit.factors ).to eq [1.0, 0.0]
      expect(unit.quantity).to eq Quantity.new
    end

    it 'raises Type Error for non numeric factors' do
      expect{ Unit.new :u, 'unit', :non_numeric        }.to raise_error TypeError
      expect{ Unit.new :u, 'unit', [1.0, :non_numeric] }.to raise_error
    end
    
    it 'raises Type Error for non Quantity quantity' do
      expect{ Unit.new :m, 'meter', 1.0, :non_quantity }.to raise_error TypeError
    end

    it 'should be immutable' do
      expect{ meter.instance_variable_set :@label,     0 }.to raise_error
      expect{ meter.instance_variable_set :@name,      0 }.to raise_error
      expect{ meter.instance_variable_set :@symbol,    0 }.to raise_error
      expect{ meter.instance_variable_set :@factor,    0 }.to raise_error
      expect{ meter.instance_variable_set :@quantity,  0 }.to raise_error
    end

    context 'Inspection' do
      it 'knows if it is a base unit' do
        expect(meter).to be_base
      end

      it 'knows if it is a derived unit' do
        expect(meter).not_to be_derived
      end
    end
  end
end
