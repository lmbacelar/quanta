require_relative '../../examples/si/units/prefixes'

module Quanta::SI::Unit
  describe Prefix do
    include_context :prefix_examples

    context 'Instance' do
      context 'Creation' do
        it 'should have a label, a name, a symbol and a factor' do
          expect(mili.label ).to eq :m
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
        expect(mili.to_s).to eq 'm'
      end
    end

    context 'Comparison' do
      it 'is identity equal only to prefixes with the same label, factor, name and symbol' do
        expect(mili.clone).to     equal mili
        expect(kilo      ).not_to equal micro
      end

      it 'can compare itself to other prefixes' do
        other_mili = mili.clone
        expect(mili <=> micro     ).to eq  1 
        expect(mili <=> other_mili).to eq  0
        expect(mili <=> kilo      ).to eq -1 
      end

      it 'knows if it is between other prefixes' do
        expect(mili.between? micro, kilo).to     be_true
        expect(kilo.between? mili, micro).not_to be_true
      end

      it 'returns nil when compared to non prefix' do
        expect(mili <=> 'not a unit').to be_nil
      end

      it 'implements hash equality based on label, factor, name and symbol' do
        a_hash = { mili => :hash_value }
        expect(a_hash[mili.clone]).to eq :hash_value
      end
    end
  end
end
