# frozen_string_literal: true

# The SortedContainers module provides data structures for sorted collections.
module SortedContainers
  # The SortedArray class is a sorted array implementation.
  class SortedArray
    include Enumerable

    DEFAULT_LOAD_FACTOR = 1000

    attr_reader :size

    # Initializes a new SortedArray object.
    #
    # @param iterable [Enumerable] An optional iterable object to initialize the array with.
    # @param load_factor [Integer] The load factor for the array.
    def initialize(iterable = [], load_factor: DEFAULT_LOAD_FACTOR)
      @lists = []
      @maxes = []
      @load_factor = load_factor
      @size = 0
      update(iterable)
    end

    # Adds a value to the sorted array.
    #
    # @param value [Object] The value to add.
    def add(value)
      if @maxes.empty?
        @lists.append([value])
        @maxes.append(value)
      else
        pos = bisect_right(@maxes, value)
        if pos == @maxes.size
          pos -= 1
          @lists[pos].push(value)
          @maxes[pos] = value
        else
          sub_pos = bisect_right(@lists[pos], value)
          @lists[pos].insert(sub_pos, value)
        end
        expand(pos)
      end
      @size += 1
    end

    # Alias for add
    #
    # @param value [Object] The value to add.
    def <<(value)
      add(value)
    end

    # Checks if Array is empty
    #
    # @return [Boolean]
    def empty?
      @size.zero?
    end

    # Deletes a value from the sorted array.
    #
    # @param value [Object] The value to delete.
    def delete(value)
      return if @maxes.empty?
      pos = bisect_left(@maxes, value)

      return if pos == @maxes.size

      idx = bisect_left(@lists[pos], value)

      internal_delete(pos, idx) if @lists[pos][idx] == value
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

    # Retrieves the last value in the sorted array.
    #
    # @return [Object] The last value in the array.
    def last
      raise "Array is empty" if @size.zero?

      @lists.last.last
    end

    # Retrieves the first value in the sorted array.
    #
    # @return [Object] The first value in the array.
    def first
      raise "Array is empty" if @size.zero?

      @lists.first.first
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

    # Pops the last value from the sorted array.
    #
    # @return [Object] The last value in the array.
    def pop
      raise "Array is empty" if @size.zero?

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

    # Clears the sorted array, removing all values.
    def clear
      @lists.clear
      @maxes.clear
      @size = 0
    end

    # Checks if the sorted array contains a value.
    #
    # @param value [Object] The value to check.
    # @return [Boolean] True if the value is found, false otherwise.
    def include?(value)
      i = bisect_left(@maxes, value)
      return false if i == @maxes.size

      sublist = @lists[i]
      idx = bisect_left(sublist, value)
      idx < sublist.size && sublist[idx] == value
    end

    # Updates the sorted array with values from an iterable object.
    #
    # @param iterable [Enumerable] The iterable object to update the array with.
    def update(iterable)
      iterable.each { |item| add(item) }
    end

    # Converts the sorted array to an array.
    #
    # @return [Array] An array representation of the sorted array.
    def to_a
      @lists.flatten
    end

    # Iterates over each value in the sorted array.
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
      array.bsearch_index { |x| x <=> value } || array.size
    end

    # Performs a right bisect on the array.
    #
    # @param array [Array] The array to bisect.
    # @param value [Object] The value to bisect with.
    # @return [Integer] The index where the value should be inserted.
    def bisect_right(array, value)
      array.bsearch_index { |x| (x <=> value) == 1 } || array.size
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

    end
  end
end
