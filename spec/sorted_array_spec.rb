# frozen_string_literal: true

RSpec.describe SortedContainers::SortedArray do
  describe "add" do
    it "sorts items after being added in an arbitrary order" do
      array = SortedContainers::SortedArray.new
      array.add(5)
      array.add(2)
      array.add(7)
      array.add(1)
      array.add(4)
      expect(array.to_a).to eq([1, 2, 4, 5, 7])
    end

    it "should sort hundreds of values" do
      array = SortedContainers::SortedArray.new
      (1..1000).to_a.shuffle.each do |i|
        array.add(i)
      end
      expect(array.to_a).to eq((1..1000).to_a)
    end

    it "a load factor of 3 should work" do
      array = SortedContainers::SortedArray.new([], load_factor: 3)
      (1..1000).to_a.shuffle.each do |i|
        array.add(i)
      end
      expect(array.to_a).to eq((1..1000).to_a)
    end

    it "a load factor of 10 should work" do
      array = SortedContainers::SortedArray.new([], load_factor: 10)
      (1..1000).to_a.shuffle.each do |i|
        array.add(i)
      end
      expect(array.to_a).to eq((1..1000).to_a)
    end
  end

  describe "load_factor" do
    it "should set the load factor to the provided value" do
      array = SortedContainers::SortedArray.new([], load_factor: 100)
      expect(array.instance_variable_get(:@load_factor)).to eq(100)
    end
  end

  describe "include?" do
    it "should return true if the value is in the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.include?(3)).to be true
    end

    it "should return false if the value is not in the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.include?(6)).to be false
    end
  end

  describe "empty?" do
    it "should return true if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.empty?).to be true
    end

    it "should return false if the array is not empty" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.empty?).to be false
    end
  end

  describe "update" do
    it "should update the array with the given values" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.update([6, 7, 8, 9, 10])
      expect(array.to_a).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    end
  end

  describe "first" do
    it "should return the first value in the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.first).to eq(1)
    end

    it "should return nil if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.first).to be_nil
    end
  end

  describe "last" do
    it "should return the last value in the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.last).to eq(5)
    end

    it "should return nil if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.last).to be_nil
    end
  end

  describe "all?" do
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
  end

  describe "any?" do
    it "should return true if any elements meet a given criterion" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.any? { |i| i > 4 }).to be true
    end

    it "should return false if no elements meet a given criterion" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.any? { |i| i > 5 }).to be false
    end
  end

  describe "delete" do
    it "should delete the value from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.delete(3)
      expect(array.to_a).to eq([1, 2, 4, 5])
    end
  end

  describe "count" do
    it "should return the number of occurrences of the value in the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5, 3])
      expect(array.count(3)).to eq(2)
    end

    it "should return 0 if the value is not in the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.count(6)).to eq(0)
    end

    it "should return the number of elements that meet the given criterion" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.count { |i| i > 3 }).to eq(2)
    end

    # Test count with lots of values
    it "should return the number of occurrences of the value in the array with lots of values" do
      array = SortedContainers::SortedArray.new((1..1000).to_a * 1000)
      expect(array.count(3)).to eq(1000)
    end
  end

  describe "clear" do
    it "should remove all values from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.clear
      expect(array.to_a).to eq([])
    end
  end

  describe "size" do
    it "should return the number of elements in the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.size).to eq(5)
      expect(array.length).to eq(5)
    end
  end

  describe "array[index]" do
    it "should return the value at the given index" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[2]).to eq(3)
    end

    it "should handle negative indices" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[-1]).to eq(5)
    end

    it "should return nil if negative index is out of range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[-6]).to be_nil
    end

    it "should return nil if the index is out of range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[5]).to be_nil
    end

    it "should return the values in the given range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[1..3]).to eq([2, 3, 4])
    end

    it "should return empty array if the range is out of range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[5..6]).to eq([])
    end

    it "should return the values in the given range excluding the last value" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[1...3]).to eq([2, 3])
    end

    it "should return values starting from the given index and continuing for the given length" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[1, 3]).to eq([2, 3, 4])
    end

    it "should return nil if the index is out of range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[5, 1]).to be_nil
    end

    it "should return values in the arithmetic sequence two dots" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[(1..).step(2)].to_a).to eq([2, 4])
    end

    it "should return values in the arithmetic sequence three dots" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[(1...).step(2)].to_a).to eq([2, 4])
    end

    it "should return values in the arithmetic sequence with a range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array[(1..3).step(2)].to_a).to eq([2, 4])
    end

    it "should return the values in the given range with a negative index" do
      array = SortedContainers::SortedArray.new([1, 3, 2])
      expect(array[-1..2]).to eq([3])
    end

    it "should return the values in the given range with a negative index and length" do
      array = SortedContainers::SortedArray.new([1, 3, 2])
      expect(array[-1, 2]).to eq([3])
    end
  end

  describe "slice!" do
    it "should return the values in the given range and remove them from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.slice!(1..3)).to eq([2, 3, 4])
      expect(array.to_a).to eq([1, 5])
    end

    it "should return the values in the given range excluding the last value and remove them from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.slice!(1...3)).to eq([2, 3])
      expect(array.to_a).to eq([1, 4, 5])
    end

    it "should return values starting from the given index and \
        continuing for the given length and remove them from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.slice!(1, 3)).to eq([2, 3, 4])
      expect(array.to_a).to eq([1, 5])
    end

    it "should return values in the arithmetic sequence two dots and remove them from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.slice!((1..).step(2)).to_a).to eq([2, 4])
      expect(array.to_a).to eq([1, 3, 5])
    end

    it "should return values in the arithmetic sequence three dots and remove them from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.slice!((1...).step(2)).to_a).to eq([2, 4])
      expect(array.to_a).to eq([1, 3, 5])
    end

    it "should return values in the arithmetic sequence with a range and remove them from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.slice!((1..3).step(2)).to_a).to eq([2, 4])
      expect(array.to_a).to eq([1, 3, 5])
    end

    it "should return the values in the given range with a negative index and remove them from the array" do
      array = SortedContainers::SortedArray.new([1, 3, 2])
      expect(array.slice!(-1..2)).to eq([3])
      expect(array.to_a).to eq([1, 2])
    end

    it "should return the values in the given range with a negative index and length and remove them from the array" do
      array = SortedContainers::SortedArray.new([1, 3, 2])
      expect(array.slice!(-1, 2)).to eq([3])
      expect(array.to_a).to eq([1, 2])
    end

    it "should return the values in the given range with a negative index and length and remove them from the array" do
      array = SortedContainers::SortedArray.new([1, 3, 2])
      expect(array.slice!(-1, 2)).to eq([3])
      expect(array.to_a).to eq([1, 2])
    end
  end

  describe "delete_at" do
    it "should delete the value at the given index" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.delete_at(2)
      expect(array.to_a).to eq([1, 2, 4, 5])
    end

    it "should return the value at the given index" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.delete_at(2)).to eq(3)
    end

    it "should return nil if the index is out of range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.delete_at(5)).to be_nil
    end

    it "should work when array size is larger than load factor" do
      array = SortedContainers::SortedArray.new((1..1000).to_a, load_factor: 3)
      array.delete_at(500)
      expect(array.size).to eq(999)
    end

    it "should update the index after deleting an element" do
      array = SortedContainers::SortedArray.new((1..1000).to_a, load_factor: 3)
      array.delete_at(50)
      expect(array[50]).to eq(52)
    end

    it "should update the index after deleting an element from small array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5], load_factor: 1)
      array.delete_at(2)
      expect(array[2]).to eq(4)
    end
  end

  describe "bisect_left" do
    it "should return the index where the value should be inserted" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.bisect_left(3)).to eq(2)
    end

    it "should return the the length of the array if the value is greater than all values" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.bisect_left(6)).to eq(5)
    end

    it "should return 0 if the value is less than all values" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.bisect_left(0)).to eq(0)
    end
  end

  describe "bisect_right" do
    it "should return the index where the value should be inserted" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.bisect_right(3)).to eq(3)
    end

    it "should return the the length of the array if the value is greater than all values" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.bisect_right(6)).to eq(5)
    end

    it "should return 0 if the value is less than all values" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.bisect_right(0)).to eq(0)
    end
  end

  describe "*" do
    it "should multiply the array by the given number" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array *= 2
      expect(array.to_a).to eq([1, 1, 2, 2, 3, 3, 4, 4, 5, 5])
    end

    it "should multiply the array by the given large number" do
      array = SortedContainers::SortedArray.new((1..1000).to_a)
      array *= 2
      expect(array.to_a).to eq(((1..1000).to_a * 2).sort)
    end
  end

  describe "min" do
    it "should return the minimum value in the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.min).to eq(1)
    end

    it "should return nil for the minimum value in an empty array" do
      array = SortedContainers::SortedArray.new
      expect(array.min).to be_nil
    end
  end

  describe "max" do
    it "should return the maximum value in the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.max).to eq(5)
    end

    it "should return nil for the maximum value in an empty array" do
      array = SortedContainers::SortedArray.new
      expect(array.max).to be_nil
    end
  end

  describe "pop" do
    it "should pop the last value from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.pop).to eq(5)
      expect(array.to_a).to eq([1, 2, 3, 4])
    end

    it "should return nil if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.pop).to be_nil
    end
  end

  describe "shift" do
    it "should shift the first value from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.shift).to eq(1)
      expect(array.to_a).to eq([2, 3, 4, 5])
    end

    it "should return nil if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.shift).to be_nil
    end
  end

  describe "stress test", :stress do
    it "should handle arrays with 10_000_000 values" do
      array = SortedContainers::SortedArray.new
      (1..10_000_000).to_a.shuffle.each do |i|
        array.add(i)
      end
      expect(array.size).to eq(10_000_000)
      expect(array.include?(5_000_000)).to be true
      expect(array.include?(10_000_001)).to be false
      expect(array.count(5_000_000)).to eq(1)
      expect(array.bisect_left(5_000_000)).to eq(5_000_000 - 1)
      expect(array.bisect_right(5_000_000)).to eq(5_000_000)
      array.delete(5_000_000)
      expect(array.size).to eq(9_999_999)
      expect(array.include?(5_000_000)).to be false
      expect(array.count(5_000_000)).to eq(0)
      expect(array.bisect_left(5_000_000)).to eq(5_000_000 - 1)
      expect(array.bisect_right(5_000_000)).to eq(5_000_000 - 1)
      array.update([5_000_000])
      expect(array.size).to eq(10_000_000)
      expect(array.include?(5_000_000)).to be true
      expect(array.count(5_000_000)).to eq(1)
      expect(array.bisect_left(5_000_000)).to eq(5_000_000 - 1)
      expect(array.bisect_right(5_000_000)).to eq(5_000_000)
    end
  end
end
