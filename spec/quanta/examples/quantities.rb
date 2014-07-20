require_relative '../../../lib/quanta/isq/quantity'

module Quanta::ISQ
  RSpec.shared_context :quantity_examples do
    let(:dimension_one) { Quantity.new :dimension_one, symbol: '1',    dimensions: {}                              }
    let(:length       ) { Quantity.new :length,        symbol: 'L'                                                 }
    let(:time         ) { Quantity.new :time,          symbol: 'T'                                                 }
    let(:mass         ) { Quantity.new :mass,          symbol: 'M'                                                 }
    let(:temperature  ) { Quantity.new :temperature,   symbol: 'THETA'                                             }
    let(:area         ) { Quantity.new :area,          symbol: 'A',    dimensions: {length: 2}                     }
    let(:frequency    ) { Quantity.new :frequency,     symbol: 'F',    dimensions: {            time: -1}          }
    let(:radioactivity) { Quantity.new :radioactivity, symbol: 'R',    dimensions: {            time: -1}          }
    let(:velocity     ) { Quantity.new :velocity,      symbol: 'V',    dimensions: {length:  1, time: -1}          }
    let(:acceleration ) { Quantity.new :acceleration,                  dimensions: {length:  1, time: -2}          }
    let(:force        ) { Quantity.new :force,                         dimensions: {length:  1, time: -2, mass: 1} }
    let(:length_time  ) { Quantity.new :length_time,                   dimensions: {length:  1, time:  1}          }
  end
end
