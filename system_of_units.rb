class SystemOfUnits
  attr_reader :label, :name, :prefixes, :units, :system_of_quantities
  def initialize label, options = {}
    @label                = label
    @name                 = options.fetch(:name)                 { label.to_s.tr_s '_', '  ' }
    @prefixes             = options.fetch(:prefixes)             { [] }
    @units                = options.fetch(:units)                { [] }
    @system_of_quantities = options.fetch(:system_of_quantities)
  end
end
