require_relative 'quantity'
require_relative 'unit'
require_relative 'prefix'
require_relative 'quantity_value'

describe QuantityValue do
  let(:length         ) { Quantity.new      :length                          }
  let(:time           ) { Quantity.new      :time                            }
  let(:micro          ) { Prefix.new        :µ,     :micro,   1.0e-06        }
  let(:kilo           ) { Prefix.new        :k,     :kilo,    1.0e+03        }
  let(:meter          ) { Unit.new          :m,     'meter',  1,      length }
  let(:inch           ) { Unit.new          :in,    'inch',   0.0254, length }
  let(:second         ) { Unit.new          :s,     'second', 1,      time   }
  let(:zero_meters    ) { QuantityValue.new 0,      meter                    }
  let(:one_meter      ) { QuantityValue.new 1,      meter                    }
  let(:other_one_meter) { QuantityValue.new 1,      meter                    }
  let(:two_meters     ) { QuantityValue.new 2,      meter                    }
  let(:three_meters   ) { QuantityValue.new 3,      meter                    }
  let(:one_kilometer  ) { QuantityValue.new 1,      meter,    kilo           }
  let(:one_microinch  ) { QuantityValue.new 1,      inch,     micro          }
  let(:one_second     ) { QuantityValue.new 1,      second                   }

  context 'Creation' do
    it 'should have a value, a unit, and an optional prefix' do
      expect(one_meter.value     ).to eq 1
      expect(one_meter.unit      ).to eq meter
      expect(one_meter.prefix    ).to be_nil
      expect(one_kilometer.prefix).to eq kilo
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
      expect(one_kilometer + one_meter).to eq QuantityValue.new 1.001, meter, kilo
    end

    it 'can add quantity values of different unit and prefix' do
      expect(
        (one_kilometer + one_microinch).between?(
          QuantityValue.new(1.0000000000253999, meter, kilo),
          QuantityValue.new(1.0000000000254001, meter, kilo))
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
    let(:dimensionless        ) { Quantity.one                                                                   }
    let(:area                 ) { Quantity.new      :area,        { length => 2             }                    }
    let(:frequency            ) { Quantity.new      :frequency,   {              time => -1 }                    }
    let(:length_time          ) { Quantity.new      :length_time, { length => 1, time =>  1 }                    }
    let(:velocity             ) { Quantity.new      :velocity   , { length => 1, time => -1 }                    }
    let(:unitless             ) { Unit.new          :_,           'unitless',                 1.0, dimensionless }
    let(:hertz                ) { Unit.new          :Hz,          'Hertz',                    1.0, frequency     }
    let(:squared_meter        ) { Unit.new          :m²,          'squared meter',            1.0, area          }
    let(:meter_second         ) { Unit.new          :m_s,         'meter second',             1,   length_time   }
    let(:meter_per_second     ) { Unit.new          :"m/s",       'meter per second',         1,   velocity      }
    let(:zero                 ) { QuantityValue.new 0,            unitless                                       }
    let(:one                  ) { QuantityValue.new 1,            unitless                                       }
    let(:two                  ) { QuantityValue.new 2,            unitless                                       }
    let(:one_hertz            ) { QuantityValue.new 1,            hertz                                          }
    let(:one_squared_meter    ) { QuantityValue.new 1,            squared_meter                                  }
    let(:one_squared_kilometer) { QuantityValue.new 1,            squared_meter,              kilo               }
    let(:one_meter_second     ) { QuantityValue.new 1,            meter_second                                   }
    let(:one_meter_per_second ) { QuantityValue.new 1,            meter_per_second                               }

    it 'can multiply itself by quantity value with same dimensions' do
      expect(one_meter * one_meter).to eq one_squared_meter
    end

    it 'can multiply itself by quantity value with same prefix and dimensions' do
      # TODO: rethink this. what should this do ? 
      #   result with op1 prefix ?                       (1 kilo meter_squared)
      #   result with no prefix ?                        (1_000_000 meter_squared)
      #   result with compound unit and both prefixes ?  (1 kilo meter * kilo meter)
      expect(one_kilometer * one_kilometer).to eq one_squared_kilometer
    end

    it 'can multiply itself by quantity value with same dimensions and different prefix' do
      # TODO: rethink this. what should this do ? 
      #   result with op1 prefix ?                       (1 kilo meter_squared)
      #   result with no prefix ?                        (1_000_000 meter_squared)
      #   result with compound unit and both prefixes ?  (1 kilo meter * kilo meter)
      expect(one_kilometer * one_meter).to eq QuantityValue.new(0.001, squared_meter, kilo)
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

    # it 'can divide itself by quantity value with same prefix and dimensions' do
    # # TODO: rethink this. what should this do ? 
    # #   result with op1 prefix ?                       (1 kilo meter_squared)
    # #   result with no prefix ?                        (1_000_000 meter_squared)
    # #   result with compound unit and both prefixes ?  (1 kilo meter * kilo meter)
    #   expect(one_kilometer / one_kilometer).to eq one
    # end

    # it 'can divide itself by quantity value with same dimensions and different prefix' do
    # # TODO: rethink this. what should this do ? 
    # #   result with op1 prefix ?                       (1 kilo meter_squared)
    # #   result with no prefix ?                        (1_000_000 meter_squared)
    # #   result with compound unit and both prefixes ?  (1 kilo meter * kilo meter)
    #   expect(one_kilometer / one_meter).to eq QuantityValue.new(1000, unitless)
    # end

    it 'can divide itself by a quantity value with different dimensions' do
      expect(one_meter / one_second).to eq one_meter_per_second
    end

    it 'can divide itself by a dimensionless quantity value' do
      expect(two_meters / one).to eq two_meters
      expect(two_meters / two).to eq one_meter
    end

    it 'can didvide itself by a numeric' do
      expect(two_meters / 2).to eq one_meter
      expect(1 / one_second).to eq one_hertz
    end

    it 'raises TypeError when divided by non-numeric' do
      expect{ one_meter / 'not a number' }.to raise_error TypeError
    end

  end
end
