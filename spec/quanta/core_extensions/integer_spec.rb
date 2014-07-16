require_relative '../../../lib/quanta/core_extensions/integer'

describe Integer do
  context 'Methods' do
    context '#to_superscript' do
      it 'returns UTF-8 superscript characters for non-negative integers' do
        expect(0.to_superscript  ).to eq '⁰'
        expect(1.to_superscript  ).to eq '¹'
        expect(42.to_superscript ).to eq '⁴²'
      end
       
      it 'returns UTF-8 superscript characters for negative integers' do
        expect(-1.to_superscript ).to eq '⁻¹'
        expect(-42.to_superscript).to eq '⁻⁴²'
      end
    end
  end
end
