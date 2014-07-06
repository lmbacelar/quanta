require_relative 'quantity'
require_relative 'unit'
require_relative 'prefix'
require_relative 'quantity_value'

describe QuantityValue do
  let(:length         ) { Quantity.new      :length                          }
  let(:time           ) { Quantity.new      :time                            }
  let(:micro          ) { Prefix.new        :µ,      :micro,  1.0e-06        }
  let(:kilo           ) { Prefix.new        :k,      :kilo,   1.0e+03        }
  let(:meter          ) { Unit.new          :m,      'meter', 1.0,    length }
  let(:inch           ) { Unit.new          :in,     'inch',  0.0254, length }
  let(:second         ) { Unit.new          :second, time                    }
  let(:zero_meters    ) { QuantityValue.new 0,       meter                   }
  let(:one_meter      ) { QuantityValue.new 1,       meter                   }
  let(:other_one_meter) { QuantityValue.new 1,       meter                   }
  let(:two_meters     ) { QuantityValue.new 2,       meter                   }
  let(:three_meters   ) { QuantityValue.new 3,       meter                   }
  let(:one_kilometer  ) { QuantityValue.new 1,       meter,   kilo           }
  let(:one_microinch  ) { QuantityValue.new 1,       inch,    micro          }
  let(:one_second     ) { QuantityValue.new 1,       second                  }

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

    it 'can subtract quantity values of the same unit and prefix' do
      expect(one_meter - zero_meters).to eq QuantityValue.new 1, meter
      expect(one_meter - one_meter  ).to eq QuantityValue.new 0, meter
    end

    it 'can add quantity values of the same unit and different prefix' do
      expect(one_kilometer - one_meter).to eq QuantityValue.new  999, meter
    end

    it 'raises TypeError when added by non quantity value' do
      expect{ one_meter + 3 }.to raise_error TypeError
    end

    it 'raises TypeError when subtracted by non quantity value' do
      expect{ one_meter - 0 }.to raise_error TypeError
    end

    it 'raises TypeError when adding quantity values of different quantities' do
      expect{ one_meter + one_second }.to raise_error TypeError
    end

    it 'raises TypeError when subtracting quantity values of different quantities' do
      expect{ one_meter + one_second }.to raise_error TypeError
    end
  end
end
