# frozen_string_literal: true

RSpec.describe SortedContainers::SortedHash do
  describe "[]" do
    it "should create a new instance of the SortedHash class" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.keys).to eq(%i[a b c])
    end

    it "should throw an error if the number of arguments is odd" do
      expect { SortedContainers::SortedHash[:a, 1, :b, 2, :c] }.to raise_error(ArgumentError)
    end
  end

  describe "<" do
    it "should return true if the first hash is less than the second hash" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict1 < dict2).to be_truthy
    end

    it "should return false if the first hash is not less than the second hash" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2]
      expect(dict1 < dict2).to be_falsey
    end
  end

  describe "<=" do
    it "should return true if the first hash is less than or equal to the second hash" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict1 <= dict2).to be_truthy
    end

    it "should return true if the first hash is equal to the second hash" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2]
      expect(dict1 <= dict2).to be_truthy
    end

    it "should return false if the first hash is not less than or equal to the second hash" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2]
      expect(dict1 <= dict2).to be_falsey
    end
  end

  describe "==" do
    it "should return true if the two hashes are equal" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2]
      expect(dict1 == dict2).to be_truthy
    end

    it "should return false if the two hashes are not equal" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict1 == dict2).to be_falsey
    end
  end

  describe ">" do
    it "should return true if the first hash is greater than the second hash" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2]
      expect(dict1 > dict2).to be_truthy
    end

    it "should return false if the first hash is not greater than the second hash" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict1 > dict2).to be_falsey
    end
  end

  describe ">=" do
    it "should return true if the first hash is greater than or equal to the second hash" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2]
      expect(dict1 >= dict2).to be_truthy
    end

    it "should return true if the first hash is equal to the second hash" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2]
      expect(dict1 >= dict2).to be_truthy
    end

    it "should return false if the first hash is not greater than or equal to the second hash" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict1 >= dict2).to be_falsey
    end
  end

  describe "hash[key]" do
    it "should return the value for the given key" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      expect(dict[:b]).to eq(2)
    end
  end

  describe "any?" do
    it "should return true if any key-value pair satisfies the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.any? { |_key, value| value > 2 }
      expect(result).to be_truthy
    end

    it "should return false if no key-value pair satisfies the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.any? { |_key, value| value > 3 }
      expect(result).to be_falsey
    end
  end

  describe "assoc" do
    it "should return the key-value pair for the given key" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      pair = dict.assoc(:b)
      expect(pair).to eq([:b, 2])
    end

    it "should return nil if the key is not found" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      pair = dict.assoc(:d)
      expect(pair).to be_nil
    end
  end

  describe "clear" do
    it "should remove all key-value pairs from the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict.clear
      expect(dict.keys).to eq([])
    end
  end

  describe "compact" do
    it "should remove all key-value pairs with nil values from the hash" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = nil
      dict[:c] = 3
      expect(dict.compact.keys).to eq(%i[a c])
    end
  end

  describe "compact!" do
    it "should remove all key-value pairs with nil values from the hash" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = nil
      dict[:c] = 3
      dict.compact!
      expect(dict.keys).to eq(%i[a c])
    end

    it "should return nil if no key-value pairs are removed" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      result = dict.compact!
      expect(result).to be_nil
    end

    it "should return the hash if key-value pairs are removed" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = nil
      dict[:c] = 3
      expect(dict.compact!.keys).to eq(%i[a c])
    end
  end

  describe "decontruct_keys" do
    it "should return a hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.deconstruct_keys(nil)
      expect(result).to eq({ a: 1, b: 2, c: 3 })
    end
  end

  describe "default" do
    it "should return the default value for the hash" do
      dict = SortedContainers::SortedHash.new
      dict.default = 0
      expect(dict.default).to eq(0)
    end

    it "should return nil if no default value is set" do
      dict = SortedContainers::SortedHash.new
      expect(dict.default).to be_nil
    end

    it "should return the default set in the constructor" do
      dict = SortedContainers::SortedHash.new(0)
      expect(dict.default).to eq(0)
    end
  end

  describe "default_proc" do
    it "should return the default proc for the hash" do
      dict = SortedContainers::SortedHash.new
      dict.default_proc = proc { |hash, key| hash[key] = key.upcase }
      expect(dict.default_proc).to be_a(Proc)
    end

    it "should return nil if no default proc is set" do
      dict = SortedContainers::SortedHash.new
      expect(dict.default_proc).to be_nil
    end

    it "should return the default proc set in the constructor" do
      dict = SortedContainers::SortedHash.new { |hash, key| hash[key] = key.upcase }
      expect(dict.default_proc).to be_a(Proc)
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

  describe "delete_if" do
    it "should remove all key-value pairs that satisfy the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict.delete_if { |_key, value| value > 2 }
      expect(dict.keys).to eq(%i[a b])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.delete_if
      expect(result).to be_a(Enumerator)
    end

    it "should return the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.delete_if { |_key, value| value > 2 }).to eq(dict)
    end
  end

  describe "dig" do
    it "should return the value for the given key" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict[:b]).to eq(2)
    end

    it "should return nil if the key is not found" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict[:d]).to be_nil
    end

    it "should work with nested hashes" do
      dict = SortedContainers::SortedHash[:a, 1, :b, SortedContainers::SortedHash[:c, 3]]
      expect(dict.dig(:b, :c)).to eq(3)
    end
  end

  describe "each" do
    it "should iterate over each key-value pair in the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      pairs = dict.map { |key, value| [key, value] }
      expect(pairs).to eq([[:a, 1], [:b, 2], [:c, 3]])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.each
      expect(result).to be_a(Enumerator)
    end

    it "should return the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.each { |key, value| [key, value] }).to eq(dict)
    end
  end

  describe "each_key" do
    it "should iterate over each key in the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      keys = []
      dict.each_key { |key| keys << key }
      expect(keys).to eq(%i[a b c])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.each_key
      expect(result).to be_a(Enumerator)
    end

    it "should return the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.each_key { |key| key }).to eq(dict)
    end
  end

  describe "each_pair" do
    it "should iterate over each key-value pair in the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      pairs = []
      dict.each_pair { |key, value| pairs << [key, value] }
      expect(pairs).to eq([[:a, 1], [:b, 2], [:c, 3]])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.each_pair
      expect(result).to be_a(Enumerator)
    end

    it "should return the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.each_pair { |key, value| [key, value] }).to eq(dict)
    end
  end

  describe "each_value" do
    it "should iterate over each value in the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      values = []
      dict.each_value { |value| values << value }
      expect(values).to eq([1, 2, 3])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.each_value
      expect(result).to be_a(Enumerator)
    end

    it "should return the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.each_value { |value| value }).to eq(dict)
    end
  end

  describe "empty?" do
    it "should return true if the hash is empty" do
      dict = SortedContainers::SortedHash.new
      expect(dict.empty?).to be_truthy
    end

    it "should return false if the hash is not empty" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.empty?).to be_falsey
    end
  end

  describe "eql?" do
    it "should return true if the two hashes are equal" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2]
      expect(dict1.eql?(dict2)).to be_truthy
    end

    it "should return false if the two hashes are not equal" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict1.eql?(dict2)).to be_falsey
    end
  end

  describe "except" do
    it "should return a new hash with the given keys removed" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.except(:b)
      expect(result.keys).to eq(%i[a c])
    end

    it "should return a new hash with the given keys removed" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.except(:b, :c)
      expect(result.keys).to eq(%i[a])
    end
  end

  describe "fetch" do
    it "should return the value for the given key" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.fetch(:b)).to eq(2)
    end

    it "should raise an error if the key is not found" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect { dict.fetch(:d) }.to raise_error(KeyError)
    end

    it "should return the default value if the key is not found" do
      dict = SortedContainers::SortedHash.new
      expect(dict.fetch(:d, 4)).to eq(4)
    end

    it "should call the block if the key is not found" do
      dict = SortedContainers::SortedHash.new
      expect(dict.fetch(:d, &:upcase)).to eq(:D)
    end
  end

  describe "fetch_values" do
    it "should return the values for the given keys" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.fetch_values(:a, :b)
      expect(result).to eq([1, 2])
    end

    it "should call the block if the key is not found" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.fetch_values(:a, :d, &:upcase)
      expect(result).to eq([1, :D])
    end
  end

  describe "filter" do
    it "should return a new hash with the key-value pairs that satisfy the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.filter { |_key, value| value > 2 }
      expect(result.keys).to eq([:c])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.filter
      expect(result).to be_a(Enumerator)
    end
  end

  describe "filter!" do
    it "should remove all key-value pairs that do not satisfy the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict.filter! { |_key, value| value > 2 }
      expect(dict.keys).to eq([:c])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.filter!
      expect(result).to be_a(Enumerator)
    end

    it "should return the hash if key-value pairs are removed" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.filter! { |_key, value| value > 2 }).to eq(dict)
    end

    it "should return nil if no key-value pairs are removed" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.filter! { |_key, value| value <= 3 }
      expect(result).to be_nil
    end
  end

  describe "flatten" do
    it "should return an array of keys and values" do
      dict = SortedContainers::SortedHash[:a, 1, :b, [:c, 3]]
      result = dict.flatten
      expect(result).to eq([:a, 1, :b, [:c, 3]])
    end

    it "should return an array with nested arrays flatten if the level is specified" do
      dict = SortedContainers::SortedHash[:a, 1, :b, [:c, 3]]
      result = dict.flatten(2)
      expect(result).to eq([:a, 1, :b, :c, 3])
    end

    it "should return array with all levels flattened if level is negative" do
      dict = SortedContainers::SortedHash[:a, 1, :b, [[:c, 3]]]
      result = dict.flatten(-3)
      expect(result).to eq([:a, 1, :b, :c, 3])
    end
  end

  describe "has_key?" do
    it "should return true if the hash contains the given key" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.key?(:b)).to be_truthy
    end

    it "should return false if the hash does not contain the given key" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.key?(:d)).to be_falsey
    end
  end

  describe "has_value?" do
    it "should return true if the hash contains the given value" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.value?(2)).to be_truthy
    end

    it "should return false if the hash does not contain the given value" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.value?(4)).to be_falsey
    end
  end

  describe "hash" do
    it "should return the hash code for the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.hash).to be_a(Integer)
    end

    it "should return the same hash code for two equal hashes" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 2]
      expect(dict1.hash).to eq(dict2.hash)
    end

    it "should return a different hash code for two unequal hashes" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:a, 1, :b, 3]
      expect(dict1.hash).not_to eq(dict2.hash)
    end
  end

  describe "include?" do
    it "should return true if the hash contains the given key" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.include?(:b)).to be_truthy
    end

    it "should return false if the hash does not contain the given key" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.include?(:d)).to be_falsey
    end
  end

  describe "inspect" do
    it "should return a string representation of the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.inspect).to eq("SortedHash({a: 1, b: 2, c: 3})")
    end
  end

  describe "invert" do
    it "should return a new hash with the keys and values swapped" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.invert
      expect(result.keys).to eq([1, 2, 3])
      expect(result.values).to eq(%i[a b c])
    end

    it "should overwrite duplicate keys with the last value" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 2]
      result = dict.invert
      expect(result.keys).to eq([1, 2])
      expect(result.values).to eq(%i[a c])
    end

    it "should throw an error if the values are not sortable" do
      dict = SortedContainers::SortedHash[:a, 1, :b, [1, 2], :c, 3]
      expect { dict.invert }.to raise_error(ArgumentError)
    end
  end

  describe "keep_if" do
    it "should remove all key-value pairs that do not satisfy the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict.keep_if { |_key, value| value > 2 }
      expect(dict.keys).to eq([:c])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.keep_if
      expect(result).to be_a(Enumerator)
    end

    it "should return the hash if key-value pairs are removed" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.keep_if { |_key, value| value > 2 }.keys).to eq([:c])
    end
  end

  describe "key" do
    it "should return the key for the given value" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.key(2)).to eq(:b)
    end

    it "should return nil if the value is not found" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.key(4)).to be_nil
    end

    it "should return the first key for the given value" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.key(2)).to eq(:b)
    end
  end

  describe "key?" do
    it "should return true if the hash contains the given key" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.key?(:b)).to be_truthy
    end

    it "should return false if the hash does not contain the given key" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.key?(:d)).to be_falsey
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

  describe "length" do
    it "should return the number of key-value pairs in the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.length).to eq(3)
    end
  end

  describe "member?" do
    it "should return true if the hash contains the given key" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.member?(:b)).to be_truthy
    end

    it "should return false if the hash does not contain the given key" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.member?(:d)).to be_falsey
    end
  end

  describe "merge" do
    it "should return a copy self if no arguments are given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2]
      result = dict.merge
      expect(result.keys).to eq(%i[a b])
    end

    it "should return a new hash with the given hash merged in" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:b, 3, :c, 4]
      result = dict1.merge(dict2)
      expect(result.keys).to eq(%i[a b c])
    end

    it "should return a new hash with the given hash merged in" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:b, 3, :c, 4]
      result = dict1.merge(dict2) { |_key, old_value, new_value| old_value + new_value }
      expect(result[:b]).to eq(5)
    end

    it "should merge multiple hashes" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:b, 3, :c, 4]
      dict3 = SortedContainers::SortedHash[:c, 5, :d, 6]
      result = dict1.merge(dict2, dict3)
      expect(result.keys).to eq(%i[a b c d])
    end
  end

  describe "merge!" do
    it "should merge the given hash into self" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:b, 3, :c, 4]
      dict1.merge!(dict2)
      expect(dict1.keys).to eq(%i[a b c])
    end

    it "should merge the given hash into self" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:b, 3, :c, 4]
      dict1.merge!(dict2) { |_key, old_value, new_value| old_value + new_value }
      expect(dict1[:b]).to eq(5)
    end

    it "should merge multiple hashes" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:b, 3, :c, 4]
      dict3 = SortedContainers::SortedHash[:c, 5, :d, 6]
      dict1.merge!(dict2, dict3)
      expect(dict1.keys).to eq(%i[a b c d])
    end
  end

  describe "rassoc" do
    it "should return the key-value pair for the given value" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      pair = dict.rassoc(2)
      expect(pair).to eq([:b, 2])
    end

    it "should return nil if the value is not found" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      pair = dict.rassoc(4)
      expect(pair).to be_nil
    end
  end

  describe "rehash" do
    it "should rehash the hash" do
      dict = SortedContainers::SortedHash.new
      a = [1, 2, 3]
      b = [4, 5, 6]
      dict[a] = "a"
      dict[b] = "b"
      a[0] = 7
      expect(dict[[7, 2, 3]]).to be_nil
      dict.rehash
      expect(dict[[7, 2, 3]]).to eq("a")
    end

    it "should return self" do
      dict = SortedContainers::SortedHash.new
      expect(dict.rehash).to eq(dict)
    end

    it "should resort the hash" do
      dict = SortedContainers::SortedHash.new
      a = [1, 2, 3]
      b = [4, 5, 6]
      dict[a] = "a"
      dict[b] = "b"
      a[0] = 7
      expect(dict.keys).to eq([a, b])
      dict.rehash
      expect(dict.keys).to eq([b, a])
    end
  end

  describe "reject" do
    it "should return a new hash with the key-value pairs that do not satisfy the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.reject { |_key, value| value > 2 }
      expect(result.keys).to eq(%i[a b])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.reject
      expect(result).to be_a(Enumerator)
    end
  end

  describe "reject!" do
    it "should remove all key-value pairs that satisfy the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict.reject! { |_key, value| value > 2 }
      expect(dict.keys).to eq(%i[a b])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.reject!
      expect(result).to be_a(Enumerator)
    end

    it "should return the hash if key-value pairs are removed" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.reject! { |_key, value| value > 2 }.keys).to eq(%i[a b])
    end

    it "should return nil if no key-value pairs are removed" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.reject! { |_key, value| value > 3 }
      expect(result).to be_nil
    end
  end

  describe "replace" do
    it "should replace the hash with the given hash" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:b, 3, :c, 4]
      dict1.replace(dict2)
      expect(dict1.keys).to eq(%i[b c])
    end

    it "should return self" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:b, 3, :c, 4]
      expect(dict1.replace(dict2)).to eq(dict1)
    end
  end

  describe "select" do
    it "should return a new hash with the key-value pairs that satisfy the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.select { |_key, value| value > 2 }
      expect(result.keys).to eq([:c])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.select
      expect(result).to be_a(Enumerator)
    end

    it "should return the hash if key-value pairs are selected" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.select { |_key, value| value > 2 }.keys).to eq([:c])
    end

    it "should return an empty hash if no key-value pairs are selected" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.select { |_key, value| value > 3 }
      expect(result.keys).to eq([])
    end
  end

  describe "select!" do
    it "should remove all key-value pairs that do not satisfy the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict.select! { |_key, value| value > 2 }
      expect(dict.keys).to eq([:c])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.select!
      expect(result).to be_a(Enumerator)
    end

    it "should return the hash if key-value pairs are removed" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.select! { |_key, value| value > 2 }
      expect(result).to eq(dict)
    end

    it "should return nil if no key-value pairs are removed" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.select! { |_key, value| value <= 3 }
      expect(result).to be_nil
    end
  end

  describe "shift" do
    it "should remove the first key-value pair from the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      pair = dict.shift
      expect(pair).to eq([:a, 1])
      expect(dict.keys).to eq(%i[b c])
    end

    it "should return nil if the hash is empty" do
      dict = SortedContainers::SortedHash.new
      pair = dict.shift
      expect(pair).to be_nil
    end

    it "should return the first key-value pair in sorted order" do
      dict = SortedContainers::SortedHash[:b, 2, :a, 1, :c, 3]
      pair = dict.shift
      expect(pair).to eq([:a, 1])
      expect(dict.keys).to eq(%i[b c])
    end
  end

  describe "size" do
    it "should return the number of key-value pairs in the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.size).to eq(3)
    end
  end

  describe "slice" do
    it "should return a new hash with the given keys" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.slice(:a, :b)
      expect(result.keys).to eq(%i[a b])
    end

    it "should ignore keys that are not in the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.slice(:a, :d)
      expect(result.keys).to eq([:a])
    end
  end

  describe "store" do
    it "should add the key-value pair to the hash" do
      dict = SortedContainers::SortedHash.new
      dict.store(:a, 1)
      expect(dict.keys).to eq([:a])
    end

    it "should update the value if the key is already in the hash" do
      dict = SortedContainers::SortedHash.new
      dict.store(:a, 1)
      dict.store(:a, 2)
      expect(dict[:a]).to eq(2)
    end

    it "should return the value" do
      dict = SortedContainers::SortedHash.new
      expect(dict.store(:a, 1)).to eq(1)
    end
  end

  describe "to_a" do
    it "should return an array of key-value pairs in sorted order" do
      dict = SortedContainers::SortedHash[:b, 2, :a, 1, :c, 3]
      expect(dict.to_a).to eq([[:a, 1], [:b, 2], [:c, 3]])
    end
  end

  describe "to_h" do
    it "should return a new hash with the key-value pairs" do
      dict = SortedContainers::SortedHash[:b, 2, :a, 1, :c, 3]
      result = dict.to_h
      expect(result).to be_a(Hash)
      expect(result).to eq({ a: 1, b: 2, c: 3 })
    end

    it "should use given block to resolve key-value pairs" do
      dict = SortedContainers::SortedHash[:b, 2, :a, 1, :c, 3]
      result = dict.to_h { |key, value| [key.to_s, value * 2] }
      expect(result.keys).to eq(%w[a b c])
      expect(result.values).to eq([2, 4, 6])
    end
  end

  describe "to_hash" do
    it "should return a new hash with the key-value pairs" do
      dict = SortedContainers::SortedHash[:b, 2, :a, 1, :c, 3]
      result = dict.to_hash
      expect(result.keys.sort).to eq(%i[a b c])
    end
  end

  describe "to_proc" do
    it "should return a proc that maps keys to values" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      proc = dict.to_proc
      expect(proc.call(:a)).to eq(1)
    end
  end

  describe "to_s" do
    it "should return a string representation of the hash" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.to_s).to eq("SortedHash({a: 1, b: 2, c: 3})")
    end
  end

  describe "transform_keys" do
    it "should return a new hash with the keys transformed by the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.transform_keys { |key| key.to_s.upcase }
      expect(result.keys).to eq(%w[A B C])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.transform_keys
      expect(result).to be_a(Enumerator)
    end
  end

  describe "transform_keys!" do
    it "should transform the keys in the hash by the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict.transform_keys! { |key| key.to_s.upcase }
      expect(dict.keys).to eq(%w[A B C])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.transform_keys!
      expect(result).to be_a(Enumerator)
    end

    it "should resort the hash" do
      dict = SortedContainers::SortedHash[1, :a, 2, :b, 3, :c]
      dict.transform_keys!(&:-@)
      expect(dict.keys).to eq([-3, -2, -1])
    end
  end

  describe "transform_values" do
    it "should return a new hash with the values transformed by the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.transform_values { |value| value * 2 }
      expect(result.values).to eq([2, 4, 6])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.transform_values
      expect(result).to be_a(Enumerator)
    end
  end

  describe "transform_values!" do
    it "should transform the values in the hash by the given block" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      dict.transform_values! { |value| value * 2 }
      expect(dict.values).to eq([2, 4, 6])
    end

    it "should return an enumerator if no block is given" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.transform_values!
      expect(result).to be_a(Enumerator)
    end
  end

  describe "update" do
    it "should merge the given hash into self" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:b, 3, :c, 4]
      dict1.update(dict2)
      expect(dict1.keys).to eq(%i[a b c])
    end

    it "should merge the given hash into self" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:b, 3, :c, 4]
      dict1.update(dict2) { |_key, old_value, new_value| old_value + new_value }
      expect(dict1[:b]).to eq(5)
    end

    it "should merge multiple hashes" do
      dict1 = SortedContainers::SortedHash[:a, 1, :b, 2]
      dict2 = SortedContainers::SortedHash[:b, 3, :c, 4]
      dict3 = SortedContainers::SortedHash[:c, 5, :d, 6]
      dict1.update(dict2, dict3)
      expect(dict1.keys).to eq(%i[a b c d])
    end
  end

  describe "value?" do
    it "should return true if the hash contains the given value" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.value?(2)).to be_truthy
    end

    it "should return false if the hash does not contain the given value" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      expect(dict.value?(4)).to be_falsey
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

  describe "values_at" do
    it "should return an array of values for the given keys" do
      dict = SortedContainers::SortedHash[:a, 1, :b, 2, :c, 3]
      result = dict.values_at(:a, :c)
      expect(result).to eq([1, 3])
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

  describe "bisect_left" do
    it "should return the index of the given key in the sorted array" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      index = dict.bisect_left(:b)
      expect(index).to eq(1)
    end
  end

  describe "bisect_right" do
    it "should return the index of the given key in the sorted array" do
      dict = SortedContainers::SortedHash.new
      dict[:a] = 1
      dict[:b] = 2
      dict[:c] = 3
      index = dict.bisect_right(:b)
      expect(index).to eq(2)
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

  describe "integration tests" do
    it "methods done in succession should work" do
      dict = SortedContainers::SortedHash.new
      (0..1000).each { |i| dict[i] = i }
      dict.delete_if { |key, _value| key.even? }
      dict.keep_if { |key, _value| key % 3 == 0 }
      dict.reject! { |key, _value| key % 5 == 0 }
      dict.select! { |key, _value| key % 7 == 0 }
      expect(dict.keys).to eq([21, 63, 147, 189, 231,
                               273, 357, 399, 441, 483,
                               567, 609, 651, 693, 777,
                               819, 861, 903, 987])
      expect(dict.bisect_left(148)).to eq(3)
      expect(dict.bisect_right(148)).to eq(3)
      expect(dict.first).to eq([21, 21])
      expect(dict.last).to eq([987, 987])
      dict[147] = nil
      dict.compact!
      expect(dict.bisect_left(148)).to eq(2)
      expect(dict.bisect_right(148)).to eq(2)
      dict.delete_at(1)
      expect(dict.bisect_left(148)).to eq(1)
      expect(dict.bisect_right(148)).to eq(1)
      expect(dict.keys).to eq([21, 189, 231,
                               273, 357, 399, 441, 483,
                               567, 609, 651, 693, 777,
                               819, 861, 903, 987])
      expect(dict.shift).to eq([21, 21])
      expect(dict.keys).to eq([189, 231, 273, 357, 399,
                               441, 483, 567, 609, 651,
                               693, 777, 819, 861, 903, 987])
    end
  end
end
