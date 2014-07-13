require_relative 'si/units'
require_relative '../../lib/quantity_value'

RSpec.shared_context :quantity_value_examples do
  include_context :unit_examples

  let(:zero                 ) { QuantityValue.new 0, unitless          }
  let(:one                  ) { QuantityValue.new 1, unitless          }
  let(:two                  ) { QuantityValue.new 2, unitless          }
  let(:zero_meters          ) { QuantityValue.new 0, meter             }
  let(:one_meter            ) { QuantityValue.new 1, meter             }
  let(:other_one_meter      ) { QuantityValue.new 1, meter             }
  let(:two_meters           ) { QuantityValue.new 2, meter             }
  let(:three_meters         ) { QuantityValue.new 3, meter             }
  let(:one_milimeter        ) { QuantityValue.new 1, milimeter         }
  let(:one_kilometer        ) { QuantityValue.new 1, kilometer         }
  let(:one_microinch        ) { QuantityValue.new 1, microinch         }
  let(:one_second           ) { QuantityValue.new 1, second            }
  let(:one_hertz            ) { QuantityValue.new 1, hertz             }
  let(:one_squared_meter    ) { QuantityValue.new 1, squared_meter     }
  let(:one_squared_kilometer) { QuantityValue.new 1, squared_kilometer }
  let(:one_meter_second     ) { QuantityValue.new 1, meter_second      }
  let(:one_meter_per_second ) { QuantityValue.new 1, meter_per_second  }
end

