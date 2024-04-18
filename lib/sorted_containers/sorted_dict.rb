# frozen_string_literal: true

require_relative "sorted_array"

# The SortedContainers module provides data structures for sorted collections.
module SortedContainers
  # The SortedDict class represents a sorted dictionary.
  class SortedDict
    include Enumerable

    # Initializes a new instance of the SortedDict class.
    #
    # @param load_factor [Integer] The load factor for the SortedDict.
    def initialize(load_factor: SortedArray::DEFAULT_LOAD_FACTOR)
      @dictionary = {}
      @sorted_array = SortedArray.new(load_factor: load_factor)
    end

    # Retrieves the value associated with the specified key.
    #
    # @param key [Object] The key to retrieve the value for.
    # @return [Object] The value associated with the key, or nil if the key is not found.
    def [](key)
      @dictionary[key]
    end

    # Associates the specified value with the specified key.
    # If the key already exists, the previous value will be replaced.
    #
    # @param key [Object] The key to associate the value with.
    # @param value [Object] The value to be associated with the key.
    # @return [Object] The value that was associated with the key.
    def []=(key, value)
      @sorted_array.delete(key) if @dictionary.key?(key)
      @sorted_array.add(key)
      @dictionary[key] = value
    end

    # Deletes the key-value pair associated with the specified key.
    #
    # @param key [Object] The key to delete.
    # @return [void]
    def delete(key)
      return unless @dictionary.key?(key)

      @dictionary.delete(key)
      @sorted_array.delete(key)
    end

    # Returns an array of all the keys in the SortedDict.
    #
    # @return [Array] An array of all the keys.
    def keys
      @sorted_array.to_a
    end

    # Returns an array of all the values in the SortedDict.
    #
    # @return [Array] An array of all the values.
    def values
      @sorted_array.to_a.map { |key| @dictionary[key] }
    end

    # Iterates over each key-value pair in the SortedDict.
    #
    # @yield [key, value] The block to be executed for each key-value pair.
    # @yieldparam key [Object] The key of the current key-value pair.
    # @yieldparam value [Object] The value of the current key-value pair.
    # @return [void]
    def each(&block)
      @sorted_array.each do |key|
        value = @dictionary[key]
        block.call(key, value)
      end
    end
  end
end
