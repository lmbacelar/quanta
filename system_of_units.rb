class SystemOfUnits
  attr_reader :label, :name, :prefixes, :units, :system_of_quantities
  def initialize label, options = {}
    @label                = label
    @name                 = options.fetch(:name)                 { label.to_s.tr_s '_', '  ' }
    @prefixes             = options.fetch(:prefixes)             { [] }
    @units                = options.fetch(:units)                { [] }
    @system_of_quantities = options.fetch(:system_of_quantities)
  end

  def base_units
    units.map { |u| u.base? }
  end

  def add_prefix label_or_prefix, symbol=nil, factor=nil, options={}
    @prefixes << case label_or_prefix
      when Prefix then label_or_prefix
      else Prefix.new label, symbol, factor, options
    end
    @prefixes.last
  end

  def add_unit unit_or_label, symbol=nil, factor=nil, quantity=nil, options={}
    @units << case unit_or_label
      when Unit then unit_or_label
      else
        quantity = system_of_quantities.quantity_for(quantity) unless quantity.is_a? Quantity
        Unit.new label, symbol, factor, quantity, options
    end
    @units.last
  end

  def configure(&block)
    instance_eval(&block) if block
  end

  def load_si
    @system_of_quantities = SystemOfQuantities.new(:isq, name: 'International System of Quantities').load_isq
    load_si_prefixes
    load_si_units
  end

  def load_si_prefixes
    self.configure do
      add_prefix :yotta, 'Y',  10**24
      add_prefix :zetta, 'Z',  10**21
      add_prefix :exa,   'E',  10**18
      add_prefix :peta,  'P',  10**15
      add_prefix :tera,  'T',  10**12
      add_prefix :giga,  'G',  10**9
      add_prefix :mega,  'M',  10**6
      add_prefix :kilo,  'k',  10**3
      add_prefix :hecto, 'h',  10**2
      add_prefix :deca,  'da', 10**1
      add_prefix :deci,  'd',  10**-1
      add_prefix :centi, 'c',  10**-2
      add_prefix :mili,  'm',  10**-3
      add_prefix :micro, 'µ',  10**-6
      add_prefix :nano,  'n',  10**-9
      add_prefix :pico,  'p',  10**-12
      add_prefix :femto, 'f',  10**-15
      add_prefix :atto,  'a',  10**-18
      add_prefix :zepto, 'z',  10**-21
      add_prefix :yocto, 'y',  10**-24

      add_prefix :yobi,  'Yi', 2**80
      add_prefix :zebi,  'Zi', 2**70
      add_prefix :exbi,  'Ei', 2**60
      add_prefix :pebi,  'Pi', 2**50
      add_prefix :tebi,  'Ti', 2**40
      add_prefix :gibi,  'Gi', 2**30
      add_prefix :mebi,  'Mi', 2**20
      add_prefix :kibi,  'Ki', 2**10
    end
    return self
  end

  def load_si_units
    self.configure do
      add_unit :m,   'meter',    1.0, :length
      add_unit :kg,  'kilogram', 1.0, :mass
      add_unit :s,   'second',   1.0, :time
      add_unit :A,   'Ampere',   1.0, :electric_current
      add_unit :K,   'Kelvin',   1.0, :temperature
      add_unit :mol, 'mole',     1.0, :amount_of_substance
      add_unit :cd,  'candela',  1.0, :luminous_intensity


    end
    return self
  end

  #
  # International System of Units (SI) Constants
  #
  SI_PREFIXES =
  [
    [ :yotta, 'Y',  10**24  ],
    [ :zetta, 'Z',  10**21  ],
    [ :exa,   'E',  10**18  ],
    [ :peta,  'P',  10**15  ],
    [ :tera,  'T',  10**12  ],
    [ :giga,  'G',  10**9   ],
    [ :mega,  'M',  10**6   ],
    [ :kilo,  'k',  10**3   ],
    [ :hecto, 'h',  10**2   ],
    [ :deca,  'da', 10**1   ],
    [ :deci,  'd',  10**-1  ],
    [ :centi, 'c',  10**-2  ],
    [ :mili,  'm',  10**-3  ],
    [ :micro, 'µ',  10**-6  ],
    [ :nano,  'n',  10**-9  ],
    [ :pico,  'p',  10**-12 ],
    [ :femto, 'f',  10**-15 ],
    [ :atto,  'a',  10**-18 ],
    [ :zepto, 'z',  10**-21 ],
    [ :yocto, 'y',  10**-24 ]
  ]

  SI_BINARY_PREFIXES =
  [
    [ :yobi,  'Yi', 2**80   ],
    [ :zebi,  'Zi', 2**70   ],
    [ :exbi,  'Ei', 2**60   ],
    [ :pebi,  'Pi', 2**50   ],
    [ :tebi,  'Ti', 2**40   ],
    [ :gibi,  'Gi', 2**30   ],
    [ :mebi,  'Mi', 2**20   ],
    [ :kibi,  'Ki', 2**10   ]
  ]

  SI_BASE_UNITS =
  [
    [ :m,   'metre',          1.0,            :length                                     ],
    [ :kg,  'kilogram',       1.0,            :mass                                       ],
    [ :s,   'second',         1.0,            :time                                       ],
    [ :A,   'Ampere',         1.0,            :electric_current                           ],
    [ :K,   'Kelvin',         1.0,            :temperature                                ],
    [ :cd,  'candela',        1.0,            :luminous_intensity                         ],
    [ :mol, 'mole',           1.0,            :amount_of_substance                        ],
    [ :bit, 'bit',            1.0,            :information                                ]
  ]

  SI_DERIVED_UNITS =
  [
    [ :η,   'amagat',         1.0,            :number_density,                symbol: 'η' ],
    [ :Bq,  'Bequerel',       1.0,            :radioactivity                              ],
    [ :ºC,  'degree Celsius', [1.0, 273.15],  :temperature                                ],
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
    [ :s,   'second',         1.0,            :time                                       ],
    [ :S,   'Siemens',        1.0,            :electric_conductance                       ],
    [ :Sv,  'Sievert',        1.0,            :radiation_dose_equivalent                  ],
    [ :sr,  'steridian',      1.0,            :solid_angle                                ],
    [ :T,   'Tesla',          1.0,            :magnetic_flux_density                      ],
    [ :V,   'Volt',           1.0,            :electric_potential_difference              ],
    [ :W,   'Watt',           1.0,            :power                                      ],
    [ :Wb,  'Weber',          1.0,            :magnetic_flux                              ],
    [ :m²,  'squared meter',  1.0,            :area                                       ],
    [ :m³,  'cubic meter',    1.0,            :volume                                     ]
  ]

  #
  # Non SI units
  #
  NON_SI_ACCEPTED_UNITS =
  [
    [ :min,            'minute',                       60.0,             :time                                     ],
    [ :h,              'hour',                         3_600.0,          :time                                     ],
    [ :d,              'day',                          86_400.0,         :time                                     ],
    [ :º,              'degree',                       Math::PI/180,     :plane_angle                              ],
    [ :arc_minute,     'minute',                       Math::PI/10_800,  :plane_angle,          symbol: "'"        ],
    [ :arc_second,     'second',                       Math::PI/648_000, :plane_angle,          symbol: '"'        ],
    [ :ha,             'hectare',                      1.0e4,            :area                                     ],
    [ :L,              'liter',                        1.0e-3,           :volume                                   ],
    [ :eV,             'electronvolt',                 1.602_176_487_40e-19, :energy                               ],
    [ :ua,             'astronomical unit',            1.495_978_706_916e11, :length                               ],
    [ :Da,             'Dalton',                       1.660_538_782_83e-27, :mass                                 ],
    [ :u,              'unified atomic mass unit',     1.660_538_782_83e-27, :mass                                 ],
    [ :nautical_mile,  'nautical mile',                1_852.0,          :length                                   ],
    [ :knot,           'nautical mile',                1_852.0/3_600.0,  :velocity                                 ],
    [ :Å,              'Angstrom',                     1.0e-10,          :length                                   ],
    [ :b,              'barn',                         1.0e-28,          :area                                     ],
    [ :bar,            'bar',                          1.0e5,            :pressure                                 ],
    [ :mmHg,           'milimeter of mercury',         133.322,          :pressure                                 ]
  ]

  NON_SI_UNITS =
  [
    [ :acre,           'acre',                         4046.8564224,     :area                                     ],
    [ :a,              'are',                          100.0,            :area                                     ],
    [ :atm,            'atmosphere',                   101.325e3,        :pressure                                 ],
    [ :Bi,             'biot',                         10.0,             :electric_current                         ],
    [ :bhp,            'boiler horsepower',            9.80950e3,        :power                                    ],
    [ :btu_39f,        'british thermal unit (39 °F)', 1059.67,          :energy,               symbol: 'BTU'      ],
    [ :btu_60f,        'british thermal unit (60 °F)', 1054.68,          :energy,               symbol: 'BTU'      ],
    [ :btu_63f,        'british thermal unit (63 °F)', 1054.6,           :energy,               symbol: 'BTU'      ],
    [ :btu_iso,        'british thermal unit (ISO)',   1055.056,         :energy,               symbol: 'BTU'      ],
    [ :btu_it,         'british thermal unit (IT)',    1055.05585262,    :energy,               symbol: 'BTU'      ],
    [ :btu_mean,       'british thermal unit (mean)',  1055.87,          :energy,               symbol: 'BTU'      ],
    [ :btu_thermo,     'british thermal unit (thermochemical)', 1054.35026444,    :energy,      symbol: 'BTU'      ],
    [ :btu_59f,        'british thermal unit (59 °F)', 1054.804,         :energy,               symbol: 'BTU'      ],
    [ :bu_imp,         'US bushel',                    36.36872e-3,      :volume,               symbol: 'bu (Imp)' ],
    [ :bu_us,          'UK bushel',                    35.23907e-3,      :volume,            symbol: 'bu (US lvl)' ],
    [ :byte,           'byte',                         8,                :information,          symbol: 'byte'     ],
    [ :cal,            'calorie',                      4.1868,           :energy                                   ],
    [ :cp,             'candle power',                 4*Math::PI,       :luminous_flux                            ],
    [ :kt,             'carat',                        200e-6,           :mass                                     ],
    [ :CHU,            'celsius heat unit',            1.0899101e3,      :energy                                   ],
    [ :cmHg,           'centimetre of mercury',        1.333222e3,       :pressure                                 ],
    [ :cmH2O,          'centimetre of water',          98.060616,        :pressure                                 ],
    [ :ch,             'chain',                        20.1168,          :length                                   ],
    [ :clo,            'clo',                          0.155,            :thermal_resistance                       ],
    [ :c_us,           'cup',                          236.5882e-6,      :volume,               symbol: 'c (US)'   ],
    [ :Ci,             'curie',                        37.0e9,           :radioactivity                            ],
    [ :deg_C,          'degree Celsius',               [0, 273.15],      :temperature,          symbol: '°C'       ],
    [ :deg_F,          'degree Farenheit',             [5.0/9.0, 459.67],:temperature,          symbol: '°F'       ],
    [ :deg_R,          'degree Rankine',               5.0/9.0,          :temperature,          symbol: '°R'       ],
    [ :dram,           'dram',                         1.771845e-3,      :length                                   ],
    [ :dyn,            'dyne',                         10e-6,            :force                                    ],
    [ :dyn_cm,         'dyne centimetre',              100e-9,           :energy,               symbol: 'dyn cm'   ],
    [ :hp_elec,        'electric horsepower',          746.0,            :power,                symbol: 'hp'       ],
    [ :me,             'electron mass',                9.10938188e-31,   :mass                                     ],
    [ :ell,            'ell',                          1.143,            :length                                   ],
    [ :erg,            'erg',                          100.0e-9,         :energy                                   ],
    [ :F,              'faraday',                      96.4853e3,        :electric_charge                          ],
    [ :ftm,            'fathom',                       1.828804,         :length                                   ],
    [ :fm,             'fermi',                        1e-15,            :length                                   ],
    [ :ft,             'foot',                         0.3048,           :length                                   ],
    [ :fc,             'footcandle',                   10.76391,         :illuminance                              ],
    [ :ftH2O,          'foot of water',                2.988887e3,       :pressure                                 ],
    [ :Fr,             'franklin',                     3.3356e-10,       :electric_charge                          ],
    [ :fur,            'furlong',                      201.168,          :length                                   ],
    [ :γ,              'gamma',                        1e-9,             :magnetic_flux_density                    ],
    [ :G,              'gauss',                        100e-6,           :magnetic_flux_density                    ],
    [ :grad,           'grad',                         Math::PI/200.0,   :plane_angle                              ],
    [ :gr,             'grain',                        64.79891e-6,      :mass                                     ],
    [ :Eh,             'hartree',                      4.359748e-18,     :energy                                   ],
    [ :ha,             'hectare',                      10e3,             :area                                     ],
    [ :hhd,            'hogshead',                     238.6697e-3,      :volume                                   ],
    [ :cwt_long,       'hundredweight long',           50.802345,        :mass,                 symbol: 'cwt'      ],
    [ :cwt_short,      'hundredweight short',          45.359237,        :mass,                 symbol: 'cwt'      ],
    [ :in,             'inch',                         25.4e-3,          :length                                   ],
    [ :inHg,           'inch of mercury',              3.386389e3,       :pressure                                 ],
    [ :inH2O,          'inch of water',                249.0740,         :pressure                                 ],
    [ :kcal,           'kilocalorie',                  4.1868e3,         :energy                                   ],
    [ :kgf,            'kilogram force',               9.80665,          :force                                    ],
    [ :kn,             'knot',                         514.4444e-3,      :velocity                                 ],
    [ :La,             'lambert',                      1e4,              :illuminance,                             ],
    [ :ly,             'light year',                   9.46073e15,       :length                                   ],
    [ :ln,             'line',                         2.116667e-3,      :length                                   ],
    [ :lnk,            'link',                         201.168e-3,       :length                                   ],
    [ :L,              'litre',                        1e-3,             :volume                                   ],
    [ :ton_uk,         'long ton',                     1.016047e3,       :mass,                 symbol: 'ton'      ],
    [ :Mx,             'maxwell',                      10e-9,            :magnetic_flux                            ],
    [ :hp,             'metric horsepower',            735.4988,         :power                                    ],
    [ :mi,             'mile',                         1.609344e3,       :length                                   ],
    [ :mbar,           'millibar',                     100,              :pressure                                 ],
    [ :mmHg,           'millimetre of mercury',        1.333222e2,       :pressure                                 ],
    [ :min,            'minute',                       60.0,             :time                                     ],
    [ :month,          'month',                        2.551444e6,       :time                                     ],
    [ :nl,             'nautical league',              5.556e3,          :length                                   ],
    [ :nmi,            'nautical mile',                1.852e3,          :length                                   ],
    [ :oz,             'ounce',                        28.34952e-3,      :mass                                     ],
    [ :pc,             'parsec',                       30.85678e15,      :length                                   ],
    [ :dwt,            'pennyweight',                  1.555174e-3,      :mass                                     ],
    [ :bbl,            'petroleum barrel',             158.9873e-3,      :volume                                   ],
    [ :pt,             'point',                        351.4598e-6,      :length                                   ],
    [ :p,              'poncelot',                     980.665,          :power                                    ],
    [ :lb,             'pound',                        0.45359237,       :mass                                     ],
    [ :pdl,            'poundal',                      138.255,          :force                                    ],
    [ :lbf,            'pound force',                  4.448222,         :force                                    ],
    [ :lbmol,          'pound mole',                   453.59237,        :amount_of_substance                      ],
    [ :quad,           'quad',                         1.055056e18,      :energy                                   ],
    [ :rd,             'rad',                          0.01,             :radiation_absorbed_dose,   symbol: 'rad' ],
    [ :rem,            'rem',                          0.01,             :radiation_dose_equivalent                ],
    [ :rev,            'revolution',                   2*Math::PI,       :plane_angle                              ],
    [ :reyn,           'reyn',                         689.5e3,          :dynamic_viscosity                        ],
    [ :rood,           'rood',                         1.011714e3,       :area                                     ],
    [ :Rd,             'rutherford',                   1e6,              :radioactivity                            ],
    [ :Ry,             'rydberg',                      2.179874e-18,     :energy,                                  ],
    [ :ton_us,         'short ton',                    907.1847,         :mass,                 symbol: 'ton'      ],
    [ :d_sid,          'sidereal day',                 86.16409053e3,    :time,                 symbol: 'd'        ],
    [ :year_sid,       'sidereal year',                31558823.803728,  :time,                 symbol: 'yr'       ],
    [ :lea,            'statute league',               4.828032e3,       :length                                   ],
    [ :sphere,         'sphere',                       4*Math::PI,       :solid_angle                              ],
    [ :sn,             'sthene',                       1e3,              :force                                    ],
    [ :St,             'stoke',                        100e-6,           :kinematic_viscosity                      ],
    [ :st,             'stone',                        6.350293,         :mass                                     ],
    [ :thm,            'therm',                        105.506e6,        :energy                                   ],
    [ :th,             'thermie',                      4.185407e6,       :energy                                   ],
    [ :tog,            'tog',                          0.1,              :thermal_resistance                       ],
    [ :t,              'tonne',                        1000.0,           :mass                                     ],
    [ :bbl_imp,        'UK barrel',                    163.6592e-3,      :volume,               symbol: 'bl (Imp)' ],
    [ :oz_fl_uk,       'UK fluid ounce',               28.41308e-6,      :volume,               symbol: 'fl oz'    ],
    [ :gal_uk,         'UK gallon',                    4.546092e-3,      :volume,               symbol: 'gal'      ],
    [ :gi_uk,          'UK gill',                      142.0654e-6,      :volume,               symbol: 'gi'       ],
    [ :hp_uk,          'UK horsepower',                745.6999,         :power,                symbol: 'hp'       ],
    [ :gal_dry_us,     'US dry gallon',                4.40488377086e-3, :volume,               symbol: 'gal'      ],
    [ :bbl_dry_us,     'US dry barrel',                115.6271e-3,      :volume,               symbol: 'bl (US)'  ],
    [ :oz_fl,          'US fluid ounce',               29.57353e-6,      :volume,               symbol: 'fl oz'    ],
    [ :gi_us,          'US gill',                      118.2941e-6,      :volume,               symbol: 'gi'       ],
    [ :bbl_fl_us,      'US liquid barrel',             119.2405e-3,      :volume,             symbol: 'fl bl (US)' ],
    [ :gal,            'US liquid gallon',             3.785412e-3,      :volume                                   ],
    [ :foot_survey_us, 'US survey foot',               304.8e-3,         :length,               symbol: 'ft'       ],
    [ :wk,             'week',                         604800,           :time                                     ],
    [ :yd,             'yard',                         0.9144,           :length                                   ],
    [ :yr,             'year',                         31557600,         :time                                     ]
  ]

end