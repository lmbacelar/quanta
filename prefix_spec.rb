require_relative 'prefix'

describe Prefix do

  let(:prefix) { Prefix.new :mili, 'm', 1.0e-3 }

  context 'Instance' do
    context 'Creation' do
      it 'should have a label, a name, a symbol and a factor' do
        expect(prefix.label ).to eq :mili
        expect(prefix.name  ).to eq 'mili'
        expect(prefix.symbol).to eq 'm'
        expect(prefix.factor).to eq 1.0e-3
      end

      it 'defaults factor to 1.0' do
        prefix = Prefix.new :none
        expect(prefix.factor).to eq 1.0
      end

      it 'raises TypeError when factor in not numeric' do
        expect{ Prefix.new :label, 'symbol', :not_a_numeric }.to raise_error TypeError
      end

      it 'should be immutable' do
        expect{ prefix.instance_variable_set :@label,  0 }.to raise_error
        expect{ prefix.instance_variable_set :@name,   0 }.to raise_error
        expect{ prefix.instance_variable_set :@symbol, 0 }.to raise_error
        expect{ prefix.instance_variable_set :@factor, 0 }.to raise_error
      end
    end
  end
end
