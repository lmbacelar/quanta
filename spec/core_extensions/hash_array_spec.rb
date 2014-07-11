require_relative '../../lib/core_extensions/hash_array'

describe HashArray do
  context 'Methods' do
    context '#map_hash' do
      it 'directly maps keys, values, in an Array of Hashes' do
        extended_array_of_hashes = [{2 => 1},{4 => 2}].extend(HashArray)
        expect(extended_array_of_hashes.map_hash{ |k,v| k*v }).to eq  [2, 8]
      end
    end
  end
end
