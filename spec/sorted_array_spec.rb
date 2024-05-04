# frozen_string_literal: true

RSpec.describe SortedContainers::SortedArray do
  describe "&" do
    it "should return the intersection of two arrays" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([3, 4, 5, 6, 7])
      expect((array1 & array2).to_a).to eq([3, 4, 5])
    end

    it "should return an empty array if there is no intersection" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([6, 7, 8, 9, 10])
      expect((array1 & array2).to_a).to eq([])
    end

    it "should return an empty array if one of the arrays is empty" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new
      expect((array1 & array2).to_a).to eq([])
    end

    it "should return an empty array if both arrays are empty" do
      array1 = SortedContainers::SortedArray.new
      array2 = SortedContainers::SortedArray.new
      expect((array1 & array2).to_a).to eq([])
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

    it "should multiply the array by 0" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array *= 0
      expect(array.to_a).to eq([])
    end
  end

  describe "+" do
    it "should concatenate two arrays" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([6, 7, 8, 9, 10])
      expect((array1 + array2).to_a).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    end

    it "should concatenate two arrays with duplicates and sort them" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([3, 4, 5, 6, 7])
      expect((array1 + array2).to_a).to eq([1, 2, 3, 3, 4, 4, 5, 5, 6, 7])
    end

    it "should concatenate an empty array with a non-empty array" do
      array1 = SortedContainers::SortedArray.new
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect((array1 + array2).to_a).to eq([1, 2, 3, 4, 5])
    end

    it "should concatenate a non-empty array with an empty array" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new
      expect((array1 + array2).to_a).to eq([1, 2, 3, 4, 5])
    end

    it "should concatenate two empty arrays" do
      array1 = SortedContainers::SortedArray.new
      array2 = SortedContainers::SortedArray.new
      expect((array1 + array2).to_a).to eq([])
    end
  end

  describe "-" do
    it "should return the difference of two arrays" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([3, 4, 5, 6, 7])
      expect((array1 - array2).to_a).to eq([1, 2])
    end

    it "should return an empty array if there is no difference" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect((array1 - array2).to_a).to eq([])
    end

    it "should return the difference of two arrays with duplicates" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([3, 4, 5, 6, 7])
      expect((array1 - array2).to_a).to eq([1, 2])
    end

    it "should return an empty array if the first array is empty" do
      array1 = SortedContainers::SortedArray.new
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect((array1 - array2).to_a).to eq([])
    end

    it "should return an empty array if the second array is empty" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new
      expect((array1 - array2).to_a).to eq([1, 2, 3, 4, 5])
    end

    it "should return an empty array if both arrays are empty" do
      array1 = SortedContainers::SortedArray.new
      array2 = SortedContainers::SortedArray.new
      expect((array1 - array2).to_a).to eq([])
    end

    it "should have an alias of difference" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([3, 4, 5, 6, 7])
      expect(array1.difference(array2).to_a).to eq([1, 2])
    end
  end

  describe "<=>" do
    it "should compare two arrays" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array1 <=> array2).to eq(0)
    end

    it "should compare two arrays with different values" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 6])
      expect(array1 <=> array2).to eq(-1)
    end

    it "should compare a shorter array to a longer array" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5, 6])
      expect(array1 <=> array2).to eq(-1)
    end

    it "should compare a longer array to a shorter array" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5, 6])
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array1 <=> array2).to eq(1)
    end

    it "should compare an empty array to a non-empty array" do
      array1 = SortedContainers::SortedArray.new
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array1 <=> array2).to eq(-1)
    end

    it "should compare a non-empty array to an empty array" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new
      expect(array1 <=> array2).to eq(1)
    end

    it "should compare two empty arrays" do
      array1 = SortedContainers::SortedArray.new
      array2 = SortedContainers::SortedArray.new
      expect(array1 <=> array2).to eq(0)
    end
  end

  describe "==" do
    it "should return true if two arrays are equal" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array1 == array2).to be true
    end

    it "should return false if two arrays are not equal" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 6])
      expect(array1 == array2).to be false
    end

    it "should return false if two arrays have different lengths" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5, 6])
      expect(array1 == array2).to be false
    end

    it "should return false if one array is empty and the other is not" do
      array1 = SortedContainers::SortedArray.new
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array1 == array2).to be false
    end

    it "should return true if two empty arrays are equal" do
      array1 = SortedContainers::SortedArray.new
      array2 = SortedContainers::SortedArray.new
      expect(array1 == array2).to be true
    end
  end

  describe "abbrev" do
    require "abbrev"

    it "should return the abbreviations of the array" do
      basic_array = %w[car cone]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.abbrev).to eq(basic_array.abbrev)
    end

    it "should only return abbreviations of strings that match the given pattern" do
      basic_array = %w[fast boat day]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.abbrev(/^.a/)).to eq(basic_array.abbrev(/^.a/))
    end

    it "should only return abbreviantions of strings that start with the given string" do
      basic_array = %w[fast boat day]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.abbrev("da")).to eq(basic_array.abbrev("da"))
    end

    it "should return an empty hash if there are no matches" do
      basic_array = %w[fast boat day]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.abbrev("zz")).to eq(basic_array.abbrev("zz"))
    end

    it "should return an empty hash if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.abbrev).to eq({})
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

    it "should return false if the array contains a falsy element" do
      array = SortedContainers::SortedArray.new([false, false])
      expect(array.all?).to be false
    end

    it "should return true if the array is empty" do
      array = SortedContainers::SortedArray.new
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

    it "should return true if the array contains a truthy element" do
      array = SortedContainers::SortedArray.new([true, true])
      expect(array.any?).to be true
    end

    it "should return false if the array contains only falsy elements" do
      array = SortedContainers::SortedArray.new([false, false])
      expect(array.any?).to be false
    end

    it "should return false if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.any?).to be false
    end
  end

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

    it "should handle arrays of arrays" do
      array = SortedContainers::SortedArray.new
      array.add([1, 2])
      array.add([3, 4])
      array.add([5, 6])
      expect(array.to_a).to eq([[1, 2], [3, 4], [5, 6]])
    end

    it "should return the array" do
      array = SortedContainers::SortedArray.new
      expect(array.add(5)).to eq(array)
    end

    it "a load factor of 10 should work" do
      array = SortedContainers::SortedArray.new([], load_factor: 10)
      (1..1000).to_a.shuffle.each do |i|
        array.add(i)
      end
      expect(array.to_a).to eq((1..1000).to_a)
    end
  end

  describe "assoc" do
    it "should return the first array whose first element is equal to the given key" do
      basic_array = [[1, 2], [3, 4], [5, 6]]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.assoc(3)).to eq(basic_array.assoc(3))
    end

    it "should return nil if no array has the given key" do
      basic_array = [[1, 2], [3, 4], [5, 6]]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.assoc(7)).to eq(basic_array.assoc(7))
    end

    it "should return nil if the array is empty" do
      basic_array = []
      array = SortedContainers::SortedArray.new
      expect(array.assoc(3)).to eq(basic_array.assoc(3))
    end
  end

  describe "at" do
    it "should return the value at the given index" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.at(2)).to eq(3)
    end

    it "should handle negative indices" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.at(-1)).to eq(5)
    end

    it "should return nil if negative index is out of range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.at(-6)).to be_nil
    end

    it "should raise exception when index is a range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect { array.at(1..3) }.to raise_error(TypeError)
    end
  end

  describe "bsearch" do
    it "should return the value at the given index" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.bsearch { |x| x >= 3 }).to eq(basic_array.bsearch { |x| x >= 3 })
    end

    it "should return nil if the value is not found" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.bsearch { |x| x >= 6 }).to eq(basic_array.bsearch { |x| x >= 6 })
    end

    it "should return nil if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.bsearch { |x| x >= 3 }).to be_nil
    end

    it "should work when load_factor is small enough for a split" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array, load_factor: 2)
      expect(array.bsearch { |x| x >= 3 }).to eq(basic_array.bsearch { |x| x >= 3 })
    end
  end

  describe "bsearch_index" do
    it "should return the index of the value" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.bsearch_index { |x| x >= 3 }).to eq(basic_array.bsearch_index { |x| x >= 3 })
    end

    it "should return nil if the value is not found" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.bsearch_index { |x| x >= 6 }).to eq(basic_array.bsearch_index { |x| x >= 6 })
    end

    it "should return nil if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.bsearch_index { |x| x >= 3 }).to be_nil
    end

    it "should work when load_factor is small enough for a split" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array, load_factor: 2)
      expect(array.bsearch_index { |x| x >= 3 }).to eq(basic_array.bsearch_index { |x| x >= 3 })
    end
  end

  describe "clear" do
    it "should remove all values from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.clear
      expect(array.to_a).to eq([])
    end

    it "should return the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.clear).to eq(array)
    end
  end

  describe "collect" do
    it "should return a new array with the results of running the block once for every element" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5]).collect { |i| i * 2 }
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5].collect { |i| i * 2 })
      expect(array1).to eq(array2)
    end

    it "should return an enumerator if no block is given" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.collect).to be_a(Enumerator)
    end

    it "should return an enumerator if no block is given and the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.collect).to be_a(Enumerator)
    end

    it "should return an enumerator that loops through the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.collect.to_a).to eq([1, 2, 3, 4, 5])
    end

    it "should keep array sorted after operation" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array = array.collect { |i| i * -1 }
      expect(array.to_a).to eq([-5, -4, -3, -2, -1])
    end

    it "map is an alias for collect" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5]).map { |i| i * 2 }
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5].collect { |i| i * 2 })
      expect(array1).to eq(array2)
    end
  end

  describe "collect!" do
    it "should return a new array with the results of running the block once for every element" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = array1.collect! { |i| i * 2 }
      expect(array1).to eq(array2)
    end

    it "should return an enumerator if no block is given" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.collect!).to be_a(Enumerator)
    end

    it "should return an enumerator if no block is given and the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.collect!).to be_a(Enumerator)
    end

    it "should return an enumerator that loops through the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.collect!.to_a).to eq([1, 2, 3, 4, 5])
    end

    it "should keep array sorted after operation" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.collect! { |i| i * -1 }
      expect(array.to_a).to eq([-5, -4, -3, -2, -1])
    end

    it "map! is an alias for collect!" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = array1.map! { |i| i * 2 }
      expect(array1).to eq(array2)
    end
  end

  describe "combination" do
    it "should return all combinations of the given length" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.combination(3).to_a).to eq(basic_array.combination(3).to_a)
    end

    it "should return an empty array if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.combination(3).to_a).to eq([])
    end

    it "should return an empty array if the given length is greater than the array length" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.combination(6).to_a).to eq(basic_array.combination(6).to_a)
    end

    it "should return an empty array if the given length is 0" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.combination(0).to_a).to eq(basic_array.combination(0).to_a)
    end

    it "should return an empty array if the given length is negative" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.combination(-1).to_a).to eq(basic_array.combination(-1).to_a)
    end

    it "should work when load_factor is small enough for a split" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array, load_factor: 2)
      expect(array.combination(3).to_a).to eq(basic_array.combination(3).to_a)
    end
  end

  describe "compact" do
    it "should remove nil values from the array" do
      # SortedArray can only contain comparable values
      # so the only way to have nil values is for all values to be nil
      array = SortedContainers::SortedArray.new([nil, nil, nil, nil, nil])
      expect(array.compact).to eq(SortedContainers::SortedArray.new)
    end

    it "should return the array if there are no nil values" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.compact).to eq(array)
    end

    it "should return the array if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.compact).to eq(array)
    end
  end

  describe "compact!" do
    it "should remove nil values from the array" do
      # SortedArray can only contain comparable values
      # so the only way to have nil values is for all values to be nil
      array = SortedContainers::SortedArray.new([nil, nil, nil, nil, nil])
      array.compact!
      expect(array).to eq(SortedContainers::SortedArray.new)
    end

    it "should return the array if there are no nil values" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.compact!
      expect(array).to eq(SortedContainers::SortedArray.new([1, 2, 3, 4, 5]))
    end

    it "should return the array if the array is empty" do
      array = SortedContainers::SortedArray.new
      array.compact!
      expect(array).to eq(SortedContainers::SortedArray.new)
    end
  end

  describe "concat" do
    it "should concatenate two arrays" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([6, 7, 8, 9, 10])
      array1.concat(array2)
      expect(array1.to_a).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    end

    it "should concatenate an empty array with a non-empty array" do
      array1 = SortedContainers::SortedArray.new
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array1.concat(array2)
      expect(array1.to_a).to eq([1, 2, 3, 4, 5])
    end

    it "should concatenate a non-empty array with an empty array" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new
      array1.concat(array2)
      expect(array1.to_a).to eq([1, 2, 3, 4, 5])
    end

    it "should concatenate two empty arrays" do
      array1 = SortedContainers::SortedArray.new
      array2 = SortedContainers::SortedArray.new
      array1.concat(array2)
      expect(array1.to_a).to eq([])
    end

    it "should concatenate 3 arrays" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3])
      array2 = SortedContainers::SortedArray.new([4, 5, 6])
      array3 = SortedContainers::SortedArray.new([7, 8, 9])
      array1.concat(array2, array3)
      expect(array1.to_a).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9])
    end

    it "should concatenate 6 arrays" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3])
      array2 = SortedContainers::SortedArray.new([4, 5, 6])
      array3 = SortedContainers::SortedArray.new([7, 8, 9])
      array4 = SortedContainers::SortedArray.new([10, 11, 12])
      array5 = SortedContainers::SortedArray.new([13, 14, 15])
      array6 = SortedContainers::SortedArray.new([16, 17, 18])
      array1.concat(array2, array3, array4, array5, array6)
      expect(array1.to_a).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18])
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

  describe "cycle" do
    it "should loop through the array the given number of times" do
      array = SortedContainers::SortedArray.new([1, 2, 3])
      expect(array.cycle(2).to_a).to eq([1, 2, 3, 1, 2, 3])
    end

    it "should loop through the array forever if no number is given" do
      array = SortedContainers::SortedArray.new([1, 2, 3])
      expect(array.cycle.take(7)).to eq([1, 2, 3, 1, 2, 3, 1])
    end

    it "should return an enumerator if no block is given" do
      array = SortedContainers::SortedArray.new([1, 2, 3])
      expect(array.cycle).to be_a(Enumerator)
    end

    it "should return an enumerator if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.cycle).to be_a(Enumerator)
    end
  end

  describe "delete" do
    it "should delete the value from the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.delete(3)
      expect(array.to_a).to eq([1, 2, 4, 5])
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

  describe "delete_if" do
    it "should delete elements that meet the given criterion" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.delete_if { |i| i > 3 }
      expect(array.to_a).to eq([1, 2, 3])
    end

    it "should work when array size is larger than load factor" do
      array = SortedContainers::SortedArray.new((1..1000).to_a, load_factor: 3)
      array.delete_if { |i| i > 500 }
      expect(array.size).to eq(500)
    end

    it "should return an enumerator if no block is given" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.delete_if).to be_a(Enumerator)
    end

    it "enumerator should loop through the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.delete_if.to_a).to eq([1, 2, 3, 4, 5])
    end
  end

  # rubocop:disable Lint/SingleArgumentDig

  describe "dig" do
    it "should return the value at the given index" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.dig(2)).to eq(3)
    end

    it "should return nil if the index is out of range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.dig(5)).to be_nil
    end

    it "should return nil if the array is empty" do
      array = SortedContainers::SortedArray.new
      expect(array.dig(2)).to be_nil
    end

    it "should return the value at the given index in an array of arrays" do
      array = SortedContainers::SortedArray.new([[1, 2], [3, 4], [5, 6]])
      expect(array.dig(1, 1)).to eq(4)
    end

    it "should return nil if the index is out of range in an array of arrays" do
      array = SortedContainers::SortedArray.new([[1, 2], [3, 4], [5, 6]])
      expect(array.dig(3, 1)).to be_nil
    end

    it "should return nil if the array is empty in an array of arrays" do
      array = SortedContainers::SortedArray.new
      expect(array.dig(1, 1)).to be_nil
    end

    it "should return raise an error if object doesn't respond to dig" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect { array.dig(1, 1) }.to raise_error(TypeError)
    end

    it "should query nested objects that respond to dig" do
      sortabable_class = Class.new do
        include Comparable
        attr_reader :value

        def initialize(value)
          @value = value
        end

        def <=>(other)
          @value[:sort] <=> other.value[:sort]
        end

        def dig(key)
          @value.dig(key)
        end
      end
      array = SortedContainers::SortedArray.new([
                                                  sortabable_class.new({ sort: 1, thing: { another: 1 } }),
                                                  sortabable_class.new({ sort: 2, thing: 2 }),
                                                  sortabable_class.new({ sort: 3, thing: 3 })
                                                ])
      expect(array.dig(0, :thing, :another)).to eq(1)
    end
  end

  # rubocop:enable Lint/SingleArgumentDig

  describe "drop" do
    it "should return the array without the first n elements" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.drop(2)).to eq(SortedContainers::SortedArray.new([3, 4, 5]))
    end

    it "should return an empty array if n is greater than the array length" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.drop(6)).to eq(SortedContainers::SortedArray.new)
    end

    it "should return the array if n is 0" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.drop(0)).to eq(SortedContainers::SortedArray.new([1, 2, 3, 4, 5]))
    end

    it "should raise an exception if n is negative" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect { array.drop(-1) }.to raise_error(ArgumentError)
    end
  end

  describe "drop_while" do
    it "should drop elements that meet the given criterion" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.drop_while { |i| i < 3 }).to eq(SortedContainers::SortedArray.new([3, 4, 5]))
    end

    it "should return an enumerator if no block is given" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.drop_while).to be_a(Enumerator)
    end

    it "should stop dropping elements when the block returns false, even if the criterion returns true again" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.drop_while { |i| [1, 5].include?(i) }).to eq(SortedContainers::SortedArray.new([2, 3, 4, 5]))
    end

    it "enumerator should loop through the array" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.drop_while.to_a).to eq(basic_array.drop_while.to_a)
    end

    it "should work when array size is larger than load factor" do
      array = SortedContainers::SortedArray.new((1..1000).to_a, load_factor: 3)
      expect(array.drop_while { |i| i < 500 }).to eq(SortedContainers::SortedArray.new((500..1000).to_a))
    end
  end

  describe "each" do
    it "should loop through the array" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      array.each_with_index do |value, index|
        expect(value).to eq(basic_array[index])
      end
    end

    it "should return an enumerator if no block is given" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.each).to be_a(Enumerator)
    end
  end

  describe "each_index" do
    it "should loop through the array" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      array.each_index do |index|
        expect(array[index]).to eq(basic_array[index])
      end
    end

    it "should return an enumerator if no block is given" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.each_index).to be_a(Enumerator)
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

  describe "eql?" do
    it "should return true if the arrays are equal" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array1.eql?(array2)).to be true
    end

    it "should return false if the arrays are not equal" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = SortedContainers::SortedArray.new([1, 2, 3, 4, 6])
      expect(array1.eql?(array2)).to be false
    end

    it "should return false if the arrays are not the same class" do
      array1 = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array2 = [1, 2, 3, 4, 5]
      expect(array1.eql?(array2)).to be false
    end
  end

  describe "fetch" do
    it "should return the value at the given index" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.fetch(2)).to eq(basic_array.fetch(2))
    end

    it "should return the default value if the index is out of range" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.fetch(5, 6)).to eq(basic_array.fetch(5, 6))
    end

    it "should return the value at the given index with a negative index" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.fetch(-1)).to eq(basic_array.fetch(-1))
    end

    it "should return the default value if the index is out of range with a negative index" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.fetch(-6, 6)).to eq(basic_array.fetch(-6, 6))
    end

    it "should raise an exception if the index is out of range and no default value is given" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect { array.fetch(5) }.to raise_error(IndexError)
    end

    it "should return the value at the given index with a block" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.fetch(2) { |i| i * 2 }).to eq(basic_array.fetch(2) { |i| i * 2 })
    end

    it "should return the default value if the index is out of range with a block" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.fetch(5, 6) { |i| i * 2 }).to eq(10)
    end

    it "should return the value at the given index with a negative index and block" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.fetch(-1) { |i| i * 2 }).to eq(basic_array.fetch(-1) { |i| i * 2 })
    end

    it "should return the default value if the index is out of range with a negative index and block" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      expect(array.fetch(-6, 6) { |i| i * 2 }).to eq(-12)
    end

    it "should run the given block with index if the index is out of range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.fetch(5) { |i| "This is the index #{i}" }).to eq("This is the index 5")
    end
  end

  describe "fill" do
    it "should fill the array with the given value" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.fill(6)
      expect(array.to_a).to eq([6, 6, 6, 6, 6])
    end

    it "should fill the array with the given value in the given range" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.fill(6, 1..3)
      expect(array.to_a).to eq([1, 5, 6, 6, 6])
    end

    it "should fill the array with the given value in the given range excluding the last value" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.fill(6, 1...3)
      expect(array.to_a).to eq([1, 4, 5, 6, 6])
    end

    it "should fill the array with the given value starting from the given index and length" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.fill(6, 1, 3)
      expect(array.to_a).to eq([1, 5, 6, 6, 6])
    end

    it "should fill the array with the given value starting from the given nagative index and length" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.fill(6, -1, 1)
      expect(array.to_a).to eq([1, 2, 3, 4, 6])
    end

    it "should fill array with given block" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.fill { |i| i * 2 }
      expect(array.to_a).to eq([0, 2, 4, 6, 8])
    end

    it "should fill array with given block in the given range" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      array.fill(1..3) { |i| i * 2 }
      basic_array.fill(1..3) { |i| i * 2 }
      expect(array.to_a).to eq(basic_array.sort)
    end

    it "should fill array with given block in the given range excluding the last value" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      array.fill(1...3) { |i| i * 2 }
      basic_array.fill(1...3) { |i| i * 2 }
      expect(array.to_a).to eq(basic_array.sort)
    end

    it "should fill array with given block starting from the given index and length" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      array.fill(1, 3) { |i| i * 2 }
      basic_array.fill(1, 3) { |i| i * 2 }
      expect(array.to_a).to eq(basic_array.sort)
    end

    it "should fill array with given block starting from the given negative index and length" do
      basic_array = [1, 2, 3, 4, 5]
      array = SortedContainers::SortedArray.new(basic_array)
      array.fill(-1, 1) { |i| i * 2 }
      basic_array.fill(-1, 1) { |i| i * 2 }
      expect(array.to_a).to eq(basic_array.sort)
    end
  end

  describe "select" do
    it "should return the values that meet the given criterion" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.select { |i| i > 3 }).to eq(SortedContainers::SortedArray.new([4, 5]))
    end

    it "should return an enumerator if no block is given" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.select).to be_a(Enumerator)
    end

    it "filter should be an alias for select" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.filter { |i| i > 3 }).to eq(SortedContainers::SortedArray.new([4, 5]))
    end
  end

  describe "select!" do
    it "should return the values that meet the given criterion and remove the rest" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.select! { |i| i > 3 }
      expect(array).to eq(SortedContainers::SortedArray.new([4, 5]))
    end

    it "should return empty SortedArray if no values meet the given criterion" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.select! { |i| i > 5 }
      expect(array).to eq(SortedContainers::SortedArray.new)
    end

    it "should return an enumerator if no block is given" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.select!).to be_a(Enumerator)
    end

    it "should create an enumerator that loop removes elements that meet the given criterion" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      enumerator = array.select!
      enumerator.each { |i| i > 3 }
      expect(array.to_a).to eq([4, 5])
    end

    it "filter! should be an alias for select!" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array.filter! { |i| i > 3 }
      expect(array).to eq(SortedContainers::SortedArray.new([4, 5]))
    end
  end

  describe "size" do
    it "should return the number of elements in the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.size).to eq(5)
      expect(array.length).to eq(5)
    end
  end

  describe "find_index" do
    it "should return the index of the first element that meets the given criterion" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.find_index { |i| i > 3 }).to eq(3)
    end

    it "should return nil if no elements meet the given criterion" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.find_index { |i| i > 5 }).to be_nil
    end

    it "should return the index of the first occurrence of the value" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5, 3])
      expect(array.find_index(3)).to eq(2)
    end

    it "should return nil if the value is not in the array" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.find_index(6)).to be_nil
    end

    it "index should be an alias for find_index" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      expect(array.index { |i| i > 3 }).to eq(3)
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

  describe "array[index] = value" do
    it "should set the value at the given index and resort" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array[2] = 6
      expect(array.to_a).to eq([1, 2, 4, 5, 6])
    end

    it "should set the value at the given index with a negative index and resort" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array[-1] = 6
      expect(array.to_a).to eq([1, 2, 3, 4, 6])
    end

    it "should set the values in the given range to a single value and resort" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array[1..3] = 6
      expect(array.to_a).to eq([1, 5, 6])
    end

    it "should set the values at a given index and length to a single value and resort" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array[1, 3] = 6
      expect(array.to_a).to eq([1, 5, 6])
    end

    it "should set the values at a given negative index and length to a single value and resort" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array[-1, 2] = 6
      expect(array.to_a).to eq([1, 2, 3, 4, 6])
    end

    it "should set the values in the given range and resort" do
      array = SortedContainers::SortedArray.new([1, 2, 3, 4, 5])
      array[1..3] = [6, 7, 8]
      expect(array.to_a).to eq([1, 5, 6, 7, 8])
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

  describe "sort!" do
    it "should resort the array in place if values have changed" do
      sortabable_class = Class.new do
        include Comparable
        attr_accessor :value

        def initialize(value)
          @value = value
        end

        def <=>(other)
          @value <=> other.value
        end
      end
      a = sortabable_class.new(1)
      b = sortabable_class.new(2)
      c = sortabable_class.new(3)
      array = SortedContainers::SortedArray.new([a, b, c])
      a.value = 4
      # Check that the array is not sorted
      expect(array.to_a).to eq([a, b, c])
      array.sort!
      expect(array.to_a).to eq([b, c, a])
    end
  end

  describe "sort" do
    it "should return a new array with the values sorted" do
      sortabable_class = Class.new do
        include Comparable
        attr_accessor :value

        def initialize(value)
          @value = value
        end

        def <=>(other)
          @value <=> other.value
        end
      end
      a = sortabable_class.new(1)
      b = sortabable_class.new(2)
      c = sortabable_class.new(3)
      array = SortedContainers::SortedArray.new([a, b, c])
      # Check that the array is not sorted
      a.value = 4
      expect(array.to_a).to eq([a, b, c])
      expect(array.sort).to eq(SortedContainers::SortedArray.new([b, c, a]))
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
