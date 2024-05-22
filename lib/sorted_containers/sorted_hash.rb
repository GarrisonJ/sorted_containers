# frozen_string_literal: true

require_relative "sorted_array"
require "forwardable"

# The SortedContainers module provides data structures for sorted collections.
module SortedContainers
  # rubocop:disable Metrics/ClassLength

  # The SortedHash class represents a sorted hash.
  class SortedHash
    include Enumerable
    extend Forwardable

    # Initializes a new instance of the SortedHash class.
    #
    # @param hash [Hash] The initial key-value pairs for the SortedHash.
    # @param default_value [Object] The default value for the SortedHash.
    # @param block [Proc] The block to call to calculate the default value.
    # @param load_factor [Integer] The load factor for the SortedHash.
    def initialize(default_value = nil, load_factor: SortedArray::DEFAULT_LOAD_FACTOR)
      raise ArgumentError, "cannot specify both default value and block" if !default_value.nil? && block_given?

      @internal_hash = if block_given?
                         Hash.new { |hash, key| hash[key] = yield(key) }
                       else
                         Hash.new(default_value)
                       end
      @sorted_array = SortedArray.new(@internal_hash.keys, load_factor: load_factor)
    end

    # Creates a new instance of the SortedHash class.
    #
    # @param args [Array] The initial key-value pairs for the SortedHash.
    # @return [SortedHash] A new instance of the SortedHash class.
    def self.[](*args)
      hash = new(nil)
      hash.merge!(Hash[*args])
    end

    # @!method join
    #   @see SortedArray#join
    # @!method first
    #   @see SortedArray#first
    # @!method last
    #   @see SortedArray#last
    # @!method bisect_left
    #   @see SortedArray#bisect_left
    # @!method bisect_right
    #   @see SortedArray#bisect_right
    def_delegators :@sorted_array,
                   :join,
                   :first,
                   :last,
                   :bisect_left,
                   :bisect_right

    # @!method keys
    #   @see Hash#keys
    def_delegator :@sorted_array, :keys, :to_a

    # @!method any?
    #   @see Hash#any?
    # @!method assoc
    #   @see Hash#assoc
    # @!method deconstruct_keys
    #   @see Hash#deconstruct_keys
    # @!method default
    #   @see Hash#default
    # @!method default=
    #   @see Hash#default=
    # @!method default_proc
    #   @see Hash#default_proc
    # @!method dig
    #   @see Hash#dig
    # @!method empty?
    #   @see Hash#empty?
    # @!method eql?
    #   @see Hash#eql?
    # @!method fetch
    #   @see Hash#fetch
    # @!method fetch_values
    #   @see Hash#fetch_values
    # @!method flatten
    #   @see Hash#flattens
    # @!method has_key?
    #   @see Hash#has_key?
    # @!method has_value?
    #   @see Hash#has_value?
    # @!method hash
    #   @see Hash#hash
    # @!method include?
    #   @see Hash#include?
    # @!method key?
    #   @see Hash#key?
    # @!method length
    #   @see Hash#length
    # @!method member?
    #   @see Hash#member?
    # @!method rassoc
    #   @see Hash#rassoc
    # @!method size
    #   @see Hash#size
    # @!method value?
    #   @see Hash#value?
    # @!method values
    #   @see Hash#values
    # @!method values_at
    #   @see Hash#values_at
    def_delegators :@internal_hash,
                   :any?,
                   :assoc,
                   :deconstruct_keys,
                   :default,
                   :default=,
                   :default_proc,
                   :default_proc=,
                   :dig,
                   :empty?,
                   :eql?,
                   :fetch,
                   :fetch_values,
                   :flatten,
                   :has_key?,
                   :has_value?,
                   :hash,
                   :include?,
                   :key?,
                   :length,
                   :member?,
                   :rassoc,
                   :size,
                   :value?,
                   :values,
                   :values_at

    # Retrieves the value associated with the specified key.
    #
    # @param key [Object] The key to retrieve the value for.
    # @return [Object] The value associated with the key, or nil if the key is not found.
    def [](key)
      @internal_hash[key]
    end

    # Associates the specified value with the specified key.
    # If the key already exists, the previous value will be replaced.
    #
    # @param key [Object] The key to associate the value with.
    # @param value [Object] The value to be associated with the key.
    # @return [Object] The value that was associated with the key.
    def []=(key, value)
      @sorted_array.delete(key) if @internal_hash.key?(key)
      @sorted_array.add(key)
      @internal_hash[key] = value
    end

    # @see Hash#<
    def <(other) = @internal_hash < other.internal_hash

    # @see Hash#<=
    def <=(other) = @internal_hash <= other.internal_hash

    # @see Hash#==
    def ==(other) = @internal_hash == other.internal_hash

    # @see Hash#>
    def >(other) = @internal_hash > other.internal_hash

    # @see Hash#>=
    def >=(other) = @internal_hash >= other.internal_hash

    # Clears the SortedHash. After this operation, the SortedHash will be empty.
    def clear
      @internal_hash.clear
      @sorted_array.clear
      self
    end

    # @see Hash#compact
    def compact
      new_hash = dup
      new_hash.compact!
      new_hash
    end

    # @see Hash#compact!
    def compact!
      return nil if @internal_hash.compact!.nil?

      @sorted_array.clear
      @sorted_array.update(@internal_hash.keys)
      self
    end

    # Deletes the key-value pair associated with the specified key.
    #
    # @param key [Object] The key to delete.
    # @return [void]
    def delete(key)
      return unless @internal_hash.key?(key)

      @internal_hash.delete(key)
      @sorted_array.delete(key)
    end

    # @see Hash#delete_if
    def delete_if(&block)
      return enum_for(:delete_if) unless block_given?

      @sorted_array.delete_if do |key|
        if block.call(key, @internal_hash[key])
          @internal_hash.delete(key)
          true
        else
          false
        end
      end
      self
    end

    # Deletes the key-value pair at the specified index and returns it as a two-element array.
    #
    # @param index [Integer] The index of the key-value pair to delete.
    # @return [Array] A two-element array containing the key and value of the deleted key-value pair.
    def delete_at(index)
      return nil if index.abs >= @sorted_array.size

      key = @sorted_array.delete_at(index)
      value = @internal_hash.delete(key)
      [key, value]
    end

    # Iterates over each key-value pair in the SortedHash.
    #
    # @yield [key, value] The block to be executed for each key-value pair.
    # @yieldparam key [Object] The key of the current key-value pair.
    # @yieldparam value [Object] The value of the current key-value pair.
    # @return [void]
    def each(&block)
      return enum_for(:each) unless block_given?

      @sorted_array.each do |key|
        value = @internal_hash[key]
        block.call(key, value)
      end
      self
    end
    alias each_pair each

    # @see Hash#each_key
    def each_key(&block)
      return enum_for(:each_key) unless block_given?

      @sorted_array.each(&block)
      self
    end

    # @see Hash#each_value
    def each_value(&block)
      return enum_for(:each_value) unless block_given?

      @sorted_array.each { |key| block.call(@internal_hash[key]) }
      self
    end

    # @see Hash#except
    def except(*keys)
      new_hash = dup
      new_hash.except!(*keys)
      new_hash
    end

    # @see Hash#except!
    def except!(*keys)
      keys.each do |key|
        @internal_hash.delete(key)
        @sorted_array.delete(key)
      end
      self
    end

    # @see Hash#filter
    def filter(&block)
      return enum_for(:filter) unless block_given?

      new_hash = dup
      new_hash.filter!(&block)
      new_hash
    end
    alias select filter

    # rubocop:disable Metrics/MethodLength

    # @see Hash#filter!
    def filter!
      return enum_for(:filter!) unless block_given?

      changed = false
      @sorted_array.filter! do |key|
        if yield(key, @internal_hash[key])
          true
        else
          @internal_hash.delete(key)
          changed = true
          false
        end
      end
      changed ? self : nil
    end
    alias select! filter!

    # rubocop:enable Metrics/MethodLength

    # Values must be comparable for this method to work.
    # @see Hash#invert
    def invert
      @internal_hash = @internal_hash.invert
      @sorted_array.clear
      @sorted_array.update(@internal_hash.keys)
      self
    end

    # @see Hash#keep_if
    def keep_if(&block)
      return enum_for(:keep_if) unless block_given?

      @sorted_array.keep_if do |key|
        if block.call(key, @internal_hash[key])
          true
        else
          @internal_hash.delete(key)
          false
        end
      end
      self
    end

    # @see Hash#key
    def key(value)
      @sorted_array.each do |key|
        return key if @internal_hash[key] == value
      end
      nil
    end

    # @see Hash#merge
    def merge(*other, &block)
      new_hash = dup
      new_hash.merge!(*other, &block)
      new_hash
    end

    # @see Hash#merge!
    def merge!(*other, &block)
      other.each do |other_hash|
        other_hash.each do |key, value|
          value = block.call(key, @internal_hash[key], value) if block_given? && @internal_hash.key?(key)
          @sorted_array.add(key) unless @internal_hash.key?(key)
          @internal_hash[key] = value
        end
      end
      self
    end
    alias update merge!

    # @see Hash#rehash
    # Also resorts the SortedHash.
    def rehash
      @internal_hash.rehash
      @sorted_array.sort!
      self
    end

    # @see Hash#reject
    def reject(&block)
      return enum_for(:reject) unless block_given?

      filter { |key, value| !block.call(key, value) }
    end

    # @see Hash#reject!
    def reject!(&block)
      return enum_for(:reject!) unless block_given?

      filter! { |key, value| !block.call(key, value) }
    end

    # @see Hash#replace
    def replace(other)
      @internal_hash.replace(other.internal_hash)
      @sorted_array.clear
      @sorted_array.update(@internal_hash.keys)
      self
    end

    # @see Hash#slice
    def slice(*keys)
      new_hash = self.class.new(@internal_hash.default, load_factor: @sorted_array.load_factor)
      keys.each do |key|
        new_hash[key] = @internal_hash[key] if @internal_hash.key?(key)
      end
      new_hash
    end

    # @see Hash#store
    def store(key, value)
      @sorted_array.add(key) unless @internal_hash.key?(key)
      @internal_hash[key] = value
    end

    # @see Hash#to_a
    # Returns in sorted order by key.
    def to_a
      @sorted_array.map { |key| [key, @internal_hash[key]] }
    end

    # @see Hash#to_h
    def to_h
      if block_given?
        @sorted_array.each_with_object({}) do |key, hash|
          key_value = yield(key, @internal_hash[key])
          hash[key_value.first] = key_value.last
        end
      else
        @internal_hash.dup
      end
    end

    # Converts SortedHash to a hash.
    def to_hash
      @internal_hash.dup
    end

    # @see Hash#to_proc
    def to_proc
      ->(key) { @internal_hash[key] }
    end

    # Returns a string representation of the SortedHash.
    #
    # @return [String] A string representation of the SortedHash.
    def to_s
      "SortedHash({#{keys.map { |key| "#{key}: #{self[key]}" }.join(", ")}})"
    end
    alias inspect to_s

    # @see Hash#transform_keys
    def transform_keys(&block)
      return enum_for(:transform_keys) unless block_given?

      new_hash = dup
      new_hash.transform_keys!(&block)
      new_hash
    end

    # @see Hash#transform_keys!
    def transform_keys!(&block)
      return enum_for(:transform_keys!) unless block_given?

      @internal_hash.transform_keys!(&block)
      @sorted_array.clear
      @sorted_array.update(@internal_hash.keys)
      self
    end

    # @see Hash#transform_values
    def transform_values(&block)
      return enum_for(:transform_values) unless block_given?

      new_hash = dup
      new_hash.transform_values!(&block)
      new_hash
    end

    # @see Hash#transform_values!
    def transform_values!(&block)
      return enum_for(:transform_values!) unless block_given?

      @internal_hash.transform_values!(&block)
      self
    end

    # Retrieves the first key-value pair from the SortedHash as a two-element array.
    #
    # @return [Array] A two-element array containing the key and value of the first key-value pair.
    def first
      return nil if @sorted_array.empty?

      key = @sorted_array.first
      [key, @internal_hash[key]]
    end

    # Removes the first key-value pair from the SortedHash and returns it as a two-element array.
    #
    # @return [Array] A two-element array containing the key and value of the first key-value pair.
    def last
      return nil if @sorted_array.empty?

      key = @sorted_array.last
      [key, @internal_hash[key]]
    end

    # Removes the last key-value pair from the SortedHash and returns it as a two-element array.
    #
    # @return [Array] A two-element array containing the key and value of the last key-value pair.
    def pop
      return nil if @sorted_array.empty?

      key = @sorted_array.pop
      value = @internal_hash.delete(key)
      [key, value]
    end

    # Removes the first key-value pair from the SortedHash and returns it as a two-element array.
    #
    # @return [Array] A two-element array containing the key and value of the first key-value pair.
    def shift
      return nil if @sorted_array.empty?

      key = @sorted_array.shift
      value = @internal_hash.delete(key)
      [key, value]
    end

    # Returns the number of key-value pairs in the SortedHash.
    #
    # @return [Integer] The number of key-value pairs.
    def bisect_left(key)
      @sorted_array.bisect_left(key)
    end

    # Returns the number of key-value pairs in the SortedHash.
    #
    # @return [Integer] The number of key-value pairs.
    def bisect_right(key)
      @sorted_array.bisect_right(key)
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
      @sorted_array.to_a.map { |key| @internal_hash[key] }
    end

    protected

    attr_reader :sorted_array, :internal_hash
  end
  # rubocop:enable Metrics/ClassLength
end
