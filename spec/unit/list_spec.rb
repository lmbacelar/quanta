require_relative '../examples/units'

describe Unit::List do
  include_context :unit_examples

  context 'Creation' do
    it 'derives factor from factors of units' do
      expect(kilometer_per_hour.factor).to eq 1000.0/3600.0
    end

    it 'derives quantity from units' do
      expect(meter_per_second.quantity).to be_same_kind_as velocity
      expect(newton.quantity          ).to be_same_kind_as force
    end
  end

  context 'Inspection' do
    it 'is valid for Enumerable of hashes of Unit => Numeric' do
      expect( [{ unitless => 1 }].extend(Unit::List)  ).to be_valid
      expect( [{ meter => 1 }, { meter => -1 }].extend(Unit::List)  ).to be_valid
      expect( [{ meter => 1 }, { meter => -2 }].extend(Unit::List)  ).to be_valid
      expect( [{ meter => 1 }, { second => -1 }].extend(Unit::List) ).to be_valid
    end

    it 'is invalid for empty units' do
      expect( [].extend(Unit::List)  ).not_to be_valid
    end

    it 'is invalid for non Unit units' do
      expect( [:non_unit].extend(Unit::List)          ).not_to be_valid
      expect( [{ :non_unit => 1 }].extend(Unit::List) ).not_to be_valid
    end

    it 'is invalid for non indexed units' do
      expect( [meter].extend(Unit::List)   ).not_to be_valid
      expect( [[meter]].extend(Unit::List) ).not_to be_valid
    end

    it 'is invalid for units indexed to non numeric' do
      expect( [{ meter => :non_numeric }].extend(Unit::List) ).not_to be_valid
    end
  end

end
