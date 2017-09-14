module ChiChunEnumerable
  def all?(&block)
    result = true

    if block_given?
      each do |element|
        unless block.call(element)
          result = false
        end  
      end
    elsif
      each do |element|
        if element == nil or element == false
          result = false
        end
      end
    end
    result
  end

  def any?(&block)
    result = false

    if block_given?
      each do |e|
        if block.call(e)
          result = true
        end
      end
    elsif
      each do |e|
        if e != nil
          result = true
        end
      end
    end
    result
  end

  def chunk
    
  end

  def find(ifnone=nil, &block)
    if block_given?
      result = nil
      found = false
      each do |element|
        if block.call(element)
          result = element
          found = true
          break
        end
      end
      found ? result : ifnone && ifnone.call
    else
      to_enum(:each)
    end
  end

  def find_all(&block)
    if block_given?
      result = []
      each do |element|
        if block.call(element)
          result << element
        end
      end
      result
    else
      to_enum(:each)
    end
  end

  def find_index(ifnone=nil, &block)
    index = 0
    has_find = false
    if block_given?
      each do |element|
        if block.call(element)
          has_find = true
          break
        end
        index = index+1
      end
      has_find ? index : nil
    elsif ifnone != nil
      each do |element|
        if ifnone == element
          has_find = true
          break
        end
        index = index+1
      end
      has_find ? index : nil
    else
      to_enum(:each)
    end
  end

  def first count=nil
    if count == nil
      each do |element|
        return element
      end
    else
      result = []
      each do |element|
        if (count > 0)
          result << element
        else
          break
        end
        count = count-1
      end
      result
    end
  end

  def flat_map(&block)
    result = []
    each do |element|
      result.concat(block.call(element)) 
    end
    result
  end

  def map(&block)
    result = []
    each do |element|
      result << block.call(element)
    end
    result
  end

  def reduce(accumulator, operation=nil, &block)
    if operation && block
      raise ArgumentError, "you must provide either an operation symbol or a block, not both"
    end

    block = case operation
      when Symbol
        lambda { |acc,value| acc.send(operation, value) }
      when nil
        block
      else
        raise ArgumentError, "the operation provided must be a symbol"
    end

    each do |element|
      accumulator = block.call(accumulator, element)
    end
    accumulator
  end
end

class Triple

  include ChiChunEnumerable

  def initialize a=nil, b=nil, c=nil
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
