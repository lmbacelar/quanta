require_relative 'examples/quantity_values'

describe QuantityValue do
  include_context :quantity_value_examples

  context 'Creation' do
    it 'should have a value and a unit' do
      expect(one_meter.value     ).to eq 1
      expect(one_meter.unit      ).to eq meter
    end

    it 'raises Type Error for non numeric :value' do
      expect{ QuantityValue.new 'non numeric', meter}.to raise_error TypeError
    end

    it 'should be immutable' do
      expect{ one_meter.instance_variable_set :@value,  0 }.to raise_error
      expect{ one_meter.instance_variable_set :@unit,   0 }.to raise_error
      expect{ one_meter.instance_variable_set :@prefix, 0 }.to raise_error
    end
  end

  context 'Inspection' do
    it 'knows when it is unitless' do
      expect(one.unitless?      ).to be_true
      expect(one_meter.unitless?).to be_false
    end
  end

  context 'Output' do
    it 'converts itself to String' do
      expect(one_meter.to_s    ).to eq '1.0 m'
      expect(one_kilometer.to_s).to eq '1.0 km'
    end
  end
  
  context 'Comparison' do
    it 'can compare itself to other quantity values of the same unit and prefix' do
      expect(one_meter  <=> two_meters     ).to eq -1 
      expect(two_meters <=> one_meter      ).to eq  1 
      expect(one_meter  <=> other_one_meter).to eq  0
    end

    it 'can compare itself to other values of same unit and different prefix' do
      one_thousand_meters = QuantityValue.new 1000, meter
      expect(one_kilometer <=> one_meter          ).to eq 1
      expect(one_kilometer <=> one_thousand_meters).to eq 0
    end

    it 'can compare itself to other values of different unit and prefix' do
      expect(one_kilometer <=> one_microinch).to eq 1
    end

    it 'can compare itself to other values of different quantities' do
      expect(one_meter <=> one_second).to eq false
    end

    it 'knows if it is between other values' do
      expect(one_meter.between? zero_meters, two_meters).to be_true
    end

    it 'implements hash equality based on value, unit, prefix' do
      a_hash = { one_meter => :hash_value }
      expect(a_hash[other_one_meter]).to eq :hash_value
    end
  end

  context 'Addition and Subtraction' do
    it 'can add quantity values of the same unit and prefix' do
      expect(one_meter  + two_meters).to eq QuantityValue.new 3, meter
      expect(two_meters + one_meter ).to eq QuantityValue.new 3, meter
    end

    it 'can add quantity values of the same unit and different prefix' do
      expect(one_meter + one_kilometer).to eq QuantityValue.new  1001, meter
      expect(one_kilometer + one_meter).to eq QuantityValue.new 1.001, kilometer
    end

    it 'can add quantity values of different unit and prefix' do
      expect(
        (one_kilometer + one_microinch).between?(
          QuantityValue.new(1.0000000000253999, kilometer),
          QuantityValue.new(1.0000000000254001, kilometer))
      ).to be_true
    end

    it 'can add quantity values of the same unit and different prefix' do
      expect(one_kilometer - one_meter).to eq QuantityValue.new  999, meter
    end

    it 'raises TypeError when added by non quantity value' do
      expect{ one_meter + 3 }.to raise_error TypeError
    end

    it 'raises TypeError when adding quantity values of different quantities' do
      expect{ one_meter + one_second }.to raise_error TypeError
    end

    it 'can subtract quantity values of the same unit and prefix' do
      expect(one_meter - zero_meters).to eq QuantityValue.new 1, meter
      expect(one_meter - one_meter  ).to eq QuantityValue.new 0, meter
    end

    it 'raises TypeError when subtracted by non quantity value' do
      expect{ one_meter - 0 }.to raise_error TypeError
    end

    it 'raises TypeError when subtracting quantity values of different quantities' do
      expect{ one_meter + one_second }.to raise_error TypeError
    end
  end

  context 'Multiplication and Division' do
    it 'can multiply itself by quantity value with same dimensions' do
      expect(one_meter * one_meter).to eq one_squared_meter
    end

    it 'can multiply itself by quantity value with same unit' do
      expect(one_kilometer * one_kilometer).to eq one_squared_kilometer
    end

    it 'can multiply itself by quantity value with same dimensions and different units' do
      expect((one_kilometer * one_meter).to_s).to eq '1.0 km.m'
      expect((one_kilometer / one_meter).base_value).to eq 1000
    end

    it 'can multiply itself by a quantity value with different dimensions' do
      expect(one_meter * one_second).to eq one_meter_second
    end

    it 'can multiply itself by a dimensionless quantity value' do
      expect(one_meter * zero).to eq zero_meters
      expect(one_meter * one ).to eq one_meter
      expect(one_meter * two ).to eq two_meters
      expect(two * one_meter ).to eq two_meters
    end

    it 'can multiply itself by a numeric' do
      expect(one_meter * 2).to eq two_meters
      expect(2 * one_meter).to eq two_meters
    end

    it 'raises TypeError when multiplied by non-numeric' do
      expect{ one_meter * 'not a number' }.to raise_error TypeError
    end

    it 'can divide itself by quantity value with same dimensions' do
      expect(one_meter / one_meter).to eq one
    end

    it 'can divide itself by quantity value with same units' do
      expect(one_kilometer / one_kilometer).to eq one
    end

    it 'can divide itself by quantity value with same dimensions and different prefix' do
      expect((one_milimeter / one_meter).to_s      ).to eq '1.0 mm/m'
      expect((one_milimeter / one_meter).base_value).to eq 0.001
    end

    it 'can divide itself by a quantity value with different dimensions' do
      expect(one_meter / one_second).to eq one_meter_per_second
    end

    it 'can divide itself by a dimensionless quantity value' do
      expect(two_meters / one).to eq two_meters
      expect(two_meters / two).to eq one_meter
    end

    it 'can divide itself by a numeric' do
      expect(two_meters / 2).to eq one_meter
      expect(1 / one_second).to eq one_hertz
    end

    it 'raises TypeError when divided by non-numeric' do
      expect{ one_meter / 'not a number' }.to raise_error TypeError
    end

  end
end
