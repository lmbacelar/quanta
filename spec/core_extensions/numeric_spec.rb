require_relative '../../lib/core_extensions/numeric'

describe Numeric do
  context 'Methods' do
    context '#to_superscript' do
      it 'returns string representation of numeric, prepended with character ^' do
        expect(   0.to_superscript).to eq '^0'
        expect(   1.to_superscript).to eq '^1'
        expect( 4.2.to_superscript).to eq '^4.2'
        expect(  -1.to_superscript).to eq '^-1'
        expect(-4.2.to_superscript).to eq '^-4.2'
      end
    end
  end
end
