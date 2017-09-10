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

    context '#count() - when no argument if given' do
      it 'return the size of the enum array: 3' do
        expect(t.count()).to eq 3
      end
    end
  end
end

describe '#cycle' do
  t = Triple.new("ruby", "c", "java")

  it 'concat ruby, c and, java for 3 times to a string, and return nil' do
    str = String.new
    result = t.cycle(3) { |e| str.concat(e) }
    expect(str).to eq "rubycjavarubycjavarubycjava"
    expect(result).to eq nil
  end

  it 'do nothing if the argument is non-positive' do
    str = String.new
    result = t.cycle(-3) { |e| str.concat(e) }
    expect(str).to eq ""
    expect(result).to eq nil
  end

  it 'enter infinite loop if argument is nil' do
    str = String.new
    result = Object.new
    thread = Thread.new do
      result = t.cycle(nil) { |e| str.concat(e) }
    end 
    # expect(str).to eq ""
    thread.kill
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
    ary = Array.new
    t = Triple.new(1, ["abc", "def"], "abcdef")
    result = t.each_entry { |e| ary << e }
    expect(ary).to eq [1, ["abc", "def"], "abcdef"]
    expect(result.instance_of?(Triple)).to eq true
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
  it 'returns the biggest integer element' do
    t = Triple.new(10, 0, -100)
    result = t.min(2)
    expect(result).to eq [-100, 0]
  end
end

describe '#min(n) with block' do
  it 'returns the biggest integer element' do
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
    end
  end
end
