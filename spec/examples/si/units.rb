require_relative 'units/plain'
require_relative 'units/composite'

RSpec.shared_context :unit_examples do
  include_context :plain_unit_examples
  include_context :composite_unit_examples
end


