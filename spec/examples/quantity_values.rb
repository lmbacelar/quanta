require_relative 'si/units'
require_relative '../../lib/quantity_value'

RSpec.shared_context :quantity_value_examples do
  include_context :unit_examples

  let(:zero                 ) { QuantityValue.new 0, unitless          }
  let(:one                  ) { QuantityValue.new 1, unitless          }
  let(:two                  ) { QuantityValue.new 2, unitless          }
  let(:zero_metres          ) { QuantityValue.new 0, metre             }
  let(:one_metre            ) { QuantityValue.new 1, metre             }
  let(:other_one_metre      ) { QuantityValue.new 1, metre             }
  let(:two_metres           ) { QuantityValue.new 2, metre             }
  let(:three_metres         ) { QuantityValue.new 3, metre             }
  let(:one_milimetre        ) { QuantityValue.new 1, milimetre         }
  let(:one_kilometre        ) { QuantityValue.new 1, kilometre         }
  let(:one_microinch        ) { QuantityValue.new 1, microinch         }
  let(:one_second           ) { QuantityValue.new 1, second            }
  let(:one_hertz            ) { QuantityValue.new 1, hertz             }
  let(:one_squared_metre    ) { QuantityValue.new 1, squared_metre     }
  let(:one_squared_kilometre) { QuantityValue.new 1, squared_kilometre }
  let(:one_metre_second     ) { QuantityValue.new 1, metre_second      }
  let(:one_metre_per_second ) { QuantityValue.new 1, metre_per_second  }
end

