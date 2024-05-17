# frozen_string_literal: true

RSpec.describe SortedContainers::SortedSet do
  describe "[]" do
    it "should return a new set with the given elements" do
      set = SortedContainers::SortedSet[1, 2, 3, 4, 5]
      expect(set.to_a).to eq([1, 2, 3, 4, 5])
    end
  end

  describe "&" do
    it "should return a new set with the intersection of the two sets" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([3, 4, 5, 6, 7])
      set3 = set1 & set2
      expect(set3.to_a).to eq([3, 4, 5])
    end
  end

  describe "+" do
    it "should return a new set with the union of the two sets" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([3, 4, 5, 6, 7])
      set3 = set1 + set2
      expect(set3.to_a).to eq([1, 2, 3, 4, 5, 6, 7])
    end
  end

  describe "-" do
    it "should return a new set with the difference of the two sets" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([3, 4, 5, 6, 7])
      set3 = set1 - set2
      expect(set3.to_a).to eq([1, 2])
    end
  end

  describe "<" do
    it "should return true if the set is a proper subset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      expect(set1 < set2).to be true
    end

    it "should return false if the set is not a proper subset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set1 < set2).to be false
    end
  end

  describe "<<" do
    it "should add a value to the set" do
      set = SortedContainers::SortedSet.new
      set << 1
      set << 2
      set << 3
      expect(set.to_a).to eq([1, 2, 3])
    end
  end

  describe "<=" do
    it "should return true if the set is a subset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      expect(set1 <= set2).to be true
    end

    it "should return true if the set is equal to the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set1 <= set2).to be true
    end

    it "should return false if the set is not a subset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4])
      expect(set1 <= set2).to be false
    end
  end

  describe "<=>" do
    it "should return 0 if the sets are equal" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set1 <=> set2).to eq(0)
    end

    it "should return -1 if the set is a proper subset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      expect(set1 <=> set2).to eq(-1)
    end

    it "should return 1 if the set is a proper superset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set1 <=> set2).to eq(1)
    end
  end

  describe "==" do
    it "should return true if the sets are equal" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set1 == set2).to be true
    end

    it "should return false if the sets are not equal" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      expect(set1 == set2).to be false
    end
  end

  # rubocop:disable Style/CaseEquality
  describe "===" do
    it "should return true if element is in the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set === 3).to be true
    end

    it "should return false if element is not in the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set === 300).to be false
    end
  end
  # rubocop:enable Style/CaseEquality

  describe ">" do
    it "should return true if the set is a proper superset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set1 > set2).to be true
    end

    it "should return false if the set is not a proper superset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      expect(set1 > set2).to be false
    end
  end

  describe ">=" do
    it "should return true if the set is a superset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set1 >= set2).to be true
    end

    it "should return true if the set is equal to the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set1 >= set2).to be true
    end

    it "should return false if the set is not a superset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      expect(set1 >= set2).to be false
    end
  end

  describe "^" do
    it "should return a new set with the symmetric difference of the two sets" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([3, 4, 5, 6, 7])
      set3 = set1 ^ set2
      expect(set3.to_a).to eq([1, 2, 6, 7])
    end
  end

  describe "add" do
    it "should add a value to the set in order" do
      set = SortedContainers::SortedSet.new
      set.add(1)
      set.add(3)
      set.add(2)
      expect(set.to_a).to eq([1, 2, 3])
    end
  end

  describe "add?" do
    it "should return self if the value was added" do
      set = SortedContainers::SortedSet.new
      result = set.add?(1)
      expect(result).to eq(set)
    end

    it "should return false if the value was not added" do
      set = SortedContainers::SortedSet.new([1, 2, 3])
      result = set.add?(3)
      expect(result).to be false
    end
  end

  describe "classify" do
    it "should return a hash with the keys being the result of the block and the values being an array of items" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      hash = set.classify { |item| item % 2 }
      expect(hash).to eq({ 0 => Set.new([2, 4]), 1 => Set.new([1, 3, 5]) })
    end
  end

  describe "clear" do
    it "should remove all items from the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set.clear
      expect(set.to_a).to eq([])
    end
  end

  describe "collect!" do
    it "should return an enumerator if no block is given" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      enumerator = set.collect!
      expect(enumerator).to be_a(Enumerator)
    end

    it "should return self after yielding each item to the block" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      result = set.collect! { |item| item + 1 }
      expect(result.to_a).to eq([2, 3, 4, 5, 6])
    end
  end

  describe "delete" do
    it "should remove the value from the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set.delete(3)
      expect(set.to_a).to eq([1, 2, 4, 5])
    end

    it "should return self" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      result = set.delete(3)
      expect(result).to eq(set)
    end

    it "should return self if the value was not found" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      result = set.delete(300)
      expect(result).to eq(set)
    end
  end

  describe "delete?" do
    it "should return self if the value was removed" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      result = set.delete?(3)
      expect(result).to eq(set)
    end

    it "should return nil if the value was not removed" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      result = set.delete?(300)
      expect(result).to be_nil
    end
  end

  describe "delete_if" do
    it "should remove items from the set that match the block" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set.delete_if(&:even?)
      expect(set.to_a).to eq([1, 3, 5])
    end

    it "should return self" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      result = set.delete_if(&:even?)
      expect(result).to eq(set)
    end

    it "should return an enumerator if no block is given" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      enumerator = set.delete_if
      expect(enumerator).to be_a(Enumerator)
    end
  end

  describe "difference" do
    it "should return a new set with the difference of the two sets" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([3, 4, 5, 6, 7])
      set3 = set1.difference(set2)
      expect(set3.to_a).to eq([1, 2])
    end
  end

  describe "disjoint?" do
    it "should return true if the sets have no elements in common" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3])
      set2 = SortedContainers::SortedSet.new([4, 5, 6])
      expect(set1.disjoint?(set2)).to be true
    end

    it "should return false if the sets have elements in common" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3])
      set2 = SortedContainers::SortedSet.new([3, 4, 5])
      expect(set1.disjoint?(set2)).to be false
    end
  end

  describe "divide" do
    it "should return a set of sets split by the given method" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      sets = set.divide(&:even?)
      expect(sets).to eq(Set[Set[2, 4], Set[1, 3, 5]])
    end
  end

  describe "each" do
    it "should iterate over each item in the set in order" do
      set = SortedContainers::SortedSet.new([1, 2, 5, 4, 3, 1])
      items = set.map { |item| item }
      expect(items).to eq([1, 2, 3, 4, 5])
    end

    it "should return self" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      result = set.each { |item| item + 1 }
      expect(result).to eq(set)
    end

    it "should return an enumerator if no block is given" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      enumerator = set.each
      expect(enumerator).to be_a(Enumerator)
    end
  end

  describe "empty?" do
    it "should return true if the set is empty" do
      set = SortedContainers::SortedSet.new
      expect(set.empty?).to be true
    end

    it "should return false if the set is not empty" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set.empty?).to be false
    end
  end

  describe "filter!" do
    it "should remove items from the set that do not match the block" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set.filter!(&:even?)
      expect(set.to_a).to eq([2, 4])
    end

    it "should return an enumerator if no block is given" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      enumerator = set.filter!
      expect(enumerator).to be_a(Enumerator)
    end
  end

  describe "flatten" do
    it "should return a new set with the elements flattened" do
      set = SortedContainers::SortedSet.new([[1, 2], [3, 4], [5, 6]])
      result = set.flatten
      expect(result.to_a).to eq([1, 2, 3, 4, 5, 6])
    end
  end

  describe "flatten!" do
    it "should return a new set with the elements flattened" do
      set = SortedContainers::SortedSet.new([[1, 2], [3, 4], [5, 6]])
      set.flatten!
      expect(set.to_a).to eq([1, 2, 3, 4, 5, 6])
    end
  end

  describe "include?" do
    it "should return true if the value is in the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set.include?(3)).to be true
    end

    it "should return false if the value is not in the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set.include?(300)).to be false
    end
  end

  describe "inspect" do
    it "should return a string representation of the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set.inspect).to eq("#<SortedSet: {1, 2, 3, 4, 5}>")
    end
  end

  describe "intersect?" do
    it "should return true if the sets have elements in common" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3])
      set2 = SortedContainers::SortedSet.new([3, 4, 5])
      expect(set1.intersect?(set2)).to be true
    end

    it "should return false if the sets have no elements in common" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3])
      set2 = SortedContainers::SortedSet.new([4, 5, 6])
      expect(set1.intersect?(set2)).to be false
    end
  end

  describe "intersection" do
    it "should return a new set with the intersection of the two sets" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([3, 4, 5, 6, 7])
      set3 = set1.intersection(set2)
      expect(set3.to_a).to eq([3, 4, 5])
    end
  end

  describe "join" do
    it "should return a string with the elements joined by the given separator" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 5, 4, 1])
      result = set.join(", ")
      expect(result).to eq("1, 2, 3, 4, 5")
    end
  end

  describe "keep_if" do
    it "should remove items from the set that do not match the block" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set.keep_if(&:even?)
      expect(set.to_a).to eq([2, 4])
    end

    it "should return an enumerator if no block is given" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      enumerator = set.keep_if
      expect(enumerator).to be_a(Enumerator)
    end
  end

  describe "length" do
    it "should return the number of elements in the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 1])
      expect(set.length).to eq(5)
    end
  end

  describe "map!" do
    it "should return self after yielding each item to the block" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      result = set.map! { |item| item + 1 }
      expect(result.to_a).to eq([2, 3, 4, 5, 6])
    end
  end

  describe "member?" do
    it "should return true if the value is in the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set.member?(3)).to be true
    end

    it "should return false if the value is not in the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set.member?(300)).to be false
    end
  end

  describe "merge" do
    it "should add the elements of the other set to the set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([3, 4, 5, 6, 7])
      set1.merge(set2)
      expect(set1.to_a).to eq([1, 2, 3, 4, 5, 6, 7])
    end
  end

  describe "proper_subset?" do
    it "should return true if the set is a proper subset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      expect(set1.proper_subset?(set2)).to be true
    end

    it "should return false if the set is not a proper subset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set1.proper_subset?(set2)).to be false
    end
  end

  describe "proper_superset?" do
    it "should return true if the set is a proper superset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set1.proper_superset?(set2)).to be true
    end

    it "should return false if the set is not a proper superset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      expect(set1.proper_superset?(set2)).to be false
    end
  end

  describe "reject!" do
    it "should remove items from the set that match the block" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set.reject!(&:even?)
      expect(set.to_a).to eq([1, 3, 5])
    end

    it "should return an enumerator if no block is given" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      enumerator = set.reject!
      expect(enumerator).to be_a(Enumerator)
    end
  end

  describe "replace" do
    it "should replace the elements of the set with the elements of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([3, 4, 5, 6, 7])
      set1.replace(set2)
      expect(set1.to_a).to eq([3, 4, 5, 6, 7])
    end
  end

  describe "reset" do
    it "should reindex the set if the elements have been modified" do
      sortable_class = Class.new do
        include Comparable
        attr_accessor :value

        def initialize(value)
          @value = value
        end

        def <=>(other)
          @value <=> other.value
        end
      end

      set = SortedContainers::SortedSet.new([sortable_class.new(1), sortable_class.new(2), sortable_class.new(3)])
      set.each { |item| item.value = -item.value }
      expect(set.to_a.map(&:value)).to eq([-1, -2, -3])
      set.reset
      expect(set.to_a.map(&:value)).to eq([-3, -2, -1])
    end
  end

  describe "select!" do
    it "should remove items from the set that do not match the block" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set.select!(&:even?)
      expect(set.to_a).to eq([2, 4])
    end

    it "should return an enumerator if no block is given" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      enumerator = set.select!
      expect(enumerator).to be_a(Enumerator)
    end
  end

  describe "size" do
    it "should return the number of elements in the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set.size).to eq(5)
    end
  end

  describe "subset?" do
    it "should return true if the set is a subset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      expect(set1.subset?(set2)).to be true
    end

    it "should return false if the set is not a subset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4])
      expect(set1.subset?(set2)).to be false
    end
  end

  describe "superset?" do
    it "should return true if the set is a superset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set1.superset?(set2)).to be true
    end

    it "should return false if the set is not a superset of the other set" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5, 6, 7])
      expect(set1.superset?(set2)).to be false
    end
  end

  describe "to_a" do
    it "sorts items after being added in an arbitrary order" do
      set = SortedContainers::SortedSet.new
      set.add(5)
      set.add(2)
      set.add(7)
      set.add(1)
      set.add(4)
      expect(set.to_a).to eq([1, 2, 4, 5, 7])
    end
  end

  describe "to_s" do
    it "should return a string representation of the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set.to_s).to eq("#<SortedSet: {1, 2, 3, 4, 5}>")
    end
  end

  describe "to_set" do
    it "should return a new set with the elements of the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      result = set.to_set
      expect(result).to be_a(Set)
      expect(result.to_a).to eq([1, 2, 3, 4, 5])
    end
  end

  describe "union" do
    it "should return a new set with the union of the two sets" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([3, 4, 5, 6, 7])
      set3 = set1.union(set2)
      expect(set3.to_a).to eq([1, 2, 3, 4, 5, 6, 7])
    end
  end

  describe "|" do
    it "should return a new set with the union of the two sets" do
      set1 = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      set2 = SortedContainers::SortedSet.new([3, 4, 5, 6, 7])
      set3 = set1 | set2
      expect(set3.to_a).to eq([1, 2, 3, 4, 5, 6, 7])
    end
  end

  describe "bisect_left" do
    it "should return the index where the value should be inserted" do
      array = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(array.bisect_left(3)).to eq(2)
    end

    it "should return the the length of the array if the value is greater than all values" do
      array = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(array.bisect_left(6)).to eq(5)
    end

    it "should return 0 if the value is less than all values" do
      array = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(array.bisect_left(0)).to eq(0)
    end
  end

  describe "bisect_right" do
    it "should return the index where the value should be inserted" do
      array = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(array.bisect_right(3)).to eq(3)
    end

    it "should return the the length of the array if the value is greater than all values" do
      array = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(array.bisect_right(6)).to eq(5)
    end

    it "should return 0 if the value is less than all values" do
      array = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(array.bisect_right(0)).to eq(0)
    end
  end

  describe "delete_at" do
    it "should remove item at the given index" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      value = set.delete_at(2)
      expect(value).to eq(3)
      expect(set.to_a).to eq([1, 2, 4, 5])
    end

    it "should return nil if index is out of range" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      value = set.delete_at(200)
      expect(value).to be_nil
      expect(set.to_a).to eq([1, 2, 3, 4, 5])
    end

    it "should handle negative indices" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      value = set.delete_at(-3)
      expect(value).to eq(3)
      expect(set.to_a).to eq([1, 2, 4, 5])
    end

    it "should handle return nil if negative index is out of range" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      value = set.delete_at(-300)
      expect(value).to be_nil
      expect(set.to_a).to eq([1, 2, 3, 4, 5])
    end
  end

  describe "set[index]" do
    it "should return the value indexed by the given index" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set[2]).to eq(3)
    end
  end

  describe "first" do
    it "should return the first element in the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set.first).to eq(1)
    end
  end

  describe "last" do
    it "should return the last element in the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      expect(set.last).to eq(5)
    end
  end

  describe "map" do
    it "should iterate over each item in the set" do
      set = SortedContainers::SortedSet.new([1, 2, 3, 4, 5])
      items = set.map { |item| item + 1 }
      expect(items).to eq([2, 3, 4, 5, 6])
    end
  end
end
