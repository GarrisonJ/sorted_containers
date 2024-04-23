# frozen_string_literal: true

# The SortedContainers module provides data structures for sorted collections.
module SortedContainers
  # The SortedArray class is a sorted array implementation.
  # rubocop:disable Metrics/ClassLength
  class SortedArray
    include Enumerable

    DEFAULT_LOAD_FACTOR = 1000

    attr_reader :size
    alias length size

    # Initializes a new SortedArray object.
    #
    # @param iterable [Enumerable] An optional iterable object to initialize the array with.
    # @param load_factor [Integer] The load factor for the array.
    def initialize(iterable = [], load_factor: DEFAULT_LOAD_FACTOR)
      @lists = []
      @maxes = []
      @index = []
      @offset = 0
      @load_factor = load_factor
      @size = 0
      update(iterable)
    end

    # Adds a value to the sorted array.
    #
    # @param value [Object] The value to add.
    # rubocop:disable Metrics/MethodLength
    def add(value)
      if @maxes.empty?
        @lists.append([value])
        @maxes.append(value)
      else
        pos = internal_bisect_right(@maxes, value)
        if pos == @maxes.size
          pos -= 1
          @lists[pos].push(value)
          @maxes[pos] = value
        else
          sub_pos = internal_bisect_right(@lists[pos], value)
          @lists[pos].insert(sub_pos, value)
        end
        expand(pos)
      end
      @size += 1
    end
    # rubocop:enable Metrics/MethodLength

    # Alias for add
    #
    # @param value [Object] The value to add.
    def <<(value)
      add(value)
    end

    # Returns a string representation of the sorted array.
    #
    # @return [String] A string representation of the sorted array.
    def to_s
      "SortedArray(#{to_a})"
    end

    # Checks if Array is empty
    #
    # @return [Boolean]
    def empty?
      @size.zero?
    end

    # Returns an index to insert `value` in the sorted list.
    #
    # If the `value` is already present, the insertion point will be before
    # (to the left of) any existing values.
    #
    # Runtime complexity: `O(log(n))` -- approximate.
    #
    # sl = SortedList.new([10, 11, 12, 13, 14])
    # sl.bisect_left(12)
    # 2
    #
    # @param value [Object] The value to insert.
    # @return [Integer] The index to insert the value.
    def bisect_left(value)
      return 0 if @maxes.empty?

      pos = internal_bisect_left(@maxes, value)

      return @size if pos == @maxes.size

      idx = internal_bisect_left(@lists[pos], value)
      loc(pos, idx)
    end

    # Returns an index to insert `value` in the sorted list.
    #
    # If the `value` is already present, the insertion point will be after
    # (to the right of) any existing values.
    #
    # Runtime complexity: `O(log(n))` -- approximate.
    #
    # sl = SortedList.new([10, 11, 12, 13, 14])
    # sl.bisect_right(12)
    # 3
    #
    # @param value [Object] The value to insert.
    # @return [Integer] The index to insert the value.
    def bisect_right(value)
      return 0 if @maxes.empty?

      pos = internal_bisect_right(@maxes, value)

      return @size if pos == @maxes.size

      idx = internal_bisect_right(@lists[pos], value)
      loc(pos, idx)
    end

    # Deletes a value from the sorted array.
    #
    # @param value [Object] The value to delete.
    def delete(value)
      return if @maxes.empty?

      pos = internal_bisect_left(@maxes, value)

      return if pos == @maxes.size

      idx = internal_bisect_left(@lists[pos], value)

      internal_delete(pos, idx) if @lists[pos][idx] == value
    end

    # Tries to match the behavior of Array#[]
    # alias for slice
    #
    # @param args [Integer, Range, Enumerator::ArithmeticSequence] The index or range of values to retrieve.
    # @return [Object, Array] The value or values at the specified index or range.
    def [](*args)
      slice(*args)
    end

    # Tries to match the behavior of Array#slice
    #
    # @param args [Integer, Range, Enumerator::ArithmeticSequence] The index or range of values to retrieve.
    # @return [Object, Array] The value or values at the specified index or range.
    # rubocop:disable Metrics/MethodLength
    def slice(*args)
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
    # rubocop:enable Metrics/MethodLength

    # Tries to match the behavior of Array#slice!
    #
    # @param args [Integer, Range, Enumerator::ArithmeticSequence] The index or range of values to retrieve.
    # @return [Object, Array] The value or values at the specified index or range.
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    def slice!(*args)
      case args.size
      when 1
        arg = args[0]
        case arg
        when Integer
          value = get_value_at_index(arg)
          delete_at(arg)
          value
        when Range
          values = get_values_from_range(arg)
          values.each { |val| delete(val) }
          values
        when Enumerator::ArithmeticSequence
          values = get_values_from_arithmetic_sequence(arg)
          values.each { |val| delete(val) }
          values
        else
          raise TypeError, "no implicit conversion of #{arg.class} into Integer"
        end
      when 2
        start, length = args
        values = get_values_from_start_and_length(start, length)
        values.each { |val| delete(val) }
        values
      else
        raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 1..2)"
      end
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity

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
      pos, idx = pos(index)
      internal_delete(pos, idx)
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
    #
    # @return [void]
    def clear
      @lists.clear
      @maxes.clear
      @index.clear
      @offset = 0
      @size = 0
    end

    # Checks if the sorted array contains a value.
    #
    # @param value [Object] The value to check.
    # @return [Boolean] True if the value is found, false otherwise.
    def include?(value)
      i = internal_bisect_left(@maxes, value)
      return false if i == @maxes.size

      sublist = @lists[i]
      idx = internal_bisect_left(sublist, value)
      idx < sublist.size && sublist[idx] == value
    end

    # Updates the sorted array with values from an iterable object.
    #
    # @param iterable [Enumerable] The iterable object to update the array with.
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def update(iterable)
      # Convert the iterable to an array and sort it
      values = iterable.to_a.sort

      # If maxes are already defined and not empty
      unless @maxes.empty?
        if values.length * 4 >= @size
          # If the new values are significant in number, merge all lists and re-sort
          @lists << values
          values = @lists.flatten.sort
          clear
        else
          # Otherwise, add each item individually
          values.each { |val| add(val) }
          return
        end
      end

      # Break sorted values into chunks of size @load_factor and extend lists
      @lists += values.each_slice(@load_factor).to_a

      # Update maxes based on the last element of each sublist
      @maxes = @lists.map(&:last)

      # Update the total length of the list
      @size = values.length

      # Clear the index as it might be outdated
      @index.clear
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    # Converts the sorted array to an array.
    #
    # @return [Array] An array representation of the sorted array.
    def to_a
      @lists.flatten
    end

    # Duplicates the sorted array.
    #
    # @return [SortedArray] The sorted array.
    def sort
      # No need to sort, already sorted
      dup
    end

    # Returns self, as the array is already sorted.
    #
    # @return [SortedArray] The sorted array.
    def sort!
      # No need to sort, already sorted
      self
    end

    # Returns a new SortedArray with the same values.
    #
    # @return [SortedArray] The duplicated sorted array.
    def dup
      # Create a new instance of SortedList with the same values
      new_instance = self.class.new
      new_instance.lists = @lists.map(&:dup)
      new_instance.maxes = @maxes.dup
      new_instance.index = @index.dup
      new_instance.offset = @offset
      new_instance.load_factor = @load_factor
      new_instance.size = @size
      new_instance
    end

    # When non-negative, multiplies returns a new Array with each value repeated `int` times.
    #
    # @param int [Integer] The integer to multiply the array by.
    # @return [SortedArray] The multiplied sorted array.
    def multiply(num)
      values = @lists.flatten * num
      new_instance = self.class.new
      new_instance.update(values)
      new_instance
    end
    alias * multiply

    # Returns the maximum value in the sorted array.
    #
    # @return [Object] The maximum value in the array.
    def max
      @lists.last&.last
    end

    # Returns the minimum value in the sorted array.
    #
    # @return [Object] The minimum value in the array.
    def min
      @lists.first&.first
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
    def internal_bisect_left(array, value)
      array.bsearch_index { |x| x >= value } || array.size
    end

    # Performs a right bisect on the array.
    #
    # @param array [Array] The array to bisect.
    # @param value [Object] The value to bisect with.
    # @return [Integer] The index where the value should be inserted.
    def internal_bisect_right(array, value)
      array.bsearch_index { |x| x > value } || array.length
    end

    # Gets the value at a given index. Supports negative indices.
    #
    # @param index [Integer] The index to get the value from.
    def get_value_at_index(index)
      raise "Index out of range" if index.abs >= @size

      index += @size if index.negative?
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
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
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
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    # Gets values from an arithmetic sequence.
    #
    # @param sequence [Enumerator::ArithmeticSequence] The arithmetic sequence to get values from.
    # @return [Array] The values from the arithmetic sequence.
    # rubocop:disable Metrics/MethodLength
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
    # rubocop:enable Metrics/MethodLength

    # Gets values starting from a given index and continuing for a given length.
    # Supports negative indices.
    #
    # @param start [Integer] The index to start from.
    # @param length [Integer] The length of the values to get.
    # @return [Array] The values starting from the given index and continuing for the given length.
    # rubocop:disable Metrics/MethodLength
    def get_values_from_start_and_length(start, length)
      return nil if start >= @size

      if length.negative?
        nil
      else
        if start.negative?
          start += @size
          return nil if start.negative?
        end

        result = []
        while length.positive?
          break if start >= @size

          loc, idx = pos(start)
          start += 1
          length -= 1
          result << @lists[loc][idx]
        end
      end
      result
    end
    # rubocop:enable Metrics/MethodLength

    # Expands a sublist if it exceeds the load factor.
    #
    # @param pos [Integer] The index of the sublist to expand.
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def expand(pos)
      if @lists[pos].size > (@load_factor << 1)
        half = @lists[pos].slice!(@load_factor, @lists[pos].size - @load_factor)
        @maxes[pos] = @lists[pos].last
        @lists.insert(pos + 1, half)
        @maxes.insert(pos + 1, half.last)
        @index.clear
      elsif @index.size.positive?
        child = @offset + pos
        while child.positive?
          @index[child] += 1
          child = (child - 1) >> 1
        end
        @index[0] += 1
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    # Deletes a value from a sublist.
    #
    # @param pos [Integer] The index of the sublist.
    # @param idx [Integer] The index of the value to delete.
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def internal_delete(pos, idx)
      @lists[pos].delete_at(idx)
      @size -= 1
      return unless @lists[pos].size < @load_factor >> 1

      @maxes[pos] = @lists[pos].last

      if @index.size.positive?
        child = @offset + pos
        while child.positive?
          @index[child] -= 1
          child = (child - 1) >> 1
        end
        @index[0] -= 1
      elsif @lists.size > 1
        pos += 1 if pos.zero?

        prev = pos - 1
        @lists[prev].concat(@lists[pos])
        @maxes[prev] = @lists[prev].last

        @lists.delete_at(pos)
        @maxes.delete_at(pos)
        @index.clear

        expand(prev)
      elsif @lists[pos].size.positive?
        @maxes[pos] = @lists[pos].last
      else
        @lists.delete_at(pos)
        @maxes.delete_at(pos)
        @index.clear
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    # Builds the positional index for indexing the sorted array.
    # Indexes are represented as binary trees in a dense array notation
    # similar to a binary heap.
    #
    # For example, given a lists representation storing integers:
    #
    #     0: [1, 2, 3]
    #     1: [4, 5]
    #     2: [6, 7, 8, 9]
    #     3: [10, 11, 12, 13, 14]
    #
    # The first transformation maps the sub-lists by their length. The
    # first row of the index is the length of the sub-lists:
    #
    #     0: [3, 2, 4, 5]
    #
    # Each row after that is the sum of consecutive pairs of the previous
    # row:
    #
    #     1: [5, 9]
    #     2: [14]
    #
    # Finally, the index is built by concatenating these lists together:
    #
    #     @index = [14, 5, 9, 3, 2, 4, 5]
    #
    # An offset storing the start of the first row is also stored:
    #
    #     @offset = 3
    #
    # When built, the index can be used for efficient indexing into the list.
    # See the comment and notes on `SortedArray#pos` for details.
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def build_index
      # Build initial row from the lengths of each sublist
      row0 = @lists.map(&:length)

      # Early return if there is only one sublist
      if row0.length == 1
        @index = row0
        @offset = 0
        return
      end

      # Build the first row by summing consecutive pairs
      # discard the last element if the row is odd
      row1 = row0.each_slice(2).map { |a, b| a + b if b }.compact

      # Handle odd number of elements in row0
      row1 << row0[-1] if row0.length.odd?

      # Return early if only one row is needed
      if row1.length == 1
        @index = row1 + row0
        @offset = 1
        return
      end

      # Calculate the size for a complete binary tree
      the_size = 2**(Math.log2(row1.length - 1).to_i + 1)
      row1 += [0] * (the_size - row1.length)
      tree = [row0, row1]

      while tree.last.length > 1
        row = []
        tree.last.each_slice(2) { |a, b| row << (a + b) }
        tree << row
      end

      # Flatten the tree into the index array
      tree.reverse_each { |level| @index.concat(level) }
      @offset = (the_size * 2) - 1
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    # Convert an index into an index pair (lists index, sublist index)
    # that can be used to access the corresponding lists position.
    #
    # Many queries require the index be built. Details of the index are
    # described in `SortedArray#build_index`.
    #
    # Indexing requires traversing the tree to a leaf node. Each node has two
    # children which are easily computable. Given an index, pos, the
    # left-child is at `pos * 2 + 1` and the right-child is at `pos * 2 + 2`.
    #
    # When the index is less than the left-child, traversal moves to the
    # left sub-tree. Otherwise, the index is decremented by the left-child
    # and traversal moves to the right sub-tree.
    #
    # At a child node, the indexing pair is computed from the relative
    # position of the child node as compared with the offset and the remaining
    # index.
    #
    # For example, using the index from `SortedArray#build_index`:
    #
    #     index = 14 5 9 3 2 4 5
    #     offset = 3
    #
    # Tree:
    #
    #          14
    #       5      9
    #     3   2  4   5
    #
    # Indexing position 8 involves iterating like so:
    #
    # 1. Starting at the root, position 0, 8 is compared with the left-child
    #    node (5) which it is greater than. When greater the index is
    #    decremented and the position is updated to the right child node.
    #
    # 2. At node 9 with index 3, we again compare the index to the left-child
    #    node with value 4. Because the index is the less than the left-child
    #    node, we simply traverse to the left.
    #
    # 3. At node 4 with index 3, we recognize that we are at a leaf node and
    #    stop iterating.
    #
    # To compute the sublist index, we subtract the offset from the index
    # of the leaf node: 5 - 3 = 2. To compute the index in the sublist, we
    # simply use the index remaining from iteration. In this case, 3.
    #
    # The final index pair from our example is (2, 3) which corresponds to
    # index 8 in the sorted list.
    #
    # @param idx [Integer] The index in the sorted list.
    # @return [Array] The (lists index, sublist index) pair.
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/CyclomaticComplexity
    def pos(idx)
      if idx.negative?
        last_len = @lists[-1].size

        return @lists.size - 1, last_len + idx if (-idx) <= last_len

        idx += @size

        raise IndexError, "list index out of range" if idx.negative?

      elsif idx >= @size
        raise IndexError, "list index out of range"
      end

      return 0, idx if idx < @lists[0].size

      build_index if @index.empty?

      pos = 0
      child = 1
      len_index = @index.size

      while child < len_index
        index_child = @index[child]

        if idx < index_child
          pos = child
        else
          idx -= index_child

          pos = child + 1
        end

        child = (pos << 1) + 1
      end

      [pos - @offset, idx]
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity

    def loc(pos, idx)
      return idx if pos.zero?

      build_index if @index.empty?

      # Increment pos to point in the index to @lists[pos].size.
      total = 0

      pos += @offset

      # Iterate until reaching the root of the index tree at pos = 0.
      while pos.positive?

        # Right-child nodes are at even indices. At such indices
        # account the total below the left child node.
        total += @index[pos - 1] if pos.odd?

        # Advance pos to the parent node.
        pos = (pos - 1) >> 1
      end

      total + idx
    end

    protected

    attr_accessor :lists, :maxes, :index, :offset, :load_factor

    attr_writer :size
  end
  # rubocop:enable Metrics/ClassLength
end
