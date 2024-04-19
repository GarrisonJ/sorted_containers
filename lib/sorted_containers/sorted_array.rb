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

    # Tries to match the behavior of Array#[]
    #
    # @param args [Integer, Range, Enumerator::ArithmeticSequence] The index or range of values to retrieve.
    def [](*args)
      case args.size
      when 1
        arg = args[0]
        case arg
        when Integer
          get_value_at_index(arg)
        when Range
          get_values_from_range(arg)
        when Enumerator::ArithmeticSequence
          get_values_from_arithmetic_sequence(arg)
        else
          raise TypeError, "no implicit conversion of #{arg.class} into Integer"
        end
      when 2
        start, length = args
        get_values_from_start_and_length(start, length)
      else
        raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 1..2)"
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
      array.bsearch_index { |x| x >= value } || array.size
    end

    # Performs a right bisect on the array.
    #
    # @param array [Array] The array to bisect.
    # @param value [Object] The value to bisect with.
    # @return [Integer] The index where the value should be inserted.
    def bisect_right(array, value)
      array.bsearch_index { |x| x > value } || array.length
    end

    # Gets the value at a given index.
    #
    # @param index [Integer] The index to get the value from.
    def get_value_at_index(index)
      raise "Index out of range" if index.negative? || index >= @size

      @lists.each do |sublist|
        return sublist[index] if index < sublist.size

        index -= sublist.size
      end
    end

    # Gets values from a range.
    #
    # @param range [Range] The range to get values from.
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def get_values_from_range(range)
      start = range.begin
      start += @size if start.negative?
      return nil if start.negative?

      length = range.end
      length += @size if length.negative?
      length += 1 unless range.exclude_end?
      length -= start
      return nil if length.negative?

      result = []
      @lists.each do |sublist|
        if start < sublist.size
          result.concat(sublist[start, length])
          length -= sublist.size - start
          break if length <= 0

          start = 0
        else
          start -= sublist.size
        end
      end
      result
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    # Gets values from an arithmetic sequence.
    #
    # @param sequence [Enumerator::ArithmeticSequence] The arithmetic sequence to get values from.
    def get_values_from_arithmetic_sequence(sequence)
      result = []
      sequence.each do |index|
        break if index.negative? || index >= @size

        @lists.each do |sublist|
          if index < sublist.size
            result << sublist[index]
            break
          else
            index -= sublist.size
          end
        end
      end
      result
    end

    # Gets values starting from a given index and continuing for a given length.
    #
    # @param start [Integer] The index to start from.
    # @param length [Integer] The length of the values to get.
    # @return [Array] The values starting from the given index and continuing for the given length.
    # rubocop:disable Metrics/PerceivedComplexity
    def get_values_from_start_and_length(start, length)
      raise "Index out of range" if start.negative? || start >= @size

      if length.negative?
        nil
      else
        result = []
        @lists.each do |sublist|
          if start < sublist.size
            result.concat(sublist[start, length])
            length -= sublist.size - start
            break if length <= 0

            start = 0
          else
            start -= sublist.size
          end
        end
        result
      end
    end
    # rubocop:enable Metrics/PerceivedComplexity

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
    # @param pos [Integer] The index of the sublist.
    # @param idx [Integer] The index of the value to delete.
    def internal_delete(pos, idx)
      @lists[pos].delete_at(idx)
      @size -= 1

      if @lists[pos].size > (@load_factor >> 1)
        @maxes[pos] = @lists[pos].last
      elsif @lists.size > 1
        if pos.zero?
          pos += 1
        end

        prev = pos - 1
        @lists[prev].concat(@lists[pos])
        @maxes[prev] = @lists[prev].last

        @lists.delete_at(pos)
        @maxes.delete_at(pos)
      elsif @lists[pos].size.positive?
        @maxes[pos] = @lists[pos].last
      else
        @lists.delete_at(pos)
        @maxes.delete_at(pos)
      end

    end
  end
end
