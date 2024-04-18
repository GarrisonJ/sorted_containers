# frozen_string_literal: true

RSpec.describe SortedContainers::SortedList do
  it "sorts items after being added in an arbitrary order" do
    list = SortedContainers::SortedList.new
    list.add(5)
    list.add(2)
    list.add(7)
    list.add(1)
    list.add(4)
    expect(list.to_a).to eq([1, 2, 4, 5, 7])
  end

  it "should set the load factor to the provided value" do
    list = SortedContainers::SortedList.new([], load_factor: 100)
    expect(list.instance_variable_get(:@load_factor)).to eq(100)
  end

  it "should return true if the value is in the list" do
    list = SortedContainers::SortedList.new([1, 2, 3, 4, 5])
    expect(list.contains(3)).to be true
  end

  it "should delete the value from the list" do
    list = SortedContainers::SortedList.new([1, 2, 3, 4, 5])
    list.delete(3)
    expect(list.to_a).to eq([1, 2, 4, 5])
  end

  it "should remove all values from the list" do
    list = SortedContainers::SortedList.new([1, 2, 3, 4, 5])
    list.clear
    expect(list.to_a).to eq([])
  end

  it "should return the number of elements in the list" do
    list = SortedContainers::SortedList.new([1, 2, 3, 4, 5])
    expect(list.size).to eq(5)
  end

  it "should return the value at the given index" do
    list = SortedContainers::SortedList.new([1, 2, 3, 4, 5])
    expect(list[2]).to eq(3)
  end

  it "should raise an error if the index is out of range" do
    list = SortedContainers::SortedList.new([1, 2, 3, 4, 5])
    expect { list[5] }.to raise_error("Index out of range")
  end

  it "should delete the value at the given index" do
    list = SortedContainers::SortedList.new([1, 2, 3, 4, 5])
    list.delete_at(2)
    expect(list.to_a).to eq([1, 2, 4, 5])
  end

  it "should raise an error if the index is out of range" do
    list = SortedContainers::SortedList.new([1, 2, 3, 4, 5])
    expect { list.delete_at(5) }.to raise_error("Index out of range")
  end

  it "should pop the last value from the list" do
    list = SortedContainers::SortedList.new([1, 2, 3, 4, 5])
    expect(list.pop).to eq(5)
    expect(list.to_a).to eq([1, 2, 3, 4])
  end

  it "should sort hundreds of values" do
    list = SortedContainers::SortedList.new
    (1..1000).to_a.shuffle.each do |i|
      list.add(i)
    end
    expect(list.to_a).to eq((1..1000).to_a)
  end
end