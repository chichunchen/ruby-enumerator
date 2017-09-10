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
	it 'python, ruby, and perl is dynamic language' do
		t = Triple.new('python', 'ruby', 'perl')
		result = t.collect_concat { |e| [e, "is dynamic language"] }
		expect(result).to eq ["python", "is dynamic language", "ruby", "is dynamic language", "perl", "is dynamic language"]
	end

	it '451, 452, 453, 455, and 456 are CS courses' do
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
	t = Triple.new("lua", "kotlin", "julia")
	it 'return the first element that have lenght > 3' do
		result = t.detect { |e| e.length > 3 }
		expect(result).to eq "kotlin"
	end

	context 'when no block is given' do
		it 'returns the enumerator of t' do
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

describe '#map' do
  it 'maps the number multiple by 2' do
    t = Triple.new(1, 2, 3)
    result = t.map do |n|
      n * 2
    end
    expect(result).to eq ([2, 4, 6])
  end
end

describe '#find' do
  it 'find an item given an predicate' do
    t = Triple.new(1, 2, 3)
    result = t.find do |n|
      n == 2
    end
    expect(result).to eq 2
  end
end
