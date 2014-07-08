require_relative 'plain_units'
require_relative 'composite_units'

RSpec.shared_context :unit_examples do
  include_context :plain_unit_examples
  include_context :composite_unit_examples
end


