require_relative '../../../lib/quanta/core_extensions/numeric'

describe Numeric do
  context 'Methods' do
    context '#to_superscript' do
      it 'returns string representation of numeric, prepended with character ^' do
        expect( 0.0.to_superscript).to eq '^0.0'
        expect( 1.0.to_superscript).to eq '^1.0'
        expect( 4.2.to_superscript).to eq '^4.2'
        expect(-1.0.to_superscript).to eq '^-1.0'
        expect(-4.2.to_superscript).to eq '^-4.2'
      end
    end
  end
end
