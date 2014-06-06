require_relative 'dimension'

describe Dimension do

  let(:length       ) { Dimension.new :length,        symbol: 'L' }
  let(:time         ) { Dimension.new :time,          symbol: 'T' }
  let(:area         ) { Dimension.new :area,          symbol: 'A', dimensions: { length => 2 } }
  let(:velocity     ) { Dimension.new :velocity,      symbol: 'V', dimensions: { length => 1 , time => -1 } }
  let(:frequency    ) { Dimension.new :frequency,     symbol: 'F', dimensions: { time => -1 } }
  let(:radioactivity) { Dimension.new :radioactivity, symbol: 'R', dimensions: { time => -1 } }
  let(:one          ) { Dimension.new :one,           symbol: '1', dimensions: {} }
    
  context 'Instance' do
    context 'Creation' do
      it 'should have a label, a name, a symbol and a set of dimensions' do
        expect(length.label ).to eq :length
        expect(length.name  ).to eq 'length'
        expect(length.symbol).to eq 'L'
        expect(length       ).to respond_to :dimensions
      end

      it 'defaults to base dimension, name to label, symbol to uppercase label)' do
        dimension = Dimension.new :length
        expect(dimension.name      ).to eq dimension.label.to_s
        expect(dimension.symbol    ).to eq dimension.label.to_s.upcase
        expect(dimension).to be_base
      end

      it 'for base dimensions, sets dimensions to self to the power of one' do
        expect(length.dimensions).to eq({ length => 1 })
      end

      it 'for non-base dimensions, sets dimension according to passed dimensions' do
        expect(area.dimensions).to eq({ length => 2 })
      end

      it 'raises Type Error when dimensions is not a Hash' do
        expect{ Dimension.new :length, symbol: 'L', dimensions: [] }.to raise_error
      end

      it 'should be immutable' do
        expect{ length.instance_variable_set :@label,      0 }.to raise_error
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
      it 'can compare itself to other base dimensions' do
        other_length = length.clone
        expect(length).to     eq other_length
        expect(area  ).not_to eq other_length
      end

      it 'can compare itself to other derived dimensions' do
        other_length   = length.clone
        other_time     = time.clone
        other_velocity = Dimension.new :velocity, symbol: 'V', dimensions: { other_length => 1, other_time => -1 } 
        expect(velocity).to     eq other_velocity
        expect(area    ).not_to eq other_velocity
      end

      it 'implements hash equality based on label, name, symbol and dimensions' do
        a_hash = { length => :hash_value }
        expect(a_hash[length.clone]).to eq :hash_value
      end
    end

    context 'Equivalence' do
      it 'base unit is equivalent to itself' do
        expect(length).to be_equivalent_to length
      end

      it 'derived unit is equivalent to itself' do
        expect(area).to be_equivalent_to area
      end

      it 'is equivalent to other dimension with the same dimensions' do
        expect(frequency).to be_equivalent_to radioactivity
      end

      it 'is not equivalent to other base dimensions' do
        expect(length).not_to be_equivalent_to time
      end

      it 'is not equivalent to other distint derived dimensions' do
        expect(area).not_to be_equivalent_to velocity
      end
    end

    context 'Multiplication, Division and Power' do
      it 'can multiply itself by other dimension' do
        expect(length * length).to be_equivalent_to area
        expect(length * one   ).to be_equivalent_to length
      end

      it 'can multiply itself by a numeric and vice-versa' do
        expect(length * 2).to eq length
        expect(2 * length).to eq length
      end

      it 'defines multiplication as cumutative' do
        expect(area * length  ).to be_equivalent_to(length * area)
        expect(velocity * time).to be_equivalent_to(time * velocity)
      end

      it 'can divide itself by other dimension' do
        expect(length / time       ).to be_equivalent_to velocity
        expect(area / one).to be_equivalent_to area
        expect(one / time).to be_equivalent_to frequency
      end

      it 'can divide itself by a numeric, and vice-versa' do
        expect(time / 1).to be_equivalent_to time
        expect(1 / time).to be_equivalent_to frequency

      end

      it 'raises Type Error when multiplied by a non Numeric or non Dimension' do
        expect{ length * 'not a dimension' }.to raise_error TypeError
      end

      it 'raises Type Error when divided by a non Numeric or non Dimension' do
        expect{ length / 'not a dimension' }.to raise_error TypeError
      end

      it 'can power itself to positive integers' do
        expect(length ** 2).to be_equivalent_to area
        expect(length ** 1).to be_equivalent_to length
        expect(one ** 2   ).to be_equivalent_to one
      end

      it 'can power itself to zero' do
        expect(length ** 0).to be_equivalent_to one
        expect(one ** 0   ).to be_equivalent_to one
      end

      it 'can power itself to positive integers' do
        expect(time ** -1).to be_equivalent_to frequency
        expect(one ** -1 ).to be_equivalent_to one
      end

      it 'can power itself to floats' do
        expect(area ** 0.5).to be_equivalent_to length
      end

      it 'raises Type Error when powered to non Numeric' do
        expect{ length ** 'not a number' }.to raise_error TypeError
        expect{ length ** length         }.to raise_error TypeError
      end
    end
  end
end
