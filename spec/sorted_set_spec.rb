# frozen_string_literal: true

RSpec.describe SortedContainers::SortedSet do
  it "sorts items after being added in an arbitrary order" do
    set = SortedContainers::SortedSet.new
    set.add(5)
    set.add(2)
    set.add(7)
    set.add(1)
    set.add(4)
    expect(set.to_a).to eq([1, 2, 4, 5, 7])
  end

  it "should return true if the value is in the set" do
    set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
    expect(set.include?(3)).to be true
  end

  it "should remove the value from the set" do
    set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
    set.delete(3)
    expect(set.to_a).to eq([1, 2, 4, 5])
  end

  it "should return the value indexed by the given index" do
    set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
    expect(set[2]).to eq(3)
  end

  it "should return the number of elements in the set" do
    set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
    expect(set.size).to eq(5)
  end

  it "should iterate over each item in the set" do
    set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
    items = set.map { |item| item }
    expect(items).to eq([1, 2, 3, 4, 5])
  end

  it "should sort hundreds of values" do
    set = SortedContainers::SortedSet.new
    (1..1000).to_a.shuffle.each do |i|
      set.add(i)
    end
    expect(set.to_a).to eq((1..1000).to_a)
  end
end
