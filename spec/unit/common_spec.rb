require_relative '../examples/units'

describe Unit::Common do

  include_context :unit_examples
  
#   context 'Creation' do
#     it 'should be immutable' do
#       expect{ meter.instance_variable_set            :@label,     0 }.to raise_error
#       expect{ meter.instance_variable_set            :@name,      0 }.to raise_error
#       expect{ meter.instance_variable_set            :@symbol,    0 }.to raise_error
#       expect{ meter.instance_variable_set            :@factor,    0 }.to raise_error
#       expect{ meter.instance_variable_set            :@scale,     0 }.to raise_error
#       expect{ meter.instance_variable_set            :@quantity,  0 }.to raise_error
# 
#       expect{ meter_per_second.instance_variable_set :@label,     0 }.to raise_error
#       expect{ meter_per_second.instance_variable_set :@name,      0 }.to raise_error
#       expect{ meter_per_second.instance_variable_set :@factor,    0 }.to raise_error
#       expect{ meter_per_second.instance_variable_set :@units,     0 }.to raise_error
#     end
#   end
# 
  context 'Inspection' do
    it 'knows if it is unitless' do
      expect(meter              ).not_to be_unitless
      expect(unitless           ).to     be_unitless
      expect(milimeter_per_meter).to     be_unitless
      expect(newton             ).not_to be_unitless
    end

    it 'knows if it is a base unit' do
      expect(meter ).to     be_base
      expect(newton).not_to be_base
    end

    it 'knows if it is a derived unit' do
      expect(meter ).not_to be_derived
      expect(newton).to     be_derived
    end

    it 'knows if it has the same kind as other unit' do
      expect(meter           ).to     be_same_kind_as milimeter
      expect(meter           ).to     be_same_kind_as inch
      expect(meter           ).not_to be_same_kind_as second
      expect(meter_per_second).to     be_same_kind_as kilometer_per_hour
      expect(newton          ).not_to be_same_kind_as psi
    end
  end

  context 'Output' do
    it 'converts itself to String' do
      expect(meter.to_s).to eq 'm'
      expect(meter_per_second.to_s).to eq 'm/s'
    end
  end

end
