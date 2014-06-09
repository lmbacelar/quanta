require_relative 'unit'
require_relative 'quantity'
require 'debugger'

describe Unit do

  let(:length     ) { Quantity.new :length                                            }
  let(:time       ) { Quantity.new :time                                              }
  let(:temperature) { Quantity.new :temperature                                    }
  let(:area       ) { Quantity.new :area, { length => 2 }                             }
  let(:one        ) { Quantity.one                                                    }
  let(:meter      ) { Unit.new :m,   'meter',  1.0,        length                     }
  let(:inch       ) { Unit.new :in,  'inch',   0.0254,     length                     }
  let(:mile       ) { Unit.new :mi,  'mile',   1.609344e3, length                     }
  let(:are        ) { Unit.new :a,   'are',    100.0,      area                       }
  let(:second     ) { Unit.new :s,   'second', 1.0,        time                       }
  let(:kelvin     ) { Unit.new :K,   'Kelvin', 1.0,        temperature, scale: 273.15 }
  let(:unitless   ) { Unit.new :one, '',       1.0,        time                       }
  let(:percent    ) { Unit.new :pct, '%',      1.0e-2,     time                       }
  
  context 'Creation' do
    it 'should have a label, a name, a symbol, a factor, a scale and a quantity' do
      expect(kelvin.label   ).to eq :K
      expect(kelvin.name    ).to eq 'Kelvin'
      expect(kelvin.symbol  ).to eq 'K'
      expect(kelvin.factor  ).to eq 1.0
      expect(kelvin.scale   ).to eq 273.15
      expect(kelvin.quantity).to eq temperature
    end

    it 'defaults name to label, symbol to label, factor to 1.0, scale to 0.0 and quantity to base' do
      unit = Unit.new :a_label
      expect(unit.name    ).to eq ''
      expect(unit.symbol  ).to eq 'a label'
      expect(unit.factor  ).to eq 1.0
      expect(unit.scale   ).to eq 0.0
      expect(unit.quantity).to eq Quantity.new
    end

    it 'raises Type Error for non numeric factor' do
      expect{ Unit.new :u, 'unit', :non_numeric }.to raise_error TypeError
    end
    
    it 'raises Type Error for non numeric scale' do
      expect{ Unit.new :u, 'unit', 1.0, length, scale: :non_numeric }.to raise_error TypeError
    end

    it 'raises Type Error for non Quantity quantity' do
      expect{ Unit.new :m, 'meter', 1.0, :non_quantity }.to raise_error TypeError
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
    it 'knows if it is a base unit' do
      expect(meter).to be_base
    end

    it 'knows if it is a derived unit' do
      expect(meter).not_to be_derived
    end

    it 'knows if it has the same kind as other unit' do
      expect(meter).to     be_same_kind_as inch
      expect(meter).not_to be_same_kind_as second
    end
  end

  context 'Output' do
    it 'converts itself to String' do
      expect(meter.to_s).to eq 'm'
    end
    
    # TODO: Compound units string conversion
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

    it 'implements hash equality based on label, name, symbol, factors and quantity' do
      a_hash = { meter => :hash_value }
      expect(a_hash[meter.clone]).to eq :hash_value
    end

    # TODO: Compound units comparison
  end

  context 'Multiplication and Division' do
    it 'can multiply itself by other unit' do
      expect(meter * meter).to be_same_kind_as are
      # expect(length * one ).to be_same_kind_as length
    end

    # it 'can multiply itself by a numeric and vice-versa' do
    #   expect(length * 2).to eq length
    #   expect(2 * length).to eq length
    # end

    # it 'defines multiplication as cumutative' do
    #   expect(area * length  ).to be_same_kind_as(length * area)
    #   expect(velocity * time).to be_same_kind_as(time * velocity)
    # end

    # it 'can divide itself by other quantity' do
    #   expect(length / time       ).to be_same_kind_as velocity
    #   expect(area / one).to be_same_kind_as area
    #   expect(one / time).to be_same_kind_as frequency
    # end

    # it 'can divide itself by a numeric, and vice-versa' do
    #   expect(time / 1).to be_same_kind_as time
    #   expect(1 / time).to be_same_kind_as frequency

    # end

    # it 'raises Type Error when multiplied by a non Numeric or non Quantity' do
    #   expect{ length * 'not a quantity' }.to raise_error TypeError
    # end

    # it 'raises Type Error when divided by a non Numeric or non Quantity' do
    #   expect{ length / 'not a quantity' }.to raise_error TypeError
    # end

    # it 'can power itself to positive integers' do
    #   expect(length ** 2).to be_same_kind_as area
    #   expect(length ** 1).to be_same_kind_as length
    #   expect(one ** 2   ).to be_same_kind_as one
    # end

    # it 'can power itself to zero' do
    #   expect(length ** 0).to be_same_kind_as one
    #   expect(one ** 0   ).to be_same_kind_as one
    # end

    # it 'can power itself to negative integers' do
    #   expect(time ** -1).to be_same_kind_as frequency
    #   expect(one ** -1 ).to be_same_kind_as one
    # end

    # it 'can power itself to floats' do
    #   expect(area ** 0.5).to be_same_kind_as length
    # end

    # it 'raises Type Error when powered to non Numeric' do
    #   expect{ length ** 'not a number' }.to raise_error TypeError
    #   expect{ length ** length         }.to raise_error TypeError
    # end
  end
end
