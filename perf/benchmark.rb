require_relative '../lib/quanta'
require 'benchmark'

puts '---------------------------------------------------------------------------------------------'
puts '  Benchmarking ISQ'
puts '    - quantities:     { Quantity => Numeric }'
puts '    - ISQ.quantities: []'
puts '---------------------------------------------------------------------------------------------'
Benchmark.bm(30) do |bm|
  bm.report 'loading ISQ' do
    500.times do
      Quanta::ISQ.load!
    end
  end

  Quanta::ISQ.load!
  bm.report 'retrieval by quantity' do
    500.times do
      quantity = Quanta::ISQ.quantities.sample
      Quanta::ISQ.quantity_for quantity
    end
  end

  bm.report 'retrieval by label' do
    500.times do
      quantity = Quanta::ISQ.quantities.sample
      Quanta::ISQ.quantity_for quantity.quantity
    end
  end

  bm.report 'retrieval by name' do
    500.times do
      quantity = Quanta::ISQ.quantities.sample
      Quanta::ISQ.quantity_for quantity.name
    end
  end
end
