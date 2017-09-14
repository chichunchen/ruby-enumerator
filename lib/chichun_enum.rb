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

  def chunk_while
  end

  def collect &block
    if block_given?
      result = []
      each do |element|
        result << block.call(element)  
      end
      result
    else
      to_enum(:each)
    end
  end

  def collect_concat &block
    result = []
    each do |element|
      result.concat(block.call(element)) 
    end
    result
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

  def max(count=nil, &block)
    if block_given?
      if count.nil?
        reduce do |accumulator, element|
          accumulator = block.call(element) == 1 ? element : accumulator
        end
      else
        ## call sort...
      end
    else
      if count.nil?
        reduce do |accumulator, element|
          accumulator < element ? element : accumulator
        end
      else
        result = []
        # call sort...
      end  
    end
  end

  def reduce(accumulator = nil, operation = nil, &block)
    if accumulator.nil? && operation.nil? && block.nil?
      raise ArgumentError, "you must provide an operation or a block"
    end

    if operation && block
      raise ArgumentError, "you must provide either an operation symbol or a block, not both"
    end

    if operation.nil? && block.nil?
      operation = accumulator
      accumulator = nil
    end

    # when operation is given by the client, assign the operation by using `send`
    # send use the first argument as the method you want to call, so we defer the choose of the function
    block = case operation
      when Symbol
        lambda { |acc, value| acc.send(operation, value) }
      when nil
        block
      else
      raise ArgumentError, "the operation provided must be a symbol"
    end

    if accumulator.nil?
      ignore_first = true
      accumulator = first
    end

    index = 0

    each do |element|
      unless ignore_first && index == 0
        accumulator = block.call(accumulator, element)
      end
      index += 1
    end
    accumulator
  end 

  def sort &block
    result = []
    if block_given?
    else
      # if block not given, use descending order

    end
  end

  def sort_by &block
  end

  def sum init=nil, &block
    if block_given?
      if init.nil?
        init = block.call(first)
        result = reduce(init) do |accumulator, element|
          accumulator + block.call(element)
        end
        result - init
      else
        reduce(init) do |accumulator, element|
          accumulator + block.call(element)
        end
      end
    else
      # no given block
      reduce(init) do |accumulator, element|
        accumulator + element
      end
    end
  end

  def take count=0
    result = []
    each do |element|
      if (count == 0)
        break
      else
        count = count-1
      end
      result << element  
    end
    result
  end

  # returns an array of prior element until the block returns nil or false
  def take_while &block
    if block_given?
      result = []
      each do |element|
        if block.call(element) != nil and block.call(element) != false
          result << element
        else
          break
        end
      end
      result
    else
      to_enum(:each)
    end
  end

  def to_a
    result = []
    each do |element|
      result << element
    end
    result
  end

  def to_h
    result = {}
    each do |key, value|
      result[key] = value
    end
    result
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
