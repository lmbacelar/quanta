require_relative 'plain'
require_relative '../../../../../lib/quanta/si/unit/list'
require_relative '../../../../../lib/quanta/si/unit/composite'

module Quanta::SI::Unit
  RSpec.shared_context :composite_unit_examples do
    include_context :plain_unit_examples

    let(:squared_metre      ) { Composite.new :m²,     'squared metre',           {metre=> 2}               }
    let(:cubic_metre        ) { Composite.new :m³,     'cubic metre',             {metre=> 3}               }
    let(:squared_kilometre  ) { Composite.new :km²,    'kilometre squared',   {kilometre=> 2}               }
    let(:squared_inch       ) { Composite.new :in²,    'squared inch',        {     inch=> 2}               }
    let(:milimetre_per_metre) { Composite.new :"mm/m", 'milimetre per metre', {milimetre=> 1}, {metre =>-1} }
    let(:newton             ) { Composite.new :N,      'Newton', {kilogram => 1}, {metre=> 1}, {second=>-2} }
    let(:pascal             ) { Composite.new :Pa,     'Pascal', {kilogram => 1}, {metre=>-1}, {second=>-2} }
    let(:psi                ) { Composite.new :psi,    'psi', {pound_force => 1}, {inch =>-2}               }
    let(:metre_second       ) { Composite.new :"m.s",  'metre second',            {metre=> 1}, {second=> 1} }
    let(:kilometre_per_hour ) { Composite.new :"km/h", 'kilometre per hour',  {kilometre=> 1}, {hour  =>-1} }
    let(:metre_per_hour     ) { Composite.new :"m/h",  'metre per hour',          {metre=> 1}, {hour  =>-1} }
    let(:metre_per_second   ) { Composite.new :"m/s",  'metre per second',        {metre=> 1}, {second=>-1} }
    let(:metre_per_second_squared) { Composite.new :"m/s²", 'metre per second',   {metre=> 1}, {second=>-2} }
  end
end
