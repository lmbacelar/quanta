require_relative 'plain_units'
require_relative '../../lib/composite_unit'

RSpec.shared_context :composite_unit_examples do
  include_context :plain_unit_examples

  let(:meter_squared     ) { CompositeUnit.new :m2,     'meter squared',       [    {meter => 2}                ] }
  let(:meter_per_second  ) { CompositeUnit.new :"m/s",  'meter per second',    [    {meter => 1}, {second => -1}] }
  let(:kilometer_per_hour) { CompositeUnit.new :"km/h", 'kilometer per hour',  [{kilometer => 1}, {hour   => -1}] }
  let(:newton            ) { CompositeUnit.new :"N",    'Newton', [{kilogram => 1}, {meter => 1}, {second => -2}] }
end
