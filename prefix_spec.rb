require_relative 'prefix'

describe Prefix do

  let(:mili) { Prefix.new :mili, 'm', 1.0e-3 }

  context 'Instance' do
    context 'Creation' do
      it 'should have a label, a name, a symbol and a factor' do
        expect(mili.label ).to eq :mili
        expect(mili.name  ).to eq 'mili'
        expect(mili.symbol).to eq 'm'
        expect(mili.factor).to eq 1.0e-3
      end

      it 'defaults factor to 1.0' do
        mili = Prefix.new :none
        expect(mili.factor).to eq 1.0
      end

      it 'raises TypeError when factor in not numeric' do
        expect{ Prefix.new :label, 'symbol', :not_a_numeric }.to raise_error TypeError
      end

      it 'should be immutable' do
        expect{ mili.instance_variable_set :@label,  0 }.to raise_error
        expect{ mili.instance_variable_set :@name,   0 }.to raise_error
        expect{ mili.instance_variable_set :@symbol, 0 }.to raise_error
        expect{ mili.instance_variable_set :@factor, 0 }.to raise_error
      end
    end
  end

  context 'Output' do
    it 'converts itself to String' do
      expect(mili.to_s).to eq 'mili'
    end
  end
end
