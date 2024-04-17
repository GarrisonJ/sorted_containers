# frozen_string_literal: true

require_relative "sorted_containers/version"
require_relative "sorted_containers/sorted_list"
require_relative "sorted_containers/sorted_set"
require_relative "sorted_containers/sorted_dict"

module SortedContainers
  class Error < StandardError; end
end
