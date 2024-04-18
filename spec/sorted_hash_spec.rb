# frozen_string_literal: true

RSpec.describe SortedContainers::SortedHash do
  it "should return the value for the given key" do
    dict = SortedContainers::SortedHash.new
    dict[:a] = 1
    dict[:b] = 2
    dict[:c] = 3
    expect(dict[:b]).to eq(2)
  end

  it "should return the keys in the hash" do
    dict = SortedContainers::SortedHash.new
    dict[:a] = 1
    dict[:b] = 2
    dict[:c] = 3
    expect(dict.keys).to eq(%i[a b c])
  end

  it "should return the values in the hash" do
    dict = SortedContainers::SortedHash.new
    dict[:a] = 1
    dict[:b] = 2
    dict[:c] = 3
    expect(dict.values).to eq([1, 2, 3])
  end

  it "should iterate over each key-value pair in the hash" do
    dict = SortedContainers::SortedHash.new
    dict[:a] = 1
    dict[:b] = 2
    dict[:c] = 3
    pairs = dict.map { |key, value| [key, value] }
    expect(pairs).to eq([[:a, 1], [:b, 2], [:c, 3]])
  end

  it "should remove the value for the given key" do
    dict = SortedContainers::SortedHash.new
    dict[:a] = 1
    dict[:b] = 2
    dict[:c] = 3
    dict.delete(:b)
    expect(dict.keys).to eq(%i[a c])
  end
end
