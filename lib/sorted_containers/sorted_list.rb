# frozen_string_literal: true

# The SortedContainers module provides data structures for sorted collections.
module SortedContainers
  # The SortedList class is a sorted list implementation.
  class SortedList
    include Enumerable

    DEFAULT_LOAD_FACTOR = 1000

    attr_reader :size

    # Initializes a new SortedList object.
    #
    # @param iterable [Enumerable] An optional iterable object to initialize the list with.
    def initialize(iterable = [])
      @lists = []
      @maxes = []
      @load_factor = DEFAULT_LOAD_FACTOR
      @size = 0
      update(iterable)
    end

    # Adds a value to the sorted list.
    #
    # @param value [Object] The value to add.
    def add(value)
      i = bisect_right(@maxes, value)
      if i == @maxes.size
        @lists.push([value])
        @maxes.push(value)
      else
        idx = bisect_right(@lists[i], value)
        @lists[i].insert(idx, value)
        @maxes[i] = @lists[i].last
        expand(i) if @lists[i].size > (@load_factor * 2)
      end
      @size += 1
    end

    # Adds a value to the sorted list using the << operator.
    #
    # @param value [Object] The value to add.
    def <<(value)
      add(value)
    end

    def remove(value)
      i = bisect_left(@maxes, value)
      raise "Value not found: #{value}" if i == @maxes.size

      idx = bisect_left(@lists[i], value)
      raise "Value not found: #{value}" unless @lists[i][idx] == value

      internal_delete(i, idx)
    end

    # Retrieves the value at the specified index.
    #
    # @param index [Integer] The index of the value to retrieve.
    # @return [Object] The value at the specified index.
    def [](index)
      raise "Index out of range" if index.negative? || index >= @size

      @lists.each do |sublist|
        return sublist[index] if index < sublist.size

        index -= sublist.size
      end
    end

    # Deletes the value at the specified index.
    #
    # @param index [Integer] The index of the value to delete.
    def delete_at(index)
      raise "Index out of range" if index.negative? || index >= @size

      deleted = false
      @lists.each_with_index do |sublist, sublist_index|
        if index < sublist.size
          internal_delete(sublist_index, index)
          deleted = true
          break
        else
          index -= sublist.size
        end
      end

      raise "Index out of range" unless deleted
    end

    # Pops the last value from the sorted list.
    #
    # @return [Object] The last value in the list.
    def pop
      raise "List is empty" if @size.zero?

      value = @lists.last.pop
      if @lists.last.empty?
        @lists.pop
        @maxes.pop
      else
        @maxes[-1] = @lists.last.last
      end
      @size -= 1
      value
    end

    # Clears the sorted list, removing all values.
    def clear
      @lists.clear
      @maxes.clear
      @size = 0
    end

    # Checks if the sorted list contains a value.
    #
    # @param value [Object] The value to check.
    # @return [Boolean] True if the value is found, false otherwise.
    def contains(value)
      i = bisect_left(@maxes, value)
      return false if i == @maxes.size

      sublist = @lists[i]
      idx = bisect_left(sublist, value)
      idx < sublist.size && sublist[idx] == value
    end

    # Converts the sorted list to an array.
    #
    # @return [Array] An array representation of the sorted list.
    def to_a
      @lists.flatten
    end

    # Iterates over each value in the sorted list.
    #
    # @yield [value] Gives each value to the block.
    def each(&block)
      @lists.each do |sublist|
        sublist.each(&block)
      end
    end

    private

    # Performs a left bisect on the array.
    #
    # @param array [Array] The array to bisect.
    # @param value [Object] The value to bisect with.
    # @return [Integer] The index where the value should be inserted.
    def bisect_left(array, value)
      array.bsearch_index { |x| x >= value } || array.size
    end

    # Performs a right bisect on the array.
    #
    # @param array [Array] The array to bisect.
    # @param value [Object] The value to bisect with.
    # @return [Integer] The index where the value should be inserted.
    def bisect_right(array, value)
      array.bsearch_index { |x| x > value } || array.size
    end

    # Expands a sublist if it exceeds the load factor.
    #
    # @param sublist_index [Integer] The index of the sublist to expand.
    def expand(sublist_index)
      sublist = @lists[sublist_index]
      return unless sublist.size > (@load_factor * 2)

      half = sublist.slice!(@load_factor, sublist.size - @load_factor)
      @lists.insert(sublist_index + 1, half)
      @maxes[sublist_index] = @lists[sublist_index].last
      @maxes.insert(sublist_index + 1, half.last)
    end

    # Deletes a value from a sublist.
    #
    # @param sublist_index [Integer] The index of the sublist.
    # @param idx [Integer] The index of the value to delete.
    def internal_delete(sublist_index, idx)
      @lists[sublist_index].delete_at(idx)
      if @lists[sublist_index].empty?
        @lists.delete_at(sublist_index)
        @maxes.delete_at(sublist_index)
      else
        @maxes[sublist_index] = @lists[sublist_index].last
      end
      @size -= 1
    end

    # Updates the sorted list with values from an iterable object.
    #
    # @param iterable [Enumerable] The iterable object to update the list with.
    def update(iterable)
      iterable.each { |item| add(item) }
    end
  end
end
