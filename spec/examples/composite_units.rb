require_relative 'plain_units'
require_relative '../../lib/composite_unit'

RSpec.shared_context :composite_unit_examples do
  include_context :plain_unit_examples

  let(:squared_meter      ) { CompositeUnit.new :m²,     'squared meter',       [    {meter =>  2}                ] }
  let(:cubic_meter        ) { CompositeUnit.new :m³,     'cubic meter',         [    {meter =>  3}                ] }
  let(:squared_kilometer  ) { CompositeUnit.new :km²,    'kilometer squared',   [{kilometer =>  2}                ] }
  let(:squared_inch       ) { CompositeUnit.new :in²,    'squared inch',        [{     inch =>  2}                ] }
  let(:milimeter_per_meter) { CompositeUnit.new :"mm/m", 'milimeter per meter', [{milimeter =>  1}, {meter =>  -1}] }
  let(:newton             ) { CompositeUnit.new :N,      'Newton', [{kilogram => 1}, {meter =>  1}, {second => -2}] }
  let(:pascal             ) { CompositeUnit.new :Pa,     'Pascal', [{kilogram => 1}, {meter => -1}, {second => -2}] }
  let(:psi                ) { CompositeUnit.new :psi,    'psi', [{pound_force => 1}, {inch  => -2}                ] }
  let(:meter_second       ) { CompositeUnit.new :"m.s",  'meter second',        [    {meter =>  1}, {second =>  1}] }
  let(:kilometer_per_hour ) { CompositeUnit.new :"km/h", 'kilometer per hour',  [{kilometer =>  1}, {hour   => -1}] }
  let(:meter_per_hour     ) { CompositeUnit.new :"m/h",  'meter per hour',      [    {meter =>  1}, {hour   => -1}] }
  let(:meter_per_second   ) { CompositeUnit.new :"m/s",  'meter per second',    [    {meter =>  1}, {second => -1}] }
  let(:meter_per_second_squared) { CompositeUnit.new :"m/s²", 'meter per second',   [{meter =>  1}, {second => -2}] }
end
