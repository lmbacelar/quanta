module Quanta
  module SI
    extend self

    @prefixes, @units, @isq = [], [], nil
    attr_accessor :label, :name, :prefixes, :units, :isq

    def base_units
      units.select(&:base?)
    end

    def derived_units
      units.select(&:derived?)
    end

    def plain_units
      units.select(&:plain?)
    end

    def composite_units?
      units.select(&:composite?)
    end

    def prefixed_units
      plain_units.select(&:prefixed?)
    end

    def unprefixed_units
      plain_units.select(&:unprefixed?)
    end

    def add_prefix label, symbol=nil, factor=nil, options={}
      find_prefix(label) or
      Unit::Prefix.new(label, symbol, factor, options).tap{ |p| @prefixes << p }
    end

    def add_unit label, symbol=nil, factor=nil, quantity=nil, options={}
      find_unit(label) or
      Unit::Plain.new(label, symbol, factor, isq.quantity_for(quantity), options).tap { |u| @units << u }
    end

    def add_prefixed_unit prefixed_unit
      found_unit = find_unit(prefixed_unit)
      return found_unit if found_unit

      prefix, unit = split_prefix_and_unit prefixed_unit
      raise TypeError, "unknown prefixed unit '#{prefixed_unit}'" unless prefix && unit
      Unit::Plain.new(unit.label, unit.name, unit.factor, unit.quantity, 
                      symbol: unit.symbol, prefix: prefix).tap { |u| @units << u }
    end

    def add_composite_unit composite_unit
      found_unit = find_unit(composite_unit)
      return found_unit if found_unit

      units = composite_unit.to_s.split('/').map{ |unit| unit.empty? ? nil : unit }
      units = units[0] && units[0].split('.').map{ |u| unit_power_hash u               }, 
              units[1] && units[1].split('.').map{ |u| unit_power_hash u, invert: true }
      Unit::Composite.new(nil, nil, *units.compact.flatten).tap{ |u| @units << u }
    end

    def unit_for unit
      found_unit = find_unit(unit)
      return found_unit if found_unit
      return add_prefixed_unit(unit) rescue TypeError 
      add_composite_unit(unit)
    end

    def prefix_for prefix
      find_prefix prefix or raise TypeError, "unknown prefix '#{prefix}'"
    end

    def clear!
      @label, @name, @isq = nil
      @prefixes, @units   = [], []
    end

    def load!
      clear!
      @isq = ISQ.load!
      load_prefixes! :all
      load_units! :all
    end

    def load_prefixes! subset = :all
      load_base_prefixes!   if subset == :all || subset == :base
      load_binary_prefixes! if subset == :all || subset == :binary
    end

    def load_units! subset = :all
      load_base_units!     if subset == :all || subset == :base
      load_derived_units!  if subset == :all || subset == :derived
      load_accepted_units! if subset == :all || subset == :accepted
      load_non_si_units!   if subset == :all || subset == :non_si
    end

    def configure(&block)
      instance_eval(&block) if block
    end

    def respond_to? method, include_private = false
      return !!unit_or_prefix_for(method) rescue TypeError
      super
    end

    def method_missing method, *args, &block
      return unit_or_prefix_for method rescue TypeError
      super
    end


    protected
    def find_prefix prefix
      case prefix
        when Unit::Prefix   then prefix if prefixes.find{ |p| p.equal? prefix }
        when Symbol, String then prefixes.find{ |p| p.label == prefix.to_sym ||
                                                 p.name.upcase == prefix.to_s.upcase || 
                                                 p.symbol      == prefix.to_s }
        else raise TypeError, 'prefix must be a prefix, name or symbol'
      end
    end

    def find_unit unit
      if unit.is_a? Unit
        units.find{ |u| u.equal? unit }
      elsif unit.is_a?(String) || unit.is_a?(Symbol)
        units.find{ |u| u.label == unit.to_sym || u.name.upcase == unit.to_s.upcase }
      else
        raise TypeError, 'unit must be a unit, name or symbol'
      end
    end

    def split_prefix_and_unit unit
      split_prefix_and_unit_by(:label, unit) or
      split_prefix_and_unit_by(:name,  unit)
    end

    def split_prefix_and_unit_by attribute, unit
      unit = unit.to_s
      found_prefix = prefixes.each do |prefix|
        if unit.start_with? prefix.send(attribute).to_s
          unit.slice! prefix.send(attribute).to_s 
          break prefix
        end
      end
      return nil unless found_prefix
      return nil if unit.empty? 
      found_unit = unprefixed_units.find{ |u| u.send(attribute).to_s == unit}
      return nil unless found_unit
      return found_prefix, found_unit
    end

    def unit_power_hash unit_power, invert: false
      unit  = unit_power.tr('⁰¹²³⁴⁵⁶⁷⁸⁹',  '').to_sym
      power = unit_power.tr '^⁰¹²³⁴⁵⁶⁷⁸⁹', ''
      if power.empty?
        power = 1
      else
        power = power.chars.map do |c|
          { '⁰'=>'0', '¹'=>'1', '²'=>'2', '³'=>'3', '⁴'=>'4', 
            '⁵'=>'5', '⁶'=>'6', '⁷'=>'7', '⁸'=>'8', '⁹'=>'9' }[c]
        end.join.to_i
      end
      power = -power if invert
      { find_unit(unit) => power }
    end

    def load_base_prefixes!
      BASE_PREFIXES.each { |args| add_prefix *args }
    end
    
    def load_binary_prefixes!
      BINARY_PREFIXES.each { |args| add_prefix *args }
    end

    def load_base_units!
      BASE_UNITS.each { |args| add_unit *args }
      # 
      # kilogram is a special case as it is the base unit and it is prefixed
      # as a consequence, gram also has to be manually added to allow for its
      # prefixed versions
      #
      kilo = find_prefix :kilo
      add_unit :g, 'gram', 1.0e-3, :mass
      add_prefixed_unit :kg
    end

    def load_derived_units!
      DERIVED_UNITS.each { |args| add_unit *args }
      add_composite_unit :m²
      add_composite_unit :m³
    end

    def load_accepted_units!
      ACCEPTED_UNITS.each { |args| add_unit *args }
    end

    def load_non_si_units!
      NON_SI_UNITS.each { |args| add_unit *args }
    end

    def unit_or_prefix_for method, *args, &block
      return unit_for method rescue TypeError
      prefix_for method
    end

    BASE_PREFIXES =
    [
      [ :Y,  'yotta', 1.0e24  ],
      [ :Z,  'zetta', 1.0e21  ],
      [ :E,  'exa',   1.0e18  ],
      [ :P,  'peta',  1.0e15  ],
      [ :T,  'tera',  1.0e12  ],
      [ :G,  'giga',  1.0e9   ],
      [ :M,  'mega',  1.0e6   ],
      [ :k,  'kilo',  1.0e3   ],
      [ :h,  'hecto', 1.0e2   ],
      [ :da, 'deca',  1.0e1   ],
      [ :d,  'deci',  1.0e-1  ],
      [ :c,  'centi', 1.0e-2  ],
      [ :m,  'mili',  1.0e-3  ],
      [ :µ,  'micro', 1.0e-6  ],
      [ :n,  'nano',  1.0e-9  ],
      [ :p,  'pico',  1.0e-12 ],
      [ :f,  'femto', 1.0e-15 ],
      [ :a,  'atto',  1.0e-18 ],
      [ :z,  'zepto', 1.0e-21 ],
      [ :y,  'yocto', 1.0e-24 ]
    ]

    BINARY_PREFIXES =
    [
      [ :Yi, 'yobi', 2**80 ],
      [ :Zi, 'zebi', 2**70 ],
      [ :Ei, 'exbi', 2**60 ],
      [ :Pi, 'pebi', 2**50 ],
      [ :ti, 'tebi', 2**40 ],
      [ :Gi, 'gibi', 2**30 ],
      [ :Mi, 'mebi', 2**20 ],
      [ :Ki, 'kibi', 2**10 ]
    ]

    BASE_UNITS =
    [
      [ :m,   'metre',          1.0,            :length                                     ],
      [ :s,   'second',         1.0,            :time                                       ],
      [ :A,   'Ampere',         1.0,            :electric_current                           ],
      [ :K,   'Kelvin',         1.0,            :temperature                                ],
      [ :cd,  'candela',        1.0,            :luminous_intensity                         ],
      [ :mol, 'mole',           1.0,            :amount_of_substance                        ],
      [ :bit, 'bit',            1.0,            :information                                ],
      [ :"",  '',               1.0,            :dimension_one,          symbol: ''         ]
    ]

    DERIVED_UNITS =
    [
      [ :Bq,  'Bequerel',       1.0,            :radioactivity                              ],
      [ :ºC,  'degree Celsius', 1.0,            :temperature,            scale: 273.15      ],
      [ :C,   'Coloumb',        1.0,            :electric_charge                            ],
      [ :F,   'Farad',          1.0,            :electric_capacitance                       ],
      [ :Gy,  'Gray',           1.0,            :radiation_absorbed_dose                    ],
      [ :Hz,  'Hertz',          1.0,            :frequency                                  ],
      [ :H,   'Henry',          1.0,            :inductance                                 ],
      [ :J,   'Joule',          1.0,            :energy                                     ],
      [ :kat, 'katal',          1.0,            :catalytic_activity                         ],
      [ :lm,  'lumen',          1.0,            :luminous_flux                              ],
      [ :lx,  'lux',            1.0,            :illuminance                                ],
      [ :N,   'Newton',         1.0,            :force                                      ],
      [ :Ohm, 'Ohm',            1.0,            :electric_resistance,           symbol: 'Ω' ],
      [ :Pa,  'Pascal',         1.0,            :pressure                                   ],
      [ :rad, 'radian',         1.0,            :plane_angle                                ],
      [ :S,   'Siemens',        1.0,            :electric_conductance                       ],
      [ :Sv,  'Sievert',        1.0,            :radiation_dose_equivalent                  ],
      [ :sr,  'steridian',      1.0,            :solid_angle                                ],
      [ :T,   'Tesla',          1.0,            :magnetic_flux_density                      ],
      [ :V,   'Volt',           1.0,            :electric_potential_difference              ],
      [ :W,   'Watt',           1.0,            :power                                      ],
      [ :Wb,  'Weber',          1.0,            :magnetic_flux                              ]
    ]

    ACCEPTED_UNITS =
    [
      [ :min,            'minute',                       60.0,             :time                                  ],
      [ :h,              'hour',                         3_600.0,          :time                                  ],
      [ :d,              'day',                          86_400.0,         :time                                  ],
      [ :º,              'degree',                       Math::PI/180,     :plane_angle                           ],
      [ :arc_minute,     'minute',                       Math::PI/10_800,  :plane_angle,        symbol: "'"       ],
      [ :arc_second,     'second',                       Math::PI/648_000, :plane_angle,        symbol: '"'       ],
      [ :ha,             'hectare',                      1.0e4,            :area                                  ],
      [ :L,              'litre',                        1.0e-3,           :volume                                ],
      [ :eV,             'electronvolt',                 1.602_176_487_40e-19, :energy                            ],
      [ :ua,             'astronomical unit',            1.495_978_706_916e11, :length                            ],
      [ :Da,             'Dalton',                       1.660_538_782_83e-27, :mass                              ],
      [ :u,              'unified atomic mass unit',     1.660_538_782_83e-27, :mass                              ],
      [ :nautical_mile,  'nautical mile',                1_852.0,          :length                                ],
      [ :knot,           'nautical mile',                1_852.0/3_600.0,  :velocity                              ],
      [ :Å,              'Angstrom',                     1.0e-10,          :length                                ],
      [ :b,              'barn',                         1.0e-28,          :area                                  ],
      [ :bar,            'bar',                          1.0e5,            :pressure                              ],
      [ :mmHg,           'milimetre of mercury',         133.32222,        :pressure                              ]
    ]

    NON_SI_UNITS =
    [
      [ :acre,           'acre',                         4046.8564224,     :area                                  ],
      [ :a,              'are',                          100.0,            :area                                  ],
      [ :atm,            'atmosphere',                   101.325e3,        :pressure                              ],
      [ :Bi,             'biot',                         10.0,             :electric_current                      ],
      [ :bhp,            'boiler horsepower',            9.80950e3,        :power                                 ],
      [ :btu_39f,        'british thermal unit (39 °F)', 1059.67,          :energy,             symbol: 'BTU'     ],
      [ :btu_60f,        'british thermal unit (60 °F)', 1054.68,          :energy,             symbol: 'BTU'     ],
      [ :btu_63f,        'british thermal unit (63 °F)', 1054.6,           :energy,             symbol: 'BTU'     ],
      [ :btu_iso,        'british thermal unit (ISO)',   1055.056,         :energy,             symbol: 'BTU'     ],
      [ :btu_it,         'british thermal unit (IT)',    1055.05585262,    :energy,             symbol: 'BTU'     ],
      [ :btu_mean,       'british thermal unit (mean)',  1055.87,          :energy,             symbol: 'BTU'     ],
      [ :btu_thermo,     'british thermal unit (thermochemical)', 1054.35026444,    :energy,    symbol: 'BTU'     ],
      [ :btu_59f,        'british thermal unit (59 °F)', 1054.804,         :energy,             symbol: 'BTU'     ],
      [ :bu_imp,         'US bushel',                    36.36872e-3,      :volume,             symbol: 'bu (Imp)'],
      [ :bu_us,          'UK bushel',                    35.23907e-3,      :volume,          symbol: 'bu (US lvl)'],
      [ :byte,           'byte',                         8,                :information,        symbol: 'byte'    ],
      [ :cal,            'calorie',                      4.1868,           :energy                                ],
      [ :cp,             'candle power',                 4*Math::PI,       :luminous_flux                         ],
      [ :kt,             'carat',                        200e-6,           :mass                                  ],
      [ :CHU,            'celsius heat unit',            1.0899101e3,      :energy                                ],
      [ :cmHg,           'centimetre of mercury',        1.333222e3,       :pressure                              ],
      [ :cmH2O,          'centimetre of water',          98.060616,        :pressure                              ],
      [ :ch,             'chain',                        20.1168,          :length                                ],
      [ :clo,            'clo',                          0.155,            :thermal_resistance                    ],
      [ :c_us,           'cup',                          236.5882e-6,      :volume,             symbol: 'c (US)'  ],
      [ :Ci,             'curie',                        37.0e9,           :radioactivity                         ],
      [ :ºF,             'degree Farenheit',             5.0/9.0,          :temperature,        scale: 459.67     ],
      [ :ºR,             'degree Rankine',               5.0/9.0,          :temperature                           ],
      [ :dram,           'dram',                         1.771845e-3,      :length                                ],
      [ :dyn,            'dyne',                         10e-6,            :force                                 ],
      [ :dyn_cm,         'dyne centimetre',              100e-9,           :energy,             symbol: 'dyn cm'  ],
      [ :hp_elec,        'electric horsepower',          746.0,            :power,              symbol:'hp (Elec)'],
      [ :me,             'electron mass',                9.10938188e-31,   :mass                                  ],
      [ :ell,            'ell',                          1.143,            :length                                ],
      [ :erg,            'erg',                          100.0e-9,         :energy                                ],
      [ :faraday,        'faraday',                      96.48533924e3,    :electric_charge                       ],
      [ :ftm,            'fathom',                       1.828804,         :length                                ],
      [ :fm,             'fermi',                        1e-15,            :length                                ],
      [ :ft,             'foot',                         0.3048,           :length                                ],
      [ :fc,             'footcandle',                   10.76391,         :illuminance                           ],
      [ :ftH2O,          'foot of water',                2.988887e3,       :pressure                              ],
      [ :Fr,             'franklin',                     3.3356e-10,       :electric_charge                       ],
      [ :fur,            'furlong',                      201.168,          :length                                ],
      [ :γ,              'gamma',                        1e-9,             :magnetic_flux_density                 ],
      [ :G,              'gauss',                        100e-6,           :magnetic_flux_density                 ],
      [ :grad,           'grad',                         Math::PI/200.0,   :plane_angle                           ],
      [ :gr,             'grain',                        64.79891e-6,      :mass                                  ],
      [ :Eh,             'hartree',                      4.359748e-18,     :energy                                ],
      [ :hhd,            'hogshead',                     238.6697e-3,      :volume                                ],
      [ :cwt_long,       'hundredweight long',           50.802345,        :mass,               symbol: 'cwt'     ],
      [ :cwt_short,      'hundredweight short',          45.359237,        :mass,               symbol: 'cwt'     ],
      [ :in,             'inch',                         25.4e-3,          :length                                ],
      [ :inHg,           'inch of mercury',              3.386389e3,       :pressure                              ],
      [ :inH2O,          'inch of water',                249.0740,         :pressure                              ],
      [ :kcal,           'kilocalorie',                  4.1868e3,         :energy                                ],
      [ :kgf,            'kilogram force',               9.80665,          :force                                 ],
      [ :kn,             'knot',                         514.4444e-3,      :velocity                              ],
      [ :La,             'lambert',                      1e4,              :illuminance,                          ],
      [ :ly,             'light year',                   9.46073e15,       :length                                ],
      [ :ln,             'line',                         2.116667e-3,      :length                                ],
      [ :lnk,            'link',                         201.168e-3,       :length                                ],
      [ :ton_uk,         'long ton',                     1.016047e3,       :mass,               symbol: 'ton'     ],
      [ :Mx,             'maxwell',                      10e-9,            :magnetic_flux                         ],
      [ :hp,             'metric horsepower',            735.4988,         :power                                 ],
      [ :mi,             'mile',                         1.609344e3,       :length                                ],
      [ :mbar,           'millibar',                     100,              :pressure                              ],
      [ :month,          'month',                        2.551444e6,       :time                                  ],
      [ :nl,             'nautical league',              5.556e3,          :length                                ],
      [ :nmi,            'nautical mile',                1.852e3,          :length                                ],
      [ :oz,             'ounce',                        28.34952e-3,      :mass                                  ],
      [ :pc,             'parsec',                       30.85678e15,      :length                                ],
      [ :dwt,            'pennyweight',                  1.555174e-3,      :mass                                  ],
      [ :bbl,            'petroleum barrel',             158.9873e-3,      :volume                                ],
      [ :pt,             'point',                        351.4598e-6,      :length                                ],
      [ :p,              'poncelot',                     980.665,          :power                                 ],
      [ :lb,             'pound',                        0.45359237,       :mass                                  ],
      [ :pdl,            'poundal',                      138.255,          :force                                 ],
      [ :lbf,            'pound force',                  4.448222,         :force                                 ],
      [ :lbmol,          'pound mole',                   453.59237,        :amount_of_substance                   ],
      [ :quad,           'quad',                         1.055056e18,      :energy                                ],
      [ :rd,             'rad',                          0.01,             :radiation_absorbed_dose, symbol: 'rad'],
      [ :rem,            'rem',                          0.01,             :radiation_dose_equivalent             ],
      [ :rev,            'revolution',                   2*Math::PI,       :plane_angle                           ],
      [ :reyn,           'reyn',                         689.5e3,          :dynamic_viscosity                     ],
      [ :rood,           'rood',                         1.011714e3,       :area                                  ],
      [ :Rd,             'rutherford',                   1e6,              :radioactivity                         ],
      [ :Ry,             'rydberg',                      2.179874e-18,     :energy,                               ],
      [ :ton_us,         'short ton',                    907.1847,         :mass,               symbol: 'ton'     ],
      [ :d_sid,          'sidereal day',                 86.16409053e3,    :time,               symbol: 'd'       ],
      [ :year_sid,       'sidereal year',                31558823.803728,  :time,               symbol: 'yr (sid)'],
      [ :lea,            'statute league',               4.828032e3,       :length                                ],
      [ :sphere,         'sphere',                       4*Math::PI,       :solid_angle                           ],
      [ :sn,             'sthene',                       1e3,              :force                                 ],
      [ :St,             'stoke',                        100e-6,           :kinematic_viscosity                   ],
      [ :st,             'stone',                        6.350293,         :mass                                  ],
      [ :thm,            'therm',                        105.506e6,        :energy                                ],
      [ :th,             'thermie',                      4.185407e6,       :energy                                ],
      [ :tog,            'tog',                          0.1,              :thermal_resistance                    ],
      [ :t,              'tonne',                        1000.0,           :mass                                  ],
      [ :bbl_imp,        'UK barrel',                    163.6592e-3,      :volume,             symbol: 'bl (Imp)'],
      [ :oz_fl_uk,       'UK fluid ounce',               28.41308e-6,      :volume,             symbol: 'fl oz'   ],
      [ :gal_uk,         'UK gallon',                    4.546092e-3,      :volume,             symbol: 'gal (UK)'],
      [ :gi_uk,          'UK gill',                      142.0654e-6,      :volume,             symbol: 'gi'      ],
      [ :hp_uk,          'UK horsepower',                745.6999,         :power,              symbol: 'hp (UK)' ],
      [ :gal_dry_us,     'US dry gallon',                4.40488377086e-3, :volume,             symbol: 'gal (US)'],
      [ :bbl_dry_us,     'US dry barrel',                115.6271e-3,      :volume,             symbol: 'bl (US)' ],
      [ :oz_fl,          'US fluid ounce',               29.57353e-6,      :volume,             symbol: 'fl oz'   ],
      [ :gi_us,          'US gill',                      118.2941e-6,      :volume,             symbol: 'gi'      ],
      [ :bbl_fl_us,      'US liquid barrel',             119.2405e-3,      :volume,           symbol: 'fl bl (US)'],
      [ :gal,            'US liquid gallon',             3.785412e-3,      :volume                                ],
      [ :foot_survey_us, 'US survey foot',               304.8e-3,         :length,             symbol: 'ft'      ],
      [ :wk,             'week',                         604800,           :time                                  ],
      [ :yd,             'yard',                         0.9144,           :length                                ],
      [ :yr,             'year',                         31557600,         :time                                  ]
    ]
  end
end
