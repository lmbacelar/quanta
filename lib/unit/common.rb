module Unit
  module Common
    attr_reader :label, :name, :factor, :scale, :quantity, :hash

    def to_s
      label.to_s
    end

    def unitless?
      quantity.dimension_one?
    end

    def base?
      quantity.base? && factor == 1.0 && scale == 0.0
    end

    def derived?
      !base?
    end

    def same_kind_as? other
      quantity.same_kind_as? other.quantity
    end

    def is_a? object
      object == Unit or super
    end
  end
end
