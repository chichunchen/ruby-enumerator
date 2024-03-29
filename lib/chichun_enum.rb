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
        if e != nil and e != false
          result = true
        end
      end
    end
    result
  end

  def chunk &block
    def keep(e)
      e != nil and e != :_separtor
    end

    attribute = block.call(first)
    result = []

    if keep(attribute)
      temp = [first]
    end

    drop(1).each do |element|
      t = block.call(element)

      # chunk it
      if t === attribute and keep(t) and t != :_alone
        temp << element
      else
        result << [attribute, temp] if keep(attribute)
        attribute = t
        temp = [element] if keep(t)
      end
    end

    result << [attribute, temp]
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
      result = []
      current_ary = first(1)

      each_cons(2) do |element|
        temp = block.call(element)
        unless temp
          result << current_ary
          current_ary = [element[1]]
        else
          current_ary << element[1]
        end
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
    reduce([]) do |accumulator, element|
        addr = block.call(element)
        if addr.instance_of?(Array)
            accumulator + addr
        else
            accumulator << addr
        end
    end
  end

  def count item=nil, &block
    count = 0
    if item.nil? and block_given? == false
      predicate = true
      count = reduce (count) { |acc, element| acc + 1 }
    elsif item.nil? and block_given?
      each do |element|
        if block.call(element)
          count = count+1
        end
      end
    elsif item and block_given? == false
      each { |element| count = count + 1 if item == element }
    else
      raise ArgumentError, "you must provide either an item or a block, not both"
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
        if block.call(element)
          return element
        end
      end
    end
    if ifnone
        ifnone.call
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
      index = 0
      enum = Enumerator.new do |y|
        each do |element|
          y << [element, index]
          index = index + 1
        end
      end
      return enum
    end

    inject(0) do |accumulator, element|
      block.call(element, accumulator)
      accumulator + 1
    end
  end

  def each_with_object obj=nil, &block
    unless block_given?
      return to_enum(:each)
    end

    inject(obj) { |acc, element| block.call(element, obj) }
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
      each { |element| return element }
    else
      result = []
      max = count || 1
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
    collect_concat(&block)
  end

  def grep pattern=nil, &block
    result = []
    each { |element|
        if pattern.instance_of? Regexp
            if pattern.match element
                result << element
            end
        elsif pattern === element
            result << element
        end
    }
    if block_given?
        ret = []
        result.each {|item| ret << block.call(item)}
        return ret
    end
    return result
  end

  def grep_v pattern=nil, &block
    result = []
    each { |element|
        unless pattern === element
            result << element
        end
    }
    if block_given?
        ret = []
        result.each {|item| ret << block.call(item)}
        return ret
    end
    return result
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

  # There are several kind of arguments combination is accepted
  # 1. no initial, have sym
  # 2. no initial, have block
  # 3. initial, have sym
  # 4. initial, have block
  def inject(initial=nil, sym=nil, &block)
    if initial.nil? and sym.nil? and block.nil?
      raise ArgumentError, "at least one operation should be passed!" 
    end

    if sym and block
      raise ArgumentError, "sym and block cannot be passed at the same time!" 
    end

    # check the first parameter is operation or initial value
    if sym.nil? and block.nil?
      sym = initial
      initial = nil
    end

    block = case sym
      when Symbol
        lambda { |acc, value| acc.send(sym, value) }
      when nil
        block
      else
        raise ArgumentError, "the operation provided must be a symbol!"
    end

    if initial.nil?
      ignore_first = true
      initial = first
    end

    index = 0

    each do |element|
      unless ignore_first and index == 0
        initial = block.call(initial, element)
      end
      index += 1
    end
    initial
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
        sort { |a, b| block.call(a, b) }.reverse.first(count)
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
        result = sort_by { |e| block.call(e) }.reverse.first(count)
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

  def reduce(initial = nil, sym = nil, &block)
    if initial.nil? and sym.nil? and block.nil?
      raise ArgumentError, "at least one operation should be passed!"
    end

    if sym and block
      raise ArgumentError, "sym and block cannot be passed at the same time!"
    end

    # check the first parameter is operation or initial value
    if sym.nil? and block.nil?
      sym = initial
      initial = nil
    end

    block = case sym
      when Symbol
        lambda { |acc, value| acc.send(sym, value) }
      when nil
        block
      else
        raise ArgumentError, "the operation provided must be a symbol!"
    end

    if initial.nil?
      ignore_first = true
      initial = first
    end

    index = 0

    each do |element|
      unless ignore_first and index == 0
        initial = block.call(initial, element)
      end
      index += 1
    end
    initial
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
          # syntax sugar: y << result[i]
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
      chunk = []
      enum_ary = []
      size = map { |e| }.size

      each_with_index do |element, index|
        if block_given?
            predicate = block.call(element)
        elsif pattern.instance_of? Regexp
            predicate = element.match(pattern)
        else
            predicate = pattern === element
        end

        if predicate
          chunk << element
          enum_ary << chunk
          chunk = Array.new
        else
          chunk << element
          puts chunk

          if index == size-1
            enum_ary << chunk 
          end
        end
      end

      enum_ary
    end
  end

  def slice_before pattern=nil, &block
    current_ary = []
    enum_ary = []

    if pattern and block_given?
      raise ArgumentError, "you must provide either an operation symbol or a block, not both"
    else
      each do |element|
        if block_given?
            predicate = block.call(element)
        elsif pattern.instance_of? Regexp
            predicate = element.match(pattern)
        else
            predicate = pattern === element
        end

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
    if block_given?
        entries.sort(&Proc.new)
    else
        entries.sort
    end
  end

  def sort_by &block
    entries.sort_by(&Proc.new)
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

  # Returns the result of interpreting enum as a list of [key, value] pairs.
  def to_h(&block)
    hash = {}
    each do |element|
      if element.instance_of? Array and element.size == 2
        key = element[0]
        value = element[1]
        hash[key] = value
      else
        raise TypeError, "All of the elements should be an array that have size=2"
      end
    end
    hash
  end

  def uniq &block
    arr = []
    aux = []
    each do |element|
      if block_given?
        temp = block.call(element)
        unless aux.member?(temp)
          aux << temp
          arr << element
        end
      else
        arr << element unless arr.member?(element)
      end
    end
    arr
  end

  def zip *args, &block
    result = []
    current = args

    each do |element|
        curr_addr = current.map { |element| element.first }
        if block_given?
            # should add element inside block
            block.call([element] + curr_addr)
        else
            result << [element] + curr_addr
        end
        current = current.map { |e| e.drop(1) }
    end
    result if not block_given?
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
