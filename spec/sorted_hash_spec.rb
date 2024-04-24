# frozen_string_literal: true

RSpec.describe SortedContainers::SortedHash do

  describe "hash[key]" do
    it "should return the value for the given key" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      expect(dict[:b]).to eq(2)
    end
  end

  describe "keys" do
    it "should return the keys in the hash" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      expect(dict.keys).to eq(%i[a b c])
    end
  end

  describe "values" do
    it "should return the values in the hash" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      expect(dict.values).to eq([1, 2, 3])
    end
  end

  describe "pop" do
    it "should remove the last key-value pair from the hash" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      pair = dict.pop
      expect(pair).to eq([:c, 3])
      expect(dict.keys).to eq(%i[a b])
    end

    it "should return nil if the hash is empty" do
      dict = SortedContainers::SortedHash.new
      pair = dict.pop
      expect(pair).to be_nil
    end
  end

  describe "shift" do
    it "should remove the first key-value pair from the hash" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      pair = dict.shift
      expect(pair).to eq([:a, 1])
      expect(dict.keys).to eq(%i[b c])
    end

    it "should return nil if the hash is empty" do
      dict = SortedContainers::SortedHash.new
      pair = dict.shift
      expect(pair).to be_nil
    end
  end

  describe "first" do
    it "should return the first key-value pair in the hash" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      pair = dict.first
      expect(pair).to eq([:a, 1])
    end

    it "should return nil if the hash is empty" do
      dict = SortedContainers::SortedHash.new
      pair = dict.first
      expect(pair).to be_nil
    end
  end

  describe "last" do
    it "should return the last key-value pair in the hash" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      pair = dict.last
      expect(pair).to eq([:c, 3])
    end

    it "should return nil if the hash is empty" do
      dict = SortedContainers::SortedHash.new
      pair = dict.last
      expect(pair).to be_nil
    end
  end

  describe "map" do
    it "should iterate over each key-value pair in the hash" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      pairs = dict.map { |key, value| [key, value] }
      expect(pairs).to eq([[:a, 1], [:b, 2], [:c, 3]])
    end
  end

  describe "delete" do
    it "should remove the value for the given key" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      dict.delete(:b)
      expect(dict.keys).to eq(%i[a c])
    end
  end

  describe "delete_at" do
    it "should remove the key-value pair at the given index" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      pair = dict.delete_at(1)
      expect(pair).to eq([:b, 2])
      expect(dict.keys).to eq(%i[a c])
    end

    it "should return nil if the index is out of bounds" do
      dict = SortedContainers::SortedHash.new
      pair = dict.delete_at(0)
      expect(pair).to be_nil
    end

    it "should handle negative indices" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      pair = dict.delete_at(-1)
      expect(pair).to eq([:c, 3])
      expect(dict.keys).to eq(%i[a b])
    end

    it "should return nil if negative index is out of bounds" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      pair = dict.delete_at(-50)
      expect(pair).to be_nil
    end
  end
end
