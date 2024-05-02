# frozen_string_literal: true

# The SortedContainers module provides data structures for sorted collections.
# rubocop:disable Metrics/ClassLength
module SortedContainers
  # The SortedArray class is a sorted array implementation.
  class SortedArray
    include Enumerable

    # The default load factor for the array.
    # Sublists are split when they exceed 2 * load_factor
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

    # Returns a new SortedArray with the values from the union of the two arrays.
    #
    # @param other [SortedArray] The other array to union with.
    # @return [SortedArray] The union of the two arrays.
    def &(other)
      new_instance = self.class.new
      new_instance.update(to_a & other.to_a)
      new_instance
    end

    # When non-negative, multiplies returns a new Array with each value repeated `int` times.
    #
    # @param num [Integer] The integer to multiply the array by.
    # @return [SortedArray] The multiplied sorted array.
    def multiply(num)
      values = @lists.flatten * num
      new_instance = self.class.new
      new_instance.update(values)
      new_instance
    end
    alias * multiply

    # Returns a new SortedArray with the values from both arrays.
    #
    # @param other [SortedArray] The other array to add.
    # @return [SortedArray] The combined array.
    def +(other)
      new_instance = self.class.new
      new_instance.update(to_a + other.to_a)
      new_instance
    end

    # Returns a new SortedArray with the values from the difference of the two arrays.
    #
    # @param other [SortedArray] The other array to subtract.
    # @return [SortedArray] The difference of the two arrays.
    def -(other)
      new_instance = self.class.new
      new_instance.update(to_a - other.to_a)
      new_instance
    end
    alias difference -

    # Returns -1, 0, or 1 as self is less than, equal to, or greater than other. For each index i in self,
    # evaluates self[i] <=> other[i]
    #
    # @param other [SortedArray] The other array to compare.
    # @return [Integer] -1, 0, or 1 as self is less than, equal to, or greater than other.
    def <=>(other)
      return size <=> other.size if size != other.size

      each_with_index do |value, index|
        return value <=> other[index] if value != other[index]
      end

      0
    end

    # Returns true if the arrays size and values are equal.
    #
    # @param other [SortedArray] The other array to compare.
    # @return [Boolean] True if the arrays are equal, false otherwise.
    def ==(other)
      return false unless other.is_a?(SortedArray)

      size == other.size && each_with_index.all? { |value, index| value == other[index] }
    end

    # rubocop:disable Metrics/MethodLength

    # Returns elements from array at the specified index or range. Does not modify the array.
    #
    # If a single index is provided, returns the value at that index.
    #
    # If a range is provided, returns the values in that range.
    #
    # If a start index and length are provided, returns the values starting from the start index and
    # continuing for the given length.
    #
    # @param args [Integer, Range, Enumerator::ArithmeticSequence] The index or range of values to retrieve.
    # @return [Object, Array] The value or values at the specified index or range.
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
    alias [] slice
    # rubocop:enable Metrics/MethodLength

    # Calculates the set of unambiguous abbreviations for the strings in +self+.
    #
    #   require 'abbrev'
    #   SortedArray.new(%w{ car cone }).abbrev
    #   #=> {"car"=>"car", "ca"=>"car", "cone"=>"cone", "con"=>"cone", "co"=>"cone"}
    #
    # The optional +pattern+ parameter is a pattern or a string. Only input
    # strings that match the pattern or start with the string are included in the
    # output hash.
    #
    #   SortedArray.new(%w{ fast boat day }).abbrev(/^.a/)
    #   #=> {"fast"=>"fast", "fas"=>"fast", "fa"=>"fast", "day"=>"day", "da"=>"day"}
    #
    # @param pattern [Regexp, String] The pattern to match.
    # @return [Hash] The set of unambiguous abbreviations.
    # See also Abbrev.abbrev
    def abbrev(pattern = nil)
      to_a.abbrev(pattern)
    end

    # rubocop:disable Metrics/MethodLength

    # Adds a value to the sorted array.
    #
    # @param value [Object] The value to add.
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
      self
    end
    alias << add
    alias push add
    alias append add

    # rubocop:enable Metrics/MethodLength

    # Returns the first element in +self+ that is an +Array+ whose first element +==+ +obj+:
    #
    # @param obj [Object] The object to search for.
    # @return [Array] The first element in +self+ that is an +Array+ whose first element +==+ +obj+.
    def assoc(obj)
      index = bsearch_index { |x| x.is_a?(Array) && x.first >= obj }
      index.nil? ? nil : self[index]
    end

    # Returns the element at +Integer+ offset +index+; does not modify +self+.
    # If +index+ is negative, counts from the end of +self+.
    # Returns +nil+ if the +index+ is out of range.
    # Will raise +TypeError+ if the +index+ is not an +Integer+.
    #
    # @param index [Integer] The index of the value to retrieve.
    # @return [Object] The value at the specified index.
    def at(index)
      raise TypeError, "no implicit conversion of #{index.class} into Integer" unless index.is_a?(Integer)

      self[index.to_i]
    end

    # Returns an element from +self+ selected by a binary search.
    #
    # @yield [value] The block to search with.
    # @return [Object] The value selected by the binary search.
    def bsearch(&block)
      index_result = bsearch_index(&block)

      return nil if index_result.nil?

      self[index_result]
    end

    # Returns an index of an element from +self+ selected by a binary search.
    #
    # @yield [value] The block to search with.
    # @return [Integer] The index of the value selected by the binary search.
    def bsearch_index(&block)
      return nil if @maxes.empty?

      pos = @maxes.bsearch_index(&block)

      return nil if pos.nil?

      idx = @lists[pos].bsearch_index(&block)
      loc(pos, idx)
    end

    # Clears the sorted array, removing all values.
    #
    # @return [SortedArray] The cleared sorted array.
    def clear
      @lists.clear
      @maxes.clear
      @index.clear
      @offset = 0
      @size = 0
      self
    end

    # Calls the block, if given, with each element of +self+;
    # returns a new Array whose elements are the return values from the block.
    #
    # If no block is given, returns an Enumerator.
    #
    # @yield [value] The block to map with.
    # @return [Array, Enumerator] The mapped array.
    def map
      return to_enum(:map) unless block_given?

      new_values = []
      # rubocop:disable Style/MapIntoArray
      each { |value| new_values << yield(value) }
      # rubocop:enable Style/MapIntoArray
      # Experimitation shows that it's faster to add all values at once
      # rather than adding them one by one
      self.class.new(new_values, load_factor: @load_factor)
    end
    alias collect map

    # Calls the block, if given, with each element of +self+;
    # returns +self+ after the block has been executed.
    #
    # If no block is given, returns an Enumerator.
    #
    # @yield [value] The block to map with.
    # @return [SortedArray, Enumerator] The mapped array.
    def map!
      return to_enum(:map!) unless block_given?

      new_values = []
      # rubocop:disable Style/MapIntoArray
      each { |value| new_values << yield(value) }
      # rubocop:enable Style/MapIntoArray
      clear
      # Experimitation shows that it's faster to add all values at once
      # rather than adding them one by one
      update(new_values)
      self
    end
    alias collect! map!

    # rubocop:disable Naming/MethodParameterName

    # Calls the block, if given, with combinations of elements from +self+; returns +self+.
    # The order of combinations is indeterminate.
    #
    # When a block and an in-range positive Integer argument +n (0 < n <= self.size)+ are given,
    # calls the block with all n-tuple combinations of +self+.
    #
    # If no block is given, returns an Enumerator.
    #
    # @param n [Integer] The number of elements to combine.
    # @yield [value] The block to combine with.
    # @return [SortedArray, Enumerator] The combined array.
    def combination(n, &block)
      return to_enum(:combination, n) unless block_given?

      to_a.combination(n, &block)
    end

    # rubocop:enable Naming/MethodParameterName

    # Returns a new SortedArray containing of non-nil elements.
    #
    # @return [SortedArray] The compacted array.
    def compact
      new_instance = self.class.new
      new_instance.update(to_a.compact)
      new_instance
    end

    # Removes nil elements from the SortedArray.
    #
    # @return [SortedArray] +self+. The compacted array.
    def compact!
      values = to_a.compact
      clear
      update(values)
      self
    end

    # Adds the elements of one or more arrays to the SortedArray.
    #
    # @param other_arrays [Array] The arrays to concatenate.
    # @return [SortedArray] +self+. The SortedArray with the concatenated values.
    def concat(*other_arrays)
      other_arrays.each do |array|
        update(array)
      end
      self
    end

    # Returns the count of elements, based on an argument or block criterion, if given.
    # With no argument and no block given, returns the number of elements:
    # With argument object given, returns the number of elements that are == to object:
    # Uses binary search to find the first and last index of the value.
    #
    # @param value [Object] The value to count.
    # @yield [value] The block to count with.
    # @return [Integer] The count of elements.
    def count(value = nil)
      # If block is given, we call super to use the Enumerable#count method
      return super() if block_given?
      return @size unless value

      left_index = bisect_left(value)
      right_index = bisect_right(value)
      right_index - left_index
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

    # Deletes the value at the specified index.
    #
    # @param index [Integer] The index of the value to delete.
    def delete_at(index)
      return nil if index.abs >= @size

      pos, idx = pos(index)
      internal_delete(pos, idx)
    end

    # Removes each element from the array for which block evaluates to true.
    #
    # @yield [value] The block to delete with.
    # @return [SortedArray] +self+. The array with the deleted values.
    def delete_if
      return to_enum(:delete_if) unless block_given?

      to_delete = []
      each do |value|
        to_delete << value if yield(value)
      end
      to_delete.each { |value| delete(value) }
      self
    end

    # Finds and returns the object in nested objects that is specified by +index+ and +identifiers+.
    # The nested objects may be instances of various classes. See Dig methods.
    #
    # @param index [Integer] The index of the value to retrieve.
    # @param identifiers [Array] The identifiers to retrieve the value.
    # @return [Object] The value at the specified index.
    def dig(index, *identifiers)
      result = self[index]
      return nil if result.nil?

      identifiers.each do |identifier|
        raise TypeError, "#{result.class} does not have #dig method" unless result.respond_to?(:dig)

        # rubocop:disable Style/SingleArgumentDig
        result = result.dig(identifier)
        # rubocop:enable Style/SingleArgumentDig
        return nil if result.nil?
      end

      result
    end

    # rubocop:disable Naming/MethodParameterName

    # Returns a new SortedArray containing all but the first +n+ elements, where +n+ is a non-negative integer.
    # Does not modify the +self+.
    #
    # @param n [Integer] The number of elements to drop.
    # @return [SortedArray] The array with the dropped values.
    def drop(n)
      raise ArgumentError, "attempt to drop negative size" if n.negative?
      return self.class.new if n >= @size

      new_instance = self.class.new
      new_instance.update(to_a.drop(n))
      new_instance
    end

    # Returns a new SortedArray containing all but the first elements for which the block returns true.
    # Does not modify the +self+.
    # If no block is given, an Enumerator is returned instead.
    #
    # @yield [value] The block to drop with.
    # @return [SortedArray, Enumerator] The array with the dropped values.
    def drop_while
      return to_enum(:drop_while) unless block_given?

      self.class.new(super)
    end

    # rubocop:enable Naming/MethodParameterName

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
    # @param value [Object] The value to insert.
    # @return [Integer] The index to insert the value.
    def bisect_right(value)
      return 0 if @maxes.empty?

      pos = internal_bisect_right(@maxes, value)

      return @size if pos == @maxes.size

      idx = internal_bisect_right(@lists[pos], value)
      loc(pos, idx)
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity

    # Tries to match the behavior of Array#slice!
    #
    # @param args [Integer, Range, Enumerator::ArithmeticSequence] The index or range of values to retrieve.
    # @return [Object, Array] The value or values at the specified index or range.
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
      return nil if @size.zero?

      @lists.last.last
    end

    # Retrieves the first value in the sorted array.
    #
    # @return [Object] The first value in the array.
    def first
      return nil if @size.zero?

      @lists.first.first
    end

    # rubocop:disable Metrics/MethodLength

    # Pops the last value from the sorted array.
    #
    # @return [Object] The last value in the array.
    def pop
      return nil if @size.zero?

      value = @lists.last.pop
      if @lists.last.empty?
        @lists.pop
        @maxes.pop
        @index.clear
      else
        @maxes[-1] = @lists.last.last
      end
      @size -= 1
      value
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength

    # Shifts the first value from the sorted array.
    #
    # @return [Object] The first value in the array.
    def shift
      return nil if @size.zero?

      value = @lists.first.shift
      if @lists.first.empty?
        @lists.shift
        @maxes.shift
        @index.clear
      else
        @maxes[0] = @lists.first.first
      end
      @size -= 1
      value
    end
    # rubocop:enable Metrics/MethodLength

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

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize

    # Updates the sorted array with values from an iterable object.
    #
    # @param iterable [Enumerable] The iterable object to update the array with.
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
      @lists.flatten(1)
    end

    # Array is already sorted. Duplicates the sorted array and returns it.
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
      array.bsearch_index { |x| (x <=> value) >= 0 } || array.size
    end

    # Performs a right bisect on the array.
    #
    # @param array [Array] The array to bisect.
    # @param value [Object] The value to bisect with.
    # @return [Integer] The index where the value should be inserted.
    def internal_bisect_right(array, value)
      array.bsearch_index { |x| (x <=> value) == 1 } || array.length
    end

    # Gets the value at a given index. Supports negative indices.
    #
    # @param index [Integer] The index to get the value from.
    def get_value_at_index(index)
      return nil if index.abs >= @size

      # get index from pos
      index, sublist_index = pos(index)
      @lists[index][sublist_index]
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength

    # Gets values from a range.
    #
    # @param range [Range] The range to get values from.
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

    # rubocop:disable Metrics/MethodLength

    # Gets values from an arithmetic sequence.
    #
    # @param sequence [Enumerator::ArithmeticSequence] The arithmetic sequence to get values from.
    # @return [Array] The values from the arithmetic sequence.
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

    # rubocop:disable Metrics/MethodLength

    # Gets values starting from a given index and continuing for a given length.
    # Supports negative indices.
    #
    # @param start [Integer] The index to start from.
    # @param length [Integer] The length of the values to get.
    # @return [Array] The values starting from the given index and continuing for the given length.
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

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength

    # Expands a sublist if it exceeds the load factor.
    #
    # @param pos [Integer] The index of the sublist to expand.
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

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength

    # Deletes a value from a sublist.
    #
    # @param pos [Integer] The index of the sublist.
    # @param idx [Integer] The index of the value to delete.
    # @return [Object] The value that was deleted.
    def internal_delete(pos, idx)
      list = @lists[pos]
      value = list.delete_at(idx)
      @size -= 1

      len_list = list.length

      if len_list > (@load_factor >> 1)
        @maxes[pos] = list.last

        if @index.size.positive?
          child = @offset + pos
          while child.positive?
            @index[child] -= 1
            child = (child - 1) >> 1
          end
          @index[0] -= 1
        end
      elsif @lists.length > 1
        pos += 1 if pos.zero?

        prev = pos - 1
        @lists[prev].concat(list)
        @maxes[prev] = @lists[prev].last

        @lists.delete_at(pos)
        @maxes.delete_at(pos)
        @index.clear

        expand(prev)
      elsif len_list.positive?
        @maxes[pos] = list.last
      else
        @lists.delete_at(pos)
        @maxes.delete_at(pos)
        @index.clear
      end
      value
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity

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

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/CyclomaticComplexity

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

    # Turns a position and index into an absolute index.
    #
    # @param pos [Integer] The position in the index.
    # @param idx [Integer] The index in the sublist.
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
        total += @index[pos - 1] if pos.even?

        # Advance pos to the parent node.
        pos = (pos - 1) >> 1
      end

      total + idx
    end

    protected

    attr_accessor :lists, :maxes, :index, :offset, :load_factor

    attr_writer :size
  end
end
# rubocop:enable Metrics/ClassLength
