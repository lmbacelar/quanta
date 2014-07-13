require_relative 'plain'
require_relative '../../../../lib/si/unit/list'
require_relative '../../../../lib/si/unit/composite'

module SI
  module Unit
    RSpec.shared_context :composite_unit_examples do
      include_context :plain_unit_examples

      let(:squared_meter      ) { Composite.new :m²,     'squared meter',           {meter=> 2}               }
      let(:cubic_meter        ) { Composite.new :m³,     'cubic meter',             {meter=> 3}               }
      let(:squared_kilometer  ) { Composite.new :km²,    'kilometer squared',   {kilometer=> 2}               }
      let(:squared_inch       ) { Composite.new :in²,    'squared inch',        {     inch=> 2}               }
      let(:milimeter_per_meter) { Composite.new :"mm/m", 'milimeter per meter', {milimeter=> 1}, {meter =>-1} }
      let(:newton             ) { Composite.new :N,      'Newton', {kilogram => 1}, {meter=> 1}, {second=>-2} }
      let(:pascal             ) { Composite.new :Pa,     'Pascal', {kilogram => 1}, {meter=>-1}, {second=>-2} }
      let(:psi                ) { Composite.new :psi,    'psi', {pound_force => 1}, {inch =>-2}               }
      let(:meter_second       ) { Composite.new :"m.s",  'meter second',            {meter=> 1}, {second=> 1} }
      let(:kilometer_per_hour ) { Composite.new :"km/h", 'kilometer per hour',  {kilometer=> 1}, {hour  =>-1} }
      let(:meter_per_hour     ) { Composite.new :"m/h",  'meter per hour',          {meter=> 1}, {hour  =>-1} }
      let(:meter_per_second   ) { Composite.new :"m/s",  'meter per second',        {meter=> 1}, {second=>-1} }
      let(:meter_per_second_squared) { Composite.new :"m/s²", 'meter per second',   {meter=> 1}, {second=>-2} }
    end
  end
end
