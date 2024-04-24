# frozen_string_literal: true

require_relative "sorted_array"

# The SortedContainers module provides data structures for sorted collections.
module SortedContainers
  # The SortedHash class represents a sorted hash.
  class SortedHash
    include Enumerable

    # Initializes a new instance of the SortedHash class.
    #
    # @param load_factor [Integer] The load factor for the SortedHash.
    def initialize(hash = {}, load_factor: SortedArray::DEFAULT_LOAD_FACTOR)
      @hash = hash
      @sorted_array = SortedArray.new(hash.keys, load_factor: load_factor)
    end

    # Retrieves the value associated with the specified key.
    #
    # @param key [Object] The key to retrieve the value for.
    # @return [Object] The value associated with the key, or nil if the key is not found.
    def [](key)
      @hash[key]
    end

    # Associates the specified value with the specified key.
    # If the key already exists, the previous value will be replaced.
    #
    # @param key [Object] The key to associate the value with.
    # @param value [Object] The value to be associated with the key.
    # @return [Object] The value that was associated with the key.
    def []=(key, value)
      @sorted_array.delete(key) if @hash.key?(key)
      @sorted_array.add(key)
      @hash[key] = value
    end

    # Returns a string representation of the SortedHash.
    #
    # @return [String] A string representation of the SortedHash.
    def to_s
      "SortedHash({#{keys.map { |key| "#{key}: #{self[key]}" }.join(", ")}})"
    end

    # Deletes the key-value pair associated with the specified key.
    #
    # @param key [Object] The key to delete.
    # @return [void]
    def delete(key)
      return unless @hash.key?(key)

      @hash.delete(key)
      @sorted_array.delete(key)
    end

    # Deletes the key-value pair at the specified index and returns it as a two-element array.
    #
    # @param index [Integer] The index of the key-value pair to delete.
    # @return [Array] A two-element array containing the key and value of the deleted key-value pair.
    def delete_at(index)
      return nil if index.abs >= @sorted_array.size

      key = @sorted_array.delete_at(index)
      value = @hash.delete(key)
      [key, value]
    end

    # Retrieves the first key-value pair from the SortedHash as a two-element array.
    #
    # @return [Array] A two-element array containing the key and value of the first key-value pair.
    def first
      return nil if @sorted_array.empty?

      key = @sorted_array.first
      [key, @hash[key]]
    end

    # Removes the first key-value pair from the SortedHash and returns it as a two-element array.
    #
    # @return [Array] A two-element array containing the key and value of the first key-value pair.
    def last
      return nil if @sorted_array.empty?

      key = @sorted_array.last
      [key, @hash[key]]
    end

    # Removes the last key-value pair from the SortedHash and returns it as a two-element array.
    #
    # @return [Array] A two-element array containing the key and value of the last key-value pair.
    def pop
      return nil if @sorted_array.empty?

      key = @sorted_array.pop
      value = @hash.delete(key)
      [key, value]
    end

    # Removes the first key-value pair from the SortedHash and returns it as a two-element array.
    #
    # @return [Array] A two-element array containing the key and value of the first key-value pair.
    def shift
      return nil if @sorted_array.empty?

      key = @sorted_array.shift
      value = @hash.delete(key)
      [key, value]
    end

    # Returns an array of all the keys in the SortedHash.
    #
    # @return [Array] An array of all the keys.
    def keys
      @sorted_array.to_a
    end

    # Returns an array of all the values in the SortedHash.
    #
    # @return [Array] An array of all the values.
    def values
      @sorted_array.to_a.map { |key| @hash[key] }
    end

    # Iterates over each key-value pair in the SortedHash.
    #
    # @yield [key, value] The block to be executed for each key-value pair.
    # @yieldparam key [Object] The key of the current key-value pair.
    # @yieldparam value [Object] The value of the current key-value pair.
    # @return [void]
    def each(&block)
      @sorted_array.each do |key|
        value = @hash[key]
        block.call(key, value)
      end
    end
  end
end
