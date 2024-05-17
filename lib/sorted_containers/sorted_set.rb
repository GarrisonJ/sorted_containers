# frozen_string_literal: true

require "set"
require_relative "sorted_array"
require "forwardable"

# A module that provides sorted container data structures.
module SortedContainers
  # rubocop:disable Metrics/ClassLength

  # The SortedSet class is a sorted set implementation.
  class SortedSet
    include Enumerable
    extend Forwardable

    # Initializes a new instance of the SortedSet class.
    #
    # @param iterable [Array] The initial elements of the sorted set.
    # @param load_factor [Integer] The load factor for the sorted set.
    def initialize(iterable = [], load_factor: SortedArray::DEFAULT_LOAD_FACTOR)
      @set = Set.new(iterable)
      @list = SortedContainers::SortedArray.new(@set, load_factor: load_factor)
    end

    # Creates a new instance of the SortedSet class.
    #
    # @param args [Array] The initial elements of the sorted set.
    # @return [SortedSet] A new instance of the SortedSet class.
    def self.[](*args)
      new(args)
    end

    # @!method []
    #   @see SortedArray#[]
    # @!method to_a
    #   @see SortedArray#to_a
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
    def_delegators :@list,
                   :[],
                   :to_a,
                   :join,
                   :first,
                   :last,
                   :bisect_left,
                   :bisect_right

    # @!method ===
    #   @see Set#===
    # @!method classify
    #   @see Set#classify
    # @!method include?
    #   @see Set#include?
    # @!method member?
    #   @see Set#member?
    # @!method size
    #   @see Set#size
    # @!method length
    #   @see Set#length
    # @!method disjoint?
    #   @see Set#disjoint?
    # @!method divide
    #   @see Set#divide
    # @!method empty?
    #   @see Set#empty?
    # @!method to_set
    #   @see Set#to_set
    def_delegators :@set,
                   :===,
                   :classify,
                   :include?,
                   :member?,
                   :size,
                   :length,
                   :disjoint?,
                   :divide,
                   :empty?,
                   :to_set

    # @see Set#<=>
    def <=>(other)
      @set <=> other.set
    end

    # @see Set#==
    def ==(other)
      @set == other.set
    end

    # @see Set#intersect?
    def intersect?(other)
      @set.intersect?(other.set)
    end

    # @see Set#subset?
    def subset?(other)
      @set.subset?(other.set)
    end
    alias <= subset?

    # @see Set#superset?
    def superset?(other)
      @set.superset?(other.set)
    end
    alias >= superset?

    # @see Set#proper_subset?
    def proper_subset?(other)
      @set.proper_subset?(other.set)
    end
    alias < proper_subset?

    # @see Set#proper_superset?
    def proper_superset?(other)
      @set.proper_superset?(other.set)
    end
    alias > proper_superset?

    # @see Set#intersection
    def intersection(other)
      SortedSet.new(@set & other.set, load_factor: @list.load_factor)
    end
    alias & intersection

    # @see Set#union
    def union(other)
      SortedSet.new(@set + other.set, load_factor: @list.load_factor)
    end
    alias + union
    alias | union

    # @see Set#difference
    def difference(other)
      SortedSet.new(@set - other.set, load_factor: @list.load_factor)
    end
    alias - difference

    # @see Set#^
    def ^(other)
      SortedSet.new(@set ^ other.set, load_factor: @list.load_factor)
    end

    # Clears the sorted set. Removes all elements.
    # @return [SortedSet] The sorted set.
    def clear
      @set.clear
      @list.clear
      self
    end

    # @see Set#collect!
    def collect!
      return enum_for(:collect!) unless block_given?

      @list.collect! do |item|
        new_item = yield(item)
        @set.delete(item)
        @set.add(new_item)
        new_item
      end
      self
    end
    alias map! collect!

    # @see Set#add
    def add(item)
      return if @set.include?(item)

      @set.add(item)
      @list.add(item)
    end
    alias << add

    # @see Set#add?
    def add?(item)
      return false if @set.include?(item)

      @set.add(item)
      @list.add(item)
      self
    end

    # Returns a string representation of the sorted set.
    #
    # @return [String] A string representation of the sorted set.
    def to_s
      "#<SortedSet: {#{to_a.join(", ")}}>"
    end
    alias inspect to_s

    # @see Set#delete
    def delete(item)
      return self unless @set.include?(item)

      @set.delete(item)
      @list.delete(item)
      self
    end

    # @see Set#delete?
    def delete?(item)
      return unless @set.include?(item) # rubocop:disable Style/ReturnNilInPredicateMethodDefinition

      @set.delete(item)
      @list.delete(item)
      self
    end

    # @see Set#delete_if
    def delete_if
      return enum_for(:delete_if) unless block_given?

      @list.delete_if do |item|
        if yield(item)
          @set.delete(item)
          true
        else
          false
        end
      end
      self
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

    # @see Set#each
    def each(&block)
      return enum_for(:each) unless block_given?

      @list.each(&block)
      self
    end

    # @see Set#select!
    def select!
      return enum_for(:select!) unless block_given?

      @list.filter! do |item|
        if yield(item)
          @set.delete(item)
          true
        else
          false
        end
      end
      self
    end
    alias filter! select!

    # @see Set#flatten
    def flatten(level = 1)
      SortedSet.new(@list.flatten(level), load_factor: @list.load_factor)
    end

    # @see Set#flatten!
    def flatten!(level = 1)
      @set.clear
      @list.flatten!(level)
      @set.merge(@list)
      self
    end

    # @see Set#keep_if
    def keep_if
      return enum_for(:keep_if) unless block_given?

      @list.keep_if do |item|
        if yield(item)
          @set.delete(item)
          true
        else
          false
        end
      end
      self
    end

    # @see Set#merge
    def merge(other)
      @set.merge(other.set)
      @list.clear
      @list.update(@set)
      self
    end

    # rubocop:disable Metrics/MethodLength

    # @see Set#reject!
    def reject!
      return enum_for(:reject!) unless block_given?

      changed = false
      @list.reject! do |item|
        if yield(item)
          @set.delete(item)
          changed = true
          true
        else
          false
        end
      end
      changed ? self : nil
    end

    # rubocop:enable Metrics/MethodLength

    # @see Set#replace
    def replace(other)
      @set.replace(other.set)
      @list.clear
      @list.update(@set)
      self
    end

    # @see Set#reset
    def reset
      values = @list.to_a
      @set.clear
      @list.clear
      @set.merge(values)
      @list.update(values)
      self
    end

    # @see Set#subtract
    def subtract(other)
      @set.subtract(other.set)
      @list.clear
      @list.update(@set)
      self
    end

    protected

    attr_reader :set, :list
  end
  # rubocop:enable Metrics/ClassLength
end
