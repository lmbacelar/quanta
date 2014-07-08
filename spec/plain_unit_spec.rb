require_relative 'examples/quantity_values'
require_relative '../lib/composite_unit'

describe PlainUnit do

  # include_context :plain_unit_examples
  include_context :quantity_value_examples
  
  context 'Creation' do
    it 'should have a label, a name, a symbol, a factor, a scale and a quantity' do
      expect(celsius.label   ).to eq :ºC
      expect(celsius.name    ).to eq 'degree Celsius'
      expect(celsius.symbol  ).to eq 'ºC'
      expect(celsius.factor  ).to eq 1.0
      expect(celsius.scale   ).to eq 273.15
      expect(celsius.quantity).to eq temperature
    end

    it 'label, name, symbol, factor are created accordingly, when prefix is present' do
      expect(milimeter.label   ).to eq :mm
      expect(milimeter.name    ).to eq 'milimeter'
      expect(milimeter.symbol  ).to eq 'mm'
      expect(milimeter.factor  ).to eq 1.0e-3
      expect(milimeter.quantity).to eq length
      expect(milimeter.prefix  ).to eq mili
    end

    it 'defaults name and symbol to label, factor to 1.0, scale to 0.0, quantity to base, and prefix to nil' do
      unit = PlainUnit.new :a_label
      expect(unit.name    ).to eq ''
      expect(unit.symbol  ).to eq 'a label'
      expect(unit.factor  ).to eq 1.0
      expect(unit.scale   ).to eq 0.0
      expect(unit.quantity).to eq Quantity.new
      expect(unit.prefix  ).to be_nil
    end

    it 'raises Type Error for non numeric factor' do
      expect{ PlainUnit.new :u, 'unit', :non_numeric }.to raise_error TypeError
    end
    
    it 'raises Type Error for non numeric scale' do
      expect{ PlainUnit.new :u, 'unit', 1.0, length, scale: :non_numeric }.to raise_error TypeError
    end

    it 'raises Type Error for non Quantity quantity' do
      expect{ PlainUnit.new :m, 'meter', 1.0, :non_quantity }.to raise_error TypeError
    end

    it 'should be immutable' do
      expect{ meter.instance_variable_set :@label,     0 }.to raise_error
      expect{ meter.instance_variable_set :@name,      0 }.to raise_error
      expect{ meter.instance_variable_set :@symbol,    0 }.to raise_error
      expect{ meter.instance_variable_set :@factor,    0 }.to raise_error
      expect{ meter.instance_variable_set :@scale,     0 }.to raise_error
      expect{ meter.instance_variable_set :@quantity,  0 }.to raise_error
    end
  end

  context 'Inspection' do
    it 'knows if it is unitless' do
      expect(meter   ).not_to be_unitless
      expect(unitless).to     be_unitless
    end

    it 'knows if it is a base unit' do
      expect(meter).to be_base
    end

    it 'knows if it is a derived unit' do
      expect(meter).not_to be_derived
    end

    it 'knows if it is a prefixed unit' do
      expect(meter    ).not_to be_prefixed
      expect(milimeter).to     be_prefixed
    end

    it 'knows if it has the same kind as other unit' do
      expect(meter).to     be_same_kind_as milimeter
      expect(meter).to     be_same_kind_as inch
      expect(meter).not_to be_same_kind_as second
    end
  end

  context 'Output' do
    it 'converts itself to String' do
      expect(meter.to_s).to eq 'm'
    end
  end

  context 'Comparison' do
    it 'can compare itself to other units of the same quantity' do
      other_meter = meter.clone
      expect(meter <=> inch       ).to eq  1 
      expect(meter <=> other_meter).to eq  0
      expect(meter <=> mile       ).to eq -1 
    end

    it 'can compare itself to other units of different quantity' do
      expect(meter <=> second).to eq false
    end

    it 'knows if it is between other units' do
      expect(meter.between? inch, mile).to be_true
    end

    it 'equals units of same quantity, same factor, different scale' do
      expect(kelvin <=> celsius).to eq 0
    end

    it 'implements hash equality based on label, name, symbol, factors and quantity' do
      a_hash = { meter => :hash_value }
      expect(a_hash[meter.clone]).to eq :hash_value
    end

    it 'returns nil when compared to non unit' do
      expect(meter <=> 'not a unit').to be_nil
    end
  end

  context 'Multiplication and Division' do
    it 'returns a composite unit when multiplied by another unit' do
      expect(meter * meter).to be_a CompositeUnit
    end

    it 'defaults multiplication result label, name according to units labels, names' do
      expect((meter * second).label   ).to eq :"m.s"
      expect((meter * second).name    ).to eq 'meter second'
      expect((meter / second).label   ).to eq :"m/s"
      expect((meter / second).name    ).to eq 'meter per second'
      expect((unitless / second).label).to eq :"/s"
      expect((unitless / second).name ).to eq 'per second'
    end

    it 'can multiply itself by other unit' do
      expect((inch * second).factor).to eq inch.factor * second.factor
      expect(meter * meter).to be_same_kind_as are
    end

    it 'defines multiplication as cumutative' do
      expect(inch * second).to be_same_kind_as(second * inch)
    end

    it 'can divide itself by other quantity' do
      expect(meter    / meter ).to be_same_kind_as unitless
      expect(are      / meter ).to be_same_kind_as meter
      expect(unitless / second).to be_same_kind_as hertz
      expect((inch / second).factor).to eq inch.factor / second.factor
    end

    it 'raises Type Error when multiplied by a non Unit' do
      expect{ meter * 'not a unit' }.to raise_error TypeError
      expect{ meter * 2            }.to raise_error TypeError
    end

    it 'raises Type Error when divided by a non Unit' do
      expect{ meter / 'not a unit' }.to raise_error TypeError
      expect{ meter / 2            }.to raise_error TypeError
    end

    it 'defaults power result label, name according to unit label, name' do
      expect((meter ** -1      ).label).to eq :m⁻¹
      expect((meter **  0      ).label).to eq :m⁰
      expect((meter **  1      ).label).to eq :m
      expect((meter **  2      ).label).to eq :m²
      expect((meter **  11     ).label).to eq :m¹¹
      expect((meter ** -1      ).name ).to eq 'meter raised to -1'
      expect((meter **  0      ).name ).to eq 'meter raised to 0'
      expect((meter **  1      ).name ).to eq 'meter'
      expect((meter **  2      ).name ).to eq 'meter squared'
      expect((meter **  3      ).name ).to eq 'meter cubed'
      expect((meter **  11     ).name ).to eq 'meter raised to 11'
    end

    it 'can power itself to positive integers' do
      expect(meter ** 2).to be_same_kind_as are
      expect((inch ** 2).factor).to eq inch.factor ** 2
    end

    it 'can power itself to zero' do
      expect(meter    ** 0).to be_same_kind_as unitless
      expect(unitless ** 0).to be_same_kind_as unitless
      expect((inch ** 0).factor).to eq 1
    end

    it 'can power itself to negative integers' do
      expect(second   ** -1).to be_same_kind_as hertz
      expect(unitless ** -1).to be_same_kind_as unitless
      expect((inch ** -2).factor).to eq inch.factor ** -2
    end

    it 'can power itself to floats' do
      expect(are ** 0.5).to be_same_kind_as meter
      expect((are ** 0.5).factor).to eq are.factor ** 0.5
    end

    it 'can power itself to unitless quantity value' do
      expect(meter ** two).to eq (meter ** 2)
    end

    it 'raises Type Error when powered to non Numeric' do
      expect{ meter ** 'not a number' }.to raise_error TypeError
      expect{ meter ** meter          }.to raise_error TypeError
    end
  end
end
