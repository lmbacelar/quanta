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

  #
  # TODO: Add remaining units
  #
  def load_si_units
    self.configure do
      add_unit :meter,    'm',   1.0, :length
      add_unit :kilogram, 'kg',  1.0, :mass
      add_unit :second,   's',   1.0, :time
      add_unit :ampere,   'A',   1.0, :electric_current,    name: 'Ampere'
      add_unit :kelvin,   'K',   1.0, :temperature,         name: 'Kelvin'
      add_unit :mole,     'mol', 1.0, :amount_of_substance
      add_unit :candela,  'cd',  1.0, :luminous_intensity
    end
    return self
  end
end
