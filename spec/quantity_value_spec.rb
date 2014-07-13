require_relative 'examples/quantity_values'

describe QuantityValue do
  include_context :quantity_value_examples

  context 'Creation' do
    it 'should have a value and a unit' do
      expect(one_metre.value     ).to eq 1
      expect(one_metre.unit      ).to eq metre
    end

    it 'raises Type Error for non numeric :value' do
      expect{ QuantityValue.new 'non numeric', metre}.to raise_error TypeError
    end

    it 'should be immutable' do
      expect{ one_metre.instance_variable_set :@value,  0 }.to raise_error
      expect{ one_metre.instance_variable_set :@unit,   0 }.to raise_error
      expect{ one_metre.instance_variable_set :@prefix, 0 }.to raise_error
    end
  end

  context 'Inspection' do
    it 'knows when it is unitless' do
      expect(one.unitless?      ).to be_true
      expect(one_metre.unitless?).to be_false
    end
  end

  context 'Output' do
    it 'converts itself to String' do
      expect(one_metre.to_s    ).to eq '1.0 m'
      expect(one_kilometre.to_s).to eq '1.0 km'
    end
  end
  
  context 'Comparison' do
    it 'can compare itself to other quantity values of the same unit and prefix' do
      expect(one_metre  <=> two_metres     ).to eq -1 
      expect(two_metres <=> one_metre      ).to eq  1 
      expect(one_metre  <=> other_one_metre).to eq  0
    end

    it 'can compare itself to other values of same unit and different prefix' do
      one_thousand_metres = QuantityValue.new 1000, metre
      expect(one_kilometre <=> one_metre          ).to eq 1
      expect(one_kilometre <=> one_thousand_metres).to eq 0
    end

    it 'can compare itself to other values of different unit and prefix' do
      expect(one_kilometre <=> one_microinch).to eq 1
    end

    it 'can compare itself to other values of different quantities' do
      expect(one_metre <=> one_second).to eq false
    end

    it 'knows if it is between other values' do
      expect(one_metre.between? zero_metres, two_metres).to be_true
    end

    it 'implements hash equality based on value, unit, prefix' do
      a_hash = { one_metre => :hash_value }
      expect(a_hash[other_one_metre]).to eq :hash_value
    end
  end

  context 'Addition and Subtraction' do
    it 'can add quantity values of the same unit and prefix' do
      expect(one_metre  + two_metres).to eq QuantityValue.new 3, metre
      expect(two_metres + one_metre ).to eq QuantityValue.new 3, metre
    end

    it 'can add quantity values of the same unit and different prefix' do
      expect(one_metre + one_kilometre).to eq QuantityValue.new  1001, metre
      expect(one_kilometre + one_metre).to eq QuantityValue.new 1.001, kilometre
    end

    it 'can add quantity values of different unit and prefix' do
      expect(
        (one_kilometre + one_microinch).between?(
          QuantityValue.new(1.0000000000253999, kilometre),
          QuantityValue.new(1.0000000000254001, kilometre))
      ).to be_true
    end

    it 'can add quantity values of the same unit and different prefix' do
      expect(one_kilometre - one_metre).to eq QuantityValue.new  999, metre
    end

    it 'raises TypeError when added by non quantity value' do
      expect{ one_metre + 3 }.to raise_error TypeError
    end

    it 'raises TypeError when adding quantity values of different quantities' do
      expect{ one_metre + one_second }.to raise_error TypeError
    end

    it 'can subtract quantity values of the same unit and prefix' do
      expect(one_metre - zero_metres).to eq QuantityValue.new 1, metre
      expect(one_metre - one_metre  ).to eq QuantityValue.new 0, metre
    end

    it 'raises TypeError when subtracted by non quantity value' do
      expect{ one_metre - 0 }.to raise_error TypeError
    end

    it 'raises TypeError when subtracting quantity values of different quantities' do
      expect{ one_metre + one_second }.to raise_error TypeError
    end
  end

  context 'Multiplication and Division' do
    it 'can multiply itself by quantity value with same dimensions' do
      expect(one_metre * one_metre).to eq one_squared_metre
    end

    it 'can multiply itself by quantity value with same unit' do
      expect(one_kilometre * one_kilometre).to eq one_squared_kilometre
    end

    it 'can multiply itself by quantity value with same dimensions and different units' do
      expect((one_kilometre * one_metre).to_s).to eq '1.0 km.m'
      expect((one_kilometre / one_metre).base_value).to eq 1000
    end

    it 'can multiply itself by a quantity value with different dimensions' do
      expect(one_metre * one_second).to eq one_metre_second
    end

    it 'can multiply itself by a dimensionless quantity value' do
      expect(one_metre * zero).to eq zero_metres
      expect(one_metre * one ).to eq one_metre
      expect(one_metre * two ).to eq two_metres
      expect(two * one_metre ).to eq two_metres
    end

    it 'can multiply itself by a numeric' do
      expect(one_metre * 2).to eq two_metres
      expect(2 * one_metre).to eq two_metres
    end

    it 'raises TypeError when multiplied by non-numeric' do
      expect{ one_metre * 'not a number' }.to raise_error TypeError
    end

    it 'can divide itself by quantity value with same dimensions' do
      expect(one_metre / one_metre).to eq one
    end

    it 'can divide itself by quantity value with same units' do
      expect(one_kilometre / one_kilometre).to eq one
    end

    it 'can divide itself by quantity value with same dimensions and different prefix' do
      expect((one_milimetre / one_metre).to_s      ).to eq '1.0 mm/m'
      expect((one_milimetre / one_metre).base_value).to eq 0.001
    end

    it 'can divide itself by a quantity value with different dimensions' do
      expect(one_metre / one_second).to eq one_metre_per_second
    end

    it 'can divide itself by a dimensionless quantity value' do
      expect(two_metres / one).to eq two_metres
      expect(two_metres / two).to eq one_metre
    end

    it 'can divide itself by a numeric' do
      expect(two_metres / 2).to eq one_metre
      expect(1 / one_second).to eq one_hertz
    end

    it 'raises TypeError when divided by non-numeric' do
      expect{ one_metre / 'not a number' }.to raise_error TypeError
    end

  end
end
