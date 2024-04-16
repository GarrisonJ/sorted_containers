# frozen_string_literal: true

require "set"
require_relative "sorted_list"

# A module that provides sorted container data structures.
module SortedContainers
  # The SortedSet class is a sorted set implementation.
  class SortedSet
    # Initializes a new instance of the SortedSet class.
    def initialize
      @set = Set.new
      @list = SortedContainers::SortedList.new
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

    # Removes an item from the sorted set.
    #
    # @param item [Object] The item to be removed.
    def delete(item)
      return unless @set.include?(item)

      @set.delete(item)
      @list.remove(item)
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

    # Iterates over each item in the sorted set.
    #
    # @yield [item] Gives each item to the block.
    def each(&block)
      @list.each(&block)
    end
  end
end
