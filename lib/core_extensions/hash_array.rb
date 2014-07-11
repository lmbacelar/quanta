module HashArray
  def map_hash &block
    self.map{ |hash| hash.map { |k,v| block.call(k,v) } }.flatten
  end
end

