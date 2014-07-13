require_relative '../../examples/si/units/plain'

module SI
  module Unit
    describe Plain do
      include_context :plain_unit_examples
      
      context 'Creation' do
        it 'should have a label, a name, a symbol, a factor, a scale and a quantity' do
          expect(celsius.label   ).to eq :ºC
          expect(celsius.name    ).to eq 'degree Celsius'
          expect(celsius.symbol  ).to eq 'ºC'
          expect(celsius.factor  ).to eq 1.0
          expect(celsius.scale   ).to eq 273.15
          expect(celsius.quantity).to eq temperature
        end

        it 'label, name, symbol, factor are created accordingly, when prefix is present' do
          expect(milimeter.label   ).to eq :mm
          expect(milimeter.name    ).to eq 'milimeter'
          expect(milimeter.symbol  ).to eq 'mm'
          expect(milimeter.factor  ).to eq 1.0e-3
          expect(milimeter.quantity).to eq length
          expect(milimeter.prefix  ).to eq mili
        end

        it 'defaults name and symbol to label, factor to 1.0, scale to 0.0, quantity to base, and prefix to nil' do
          unit = Plain.new :a_label
          expect(unit.name    ).to eq ''
          expect(unit.symbol  ).to eq 'a label'
          expect(unit.factor  ).to eq 1.0
          expect(unit.scale   ).to eq 0.0
          expect(unit.quantity).to eq ISQ::Quantity.new
          expect(unit.prefix  ).to be_nil
        end

        it 'raises Type Error for non numeric factor' do
          expect{ Plain.new :u, 'unit', :non_numeric }.to raise_error TypeError
        end
        
        it 'raises Type Error for non numeric scale' do
          expect{ Plain.new :u, 'unit', 1.0, length, scale: :non_numeric }.to raise_error TypeError
        end

        it 'raises Type Error for non Quantity quantity' do
          expect{ Plain.new :m, 'meter', 1.0, :non_quantity }.to raise_error TypeError
        end
      end

      context 'Inspection' do
        it 'knows if it is a prefixed unit' do
          expect(meter    ).not_to be_prefixed
          expect(milimeter).to     be_prefixed
        end
      end

      context 'Comparison' do
        it 'equals units of same quantity, same factor, different scale' do
          expect(kelvin <=> celsius).to eq 0
        end

        it 'implements hash equality based on label, name, symbol, factors and quantity' do
          a_hash = { meter => :hash_value }
          expect(a_hash[meter.clone]).to eq :hash_value
        end
      end
    end
  end
end
