require_relative '../../../lib/unit/prefix'

RSpec.shared_context :prefix_examples do
  let(:micro) { Unit::Prefix.new :µ, 'micro', 1.0e-06 }
  let(:mili ) { Unit::Prefix.new :m, 'mili',  1.0e-03 }
  let(:kilo ) { Unit::Prefix.new :k, 'kilo',  1.0e+03 }
end

