# frozen_string_literal: true

require "gruff"
require "csv"

# Read data from CSV
data = CSV.read("benchmark_results_init.csv", headers: true, converters: :numeric)

# Prepare data arrays
sizes = data["size"]
operations = {
  "initialize" => %w[init_sorted_set init_sorted_containers]
}

# Method to create and save a graph
# rubocop:disable Metrics/ParameterLists
def create_graph(title, _sizes, data1, data2, labels, file_name)
  g = Gruff::Line.new
  g.title = "#{title} performance"

  g.theme = Gruff::Themes::THIRTYSEVEN_SIGNALS

  # Set line colors
  g.colors = %w[#ff6600 #3333ff]

  # Define data
  g.data("C Implemented RB Tree", data1)
  g.data("SortedContainers::SortedSet", data2)

  # X-axis labels
  g.x_axis_label = "Number of operations"

  # Labels for x_axis
  g.labels = labels

  # Formatting y-axis to ensure no scientific notation, may need to adjust if log scale creates issues
  g.y_axis_label = "Time (seconds)"

  # Write the graph to a file
  g.write(file_name)
end
# rubocop:enable Metrics/ParameterLists

# Generate labels for x_axis, format numbers with commas
labels = {}
sizes.each_with_index do |size, index|
  labels[index] = size.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

# Generate a graph for each operation
operations.each do |operation, keys|
  puts "#{operation} #{keys}"
  create_graph(operation, sizes, data[keys[0]], data[keys[1]], labels,
               "#{operation.downcase}_performance_comparison.png")
end
