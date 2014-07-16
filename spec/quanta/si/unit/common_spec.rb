require_relative '../../examples/si/units'

describe Quanta::SI::Unit::Common do
  include_context :unit_examples
  
  context 'Inspection' do
    it 'knows if it is unitless' do
      expect(metre              ).not_to be_unitless
      expect(unitless           ).to     be_unitless
      expect(milimetre_per_metre).to     be_unitless
      expect(newton             ).not_to be_unitless
    end

    it 'knows if it is a base unit' do
      expect(metre ).to     be_base
      expect(newton).not_to be_base
    end

    it 'knows if it is a derived unit' do
      expect(metre ).not_to be_derived
      expect(newton).to     be_derived
    end

    it 'knows if it has the same kind as other unit' do
      expect(metre           ).to     be_same_kind_as milimetre
      expect(metre           ).to     be_same_kind_as inch
      expect(metre           ).not_to be_same_kind_as second
      expect(metre_per_second).to     be_same_kind_as kilometre_per_hour
      expect(newton          ).not_to be_same_kind_as psi
    end
  end

  context 'Output' do
    it 'converts itself to String' do
      expect(metre.to_s).to eq 'm'
      expect(metre_per_second.to_s).to eq 'm/s'
    end
  end
end
