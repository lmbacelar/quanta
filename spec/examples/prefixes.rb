require_relative '../../lib/prefix'

RSpec.shared_context :prefix_examples do
  let(:micro) { Prefix.new :µ, 'micro', 1.0e-06 }
  let(:mili ) { Prefix.new :m, 'mili',  1.0e-03 }
  let(:kilo ) { Prefix.new :k, 'kilo',  1.0e+03 }
end

