# frozen_string_literal: true

RSpec.describe SortedContainers::SortedArray do
  it "sorts items after being added in an arbitrary order" do
    array = SortedContainers::SortedArray.new
    array.add(5)
    array.add(2)
    array.add(7)
    array.add(1)
    array.add(4)
    expect(array.to_a).to eq([1, 2, 4, 5, 7])
  end

  it "should set the load factor to the provided value" do
    array = SortedContainers::SortedArray.new([], load_factor: 100)
    expect(array.instance_variable_get(:@load_factor)).to eq(100)
  end

  it "should return true if the value is in the array" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.include?(3)).to be true
  end

  it "should return false if the value is not in the array" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.include?(6)).to be false
  end

  it "should return true if the array is empty" do
    array = SortedContainers::SortedArray.new
    expect(array.empty?).to be true
  end

  it "should return false if the array is not empty" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.empty?).to be false
  end

  it "should return the first value in the array" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.first).to eq(1)
  end

  it "should return the last value in the array" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.last).to eq(5)
  end

  it "should return true if all elements meet a given criterion" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.all? { |i| i > 0 }).to be true
  end

  it "should return false if all elements do not meet a given criterion" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.all? { |i| i > 1 }).to be false
  end

  it "should return true if the array contains only truthy elements" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.all?).to be true
  end

  it "should return true if any elements meet a given criterion" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.any? { |i| i > 4 }).to be true
  end

  it "should return false if no elements meet a given criterion" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.any? { |i| i > 5 }).to be false
  end

  it "should delete the value from the array" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    array.delete(3)
    expect(array.to_a).to eq([1, 2, 4, 5])
  end

  it "should remove all values from the array" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    array.clear
    expect(array.to_a).to eq([])
  end

  it "should return the number of elements in the array" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.size).to eq(5)
  end

  it "should return the value at the given index" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array[2]).to eq(3)
  end

  it "should raise an error if the index is out of range" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect { array[5] }.to raise_error("Index out of range")
  end

  it "should delete the value at the given index" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    array.delete_at(2)
    expect(array.to_a).to eq([1, 2, 4, 5])
  end

  it "should raise an error if the index is out of range" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect { array.delete_at(5) }.to raise_error("Index out of range")
  end

  it "should pop the last value from the array" do
    array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
    expect(array.pop).to eq(5)
    expect(array.to_a).to eq([1, 2, 3, 4])
  end

  it "should sort hundreds of values" do
    array = SortedContainers::SortedArray.new
    (1..1000).to_a.shuffle.each do |i|
      array.add(i)
    end
    expect(array.to_a).to eq((1..1000).to_a)
  end
end
