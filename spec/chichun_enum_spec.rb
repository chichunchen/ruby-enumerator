require './lib/chichun_enum'

describe '#all?' do
  it 'return true if all three elements in t > 0' do
    t = Triple.new(1, 2, 3)
    result = t.all? do |n|
      n > 0
    end
    expect(result).to eq true
  end

  it 'return false if one of the elements in t < 0' do
    t = Triple.new(-1, 2, 3)
    result = t.all? do |n|
      n < 0
    end
    expect(result).to eq false
  end

  context 'when block not given' do
    it 'return false if there are any elements that is nil' do
      t = Triple.new(1, nil, 3)
      result = t.all?
      expect(result).to eq false
    end

    it 'return false if there are any elements that is false' do
      t = Triple.new(1, false, 3)
      result = t.all?
      expect(result).to eq false
    end

    it 'return true if there no elements that is false or nil' do
      t = Triple.new(1, 2, 3)
      result = t.all?
      expect(result).to eq true
    end
  end
end

describe '#any?' do
  it 'returns true if there is one element greater than 0' do
    t = Triple.new(-1, -2, 3)
    result = t.any? do |n|
      n > 0
    end
    expect(result).to eq true
  end

  it 'returns false since there is no elements in t greater than 0' do
    t = Triple.new(-1, -2, -3)
    result = t.any? do |n|
      n > 0
    end
    expect(result).to eq false
  end

  context 'when block not given' do
    it 'return true if there are any elements?' do
      t = Triple.new(nil, nil, 1)
      result = t.any?
      expect(result).to eq true
    end

    it 'return false if no any elements?' do
      t = Triple.new(nil, nil, nil)
      result = t.any?
      expect(result).to eq false
    end
  end
end

describe '#chunk' do
  it 'group consecutive odd number and group consecutive even number' do
    t = Triple.new(1, 2, 4)
    result = t.chunk { |n| n.even? }.to_a
    expect(result[1]).to eq ([true, [2, 4]])
    expect(result[0]).to eq ([false, [1]])
  end
end

describe '#chunk_while' do
  it 'create enumerators for each consecutive elements < 0' do
    t = Triple.new(1, -2, -3)
    result = t.chunk_while { |n| n < 0 }.to_a
    expect(result[0]).to eq [1]
    expect(result[1]).to eq [-2, -3]
  end

  it 'create enumerators for non-descending subsequences' do
    t = Triple.new(1, 2, 0)
    result = t.chunk_while { |i, j| i < j }.to_a
    expect(result[0]).to eq [1, 2]
    expect(result[1]).to eq [0]
  end
end

describe '#collect' do
  it 'collect the number multiple by 2' do
    t = Triple.new(1, 2, 3)
    result = t.collect do |n|
      n * 2
    end
    expect(result).to eq ([2, 4, 6])
  end

  context 'when block not given' do
    it 'return an enumerator for t' do
      t = Triple.new(1, 2, 3)
      result = t.collect
      expect(result.to_a).to eq [1, 2, 3]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#collect_concat' do
  it 'append dynamic language after python, ruby, and perl' do
    t = Triple.new('python', 'ruby', 'perl')
    result = t.collect_concat { |e| [e, "is dynamic language"] }
    expect(result).to eq ["python", "is dynamic language", "ruby", "is dynamic language", "perl", "is dynamic language"]
  end

  it 'append CS after each flatted element' do
    t = Triple.new([451, 452], [453, 455], [456])
    result = t.collect_concat { |e| e + ["CS"] }
    expect(result).to eq [451, 452, "CS", 453, 455, "CS", 456, "CS"]
  end
end

describe '#count' do
  t = Triple.new(-1, 2, 4)

  context '#count(item) { |e| block }' do
    it 'return all of the elements that is greater than 0' do
      result = t.count { |e| e > 0 }
      expect(result).to eq 2
    end
  end

  context '#count(item) - when block not given' do
    it 'return the count of element: 2' do
      result = t.count(2)
      expect(result).to eq 1
    end

    context '#count() - when no argument is given' do
      it 'return the size of the enum array: 3' do
        expect(t.count()).to eq 3
      end
    end
  end

### should test both argument and block and raise error
end

describe '#cycle' do
  it 'concat ruby, c and, java for 3 times to a string, and return nil' do
    t = Triple.new("ruby", "c", "java")
    str = String.new
    result = t.cycle(3) { |e| str.concat(e) }
    expect(str).to eq "rubycjavarubycjavarubycjava"
    expect(result).to eq nil
  end

  it 'do nothing if the argument is non-positive' do
    t = Triple.new("ruby", "c", "java")
    str = String.new
    result = t.cycle(-3) { |e| str.concat(e) }
    expect(str).to eq ""
    expect(result).to eq nil
  end

  context 'when no block is given' do
    it 'returns the enumerator of t' do
      t = Triple.new("lua", "kotlin", "julia")
      result = t.cycle
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end

  context 'non or nil is given in argument' do
    t = Triple.new("ruby", "c", "java")
    str = String.new
    inloop = false

    it 'enter infinite loop if argument is nil' do
      thread = Thread.new do
        t.cycle(nil) { |e| str.concat(e); inloop = true }
        inloop = false
      end 
      sleep(0.01)
      thread.kill
      expect(str).to_not eq ""
      expect(inloop).to eq true
    end

    it 'enter infinite loop if argument is not given' do
      thread = Thread.new do
        t.cycle() { |e| str.concat(e); inloop = true }
        inloop = false
      end 
      sleep(0.01)
      thread.kill
      expect(str).to_not eq ""
      expect(inloop).to eq true
    end
  end
end

describe '#detect' do
  it 'return the first element that have lenght > 3' do
    t = Triple.new("lua", "kotlin", "julia")
    result = t.detect { |e| e.length > 3 }
    expect(result).to eq "kotlin"
  end

  context 'when no block is given' do
    it 'returns the enumerator of t' do
      t = Triple.new("lua", "kotlin", "julia")
      result = t.detect
      expect(result.to_a).to eq ["lua", "kotlin", "julia"]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#drop' do
  it 'delete first two elements' do
    t = Triple.new(1, 2, 3)
    result = t.drop(2)
    expect(result).to eq [3]
  end
end

describe '#drop_while' do
  it 'drop elements if elements smaller than zero, but once the predicate is true, the iteration stops' do
    t = Triple.new(-1, 2, -3)
    result = t.drop_while { |e| e < 0 }
    expect(result).to eq [2, -3]
  end

  context 'when no block given' do
    it 'returns an iterator' do
      t = Triple.new(1, 2, 3)
      result = t.drop_while
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#each_cons' do
  it 'push array of 2 consecutive elements in t and return nil' do
    ary = Array.new
    t = Triple.new(1, 2, 3)
    result = t.each_cons(2) { |e| ary << e }
    expect(ary).to eq [[1, 2], [2, 3]]
    expect(result).to eq nil
  end

  context 'when no block given' do
    it 'returns an iterator' do
      t = Triple.new(1, 2, 3)
      result = t.each_cons(2)
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#each_entry' do
  it 'push each element into ary and return object whose class is Triple' do
    ary = []
    t = Triple.new(1, ["abc", "def"], "abcdef")
    result = t.each_entry { |e| ary << e }
    expect(ary).to eq [1, ["abc", "def"], "abcdef"]
    expect(result.instance_of?(Triple)).to eq true
  end

  it 'should treat nil element like normal' do
    ary = []
    t = Triple.new(1, [1, 2], nil)
    result = t.each_entry { |e| ary << e }
    expect(ary).to eq [1, [1, 2], nil]
  end

  context 'when no block given' do
    it 'returns an iterator' do
      t = Triple.new(1, 2, 3)
      result = t.each_entry(2)
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#each_slice' do
  it 'slice each two elements into an array and the last array has only one element' do
    ary = Array.new
    t = Triple.new("abc", "cde", "fgh")
    result = t.each_slice(2) { |e| ary << e }
    expect(ary).to eq [["abc", "cde"], ["fgh"]]
  end

  context 'when no block given' do
    it 'returns an iterator' do
      t = Triple.new(1, 2, 3)
      result = t.each_slice(1)
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#each_with_index' do
  it 'concat each item with index and then add to ary' do
    ary = Array.new
    t = Triple.new(1, 2, 3)
    result = t.each_with_index { |item, index| ary << item.to_s.concat(index.to_s).to_i } 
    expect(ary).to eq [10, 21, 32]
  end

  context 'when no block given' do
    it 'returns an iterator' do
      t = Triple.new(1, 2, 3)
      result = t.each_with_index(1)
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#each_with_object' do
  it 'element as key and 2*element as value and then add to the hash' do
    t = Triple.new(1, 2, 3)
    result = t.each_with_object({}) { |item, h| h[item] = item*2  } 
    expect(result).to eq ({1=>2, 2=>4, 3=>6})
  end

  context 'when no block given' do
    it 'returns an iterator' do
      t = Triple.new(1, 2, 3)
      result = t.each_with_object(1)
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#entries' do
  it 'return an array with all elements' do
    t = Triple.new(1, 2, 3)
    result = t.entries
    expect(result).to eq [1, 2, 3]
  end
end

describe '#find' do
  it 'find the first element greater than 1' do
    t = Triple.new(1, 2, 3)
    result = t.find do |n|
      n > 1
    end
    expect(result).to eq 2
  end

  context 'when no block is given' do
    it 'returns the enumerator of t' do
      t = Triple.new("lua", "kotlin", "julia")
      result = t.find
      expect(result.to_a).to eq ["lua", "kotlin", "julia"]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#find_all' do
  it 'find all elements greater than 1' do
    t = Triple.new(1, 2, 3)
    result = t.find_all do |n|
      n > 1
    end
    expect(result).to eq [2, 3]
  end

  context 'when no block is given' do
    it 'returns the enumerator of t' do
      t = Triple.new("lua", "kotlin", "julia")
      result = t.find_all
      expect(result.to_a).to eq ["lua", "kotlin", "julia"]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#find_index' do
  it 'find the index of first element' do
    t = Triple.new(1, 2, 3)
    result = t.find_index { |i| i == 1 }
    expect(result).to eq 0
  end

  context 'when argument is given but block not given' do
    it 'find the index of second element' do
      t = Triple.new(1, 2, 3)
      result = t.find_index(2)
      expect(result).to eq 1
    end
  end

  context 'when no block is given' do
    it 'returns the enumerator of t' do
      t = Triple.new("lua", "kotlin", "julia")
      result = t.find_index
      expect(result.to_a).to eq ["lua", "kotlin", "julia"]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#first' do
  it 'returns first element' do
    t = Triple.new(1, 2, 3)
    result = t.first
    expect(result).to eq 1
  end

  it 'returns first two elements' do
    t = Triple.new(1, 2, 3)
    result = t.first(2)
    expect(result).to eq [1, 2]
  end

  it 'returns first ten elements' do
    t = Triple.new(1, 2, 3)
    result = t.first(10)
    expect(result).to eq [1, 2, 3]
  end

  it 'if t is empty, still return first two nil element' do
    t = Triple.new()
    result = t.first(2)
    expect(result).to eq [nil, nil]
  end
end

describe '#flat_map' do
  it 'append dynamic language after python, ruby, and perl' do
    t = Triple.new('python', 'ruby', 'perl')
    result = t.flat_map { |e| [e, "is dynamic language"] }
    expect(result).to eq ["python", "is dynamic language", "ruby", "is dynamic language", "perl", "is dynamic language"]
  end

  it 'append CS after each flatted element' do
    t = Triple.new([451, 452], [453, 455], [456])
    result = t.flat_map { |e| e + ["CS"] }
    expect(result).to eq [451, 452, "CS", 453, 455, "CS", 456, "CS"]
  end
end

describe '#grep' do
  it 'return strings that has prefix "app"' do
    t = Triple.new("apple", "app", "application")
    result = t.grep /^app/
    expect(result).to eq ["apple", "app", "application"]
  end

  it 'return strings that match xxx-xxx-xxx, and x is digit' do
    t = Triple.new("555-888-999", "454-588-792", "123456789")
    result = t.grep /\d\d\d-\d\d\d-\d\d\d/
    expect(result).to eq (["555-888-999", "454-588-792"])
  end

  context '#grep(patter) { |obj| block }' do
    it 'returns strings that is composed of digits' do
      t = Triple.new("aaa", "bbb", "100")
      result = t.grep(/\d+/) { |obj| obj.concat(" is all digits.") }
      expect(result).to eq ["100 is all digits."]
    end
  end
end

describe '#grep_v' do
  it 'return strings that has no prefix "app"' do
    t = Triple.new("apple", "app", "application")
    result = t.grep_v /^app/
    expect(result).to eq []
  end

  it 'return strings that does not match xxx-xxx-xxx, and x is digit' do
    t = Triple.new("555-888-999", "454-588-792", "123456789")
    result = t.grep_v /\d\d\d-\d\d\d-\d\d\d/
    expect(result).to eq (["123456789"])
  end

  context '#grep_v(patter) { |obj| block }' do
    it 'returns strings that has no digits' do
      t = Triple.new("aaa", "bbb", "100")
      result = t.grep_v(/\d+/) { |obj| obj.concat(" has no digits.") }
      expect(result).to eq ["aaa has no digits.", "bbb has no digits."]
    end
  end
end

describe '#group_by' do
  it 'returns a hash that has two group, one is group of even number, the other is group of odd number' do
    t = Triple.new(0, 1, 2)
    result = t.group_by { |e| e.odd? }
    expect(result).to eq ({ true => [1], false => [0, 2]})
  end

  context 'when block not given' do
    it 'return an enumerator for t' do
      t = Triple.new(1, 2, 3)
      result = t.group_by
      expect(result.to_a).to eq [1, 2, 3]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#include?' do
  it 'returns true if include 0' do
    t = Triple.new(0, 1, 2)
    result = t.include? 0
    expect(result).to eq true
  end

  it 'returns false since there is no -1' do
    t = Triple.new(0, 1, 2)
    result = t.include? -1
    expect(result).to eq false
  end
end

describe '#inject(initial, sym)' do
  it 'add up all elements' do
    t = Triple.new(0, 1, 2)
    result = t.inject(0, :+)
    expect(result).to eq 3
  end
end

describe '#inject(sym)' do
  it 'add up all elements' do
    t = Triple.new(0, 1, 2)
    result = t.inject(:+)
    expect(result).to eq 3
  end
end

describe '#inject(initial)' do
  it 'add up all elements' do
    t = Triple.new(0, 1, 2)
    result = t.inject(0) { |sum, e| sum + e }
    expect(result).to eq 3
  end
end

describe '#inject' do
  it 'add up all elements' do
    t = Triple.new(0, 1, 2)
    result = t.inject { |sum, e| sum + e }
    expect(result).to eq 3
  end
end

describe '#map' do
  it 'maps the number multiple by 2' do
    t = Triple.new(1, 2, 3)
    result = t.map { |n| n * 2 }
    expect(result).to eq ([2, 4, 6])
  end
end

describe '#max - without block' do
  it 'returns the biggest integer element' do
    t = Triple.new(10, 0, -100)
    result = t.max
    expect(result).to eq 10
  end
end

describe '#max - with block' do
  it 'returns the biggest integer element' do
    t = Triple.new(10, 0, -100)
    result = t.max { |a, b| a <=> b } 
    expect(result).to eq 10
  end
end

describe '#max(n) without block' do
  it 'returns the biggest integer element' do
    t = Triple.new(10, 0, -100)
    result = t.max(2)
    expect(result).to eq [10, 0]
  end
end

describe '#max(n) with block' do
  it 'returns the biggest integer element' do
    t = Triple.new(10, 0, -100)
    result = t.max(2) { |a, b| a <=> b }
    expect(result).to eq [10, 0]
  end
end

describe '#max_by' do
  it 'returns the string that has longest length' do
    t = Triple.new("ruby", "python", "haskell")
    result = t.max_by { |e| e.length }
    expect(result).to eq "haskell"
  end

  context 'when block not given' do
    it 'return an enumerator for t' do
      t = Triple.new(1, 2, 3)
      result = t.max_by
      expect(result.to_a).to eq [1, 2, 3]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#max_by(n)' do
  it 'returns the string that has longest length' do
    t = Triple.new("ruby", "python", "haskell")
    result = t.max_by(2) { |e| e.length }
    expect(result).to eq ["haskell", "python"]
  end

  context 'when block not given' do
    it 'return an enumerator for t' do
      t = Triple.new(1, 2, 3)
      result = t.max_by(2)
      expect(result.to_a).to eq [1, 2, 3]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#member?' do
  it 'returns true if member 0' do
    t = Triple.new(0, 1, 2)
    result = t.member? 0
    expect(result).to eq true
  end

  it 'returns false since there is no -1' do
    t = Triple.new(0, 1, 2)
    result = t.member? -1
    expect(result).to eq false
  end
end

describe '#min - without block' do
  it 'returns the biggest integer element' do
    t = Triple.new(10, 0, -100)
    result = t.min
    expect(result).to eq -100
  end
end

describe '#min - with block' do
  it 'returns the biggest integer element' do
    t = Triple.new(10, 0, -100)
    result = t.min { |a, b| a <=> b } 
    expect(result).to eq -100
  end
end

describe '#min(n) without block' do
  it 'returns the smallest integer element' do
    t = Triple.new(10, 0, -100)
    result = t.min(2)
    expect(result).to eq [-100, 0]
  end
end

describe '#min(n) with block' do
  it 'returns the smallest integer element' do
    t = Triple.new(10, 0, -100)
    result = t.min(2) { |a, b| a <=> b }
    expect(result).to eq [-100, 0]
  end
end

describe '#min_by' do
  it 'returns the string that has longest length' do
    t = Triple.new("ruby", "python", "haskell")
    result = t.min_by { |e| e.length }
    expect(result).to eq "ruby"
  end

  context 'when block not given' do
    it 'return an enumerator for t' do
      t = Triple.new(1, 2, 3)
      result = t.min_by
      expect(result.to_a).to eq [1, 2, 3]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#min_by(n)' do
  it 'returns the string that has longest length' do
    t = Triple.new("ruby", "python", "haskell")
    result = t.min_by(2) { |e| e.length }
    expect(result).to eq ["ruby", "python"]
  end

  context 'when block not given' do
    it 'return an enumerator for t' do
      t = Triple.new(1, 2, 3)
      result = t.min_by(2)
      expect(result.to_a).to eq [1, 2, 3]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#minmax' do
  it 'returns min and max of the integer in t' do
    t = Triple.new(1, 2, 3)
    result = t.minmax
    expect(result).to eq [1, 3]
  end
end

describe '#minmax' do
  it 'returns min and max of the integer in t' do
    t = Triple.new(1, 2, 3)
    result = t.minmax { |a, b| a <=> b }
    expect(result).to eq [1, 3]
  end
end

describe '#minmax_by' do
  it 'returns min and max of the integer in t' do
    t = Triple.new(1, 2, 3)
    result = t.minmax_by { |x| x }
    expect(result).to eq [1, 3]
  end

  it 'returns shortest and longest string in t' do
    t = Triple.new("abc", "bdasdf", "java")
    result = t.minmax_by { |x| x.length }
    expect(result).to eq ["abc", "bdasdf"]
  end

  context 'when block not given' do
    it 'return an enumerator for t' do
      t = Triple.new(1, 2, 3)
      result = t.minmax_by
      expect(result.to_a).to eq [1, 2, 3]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#none?' do
  it 'return true if none three elements in t > 0' do
    t = Triple.new(1, 2, 3)
    result = t.none? do |n|
      n > 0
    end
    expect(result).to eq false
  end

  it 'return true if none of the elements in t < 0' do
    t = Triple.new(1, 2, 3)
    result = t.none? { |n| n < 0 }
    expect(result).to eq true
  end

  context 'when block not given' do
    it 'return false if there are any elements that is not nil or false' do
      t = Triple.new(1, nil, false)
      result = t.none?
      expect(result).to eq false
    end

    it 'return true if there no elements that is not false or nil' do
      t = Triple.new(nil, nil, false)
      result = t.none?
      expect(result).to eq true
    end
  end
end

describe '#one?' do
  it 'returns true if there is exactly one string object' do
    t = Triple.new("java", 1, { 0 => 1 })
    result = t.one? { |e| e.instance_of?(String) }
    expect(result).to eq true
  end

  it 'returns false if there are no element is an array' do
    t = Triple.new("java", 1, { 0 => 1 })
    result = t.one? { |e| e.instance_of?(Array) }
    expect(result).to eq false
  end

  it 'returns false if there are more than one element is an Integer' do
    t = Triple.new(2, 1, { 0 => 1 })
    result = t.one? { |e| e.instance_of?(Integer) }
    expect(result).to eq false
  end
  
  context 'when block not given' do
    it 'returns true if there are exactly one element is true' do
      t = Triple.new(1, nil, false)
      result = t.one?
      expect(result).to eq true
    end
  end 
end

describe 'partition' do
  it 'seperate Integer from hash' do
    t = Triple.new(2, 1, { 0 => 1 })
    result = t.partition{ |e| e.instance_of?(Integer) }
    expect(result).to eq [[2, 1], [{ 0 => 1}]]
  end

  context 'when block not given' do
    it 'returns enumerator of t' do
      t = Triple.new(2, 1, { 0 => 1 })
      result = t.partition
      expect(result.to_a).to eq [2, 1, {0=>1}] 
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end 
end

describe '#reduce(initial, sym)' do
  it 'add up all elements' do
    t = Triple.new(0, 1, 2)
    result = t.reduce(0, :+)
    expect(result).to eq 3
  end
end

describe '#reduce(sym)' do
  it 'add up all elements' do
    t = Triple.new(0, 1, 2)
    result = t.reduce(:+)
    expect(result).to eq 3
  end
end

describe '#reduce(initial)' do
  it 'add up all elements' do
    t = Triple.new(0, 1, 2)
    result = t.reduce(0) { |sum, e| sum + e }
    expect(result).to eq 3
  end
end

describe '#reduce' do
  it 'add up all elements' do
    t = Triple.new(0, 1, 2)
    result = t.reduce { |sum, e| sum + e }
    expect(result).to eq 3
  end
end

describe '#reject' do
  it 'find all elements greater than 1' do
    t = Triple.new(1, 2, 3)
    result = t.reject do |n|
      n > 1
    end
    expect(result).to eq [1]
  end

  context 'when no block is given' do
    it 'returns the enumerator of t' do
      t = Triple.new("lua", "kotlin", "julia")
      result = t.reject
      expect(result.to_a).to eq ["lua", "kotlin", "julia"]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#reverse_each' do
  it 'build array from object t in reverse order' do
    ary = Array.new
    t = Triple.new("lua", "kotlin", "julia")
    result = t.reverse_each { |e| ary << e }
    expect(ary).to eq ["julia", "kotlin", "lua"]
  end

  context 'when no block is given' do
    it 'returns the enumerator of t' do
      t = Triple.new("lua", "kotlin", "julia")
      result = t.reverse_each
      expect(result.to_a).to eq ["julia", "kotlin", "lua"]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#select' do
  it 'find all elements greater than 1' do
    t = Triple.new(1, 2, 3)
    result = t.select do |n|
      n > 1
    end
    expect(result).to eq [2, 3]
  end

  context 'when no block is given' do
    it 'returns the enumerator of t' do
      t = Triple.new("lua", "kotlin", "julia")
      result = t.select
      expect(result.to_a).to eq ["lua", "kotlin", "julia"]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#slice_after' do
  it 'chunk until the elements is start with character a' do
    t = Triple.new("bird", "application", "app")
    result = t.slice_after /^a/
    expect(result.to_a).to eq [["bird", "application"], ["app"]]
    expect(result.instance_of?(Enumerator)).to eq true
  end

  it 'group all the elements' do
    t = Triple.new("bird", "car", "application")
    result = t.slice_after /^a/
    expect(result.to_a).to eq [["bird", "car", "application"]]
    expect(result.instance_of?(Enumerator)).to eq true
  end
end

describe '#slice_after { |elt| block }' do
  it 'seperate each elements' do
    t = Triple.new(1, 3, 5)
    result = t.slice_after { |e| e.odd? }
    expect(result.to_a).to eq [[1], [3], [5]]
    expect(result.instance_of?(Enumerator)).to eq true
  end 

  it 'group string that has length <= 3 and end with one string that has length > 3' do
    t = Triple.new("bird", "car", "application")
    result = t.slice_after { |e| e.length > 3 }
    expect(result.to_a).to eq [["bird"], ["car", "application"]]
    expect(result.instance_of?(Enumerator)).to eq true
  end
end

describe '#slice_before { |elt| block }' do
  it 'seperate each elements' do
    t = Triple.new(1, 3, 4)
    result = t.slice_before { |e| e.even? }
    expect(result.to_a).to eq [[1, 3], [4]]
    expect(result.instance_of?(Enumerator)).to eq true
  end 

  it 'group string that has length <= 3 and end with one string that has length > 3' do
    t = Triple.new("bird", "car", "application")
    result = t.slice_before { |e| e.length > 3 }
    expect(result.to_a).to eq [["bird", "car"], ["application"]]
    expect(result.instance_of?(Enumerator)).to eq true
  end
end

describe '#slice_when' do
  it 'slice when the length of the element is the same as the next element' do
    t = Triple.new([1, 3], [2, 4], [5])
    result = t.slice_when { |i, j| i.length == j.length }
    expect(result.to_a).to eq [[[1, 3]], [[2, 4], [5]]]
    expect(result.instance_of?(Enumerator)).to eq true
  end

  it 'slice when the length of the element is the same as the next element' do
    t = Triple.new([1], [2, 4], [5])
    result = t.slice_when { |i, j| i.length == j.length }
    expect(result.to_a).to eq [[[1], [2, 4], [5]]]
    expect(result.instance_of?(Enumerator)).to eq true
  end

  it 'chuck adjacent even or odd elements' do
    t = Triple.new(1, 3, 4)
    result = t.slice_when { |i, j| i.even? != j.even? }
    expect(result.to_a).to eq [[1, 3], [4]]
    expect(result.instance_of?(Enumerator)).to eq true
  end
end

describe '#sort' do
  it 'sort integers in t' do
    t = Triple.new(3, 4, 1)
    result = t.sort { |a, b| a <=> b }
    expect(result).to eq [1, 3, 4]
  end

  it 'sort by the length of elements (descending)' do
    t = Triple.new("bird", "car", "application")
    result = t.sort { |a, b| a.length <=> b.length }
    expect(result).to eq ["car", "bird", "application"]
  end

  it 'sort by the length of elements (ascending)' do
    t = Triple.new("bird", "car", "application")
    result = t.sort { |a, b| 0-a.length <=> 0-b.length }
    expect(result).to eq ["application", "bird", "car"]
  end
end

describe '#sort_by' do
  it 'sort_by integers in t' do
    t = Triple.new(3, 4, 1)
    result = t.sort_by { |a| a }
    expect(result).to eq [1, 3, 4]
  end

  it 'sort_by by the length of elements (descending)' do
    t = Triple.new("bird", "car", "application")
    result = t.sort_by { |a| a.length }
    expect(result).to eq ["car", "bird", "application"]
  end

  it 'sort_by by the length of elements (ascending)' do
    t = Triple.new("bird", "car", "application")
    result = t.sort_by { |a| 0-a.length }
    expect(result).to eq ["application", "bird", "car"]
  end
end

describe '#sum(init=0)' do
  it '(init=0): add up all the value of elements' do
    t = Triple.new(3, 4, 1)
    result = t.sum
    expect(result).to eq 8
  end

  it '(init=""): concat all the string' do
    t = Triple.new("bird", "car", "application")
    result = t.sum("")
    expect(result).to eq "birdcarapplication"
  end
end

describe '#sum with block' do
  it '(init=0): add up all the length of elements' do
    t = Triple.new("bird", "car", "application")
    result = t.sum { |e| e.length }
    expect(result).to eq 18
  end

  it '(init=100): add up all the length of elements and 100' do
    t = Triple.new("bird", "car", "application")
    result = t.sum(100) { |k| k.length }
    expect(result).to eq 118
  end
end

describe '#take' do
  it 'return first elements' do
    t = Triple.new("bird", "car", "application")
    result = t.take(1)
    expect(result).to eq ["bird"]
  end

  it 'return first 3 elements from t' do
    t = Triple.new("bird", "car", "application")
    result = t.take(3)
    expect(result).to eq ["bird", "car", "application"]
  end

  it 'do not return any elements' do
    t = Triple.new("bird", "car", "application")
    result = t.take(0)
    expect(result).to eq []
  end
end

describe '#take_while' do
  it 'return first group of elements that has length > 3' do
    t = Triple.new("bird", "car", "application")
    result = t.take_while { |e| e.length > 3 }
    expect(result).to eq ["bird"]
  end

  it 'return all elements that is even' do
    t = Triple.new(100, 2, 300)
    result = t.take_while { |e| e.even? }
    expect(result).to eq [100, 2, 300]
  end

  context 'when no block is given' do
    it 'returns the enumerator of t' do
      t = Triple.new("lua", "kotlin", "julia")
      result = t.take_while
      expect(result.to_a).to eq ["lua"]
      expect(result.instance_of?(Enumerator)).to eq true
    end
  end
end

describe '#to_a' do
  it 'return array' do
    t = Triple.new("lua", "kotlin", "julia")
    result = t.to_a
    expect(result).to eq ["lua", "kotlin", "julia"] 
  end
end

describe '#to_h' do
  it 'create each pair from array with size = 2' do
    t = Triple.new(["lua", "javascript"], ["kotlin", "scala"], ["c", "go"])
    result = t.to_h
    expect(result).to eq ({"lua"=>"javascript", "kotlin"=>"scala", "c"=>"go"})
  end

  it 'create each group of language to hash table' do
    t = Triple.new(["lua", "javascript"], ["kotlin", "scala"], ["c", "go"])
    result = t.each_with_index.to_h
    expect(result).to eq ({["lua", "javascript"]=>0, ["kotlin", "scala"]=>1, ["c", "go"]=>2})
  end
end

describe '#uniq' do
  it 'return all unique integers' do
    t = Triple.new(1, 2, 1)
    result = t.uniq
    expect(result).to eq [1, 2]
  end

  it 'return all uniq strings' do
    t = Triple.new("lua", "lua", "julia")
    result = t.uniq
    expect(result).to eq ["lua", "julia"]
  end
end

describe '#uniq with block' do
  it 'return unique negative and positive integers' do
    t = Triple.new(-1, 2, 1)
    result = t.uniq { |e| e > 0 }
    expect(result).to eq [-1, 2]
  end

  it 'return all uniq strings' do
    t = Triple.new("java", "luna", "julia")
    result = t.uniq { |e| e.length }
    expect(result).to eq ["java", "julia"]
  end
end

describe '#zip' do
  it 'interleaves [1, 2, 3] with [4, 5, 6]' do
    t = Triple.new(1, 2, 3)
    result = t.zip [4, 5, 6]
    expect(result).to eq [[1, 4], [2, 5], [3, 6]]
  end

  it 'interleaves different kinds of programming languages' do
    t1 = Triple.new("java", "luna", "julia")
    t2 = Triple.new("ruby", "python", "c++")
    t3 = Triple.new("c", "rust", "Ocaml")
    result = t1.zip(t2, t3) 
    expect(result).to eq [["java", "ruby", "c"], ["luna", "python", "rust"], ["julia", "c++", "Ocaml"]]
  end

  it 'insert nil if the size of any argument is less than enum#size' do
    t1 = Triple.new(4, 5, 6)
    t2 = Triple.new(1, 2)
    t3 = Triple.new(8)
    result = t1.zip(t2, t3)
    expect(result).to eq [[4, 1, 8], [5, 2, nil], [6, nil, nil]]
  end
end

describe '#zip with block' do
  it 'group same kinds of language' do
    result = {}
    t1 = Triple.new("java", "c", "haskell")
    t2 = Triple.new("kotlin", "rust", "ocaml")
    t1.zip(t2) { |a, b| result[a] = b }
    expect(result).to eq ({"java"=>"kotlin", "c"=>"rust", "haskell"=>"ocaml"})
  end
end
