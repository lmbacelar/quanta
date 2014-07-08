require_relative 'plain_units'

RSpec.shared_context :composite_unit_examples do
  include_context :plain_unit_examples

  let(:squared_meter    ) { meter * meter         }
  let(:squared_kilometer) { kilometer * kilometer }
  let(:meter_second     ) { meter * second        }
  let(:meter_per_second ) { meter / second        }
end
