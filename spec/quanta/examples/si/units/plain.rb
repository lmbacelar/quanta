require_relative '../../quantities'
require_relative 'prefixes'
require_relative '../../../../../lib/quanta/si/unit/prefix'
require_relative '../../../../../lib/quanta/si/unit/common'
require_relative '../../../../../lib/quanta/si/unit/arithmetic'
require_relative '../../../../../lib/quanta/si/unit/plain'

module Quanta::SI::Unit
  RSpec.shared_context :plain_unit_examples do
    include_context :quantity_examples
    include_context :prefix_examples

    let(:unitless   ) { Plain.unitless                                                           }
    let(:metre      ) { Plain.new :m,   'metre',          1.0,        length                     }
    let(:inch       ) { Plain.new :in,  'inch',           0.0254,     length                     }
    let(:mile       ) { Plain.new :mi,  'mile',           1.609344e3, length                     }
    let(:are        ) { Plain.new :a,   'are',            100.0,      area                       }
    let(:second     ) { Plain.new :s,   'second',         1.0,        time                       }
    let(:hertz      ) { Plain.new :Hz,  'Hertz',          1.0,        frequency                  }
    let(:bequerel   ) { Plain.new :Bq,  'Bequerel',       1.0,        frequency                  }
    let(:hertz      ) { Plain.new :Hz,  'Hertz',          1.0,        frequency                  }
    let(:kelvin     ) { Plain.new :K,   'Kelvin',         1.0,        temperature                }
    let(:celsius    ) { Plain.new :ºC,  'degree Celsius', 1.0,        temperature, scale: 273.15 }
    let(:percent    ) { Plain.new :pct, '%',              1.0e-2,     dimension_one              }
    let(:milimetre  ) { Plain.new :m,   'metre',          1.0,        length,      prefix: mili  }
    let(:kilometre  ) { Plain.new :m,   'metre',          1.0,        length,      prefix: kilo  }
    let(:microinch  ) { Plain.new :in,  'inch',           0.0254,     length,      prefix: micro }
    let(:hour       ) { Plain.new :h,   'hour',           3600.0,     time                       }
    let(:kilogram   ) { Plain.new :g,   'gram',           1.0,        mass,        prefix: kilo  }
    let(:pound      ) { Plain.new :lb,  'pound',          453.59237,  mass                       }
    let(:pound_force) { Plain.new :lbf, 'pound force',    4448.222,   force                      }
  end
end
