class SystemOfQuantities
  attr_reader :label, :name, :quantities
  def initialize label, options = {}
    @label      = label
    @name       = options.fetch(:name) { label.to_s.tr_s '_', ' ' }
    @quantities = options.fetch(quantities) { [] }
  end

  def add quantity, qtys, options = {}
    # ensure each quantity in qtys exists in quantities
    qtys = Hash[qtys.map{ |qty, pow| [quantity_for(qty), pow] }] unless qtys.nil?
    @quantities << Quantity.new(quantity, qtys, options)
    @quantities.last
  end

  def base_quantities
    quantities.select{ |quantity| quantity.base? }
  end

  def configure(&block)
    instance_eval(&block) if block
  end

  def quantity_for quantity
    qty = case quantity
            when Quantity then quantity if quantities.include? quantity
            when Symbol   then quantities.select{ |q| q.quantity    == quantity }.first
            when String   then quantities.select{ |q| q.quantity    == quantity.to_sym ||
                                                      q.name.upcase == quantity.upcase || 
                                                      q.symbol      == quantity }.first
            else raise TypeError, ' quantity must be a quantity, name or symbol'
          end
    return qty if qty
    raise TypeError, "unknown quantity '#{quantity}'"
  end

  def method_missing method, *args, &block
    if quantities = self.quantity_for(method)
      return  quantities
    end
    super
  end

  def load_isq
    ISQ_BASE_QUANTITIES.each    { |args| add *args }
    ISQ_DERIVED_QUANTITIES.each { |args| add *args }
    return self
  end

  #
  #  International System of Quantities (ISQ) Constants
  #
  ISQ_BASE_QUANTITIES =
  [
    [ :length,              nil, symbol: 'L'           ],
    [ :mass,                nil, symbol: 'M'           ],
    [ :time,                nil, symbol: 'T'           ],
    [ :electric_current,    nil, symbol: 'I'           ],
    [ :temperature,         nil, symbol: 'Θ'           ],
    [ :luminous_intensity,  nil, symbol: 'L'           ],
    [ :amount_of_substance, nil, symbol: 'J'           ],
    [ :information,         nil, symbol: 'INFORMATION' ]
  ]

  ISQ_DERIVED_QUANTITIES =
  [
    [ :acceleration,                  { length: 1,            time: -2                         } ],
    [ :angle,                         {                                                        } ],
    [ :area,                          { length: 2                                              } ],
    [ :action,                        { length: 2,  mass: 1,  time: -1                         } ],
    [ :angular_momentum,              { length: 2,  mass: 1,  time: -1                         } ],
    [ :conductivity,                  { length: -3, mass: -1, time: 3,  electric_current: 2    } ],
    [ :density,                       { length: -3, mass: 1                                    } ],
    [ :electric_charge,               {                       time: 1,  electric_current: 1    } ],
    [ :electric_charge_density,       { length: -3,           time: 1,  electric_current: 1    } ],
    [ :electric_conductance,          { length: -2, mass: -1, time: 3,  electric_current: 2    } ],
    [ :electric_displacement,         { length: -2,           time: 1,  electric_current: 1    } ],
    [ :electric_field_strength,       { length: 1,  mass: 1,  time: -3, electric_current: -1   } ],
    [ :electric_polarisability,       {             mass: -1, time: 4,  electric_current: 2    } ],
    [ :electric_polarisation,         { length: -2,           time: 1,  electric_current: 1    } ],
    [ :electric_potential_difference, { length: 2,  mass: 1,  time: -3, electric_current: -1   } ],
    [ :electric_resistance,           { length: 2,  mass: 1,  time: -3, electric_current: -2   } ],
    [ :electric_capacitance,          { length: -2, mass: -1, time: 4,  electric_current: 2    } ],
    [ :energy,                        { length: 2,  mass: 1,  time: -2                         } ],
    [ :entropy,                       { length: 2,  mass: 1,  time: -2, temperature: -1        } ],
    [ :force,                         { length: 1,  mass: 1,  time: -2                         } ],
    [ :frequency,                     {                       time: -1                         } ],
    [ :heat_capacity,                 { length: 2,  mass: 1,  time: -2, temperature: -1        } ],
    [ :illuminance,                   { length: -2,                     luminous_intensity: 1  } ],
    [ :impedance,                     { length: 2,  mass: 1,  time: -3, electric_current: -2   } ],
    [ :inductance,                    { length: 2,  mass: 1,  time: -2, electric_current: -2   } ],
    [ :irradiance,                    {             mass: 1,  time: -3                         } ],
    [ :luminous_flux,                 {                                 luminous_intensity: 1  } ],
    [ :magnetic_field_strength,       { length: -1,                     electric_current: 1    } ],
    [ :magnetic_flux,                 { length: 2,  mass: 1,  time: -2, electric_current: -1   } ],
    [ :magnetic_flux_density,         {             mass: 1,  time: -2, electric_current: -1   } ],
    [ :magnetic_dipole_moment,        { length: 2,                      electric_current: 1    } ],
    [ :magnetic_vector_potential,     { length: 1,  mass: 1,  time: -2, electric_current: -1   } ],
    [ :magnetisation,                 { length: -1,                     electric_current: 1    } ],
    [ :moment_of_inertia,             { length: 2,  mass: 1                                    } ],
    [ :momentum,                      { length: 1,  mass: 1,  time: -1                         } ],
    [ :permeability,                  { length: 1,  mass: 1,  time: -2, electric_current: -2   } ],
    [ :permittivity,                  { length: -3, mass: -1, time: 4,  electric_current: 2    } ],
    [ :plane_angle,                   {                                                        } ],
    [ :power,                         { length: 2,  mass: 1,  time: -3                         } ],
    [ :pressure,                      { length: -1, mass: 1,  time: -2                         } ],
    [ :radiation_absorbed_dose,       { length: 2,            time: -2                         } ],
    [ :radiation_dose_equivalent,     { length: 2,            time: -2                         } ],
    [ :radioactivity,                 {                       time: -1                         } ],
    [ :solid_angle,                   {                                                        } ],
    [ :surface_tension,               {             mass: 1,  time: -2                         } ],
    [ :velocity,                      { length: 1,            time: -1                         } ],
    [ :dynamic_viscosity,             { length: -1, mass: 1,  time: -1                         } ],
    [ :kinematic_viscosity,           { length: 2,            time: -1                         } ],
    [ :volume,                        { length: 3                                              } ],
    [ :energy_density,                { length: -1, mass: 1,  time: -2                         } ],
    [ :thermal_resistance,            {             mass: -1, time: 3,  temperature: 1         } ],
    [ :catalytic_activity,            {                       time: -1, amount_of_substance: 1 } ]
  ]

end
