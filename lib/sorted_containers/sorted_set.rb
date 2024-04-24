# frozen_string_literal: true

require "set"
require_relative "sorted_array"

# A module that provides sorted container data structures.
module SortedContainers
  # The SortedSet class is a sorted set implementation.
  class SortedSet
    include Enumerable

    # Initializes a new instance of the SortedSet class.
    #
    # @param iterable [Array] The initial elements of the sorted set.
    # @param load_factor [Integer] The load factor for the sorted set.
    def initialize(iterable = [], load_factor: SortedArray::DEFAULT_LOAD_FACTOR)
      @set = Set.new(iterable)
      @list = SortedContainers::SortedArray.new(@set.to_a, load_factor: load_factor)
    end

    # Adds an item to the sorted set.
    #
    # @param item [Object] The item to be added.
    def add(item)
      return if @set.include?(item)

      @set.add(item)
      @list.add(item)
    end

    # Adds an item to the sorted set using the `<<` operator.
    #
    # @param item [Object] The item to be added.
    def <<(item)
      add(item)
    end

    # Retrieves the item at the specified index.
    #
    # @param index [Integer] The index of the item to retrieve.
    def [](index)
      @list[index]
    end

    # Returns a string representation of the sorted set.
    #
    # @return [String] A string representation of the sorted set.
    def to_s
      "SortedSet(#{to_a.join(", ")})"
    end

    # Retrieves the first item in the sorted set.
    #
    # @return [Object] The first item.
    def first
      @list.first
    end

    # Retrieves the last item in the sorted set.
    #
    # @return [Object] The last item.
    def last
      @list.last
    end

    # Removes an item from the sorted set.
    #
    # @param item [Object] The item to be removed.
    def delete(item)
      return unless @set.include?(item)

      @set.delete(item)
      @list.delete(item)
    end

    # Removes the item at the specified index.
    #
    # @param index [Integer] The index of the item to remove.
    def delete_at(index)
      return if index.abs >= @list.size
      item = @list.delete_at(index)
      @set.delete(item)
      item
    end

    # Returns the number of items in the sorted set.
    #
    # @return [Integer] The number of items.
    def size
      @list.size
    end

    # Checks if an item is included in the sorted set.
    #
    # @param item [Object] The item to be checked.
    # @return [Boolean] `true` if the item is included, `false` otherwise.
    def include?(item)
      @set.include?(item)
    end

    # Returns an index to insert `value` in the sorted list.
    #
    # If the `value` is already present, the insertion point will be before
    # (to the left of) any existing values.
    #
    # Runtime complexity: `O(log(n))` -- approximate.
    #
    # @see SortedArray#bisect_left
    # @param value [Object] The value to insert.
    # @return [Integer] The index to insert the value.
    def bisect_left(value)
      @list.bisect_left(item)
    end

    # Returns an index to insert `value` in the sorted list.
    #
    # If the `value` is already present, the insertion point will be after
    # (to the right of) any existing values.
    #
    # Runtime complexity: `O(log(n))` -- approximate.
    #
    # @see SortedArray#bisect_right
    # @param value [Object] The value to insert.
    # @return [Integer] The index to insert the value.
    def bisect_right(value)
      @list.bisect_right(item)
    end

    # Returns the items in the sorted set as an array.
    #
    # @return [Array] The items in the sorted set.
    def to_a
      @list.to_a
    end

    # Iterates over each item in the sorted set.
    #
    # @yield [item] Gives each item to the block.
    def each(&block)
      @list.each(&block)
    end
  end
end
