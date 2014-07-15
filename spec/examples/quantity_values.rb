require_relative '../../lib/isq'
require_relative '../../lib/si/unit/common'
require_relative '../../lib/si/unit/arithmetic'
require_relative '../../lib/si'
require_relative '../../lib/quantity_value'
require_relative 'si/units'

RSpec.shared_context :quantity_value_examples do
  SI.load!

  include_context :unit_examples

  let(:zero                 ) { QuantityValue.new 0, :""                }
  let(:one                  ) { QuantityValue.new 1, :""                }
  let(:two                  ) { QuantityValue.new 2, :""                }
  let(:zero_metres          ) { QuantityValue.new 0, :m                 }
  let(:one_metre            ) { QuantityValue.new 1, :m                 }
  let(:one_kilogram         ) { QuantityValue.new 1, :kg                }
  let(:one_second           ) { QuantityValue.new 1, :s                 }
  let(:other_one_metre      ) { QuantityValue.new 1, :m                 }
  let(:two_metres           ) { QuantityValue.new 2, :m                 }
  let(:three_metres         ) { QuantityValue.new 3, :m                 }
  let(:one_milimetre        ) { QuantityValue.new 1, :mm                }
  let(:one_kilometre        ) { QuantityValue.new 1, :km                }
  let(:one_microinch        ) { QuantityValue.new 1, :µin               }
  let(:one_second           ) { QuantityValue.new 1, :s                 }
  let(:one_hertz            ) { QuantityValue.new 1, :Hz                }
  let(:one_squared_metre    ) { QuantityValue.new 1, :m²                }
  let(:one_squared_kilometre) { QuantityValue.new 1, :km²               }
  let(:one_metre_second     ) { QuantityValue.new 1, :"m.s"             }
  let(:one_metre_per_second ) { QuantityValue.new 1, :"m/s"             }
end

