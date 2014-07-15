require_relative '../../examples/si/units'

module SI
  module Unit
    describe Composite do
      include_context :unit_examples

      context 'Creation' do
        it 'should have a label, a name, a factor and a collection of indexed units' do
          expect(metre_per_second.label ).to eq :"m/s"
          expect(metre_per_second.name  ).to eq 'metre per second'
          expect(metre_per_second.factor).to eq 1.0
          expect(metre_per_second.units ).to respond_to :each
        end

        it 'raises Type Error for empty units' do
          expect{ Composite.new :u, 'unit', [] }.to raise_error TypeError
          expect{ Composite.new :u, 'unit'     }.to raise_error TypeError
        end

        it 'raises Type Error for non Unit units' do
          expect{ Composite.new :u, 'unit', :non_unit }.to raise_error TypeError
        end

        it 'raises Type Error for non indexed units' do
          expect{ Composite.new :u, 'unit', metre }.to raise_error TypeError
        end

        it 'raises Type Error for units indexed to non numeric' do
          expect{ Composite.new :u, 'unit', metre => :non_numeric }.to raise_error TypeError
        end
      end

      context 'Comparison' do
        it 'is identity equal only to units with the same label, name and units' do
          expect(newton.clone ).to     equal newton
          expect(squared_metre).not_to equal metre
          expect(cubic_metre  ).not_to equal squared_metre
          expect(psi          ).not_to equal pascal
        end

        it 'implements hash equality based on label, name and units' do
          a_hash = { newton => :hash_value }
          expect(a_hash[newton.clone]).to eq :hash_value
        end
      end
    end
  end
end
