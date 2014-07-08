require_relative '../../lib/core_extensions/array'

describe Array do
  context 'Methods' do
    context '#map_hash' do
      it 'directly maps keys, values, in an Array of Hashes' do
        expect([{2 => 1},{4 => 2}].map_hash{ |k,v| k*v }).to eq  [2, 8]
      end
    end
  end
end
