# frozen_string_literal: true

module SortedContainers
  class Error < StandardError; end

  class SortedList
    DEFAULT_LOAD_FACTOR = 1000
  
    attr_reader :size
  
    def initialize(iterable = [])
      @lists = []
      @maxes = []
      @load_factor = DEFAULT_LOAD_FACTOR
      @size = 0
      update(iterable)
    end
  
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

    def <<(value)
      add(value)
    end
  
    def remove(value)
      i = bisect_left(@maxes, value)
      return if i == @maxes.size
  
      idx = @lists[i].index(value)
      raise "Value not found: #{value}" unless idx
  
      internal_delete(i, idx)
    end

    def [](index)
      raise "Index out of range" if index < 0 || index >= @size

      @lists.each do |sublist|
        if index < sublist.size
          return sublist[index]
        else
          index -= sublist.size
        end
      end
    end

    def delete_at(index)
      raise "Index out of range" if index < 0 || index >= @size

      @lists.each do |sublist|
        if index < sublist.size
          internal_delete(@lists.index(sublist), index)
          return
        else
          index -= sublist.size
        end
      end
    end

    def clear
      @lists.clear
      @maxes.clear
      @size = 0
    end

    def contains(value)
      i = bisect_left(@maxes, value)
      return false if i == @maxes.size

      sublist = @lists[i]
      idx = bisect_left(sublist, value)
      return idx < sublist.size && sublist[idx] == value
    end

    def to_a
      @lists.flatten
    end
  
    private
  
    def bisect_left(array, value)
      array.bsearch_index { |x| x >= value } || array.size
    end
  
    def bisect_right(array, value)
      array.bsearch_index { |x| x > value } || array.size
    end
  
    def expand(i)
      list = @lists[i]
      if list.size > (@load_factor * 2)
        half = list.slice!(@load_factor, list.size - @load_factor)
        @lists.insert(i + 1, half)
        @maxes[i] = @lists[i].last
        @maxes.insert(i + 1, half.last)
      end
    end
  
    def internal_delete(i, idx)
      @lists[i].delete_at(idx)
      if @lists[i].empty?
        @lists.delete_at(i)
        @maxes.delete_at(i)
      else
        @maxes[i] = @lists[i].last
      end
      @size -= 1
    end
  
    def update(iterable)
      iterable.each { |item| add(item) }
    end
  end
end
