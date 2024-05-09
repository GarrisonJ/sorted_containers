# frozen_string_literal: true

RSpec.describe Array do
  describe "#to_sorted_set" do
    it "converts the array to a SortedSet" do
      array = [3, 1, 2]
      sorted_set = array.to_sorted_set
      expect(sorted_set).to be_a(SortedContainers::SortedSet)
      expect(sorted_set.to_a).to eq([1, 2, 3])
    end
  end

  describe "#to_sorted_h" do
    it "converts the array to a SortedHash" do
      array = [["a", 1], ["b", 2], ["c", 3]]
      sorted_hash = array.to_sorted_h
      expect(sorted_hash).to be_a(SortedContainers::SortedHash)
      expect(sorted_hash.to_a).to eq([["a", 1], ["b", 2], ["c", 3]])
    end
  end

  describe "#to_sorted_a" do
    it "converts the array to a SortedArray" do
      array = [3, 1, 2]
      sorted_array = array.to_sorted_a
      expect(sorted_array).to be_a(SortedContainers::SortedArray)
      expect(sorted_array.to_a).to eq([1, 2, 3])
    end
  end
end

RSpec.describe Hash do
  describe "#to_sorted_h" do
    it "converts the hash to a SortedHash" do
      hash = { "a" => 1, "b" => 2, "c" => 3 }
      sorted_hash = hash.to_sorted_h
      expect(sorted_hash).to be_a(SortedContainers::SortedHash)
      expect(sorted_hash.to_a).to eq([["a", 1], ["b", 2], ["c", 3]])
    end
  end
end

RSpec.describe Set do
  describe "#to_sorted_set" do
    it "converts the set to a SortedSet" do
      set = Set.new([3, 1, 2])
      sorted_set = set.to_sorted_set
      expect(sorted_set).to be_a(SortedContainers::SortedSet)
      expect(sorted_set.to_a).to eq([1, 2, 3])
    end
  end
end
