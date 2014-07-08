require_relative 'plain_units'
require_relative '../../lib/composite_unit'

RSpec.shared_context :composite_unit_examples do
  include_context :plain_unit_examples

  let(:squared_meter      ) { CompositeUnit.new :m²,     'meter squared',       [    {meter => 2}                ] }
  let(:squared_kilometer  ) { CompositeUnit.new :km²,    'kilometer squared',   [{kilometer => 2}                ] }
  let(:meter_second       ) { CompositeUnit.new :"m.s",  'meter second',        [    {meter => 1}, {second =>  1}] }
  let(:milimeter_per_meter) { CompositeUnit.new :"mm/m", 'milimeter per meter', [{milimeter => 1}, {meter =>  -1}] }
  let(:meter_per_second   ) { CompositeUnit.new :"m/s",  'meter per second',    [    {meter => 1}, {second => -1}] }
  let(:kilometer_per_hour ) { CompositeUnit.new :"km/h", 'kilometer per hour',  [{kilometer => 1}, {hour   => -1}] }
  let(:newton             ) { CompositeUnit.new :"N",    'Newton', [{kilogram => 1}, {meter => 1}, {second => -2}] }
end
