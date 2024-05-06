# frozen_string_literal: true

# The SortedContainers module provides data structures for sorted collections.
# rubocop:disable Metrics/ClassLength
require "English"
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
      @array_index = []
      @offset = 0
      @load_factor = load_factor
      @size = 0
      update(iterable)
    end

    # Returns a new SortedArray populated with the given objects.
    #
    # @param args [Array] The objects to populate the array with.
    # @return [SortedArray] The populated array.
    def self.[](*args)
      new(args)
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
    alias intersection &

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

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity

    # Removes elements from array at the specified index or range and returns them. Modifies the array.
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

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity

    # Sets the value at the specified index or range.
    #
    # If a single index is provided, sets the value at that index.
    #
    # If a range is provided, sets the values in that range.
    #
    # If a start index and length are provided, sets the values starting from the start index and
    # continuing for the given length.
    #
    # @overload []=(index, value)
    #   @param index [Integer] The index of the value to set.
    #   @param value [Object] The value to set.
    # @overload []=(range, value)
    #   @param range [Range] The range of values to set.
    #   @param value [Object] The value to set.
    # @overload []=(start, length, value)
    #   @param start [Integer] The index to start from.
    #   @param length [Integer] The length of the values to set.
    #   @param value [Object, Array] The value or values to set.
    # @return [Object, Array] The value or values at the specified index or range.
    def []=(*args)
      raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 2..3)" if args.size < 2

      value = args.pop
      case args.size
      when 1
        if args[0].is_a?(Integer)
          index = args[0]
          delete_at(index)
          add(value)
        elsif args[0].is_a?(Range)
          range = args[0]
          values = get_values_from_range(range)
          values.each { |val| delete(val) }
          if value.is_a?(Array)
            value.each { |val| add(val) }
          else
            add(value)
          end
        else
          raise TypeError, "no implicit conversion of #{args[0].class} into Integer"
        end
      when 2
        start, length = args
        values = get_values_from_start_and_length(start, length)
        values.each { |val| delete(val) }
        add(value)
      else
        raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 2..3)"
      end
    end

    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity

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
      @lists.map(&:clear)
      @lists.clear
      @maxes.clear
      @array_index.clear
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

    # rubocop:enable Naming/MethodParameterName

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

    # Iterates over each value in the sorted array.
    #
    # @yield [value] Gives each value to the block.
    # @return [Enumerator] If no block is given, an Enumerator is returned.
    def each(&block)
      return to_enum(:each) unless block_given?

      @lists.each do |sublist|
        sublist.each(&block)
      end
    end

    # Iterates over each index in the sorted array.
    #
    # @yield [index] Gives each index to the block.
    # @return [Enumerator] If no block is given, an Enumerator is returned.
    def each_index(&block)
      return to_enum(:each_index) unless block_given?

      0.upto(@size - 1, &block)
    end

    # Checks if Array is empty
    #
    # @return [Boolean]
    def empty?
      @size.zero?
    end

    # Returns +true+ if +self+ and +other+ are the same size,
    # and if, for each index +i+ in +self+, +self[i].eql? other[i]+
    #
    # This method is different from method +SortedArray#==+,
    # which compares using method +Object#==+
    #
    # @param other [SortedArray] The other array to compare.
    # @return [Boolean] True if the arrays are equal, false otherwise.
    def eql?(other)
      return false unless other.is_a?(SortedArray)

      size == other.size && each_with_index.all? { |value, index| value.eql?(other[index]) }
    end

    # Returns the element at the specified index, or returns a default value if the index is out of range.
    # Raises an IndexError if the index is out of range and no default is given.
    # If a block is given, it is called with the index. The block will supplant the default value if both are given.
    #
    # @param index [Integer] The index of the value to retrieve.
    # @param args [Object] The default value to return if the index is out of range.
    def fetch(index, *args)
      return self[index] if index.abs < @size

      return yield(index) if block_given?

      return args[0] if args.size.positive?

      raise IndexError, "index #{index} outside of array bounds: #{-size}...#{size}"
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength

    # Fills the array with the given value.
    #
    # @overload fill(value)
    #   @param value [Object] The value to fill the array with.
    # @overload fill(value, start)
    #   @param value [Object] The value to fill the array with.
    #   @param start [Integer] The index to start filling from.
    # @overload fill(value, start, length)
    #   @param value [Object] The value to fill the array with.
    #   @param start [Integer] The index to start filling from.
    #   @param length [Integer] The length of the values to fill.
    # @overload fill(value, range)
    #   @param value [Object] The value to fill the array with.
    #   @param range [Range] The range of values to fill.
    # # Overload for if block given
    # @overload fill
    #   @yield [index] The block to fill with.
    # @overload fill(start)
    #   @param start [Integer] The index to start filling from.
    #   @yield [index] The block to fill with.
    # @overload fill(start, length)
    #   @param start [Integer] The index to start filling from.
    #   @param length [Integer] The length of the values to fill.
    #   @yield [index] The block to fill with.
    # @overload fill(range)
    #   @param range [Range] The range of values to fill.
    #   @yield [index] The block to fill with.
    # @return [SortedArray] +self+. The filled array.
    def fill(*args, &block)
      unless block_given?
        value = args.shift
        block = proc { value }
      end

      case args.size
      when 0
        fill_range_unsafe(0..@size - 1, block)
      when 1
        if args[0].is_a?(Integer)
          start = args[0]
          start += @size if start.negative?
          fill_range_unsafe(start..@size - 1, block)
        elsif args[0].is_a?(Range)
          fill_range_unsafe(args[0], block)
        end
      when 2
        start, length = args
        start += @size if start.negative?
        fill_range_unsafe(start...(start + length), block)
      end

      sort! # resort will re-initialize the index and maxes
      self
    end

    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength

    # Calls the block, if given, with each element of +self+;
    # returns a new SortedArray containing those elements of +self+
    # for which the block returns a truthy value.
    #
    # If no block is given, an Enumerator is returned instead.
    #
    # @yield [value] The block to filter with.
    # @return [SortedArray, Enumerator] The filtered array.
    def select
      return to_enum(:select) unless block_given?

      new_values = []
      each do |value|
        new_values << value if yield(value)
      end
      self.class.new(new_values, load_factor: @load_factor)
    end
    alias filter select

    # Calls the block, if given, with each element of +self+;
    # returns +self+ with the elements for which the block returns a truthy value.
    #
    # If no block is given, returns an Enumerator.
    #
    # @yield [value] The block to filter with.
    # @return [SortedArray, Enumerator] The filtered array.
    def select!
      return to_enum(:select!) unless block_given?

      indexes_to_delete = []
      each_with_index do |value, index|
        indexes_to_delete << index unless yield(value)
      end
      indexes_to_delete.reverse.each { |index| delete_at(index) }
      self
    end
    alias filter! select!

    # Returns the first index of the value in the sorted array, or returns
    # the first index that returns true when passed to the block.
    #
    # This method will binary search if value is given,
    # if a block is given, it will iterate through the array.
    #
    # @overload find_index(value)
    #   @param value [Object] The value to find.
    # @overload find_index
    #   @yield [value] The block to find with.
    # @return [Integer] The index of the value.
    def find_index(value = nil)
      return nil if @size.zero?

      if block_given?
        each_with_index { |val, idx| return idx if yield(val) }
        nil
      else
        bsearch_index { |val| val >= value }
      end
    end
    alias index find_index

    # Retrieves the first value in the sorted array.
    #
    # @return [Object] The first value in the array.
    def first
      return nil if @size.zero?

      @lists.first.first
    end

    # Returns a new SortedArray that is a recursive flattening of the array.
    #
    # Each non-array element is unchanged, and each array element is recursively flattened.
    # When the optional level argument is given, the recursion is limited to that level.
    #
    # @param level [Integer] The level to flatten to.
    # @return [SortedArray] The flattened array.
    def flatten(level = nil)
      new_instance = self.class.new
      new_instance.update(to_a.flatten(level))
      new_instance
    end

    # Flattens the array in place.
    #
    # Each non-array element is unchanged, and each array element is recursively flattened.
    # When the optional level argument is given, the recursion is limited to that level.
    #
    # @param level [Integer] The level to flatten to.
    # @return [SortedArray] +self+. The flattened array.
    def flatten!(level = nil)
      values = to_a.flatten(level)
      clear
      update(values)
      self
    end

    # Returns the integer hash value for the sorted array.
    # Two arrays with the same content will have the same hash value.
    #
    # @return [Integer] The hash value.
    def hash
      @lists.hash
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

    # Returns a string representation of the sorted array.
    #
    # @return [String] A string representation of the sorted array.
    def inspect
      "#<#{self.class} size=#{@size} array_index=#{@array_index} " \
        "offset=#{@offset} maxes=#{@maxes} items=#{to_a.inspect}>"
    end

    # Returns +true+ if the SortedArray and +other+ have at least one element in common, otherwise returns +false+
    # Elements are compared using +eql?+
    #
    # @param other [SortedArray] The other array to compare.
    # @return [Boolean] +true+ if the array and +other+ have at least one element in common, otherwise +false+
    def intersect?(other)
      each do |value|
        return true if other.include_eql?(value)
      end
      false
    end

    # Returns a +String+ formed by joining each element of the array with the given separator.
    #
    # @param separator [String] The separator to join the elements with.
    # @return [String] The joined string.
    def join(separator = $OUTPUT_FIELD_SEPARATOR)
      to_a.join(separator)
    end

    # Retains those elements for which the block returns a truthy value; deletes all other elements; returns +self+
    #
    # Returns an Enumerator if no block is given.
    #
    # @yield [value] The block to keep with.
    # @return [SortedArray, Enumerator] The array with the kept values.
    def keep_if
      return to_enum(:keep_if) unless block_given?

      (@size - 1).downto(0) do |index|
        delete_at(index) unless yield(self[index])
      end
      self
    end

    # Retrieves the last value in the sorted array.
    #
    # @return [Object] The last value in the array.
    def last
      return nil if @size.zero?

      @lists.last.last
    end

    # Replaces the contents of +self+ with the contents of +other+.
    #
    # @param other [SortedArray] The other array to replace with.
    # @return [SortedArray] +self+. The replaced array.
    def replace(other)
      @lists = other.lists.map(&:dup)
      @maxes = other.maxes.dup
      @array_index = other.array_index.dup
      @offset = other.offset
      @load_factor = other.load_factor
      @size = other.size
      self
    end

    # Returns a string representation of the sorted array.
    #
    # @return [String] A string representation of the sorted array.
    def to_s
      "SortedArray(#{to_a})"
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

    # Shifts the first value from the sorted array.
    #
    # @return [Object] The first value in the array.
    def shift
      return nil if @size.zero?

      value = @lists.first.shift
      if @lists.first.empty?
        @lists.shift
        @maxes.shift
        @array_index.clear
      else
        @maxes[0] = @lists.first.first
      end
      @size -= 1
      value
    end
    # rubocop:enable Metrics/MethodLength

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
      @array_index.clear
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    # Converts the sorted array to an array.
    #
    # @return [Array] An array representation of the sorted array.
    def to_a
      @lists.flatten(1)
    end

    # Creates a new SortedArray and resorts the values.
    # Usefull when the values are modified and the array needs to be resorted.
    #
    # @return [SortedArray] The sorted array.
    def sort
      values = to_a
      self.class.new(values, load_factor: @load_factor)
    end

    # Resorts the values in the array.
    # Usefull when the values are modified and the array needs to be resorted.
    #
    # @return [SortedArray] The sorted array.
    def sort!
      values = to_a
      clear
      update(values)
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
      new_instance.array_index = @array_index.dup
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

    # Returns a 2-element array containing the minimum and maximum values in the sorted array.
    # If a block is given, the result of the block is computed for each value in the array,
    # and the minimum and maximum values are computed from the result.
    #
    # @yield [value] The block to compute with.
    # @return [Array] A 2-element array containing the minimum and maximum values.
    def minmax
      if block_given?
        each.reduce([nil, nil]) do |(min_value, max_value), value|
          min_value = value if min_value.nil? || yield(value, min_value).negative?
          max_value = value if max_value.nil? || yield(value, max_value).positive?
          [min_value, max_value]
        end
      else
        [min, max]
      end
    end

    # Packs the values in the array into a binary sequence.
    # @see Array#pack
    #
    # @param template [String] The template to pack the values with.
    # @param buffer [String] The buffer to pack the values into.
    # @return [String] The packed values.
    def pack(template, buffer: nil)
      to_a.pack(template, buffer: buffer)
    end

    # rubocop:disable Naming/MethodParameterName
    # rubocop:disable Metrics/MethodLength

    # Pops the last value from the sorted array.
    #
    # @param n [Integer] The number of values to pop.
    # @return [Object] The last value in the array.
    def pop(n = nil)
      return nil if @size.zero?

      if n.nil?
        index = @size - 1
        delete_at(index)
      else
        values = []
        n.times do
          return values if @size.zero?

          index = @size - 1
          values.prepend(delete_at(index))
        end
        values
      end
    end

    # rubocop:enable Naming/MethodParameterName
    # rubocop:enable Metrics/MethodLength

    # Computes and returns or yields all combinations of elements from all the Arrays,
    # including both +self+ and +other_arrays+.
    #
    # @param other_arrays [SortedArray] The arrays to combine with.
    # @yield [value] The block to combine with.
    # @return [SortedArray] The combined array.
    def product(*other_arrays, &block)
      arrays = other_arrays.map(&:to_a)
      self.class.new(
        to_a.product(*arrays, &block),
        load_factor: @load_factor
      )
    end

    # Returns the first element in +self+ that is an +Array+ whose second element +==+ +obj+:
    #
    # Time complexity: O(n)
    #
    # @param obj [Object] The object to search for.
    # @return [Array] The first element in +self+ that is an +Array+ whose second element +==+ +obj+.
    def rassoc(obj)
      index = find_index { |x| x.is_a?(Array) && x[1] >= obj }
      index.nil? ? nil : self[index]
    end

    # Returns a new SortedArray whose elements are all those from +self+ for which the block returns false or nil.
    #
    # Returns an Enumerator if no block is given.
    #
    # @yield [value] The block to reject with.
    # @return [SortedArray, Enumerator] The rejected array.
    def reject
      return to_enum(:reject) unless block_given?

      select { |value| !yield(value) }
    end

    # Deletes every element of +self+ for which block evaluates to true.
    #
    # Returns +self+ if any changes were made, otherwise returns +nil+.
    #
    # Returns an Enumerator if no block is given.
    #
    # @yield [value] The block to reject with.
    # @return [SortedArray, Enumerator] The rejected array.
    def reject!
      return to_enum(:reject!) unless block_given?

      indexes_to_delete = []
      each_with_index do |value, index|
        indexes_to_delete << index if yield(value)
      end
      return nil if indexes_to_delete.empty?

      indexes_to_delete.reverse.each { |index| delete_at(index) }
      self
    end

    # Iterates over the sorted array in reverse order.
    #
    # @yield [value] Gives each value to the block.
    # @return [Enumerator] If no block is given, an Enumerator is returned.
    def reverse_each(&block)
      return to_enum(:reverse_each) unless block_given?

      @lists.reverse_each do |sublist|
        sublist.reverse_each(&block)
      end
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity

    # Returns the index of the last element for which object +==+ element.
    #
    # Returns an Enumerator if no block or value is given.
    #
    # When a block is given but no value, the block is used to find the last element.
    #
    # @overload rindex(value)
    #   @param value [Object] The value to find.
    # @overload rindex
    #   @yield [value] The block to find with.
    # @return [Integer] The index of the value.
    def rindex(value = nil)
      return to_enum(:rindex, value) unless block_given? || value
      return nil if @size.zero?

      if value.nil?
        reverse_each.with_index do |val, idx|
          return @size - idx - 1 if yield(val)
        end
        nil
      else
        warn "given block not used" if block_given?
        index = bisect_right(value)
        self[index - 1] == value ? index - 1 : nil
      end
    end

    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity

    # rubocop:disable Naming/MethodParameterName

    # Returns random elements from +self+.
    #
    # If +n+ is given, returns an array of +n+ random elements.
    # If +n+ is not given, returns a single random element.
    #
    # @param n [Integer] The number of random elements to return.
    # @param random [Random] The random number generator to use.
    # @return [Object, Array] The random element(s).
    def sample(n = nil, random: Random)
      return nil if @size.zero?

      if n.nil?
        index = random.rand(@size)
        self[index]
      else
        raise ArgumentError, "negative sample number" if n.negative?

        n.times.map { self[random.rand(@size)] }
      end
    end

    # rubocop:enable Naming/MethodParameterName

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

    # Updates the index within the range with the block.
    # Does not update index or maxes. Distrupts the sorted order.
    #
    # @param range [Range] The range to update.
    # @param block [Proc] The block that takes the index and returns the value.
    def fill_range_unsafe(range, block)
      range.each { |index| internal_change_unsafe(index, block.call(index)) }
    end

    # Updates the element at index with the value.
    # Does not update index or maxes. Distrupts the sorted order.
    #
    # @param index [Integer] The index of the value to update.
    # @param value [Object] The value to update.
    def internal_change_unsafe(index, value)
      pos, idx = pos(index)
      @lists[pos][idx] = value
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
        @array_index.clear
      elsif @array_index.size.positive?
        child = @offset + pos
        while child.positive?
          @array_index[child] += 1
          child = (child - 1) >> 1
        end
        @array_index[0] += 1
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

        if @array_index.size.positive?
          child = @offset + pos
          while child.positive?
            @array_index[child] -= 1
            child = (child - 1) >> 1
          end
          @array_index[0] -= 1
        end
      elsif @lists.length > 1
        pos += 1 if pos.zero?

        prev = pos - 1
        @lists[prev].concat(list)
        @maxes[prev] = @lists[prev].last

        @lists.delete_at(pos)
        @maxes.delete_at(pos)
        @array_index.clear

        expand(prev)
      elsif len_list.positive?
        @maxes[pos] = list.last
      else
        @lists.delete_at(pos)
        @maxes.delete_at(pos)
        @array_index.clear
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
    #     @array_index = [14, 5, 9, 3, 2, 4, 5]
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
        @array_index = row0
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
        @array_index = row1 + row0
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
      tree.reverse_each { |level| @array_index.concat(level) }
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

      build_index if @array_index.empty?

      pos = 0
      child = 1
      len_index = @array_index.size

      while child < len_index
        index_child = @array_index[child]

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

      build_index if @array_index.empty?

      # Increment pos to point in the index to @lists[pos].size.
      total = 0

      pos += @offset

      # Iterate until reaching the root of the index tree at pos = 0.
      while pos.positive?

        # Right-child nodes are at even indices. At such indices
        # account the total below the left child node.
        total += @array_index[pos - 1] if pos.even?

        # Advance pos to the parent node.
        pos = (pos - 1) >> 1
      end

      total + idx
    end

    protected

    # Checks if the sorted array includes a value using eql?.
    #
    # @param value [Object] The value to check.
    # @return [Boolean] True if the value is found, false otherwise.
    def include_eql?(value)
      index = find_index(value)
      index ? self[index].eql?(value) : false
    end

    attr_accessor :lists, :maxes, :array_index, :offset, :load_factor

    attr_writer :size
  end
end
# rubocop:enable Metrics/ClassLength
