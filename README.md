# SortedContainers

SortedContainers is a _fast_ implementation of sorted lists, sets, and dictionaries in pure Ruby. It is based on the [sortedcontainers](https://grantjenks.com/docs/sortedcontainers/) Python library by Grant Jenks.

SortedContainers provides three main classes: `SortedArray`, `SortedSet`, and `SortedHash`. Each class is a drop-in replacement for the corresponding Ruby class, but with the added benefit of maintaining the elements in sorted order.

SortedContainers exploits the fact that modern computers are really good at shifting elements around in memory. We sacrifice theroetical time complexity for practical performance. In practice, SortedContainers is _fast_.

## How it works

Computers are really good at shifting arrays around. For that reason, in practice it's often faster to keep an array sorted than to use the usual tree-based data structures.

For example, if you have the array `[1, 2, 4, 5]` and you want to insert the element `3`, you can simply shift `4, 5` to the right and insert `3` in the correct position. This is a `O(n)` operation, but it's fast.

But if we have a lot of elements we can do better by breaking up the array into smaller arrays. That way we don't have to shift so many elements whenever we insert. For example, if you have the array `[[1, 2], [4, 5]]` and you want to insert the element `3`, you can simply insert `3` into the first array. 

This often outperforms the more common tree-based data structures like red-black trees and AVL trees, which have `O(log n)` insertions and deletions. In practice, the `O(n)` insertions and deletions of SortedContainers are faster.

How big these smaller arrays should be is a trade-off. The default is set DEFAULT_LOAD_FACTOR = 1000. There is no perfect value and the ideal value will depend on your use case.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sorted_containers'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:
    
```bash
gem install sorted_containers
```

## Usage

```ruby
require 'sorted_containers'

# Create a new SortedArray
list = SortedContainers::SortedArray.new

# Add elements to the list
list << 3
list << 1
list << 2

# Access elements by index
puts list[0] # => 1
puts list[1] # => 2
puts list[2] # => 3

# Access elements by index
puts list.first # => 1
puts list.last # => 3

# Remove elements from the list
list.delete(2)

# Iterate over the list
list.each do |element|
  puts element
end

# Create a new SortedSet
set = SortedContainers::SortedSet.new

# Add elements to the set
set << 3
set << 1
set << 2

# Access elements by index
puts set[0] # => 1
puts set[1] # => 2
puts set[2] # => 3

# Access elements by index
puts set.first # => 1
puts set.last # => 3

# Remove elements from the set
set.delete(2)

# Iterate over the set
set.each do |element|
  puts element
end

# Create a new SortedHash
dict = SortedContainers::SortedHash.new

# Add elements to the dict
dict[3] = 'three'
dict[1] = 'one'
dict[2] = 'two'

# Access elements by key
puts dict[1] # => 'one'
puts dict[2] # => 'two'
puts dict[3] # => 'three'

# Access elements by index
puts dict.first # => [1, 'one']
puts dict.last # => [3, 'three']

# Remove elements from the dict
dict.delete(2)

# Iterate over the dict
dict.each do |key, value|
  puts "#{key}: #{value}"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/GarrisonJ/sorted_containers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/GarrisonJ/sorted_containers/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SortedContainers project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/GarrisonJ/sorted_containers/blob/main/CODE_OF_CONDUCT.md).
