require_relative '../lib/si'
require_relative '../lib/isq'
require_relative 'examples/si/units/plain'

describe SI do
  include_context :plain_unit_examples

  context 'Properties' do
    it 'should have a label, a name, a collection of prefixes, a collection of units and a system of quantities' do
      SI.label                = :c_g_s
      SI.name                 = 'Centimeter Gram Second'
      SI.isq = ISQ
      expect(SI.label               ).to eq :c_g_s
      expect(SI.name                ).to eq 'Centimeter Gram Second'
      expect(SI.prefixes            ).to respond_to :each
      expect(SI.units               ).to respond_to :each
      expect(SI.isq).to eq ISQ
    end
  end

  context 'International System of Units' do
    before(:each) { SI.load }

    it 'knows how to create itself according to the International System of Quantities' do
      expect(SI.prefixes.count      ).to eq 28
      expect(SI.base_units.count    ).to be 8
      expect(SI.derived_units.count ).to be 160
      expect(SI.units.count         ).to be 168
      expect(SI.isq).to eq ISQ
    end
  end

  context 'Addition' do
    it 'allows individual addition of prefixes' do
      expect{ SI.add_prefix :mili, 'm', 1.0e-3 }.to change{ SI.prefixes.count }.by 1
    end
    
    it 'allows bulk addition of prefixes' do
      expect {
        SI.configure do
          add_prefix :mili,  'm',     1.0e-3
        end
      }.to change{ SI.prefixes.count }.by 1
    end

    it 'allows individual addition of units' do
      ISQ.add :length, nil
      expect{ SI.add_unit :m, 'meter', 1.0, :length }.to change{ SI.units.count }.by 1
    end
  end
end
