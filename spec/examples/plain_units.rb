require_relative 'quantities'
require_relative 'prefixes'
require_relative '../../lib/unit'
require_relative '../../lib/plain_unit'

RSpec.shared_context :plain_unit_examples do
  include_context :quantity_examples
  include_context :prefix_examples

  let(:unitless   ) { PlainUnit.unitless                                                           }
  let(:meter      ) { PlainUnit.new :m,   'meter',          1.0,        length                     }
  let(:inch       ) { PlainUnit.new :in,  'inch',           0.0254,     length                     }
  let(:mile       ) { PlainUnit.new :mi,  'mile',           1.609344e3, length                     }
  let(:are        ) { PlainUnit.new :a,   'are',            100.0,      area                       }
  let(:second     ) { PlainUnit.new :s,   'second',         1.0,        time                       }
  let(:hertz      ) { PlainUnit.new :Hz,  'Hertz',          1.0,        frequency                  }
  let(:kelvin     ) { PlainUnit.new :K,   'Kelvin',         1.0,        temperature                }
  let(:celsius    ) { PlainUnit.new :ºC,  'degree Celsius', 1.0,        temperature, scale: 273.15 }
  let(:percent    ) { PlainUnit.new :pct, '%',              1.0e-2,     dimension_one              }
  let(:milimeter  ) { PlainUnit.new :m,   'meter',          1.0,        length,      prefix: mili  }
  let(:kilometer  ) { PlainUnit.new :m,   'meter',          1.0,        length,      prefix: kilo  }
  let(:microinch  ) { PlainUnit.new :in,  'inch',           0.0254,     length,      prefix: micro }
  let(:hour       ) { PlainUnit.new :h,   'hour',           3600.0,     time                       }
  let(:kilogram   ) { PlainUnit.new :g,   'gram',           1.0,        mass,        prefix: kilo  }
  let(:pound      ) { PlainUnit.new :lb,  'pound',          453.59237,  mass                       }
  let(:pound_force) { PlainUnit.new :lbf, 'pound force',    4448.222,   force                      }
end
