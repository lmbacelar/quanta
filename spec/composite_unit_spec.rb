require_relative 'examples/plain_units'
require_relative 'examples/composite_units'

describe CompositeUnit do
  include_context :composite_unit_examples

  context 'Creation' do
    it 'should have a label, a name, a factor and a collection of indexed units' do
      expect(meter_per_second.label ).to eq :"m/s"
      expect(meter_per_second.name  ).to eq 'meter per second'
      expect(meter_per_second.factor).to eq 1.0
      expect(meter_per_second.units ).to respond_to :each
    end

    it 'derives factor from factors of units' do
      expect(kilometer_per_hour.factor).to eq 1000.0/3600.0
    end

    it 'should have quantity according to its indexed units' do
      expect(meter_per_second.quantity).to be_same_kind_as velocity
      expect(newton.quantity          ).to be_same_kind_as force
    end

    it 'raises Type Error for empty units' do
      expect{ CompositeUnit.new :u, 'unit', {} }.to raise_error TypeError
      expect{ CompositeUnit.new :u, 'unit' }.to raise_error TypeError
    end

    it 'raises Type Error for non Unit units' do
      expect{ CompositeUnit.new :u, 'unit', :non_unit }.to raise_error TypeError
    end

    it 'raises Type Error for non indexed units' do
      expect{ CompositeUnit.new :u, 'unit', meter }.to raise_error TypeError
    end

    it 'raises Type Error for units indexed to non numeric' do
      expect{ CompositeUnit.new :u, 'unit', meter => :non_numeric }.to raise_error TypeError
    end

    it 'should be immutable' do
      expect{ meter_per_second.instance_variable_set :@label,  0 }.to raise_error
      expect{ meter_per_second.instance_variable_set :@name,   0 }.to raise_error
      expect{ meter_per_second.instance_variable_set :@factor, 0 }.to raise_error
      expect{ meter_per_second.instance_variable_set :@units,  0 }.to raise_error
    end
  end

  context 'Inspection' do
    it 'knows when it is unitless' do
      expect(milimeter_per_meter.unitless?).to be_true
      expect(newton.unitless?             ).to be_false
    end

    it 'knows if it has the same kind as other composite unit' do
      expect(meter_per_second).to be_same_kind_as kilometer_per_hour
      expect(meter).not_to be_same_kind_as second
    end
  end

  context 'Output' do
    it 'converts itself to String' do
      expect(meter_per_second.to_s).to eq 'm/s'
    end
  end
end
