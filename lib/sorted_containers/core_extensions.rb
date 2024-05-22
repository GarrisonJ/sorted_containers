# frozen_string_literal: true

# Array class is being extended to include methods for converting
# an Array to a SortedSet, SortedHash, and SortedArray.
class Array
  # Converts the array to a SortedSet.
  #
  # @param load_factor [Integer] The load factor for the SortedSet.
  # @return [SortedContainers::SortedSet] The new SortedSet.
  def to_sorted_set(load_factor: SortedContainers::SortedArray::DEFAULT_LOAD_FACTOR)
    SortedContainers::SortedSet.new(self, load_factor: load_factor)
  end

  # Converts the array to a SortedHash.
  #
  # @param load_factor [Integer] The load factor for the SortedHash.
  # @return [SortedContainers::SortedHash] The new SortedHash.
  def to_sorted_h(load_factor: SortedContainers::SortedArray::DEFAULT_LOAD_FACTOR)
    hash = SortedContainers::SortedHash.new(load_factor: load_factor)
    hash.merge!(self)
  end

  # Converts the array to a SortedArray.
  #
  # @param load_factor [Integer] The load factor for the SortedArray.
  # @return [SortedContainers::SortedArray] The new SortedArray.
  def to_sorted_a(load_factor: SortedContainers::SortedArray::DEFAULT_LOAD_FACTOR)
    SortedContainers::SortedArray.new(self, load_factor: load_factor)
  end
end

# Hash class is being extended to include a method for converting
# a Hash to a SortedHash.
class Hash
  # Converts the hash to a SortedHash.
  #
  # @param load_factor [Integer] The load factor for the SortedHash.
  # @return [SortedContainers::SortedHash] The new SortedHash.
  def to_sorted_h(load_factor: SortedContainers::SortedArray::DEFAULT_LOAD_FACTOR)
    hash = SortedContainers::SortedHash.new(load_factor: load_factor)
    hash.merge!(self)
    hash
  end
end

# Set class is being extended to include a method for converting
# a Set to a SortedSet.
class Set
  # Converts the set to a SortedSet.
  #
  # @param load_factor [Integer] The load factor for the SortedSet.
  # @return [SortedContainers::SortedSet] The new SortedSet.
  def to_sorted_set(load_factor: SortedContainers::SortedArray::DEFAULT_LOAD_FACTOR)
    SortedContainers::SortedSet.new(self, load_factor: load_factor)
  end
end
