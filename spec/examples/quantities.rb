require_relative '../../lib/system_of_quantities/quantity'

module SystemOfQuantities
  RSpec.shared_context :quantity_examples do
    let(:dimension_one) { Quantity.new :dimension_one, {},                         symbol: '1'     }
    let(:length       ) { Quantity.new :length,        nil,                        symbol: 'L'     }
    let(:time         ) { Quantity.new :time,          nil,                        symbol: 'T'     }
    let(:mass         ) { Quantity.new :mass,          nil,                        symbol: 'M'     }
    let(:temperature  ) { Quantity.new :temperature,   nil,                        symbol: 'THETA' }
    let(:area         ) { Quantity.new :area,          {length => 2},              symbol: 'A'     }
    let(:frequency    ) { Quantity.new :frequency,     {              time => -1}, symbol: 'F'     }
    let(:radioactivity) { Quantity.new :radioactivity, {              time => -1}, symbol: 'R'     }
    let(:velocity     ) { Quantity.new :velocity,      {length =>  1, time => -1}, symbol: 'V'     }
    let(:acceleration ) { Quantity.new :acceleration,  {length =>  1, time => -2}                  }
    let(:force        ) { Quantity.new :force,         {length =>  1, time => -2, mass => 1}       }
    let(:length_time  ) { Quantity.new :length_time,   {length =>  1, time =>  1}                  }
  end
end
