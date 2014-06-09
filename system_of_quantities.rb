class SystemOfQuantities
  attr_reader :label, :name, :quantities
  def initialize label, options = {}
    @label      = label
    @name       = options.fetch(:name) { label.to_s.tr_s '_', ' ' }
    @quantities = options.fetch(quantities) { [] }
  end

  def add quantity, dimensions_or_quantity, options = {}
    @quantities << Quantity.new(quantity, dimensions_or_quantity, options)
    @quantities.last
  end

  def base_quantities
    quantities.select{ |quantity| quantity.base? }
  end

  def configure(&block)
    instance_eval(&block) if block
  end

  def quantity_for quantity
    case quantity
      when Quantity then quantity if quantities.include? quantity
      when Symbol   then quantities.select{ |q| q.quantity    == quantity }.first
      when String   then quantities.select{ |q| q.quantity    == quantity.to_sym ||
                                                q.name.upcase == quantity.upcase || 
                                                q.symbol      == quantity }.first
      else raise TypeError, ' quantity must be a quantity, name or symbol'
    end
  end

  def method_missing method, *args, &block
    if quantities = self.quantity_for(method)
      return  quantities
    end
    super
  end

  def load_isq
    self.configure do
      # Base dimensions
      length =
        add :length,                    nil, symbol: 'L'
      mass =
        add :mass,                      nil, symbol: 'M'
      time =
        add :time,                      nil, symbol: 'T'
      electric_current =
        add :electric_current,          nil, symbol: 'I'
      temperature =
        add :temperature,               nil, symbol: 'THETA'
      amount_of_substance =
        add :amount_of_substance,       nil, symbol: 'N'
      luminous_intensity =
        add :luminous_intensity,        nil, symbol: 'J'

      # Derived dimensions
      solid_angle =
        add :solid_angle,               length / length
        add :plane_angle,               length / length
      area =
        add :area,                      length**2
      volume =
        add :volume,                    length**3

      frequency =
        add :frequency,                 1 / time

      velocity =
        add :velocity,                  length / time
      acceleration =
        add :acceleration,              velocity / time
        add :momentum,                  mass * velocity
      moment_of_inertia =
        add :moment_of_inertia,         mass * area
      angular_momentum =
        add :angular_momentum,          moment_of_inertia / time
        add :action,                    angular_momentum

      electric_charge =
        add :eletric_charge,            electric_current * time
        add :eletric_charge_density,    electric_charge / volume
        add :electric_displacement,     electric_charge / area
      electric_voltage = 
        add :electric_voltage,          mass * area / electric_current / time**3
        add :electric_potential_difference, electric_voltage
      electric_resistance = 
        add :electric_resistance,       electric_voltage / electric_current
        add :electric_impedance,        electric_resistance
        add :electric_conductance,      1 / electric_resistance
      electric_inductance =
        add :electric_inductance,       electric_resistance * time
      electric_resistivity = 
        add :electric_resistivity,      electric_resistance * length
        add :conductivity,              1 / electric_resistivity
      electric_capacitance =
        add :electric_capacitance,      electric_charge / electric_voltage
        add :electric_field_strength,   electric_voltage / length
        add :electric_polarisability,   electric_current**2 * time**4 / mass
        add :electric_polarisation,     electric_charge / area
        add :magnetic_field_strength,   electric_current / length
      magnetic_flux =
        add :magnetic_flux,             electric_voltage * time
        add :magnetic_flux_density,     magnetic_flux / area
        add :magnetic_dipole_moment,    electric_current * area
        add :magnetic_vector_potential, electric_voltage * time / length
        add :magnetisation,             electric_current / length
        add :permeability,              electric_inductance / length
        add :permittivity,              electric_capacitance / length

      energy =
        add :energy,                    mass * velocity**2
        add :energy_density,            energy / volume
      power =
        add :power,                     energy / time

      entropy =
        add :entropy,                   energy / temperature
        add :heat_capacity,             entropy
        add :thermal_resistance,        temperature * area / power

      force = 
        add :force,                     mass * acceleration
        add :density,                   mass / volume
      pressure =
        add :pressure,                  force / area
        add :surface_tension,           force / length
        add :dynamic_viscosity,         pressure * time
        add :kinematic_viscosity,       area / time

        add :illuminance,               luminous_intensity / area
        add :irradiance,                power / area
        add :luminous_flux,             luminous_intensity * solid_angle

      radiation_absorbed_dose =
        add :radiation_absorbed_dose,   energy / mass
        add :radiation_dose_equivalent, radiation_absorbed_dose
        add :radioactivity,             frequency

        add :calalytic_activity,        amount_of_substance / time
    end
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
    [ :electrical_capacitance,        { length: -2, mass: -1, time: 4,  electric_current: 2    } ],
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
