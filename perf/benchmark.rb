require_relative '../lib/quanta'
require 'benchmark'

puts '---------------------------------------------------------------------------------------------'
puts '  Benchmarking ISQ'
puts '    - quantities:     { Symbol => Numeric }'
puts '    - ISQ.quantities: {}'
puts '---------------------------------------------------------------------------------------------'
Benchmark.bm(30) do |bm|
  bm.report 'loading ISQ' do
    500.times do
      Quanta::ISQ.load!
    end
  end

  Quanta::ISQ.load!
  quantities = Quanta::ISQ.quantities.values
  bm.report 'retrieval by label' do
    500.times do
      quantity = quantities.sample
      Quanta::ISQ.quantity_for quantity.label
    end
  end

  bm.report 'retrieval by name' do
    500.times do
      quantity = quantities.sample
      Quanta::ISQ.quantity_for quantity.name
    end
  end
end
