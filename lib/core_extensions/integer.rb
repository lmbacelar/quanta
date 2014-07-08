class Integer
  def to_superscript
    "#{'⁻' if self < 0}#{self.abs.to_s.chars.map{ |n| %w{⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹}[n.to_i] }.join}"
  end
end
