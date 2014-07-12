require_relative '../../examples/units/plain'
require_relative '../../../lib/unit/list'
require_relative '../../../lib/unit/composite'

RSpec.shared_context :composite_unit_examples do
  include_context :plain_unit_examples

  let(:squared_meter      ) { Unit::Composite.new :m²,     'squared meter',           {meter=> 2}               }
  let(:cubic_meter        ) { Unit::Composite.new :m³,     'cubic meter',             {meter=> 3}               }
  let(:squared_kilometer  ) { Unit::Composite.new :km²,    'kilometer squared',   {kilometer=> 2}               }
  let(:squared_inch       ) { Unit::Composite.new :in²,    'squared inch',        {     inch=> 2}               }
  let(:milimeter_per_meter) { Unit::Composite.new :"mm/m", 'milimeter per meter', {milimeter=> 1}, {meter =>-1} }
  let(:newton             ) { Unit::Composite.new :N,      'Newton', {kilogram => 1}, {meter=> 1}, {second=>-2} }
  let(:pascal             ) { Unit::Composite.new :Pa,     'Pascal', {kilogram => 1}, {meter=>-1}, {second=>-2} }
  let(:psi                ) { Unit::Composite.new :psi,    'psi', {pound_force => 1}, {inch =>-2}               }
  let(:meter_second       ) { Unit::Composite.new :"m.s",  'meter second',            {meter=> 1}, {second=> 1} }
  let(:kilometer_per_hour ) { Unit::Composite.new :"km/h", 'kilometer per hour',  {kilometer=> 1}, {hour  =>-1} }
  let(:meter_per_hour     ) { Unit::Composite.new :"m/h",  'meter per hour',          {meter=> 1}, {hour  =>-1} }
  let(:meter_per_second   ) { Unit::Composite.new :"m/s",  'meter per second',        {meter=> 1}, {second=>-1} }
  let(:meter_per_second_squared) { Unit::Composite.new :"m/s²", 'meter per second',   {meter=> 1}, {second=>-2} }
end
