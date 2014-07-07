require_relative 'examples/plain_units'
require_relative '../lib/composite_unit'
require_relative '../lib/quantity_value'

describe QuantityValue do
  include_context :plain_unit_examples
  let(:zero_meters    ) { QuantityValue.new 0,      meter                                   }
  let(:one_meter      ) { QuantityValue.new 1,      meter                                   }
  let(:other_one_meter) { QuantityValue.new 1,      meter                                   }
  let(:two_meters     ) { QuantityValue.new 2,      meter                                   }
  let(:three_meters   ) { QuantityValue.new 3,      meter                                   }
  let(:one_kilometer  ) { QuantityValue.new 1,      kilometer                               }
  let(:one_microinch  ) { QuantityValue.new 1,      microinch                               }
  let(:one_second     ) { QuantityValue.new 1,      second                                  }

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
    let(:hertz                ) { PlainUnit.new          :Hz,          'Hertz',                    1.0, frequency     }
    let(:squared_meter        ) { PlainUnit.new          :m²,          'squared meter',            1.0, area          }
    let(:squared_kilometer    ) { kilometer * kilometer                                                          }
    let(:meter_second         ) { PlainUnit.new          :m_s,         'meter second',             1,   length_time   }
    let(:meter_per_second     ) { PlainUnit.new          :"m/s",       'meter per second',         1,   velocity      }
    let(:zero                 ) { QuantityValue.new 0,            unitless                                       }
    let(:one                  ) { QuantityValue.new 1,            unitless                                       }
    let(:two                  ) { QuantityValue.new 2,            unitless                                       }
    let(:one_hertz            ) { QuantityValue.new 1,            hertz                                          }
    let(:one_squared_meter    ) { QuantityValue.new 1,            squared_meter                                  }
    let(:one_squared_kilometer) { QuantityValue.new 1,            squared_kilometer                              }
    let(:one_meter_second     ) { QuantityValue.new 1,            meter_second                                   }
    let(:one_meter_per_second ) { QuantityValue.new 1,            meter_per_second                               }

    xit 'can multiply itself by quantity value with same dimensions' do
      expect(one_meter * one_meter).to eq one_squared_meter
    end

    xit 'can multiply itself by quantity value with same unit' do
      expect(one_kilometer * one_kilometer).to eq one_squared_kilometer
    end

    xit 'can multiply itself by quantity value with same dimensions and different units' do
      # TODO: rethink this. what should this do ? 
      #   result with op1 prefix ?                       (1 kilo meter_squared)
      #   result with no prefix ?                        (1_000_000 meter_squared)
      #   result with compound unit and both prefixes ?  (1 kilo meter * kilo meter)
      expect(one_kilometer * one_meter).to eq QuantityValue.new(0.001, squared_kilometer)
    end

    xit 'can multiply itself by a quantity value with different dimensions' do
      expect(one_meter * one_second).to eq one_meter_second
    end

    xit 'can multiply itself by a dimensionless quantity value' do
      expect(one_meter * zero).to eq zero_meters
      expect(one_meter * one ).to eq one_meter
      expect(one_meter * two ).to eq two_meters
      expect(two * one_meter ).to eq two_meters
    end

    xit 'can multiply itself by a numeric' do
      expect(one_meter * 2).to eq two_meters
      expect(2 * one_meter).to eq two_meters
    end

    xit 'raises TypeError when multiplied by non-numeric' do
      expect{ one_meter * 'not a number' }.to raise_error TypeError
    end

    xit 'can divide itself by quantity value with same dimensions' do
      expect(one_meter / one_meter).to eq one
    end

    xit 'can divide itself by quantity value with same units' do
      expect(one_kilometer / one_kilometer).to eq one
    end

    xit 'can divide itself by quantity value with same dimensions and different prefix' do
    # TODO: rethink this. what should this do ? 
    #   result with op1 prefix ?                       (1 kilo meter_squared)
    #   result with no prefix ?                        (1_000_000 meter_squared)
    #   result with compound unit and both prefixes ?  (1 kilo meter * kilo meter)
      expect(one_kilometer / one_meter).to eq QuantityValue.new(1000, unitless)
    end

    xit 'can divide itself by a quantity value with different dimensions' do
      expect(one_meter / one_second).to eq one_meter_per_second
    end

    xit 'can divide itself by a dimensionless quantity value' do
      expect(two_meters / one).to eq two_meters
      expect(two_meters / two).to eq one_meter
    end

    xit 'can didvide itself by a numeric' do
      expect(two_meters / 2).to eq one_meter
      expect(1 / one_second).to eq one_hertz
    end

    xit 'raises TypeError when divided by non-numeric' do
      expect{ one_meter / 'not a number' }.to raise_error TypeError
    end

  end
end
