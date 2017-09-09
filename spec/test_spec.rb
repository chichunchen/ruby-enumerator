require './lib/test'


describe 'Create a Triple object' do
  t = Triple.new(1, 2, 3)
    
  it 'maps the number multiple by 2' do
    result = t.map do |n|
      n * 2
    end
    expect(result).to eq ([2, 4, 6])
  end
end
