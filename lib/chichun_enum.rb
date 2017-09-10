module ChiChunEnumerable
end

class Triple

  include Enumerable

  def initialize a, b, c
		@a = a
		@b = b
		@c = c
  end

  def each(&block)
    yield(@a)  
    yield(@b)  
    yield(@c)  
    self
  end
end
