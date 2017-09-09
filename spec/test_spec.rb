require './lib/test'

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
