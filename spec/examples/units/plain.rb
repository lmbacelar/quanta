require_relative '../quantities'
require_relative 'prefixes'
require_relative '../../../lib/unit/prefix'
require_relative '../../../lib/unit/common'
require_relative '../../../lib/unit/arithmetic'
require_relative '../../../lib/unit/plain'

RSpec.shared_context :plain_unit_examples do
  include_context :quantity_examples
  include_context :prefix_examples

  let(:unitless   ) { Unit::Plain.unitless                                                           }
  let(:meter      ) { Unit::Plain.new :m,   'meter',          1.0,        length                     }
  let(:inch       ) { Unit::Plain.new :in,  'inch',           0.0254,     length                     }
  let(:mile       ) { Unit::Plain.new :mi,  'mile',           1.609344e3, length                     }
  let(:are        ) { Unit::Plain.new :a,   'are',            100.0,      area                       }
  let(:second     ) { Unit::Plain.new :s,   'second',         1.0,        time                       }
  let(:hertz      ) { Unit::Plain.new :Hz,  'Hertz',          1.0,        frequency                  }
  let(:kelvin     ) { Unit::Plain.new :K,   'Kelvin',         1.0,        temperature                }
  let(:celsius    ) { Unit::Plain.new :ºC,  'degree Celsius', 1.0,        temperature, scale: 273.15 }
  let(:percent    ) { Unit::Plain.new :pct, '%',              1.0e-2,     dimension_one              }
  let(:milimeter  ) { Unit::Plain.new :m,   'meter',          1.0,        length,      prefix: mili  }
  let(:kilometer  ) { Unit::Plain.new :m,   'meter',          1.0,        length,      prefix: kilo  }
  let(:microinch  ) { Unit::Plain.new :in,  'inch',           0.0254,     length,      prefix: micro }
  let(:hour       ) { Unit::Plain.new :h,   'hour',           3600.0,     time                       }
  let(:kilogram   ) { Unit::Plain.new :g,   'gram',           1.0,        mass,        prefix: kilo  }
  let(:pound      ) { Unit::Plain.new :lb,  'pound',          453.59237,  mass                       }
  let(:pound_force) { Unit::Plain.new :lbf, 'pound force',    4448.222,   force                      }
end
