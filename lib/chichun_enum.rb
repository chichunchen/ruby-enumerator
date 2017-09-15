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

  def chunk &block
    # set last_type to first predicate, so that the first one
    # must be added to the array
    last_type = block.call(first)
    current_ary = []
    current_2d_ary = []
    result = []

    each do |element|
      temp = block.call(element)
      if temp == last_type
        current_ary << element
      else
        current_2d_ary << last_type
        current_2d_ary << current_ary
        result << current_2d_ary
        last_type = temp

        # recreate new array
        current_2d_ary = []
        current_ary = []
        current_ary << element
      end
    end

    current_2d_ary << last_type
    current_2d_ary << current_ary
    result << current_2d_ary
  end

  def chunk_while &block
    last_item = nil
    current_ary = []
    result = []

    if block.arity == 1
      last_item = block.call(first)

      each do |i, j|
        temp = block.call(i, j)
        if temp == last_item
          current_ary << i
        else
          result << current_ary
          last_item = temp

          # recreate new array
          current_ary = []
          current_ary << i
        end
      end
    elsif block.arity == 2
      each do |current_item|
        unless last_item.nil?
          if block.call(last_item, current_item)
            current_ary << last_item
          else    
            current_ary << last_item
            result << current_ary
            current_ary = []
            current_ary << current_item
          end
        end
        last_item = current_item
      end
    end
    result << current_ary
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

  def count item=nil, &block
    count = 0
    if item.nil? and block_given? == false
      each do |element|
        count = count+1
      end
    elsif item.nil? and block_given?
      each do |element|
        if block.call(element)
          count = count+1
        end
      end
    elsif item and block_given? == false
      each do |element|
        if item == element
          count = count+1
        end
      end
    else
      raise ArgumentError, "you must provide either an operation symbol or a block, not both"
    end
    count
  end

  def cycle n=nil, &block
    if block_given? == false
      to_enum(:each)
    elsif n != nil and n < 0
      nil
    elsif n != nil and block_given?
      n.times do
        each do |element|
          block.call(element)
        end
      end
      # Returns nil if the loop has finished without getting interrupted.
      nil
    elsif n.nil? and block_given?
      while 1
        each do |element|
          block.call(element)
        end
      end
    end
  end

  def detect ifnone=nil, &block
    if block_given?
      each do |element|
        if block.call(element) != false
          return element
        end
      end
      block.call(ifnone)
    else
      to_enum(:each)
    end
  end

  def drop n=0
    result = []
    each do |element|
      if n == 0
        result << element
      else
        n = n-1
      end
    end
    result
  end

  def drop_while &block
    unless block_given?
      return to_enum(:each)
    end

    result = []
    already_false = false

    each do |element|
      if block.call(element) == false or already_false == true
        p element
        result << element
        already_false = true
      end
    end
    result
  end

  def each_cons n=nil, &block
    unless block_given?
      return to_enum(:each)
    end

    unless n.nil?
      current = []
      each do |element|
        if current.size < n
          current << element
        else 
          block.call(current)
          current = Array.new(current)
          current.shift
          current << element
        end
      end
      block.call(current)
      return nil
    end
  end

  def each_entry ifnone=nil, &block
    unless block_given?
      return to_enum(:each)
    end

    each do |element|
      block.call(element)
    end
  end

  def each_slice n=nil, &block
    unless block_given?
      return to_enum(:each)
    end

    result = []
    each do |element|
      if result.size == n
        block.call(result)
        result = Array.new
      end
      result << element
    end

    if result.size > 0
      block.call(result)
    end
  end

  def each_with_index *args, &block
    unless block_given?
      return to_enum(:each)
    end

    index = 0
    each do |element|
      block.call(element, index)
      index = index+1
    end
  end

  def each_with_object obj=nil, &block
    unless block_given?
      return to_enum(:each)
    end

    each do |element|
      block.call(element, obj)
    end
    obj
  end

  def entries *args
    result = []
    each do |element|
      result << element
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

  def grep pattern=nil, &block
    result = []
    each do |element|
      if element.match(pattern) 
        block.call(element) if block_given?
        result << element
      end
    end
    result
  end

  def grep_v pattern=nil, &block
    result = []
    each do |element|
      unless element.match(pattern) 
        block.call(element) if block_given?
        result << element
      end
    end
    result
  end

  def group_by &block
    unless block_given?
      return to_enum(:each)
    end

    hash = {}
    ary = []
    each do |element|
      temp = block.call(element)
      if hash.key?(temp)
          ary = hash[temp]
          ary << element
          hash[temp] = ary
      else
        hash[temp] = [element]
      end
    end
    hash
  end

  def include? obj=nil
    each do |element|
      if element == obj
        return true
      end
    end
    false
  end

  def inject
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
          block.call(accumulator, element) != 1 ? element : accumulator
        end
      else
        sort { |a, b| block.call(-a, -b) }.first(count)
      end
    else
      if count.nil?
        reduce do |accumulator, element|
          accumulator < element ? element : accumulator
        end
      else
        sort_by { |e| -e }.first(count)
      end  
    end
  end

  def max_by(count=nil, &block)
    if block_given?
      if count.nil?
        reduce do |accumulator, element|
          accumulator = block.call(element) > block.call(accumulator) ? element : accumulator
        end
      else
        result = sort_by { |e| 0-block.call(e) }.first(count)
      end
    else
      to_enum(:each)
    end
  end

  def member? obj=nil
    each do |element|
      if element == obj
        return true
      end
    end
    false
  end

  def min (count=nil, &block)
    if block_given?
      if count.nil?
        reduce do |accumulator, element|
          block.call(accumulator, element) == 1 ? element : accumulator
        end
      else
        sort { |a, b| block.call(a, b) }.first(count)
      end
    else
      if count.nil?
        reduce do |accumulator, element|
          accumulator > element ? element : accumulator
        end
      else
        sort_by { |e| e }.first(count)
      end  
    end
  end

  def min_by(count=nil, &block)
    if block_given?
      if count.nil?
        reduce do |accumulator, element|
          accumulator = block.call(element) < block.call(accumulator) ? element : accumulator
        end
      else
        result = sort_by { |e| block.call(e) }.first(count)
      end
    else
      to_enum(:each)
    end
  end

  def minmax &block
    if block_given?
      [
        min { |a, b| block.call(a, b) },
        max { |a, b| block.call(a, b) }
      ]
    else
      [min, max]
    end
  end

  def minmax_by &block
    if block_given?
      [
        min_by { |e| block.call(e) },
        max_by { |e| block.call(e) }
      ]
    else
      to_enum(:each)
    end
  end

  def none? &block
    if block_given?
      each do |element|
        if block.call(element)
          return false
        end
      end
      true
    else
      each do |element|
        unless element.nil? or element == false
          return false
        end
      end
      true
    end 
  end

  def one? &block
    is_one = false
    each do |element|
      temp = block_given? ? block.call(element) : element
      if temp and is_one == false
        is_one = true
      elsif temp and is_one == true
        is_one = false
        break
      end
    end
    is_one
  end

  def partition &block
    unless block_given?
      return to_enum(:each)
    end

    result = []
    true_ary = []
    other_ary = []

    each do |element|
      if block.call(element)
        true_ary << element
      else
        other_ary << element
      end
    end
    result << true_ary << other_ary
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

  def reject &block
    unless block_given?
      return to_enum(:each)
    end

    result = []
    each do |element|
      unless block.call(element)
        result << element   
      end
    end
    result
  end

  def reverse_each &block
    ary = []
    result = []

    # create temporary ary
    each do |element|
      ary << element
    end

    # create reverse order array
    for i in (ary.size-1).downto(0)
      result << ary[i]
      if block_given? then block.call(ary[i]) end
    end

    if block_given?
      result
    else
      # Manually create reverse enumerator
      enum = Enumerator.new do |y|
        for i in 0...result.size
          y.yield(result[i])
        end
      end
    end
  end

  def select &block
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

  def slice_after pattern=nil, &block
    if pattern and block_given?
      raise ArgumentError, "you must provide either an operation symbol or a block, not both"
    else
      current_ary = []
      enum_ary = []

      each do |element|
        predicate = block_given? ? block.call(element) : element.match(pattern)
        if predicate
          current_ary << element
          enum_ary << current_ary
          current_ary = []
        else
          current_ary << element
        end
      end

      # return an enumerator that enumerates each chunked array
      enum_of_enum = Enumerator.new do |y|
        enum_ary.each do |chunked_ary|
          y.yield chunked_ary
        end
      end
    end
  end

  def slice_before pattern=nil, &block
    current_ary = []
    enum_ary = []

    if pattern and block_given?
      raise ArgumentError, "you must provide either an operation symbol or a block, not both"
    else
      each do |element|
        predicate = block_given? ? block.call(element) : element.match(pattern)
        if predicate
          enum_ary << current_ary if current_ary.size > 0
          current_ary = []
          current_ary << element
        else
          current_ary << element
        end
      end
      enum_ary << current_ary if current_ary.size > 0

      # return an enumerator that enumerates each chunked array
      enum_of_enum = Enumerator.new do |y|
        enum_ary.each do |chunked_ary|
          y.yield chunked_ary
        end
      end
    end
  end

  def slice_when &block
    if block_given?
      last_item = nil
      current_ary = []
      enum_ary = []
      each do |current|
        if last_item.nil?
          last_item = current
        else
          predicate = block.call(last_item, current)
          if predicate
            current_ary << last_item
            enum_ary << current_ary
            current_ary = []
            last_item = current
          else
            current_ary << last_item
            last_item = current
          end
        end
      end
      current_ary << last_item
      enum_ary << current_ary

      Enumerator.new do |y|
        enum_ary.each do |ele|
          y.yield(ele)
        end
      end
    else
      to_enum(:each)
    end
  end

  # use insertion sort since the number of item is small
  def sort &block
    result = []
    each do |element|
      result << element
    end

    size = result.size
    for i in 0...size
      key = result[i]
      j = i-1
      predicate = block_given? ? block.call(key, result[j]) == -1 : key < result[j]
      while(j >= 0 and predicate)
        result[j+1] = result[j]
        j = j-1
      end
      result[j+1] = key
    end
    result
  end

  def sort_by &block
    result = []
    each do |element|
      result << element
    end

    size = result.size
    for i in 0...size
      key = result[i]
      j = i-1
      predicate = block_given? ? block.call(key) < block.call(result[j]) : key < result[j]
      while(j >= 0 and predicate)
        result[j+1] = result[j]
        j = j-1
      end
      result[j+1] = key
    end
    result
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
      Enumerator.new do |y|
        y.yield(first)
      end
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

  def uniq
  end

  def zip
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


    t = Triple.new(["lua", "javascript"], ["kotlin", "scala"], ["c", "go"])
    result = t.each_with_index.to_h
    p result
