require_relative 'quantity'

describe Quantity do

  let(:length       ) { Quantity.new :length,        nil,                          symbol: 'L' }
  let(:time         ) { Quantity.new :time,          nil,                          symbol: 'T' }
  let(:area         ) { Quantity.new :area,          { length => 2 },              symbol: 'A' }
  let(:velocity     ) { Quantity.new :velocity,      { length => 1 , time => -1 }, symbol: 'V' }
  let(:frequency    ) { Quantity.new :frequency,     { time => -1 },               symbol: 'F' }
  let(:radioactivity) { Quantity.new :radioactivity, { time => -1 },               symbol: 'R' }
  let(:one          ) { Quantity.new :one,           {},                           symbol: '1' }
    
  context 'Instance' do
    context 'Creation' do
      it 'should have a quantity, a name, a symbol and a set of dimensions' do
        expect(length.quantity).to eq :length
        expect(length.name    ).to eq 'length'
        expect(length.symbol  ).to eq 'L'
        expect(length         ).to respond_to :dimensions
      end

      it 'defaults to base quantity, name to quantity, symbol to uppercase quantity)' do
        quantity = Quantity.new :some_quantity
        expect(quantity.name  ).to eq 'some quantity'
        expect(quantity.symbol).to eq 'SOME_QUANTITY'
        expect(quantity).to be_base
      end

      it 'can be created using existing quantity' do
        expect(Quantity.new :radius,      length,        symbol: 'R'    ).to be_a Quantity
        expect(Quantity.new :plane_angle, Quantity.one, symbol: 'ANGLE').to be_a Quantity
      end

      it 'for base quantities, sets dimensions to self to the power of one' do
        expect(length.dimensions).to eq({ length => 1 })
      end

      it 'for non-base quantities, sets dimensions according to passed dimensions' do
        expect(area.dimensions).to eq({ length => 2 })
      end

      it 'raises Type Error when dimensions_or_quantity is not nil, a hash or a quantity' do
        expect{ Quantity.new :length, [] }.to raise_error
      end

      it 'should be immutable' do
        expect{ length.instance_variable_set :@quantity,   0 }.to raise_error
        expect{ length.instance_variable_set :@name,       0 }.to raise_error
        expect{ length.instance_variable_set :@symbol,     0 }.to raise_error
        expect{ length.instance_variable_set :@dimensions, 0 }.to raise_error
      end
    end

    context 'Output' do
      it 'converts itself to String for one dimension' do
        expect(length.to_s).to eq 'L'
      end

      it 'converts itself to String for two equal dimensions' do
        expect(area.to_s).to eq 'L^2'
      end
      it 'converts itself to String for two different dimensions' do
        expect(velocity.to_s).to eq 'L . T^-1'
      end
    end

    context 'Comparison' do
      it 'can compare itself to other base quantities' do
        other_length = length.clone
        expect(length).to     eq other_length
        expect(area  ).not_to eq other_length
      end

      it 'can compare itself to other derived quantities' do
        other_length   = length.clone
        other_time     = time.clone
        other_velocity = Quantity.new :velocity, { other_length => 1, other_time => -1 }, symbol: 'V' 
        expect(velocity).to     eq other_velocity
        expect(area    ).not_to eq other_velocity
      end

      it 'implements hash equality based on quantity, name, symbol and dimensions' do
        a_hash = { length => :hash_value }
        expect(a_hash[length.clone]).to eq :hash_value
      end
    end

    context 'Equivalence' do
      it 'base unit is equivalent to itself' do
        expect(length).to be_same_kind_as length
      end

      it 'derived unit is equivalent to itself' do
        expect(area).to be_same_kind_as area
      end

      it 'is equivalent to other quantity with the same dimensions' do
        expect(frequency).to be_same_kind_as radioactivity
      end

      it 'is not equivalent to other base quantities' do
        expect(length).not_to be_same_kind_as time
      end

      it 'is not equivalent to other distint derived quantities' do
        expect(area).not_to be_same_kind_as velocity
      end
    end

    context 'Multiplication, Division and Power' do
      it 'can multiply itself by other quantity' do
        expect(length * length).to be_same_kind_as area
        expect(length * one   ).to be_same_kind_as length
      end

      it 'can multiply itself by a numeric and vice-versa' do
        expect(length * 2).to eq length
        expect(2 * length).to eq length
      end

      it 'defines multiplication as cumutative' do
        expect(area * length  ).to be_same_kind_as(length * area)
        expect(velocity * time).to be_same_kind_as(time * velocity)
      end

      it 'can divide itself by other quantity' do
        expect(length / time       ).to be_same_kind_as velocity
        expect(area / one).to be_same_kind_as area
        expect(one / time).to be_same_kind_as frequency
      end

      it 'can divide itself by a numeric, and vice-versa' do
        expect(time / 1).to be_same_kind_as time
        expect(1 / time).to be_same_kind_as frequency

      end

      it 'raises Type Error when multiplied by a non Numeric or non Quantity' do
        expect{ length * 'not a quantity' }.to raise_error TypeError
      end

      it 'raises Type Error when divided by a non Numeric or non Quantity' do
        expect{ length / 'not a quantity' }.to raise_error TypeError
      end

      it 'can power itself to positive integers' do
        expect(length ** 2).to be_same_kind_as area
        expect(length ** 1).to be_same_kind_as length
        expect(one ** 2   ).to be_same_kind_as one
      end

      it 'can power itself to zero' do
        expect(length ** 0).to be_same_kind_as one
        expect(one ** 0   ).to be_same_kind_as one
      end

      it 'can power itself to negative integers' do
        expect(time ** -1).to be_same_kind_as frequency
        expect(one ** -1 ).to be_same_kind_as one
      end

      it 'can power itself to floats' do
        expect(area ** 0.5).to be_same_kind_as length
      end

      it 'raises Type Error when powered to non Numeric' do
        expect{ length ** 'not a number' }.to raise_error TypeError
        expect{ length ** length         }.to raise_error TypeError
      end
    end
  end
end
