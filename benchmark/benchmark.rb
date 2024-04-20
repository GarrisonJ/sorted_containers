# frozen_string_literal: true

require "benchmark"
require "sorted_set"
require_relative "../lib/sorted_containers/sorted_set"
require "csv"

sizes = [1_000_000, 2_000_000, 3_000_000, 4_000_000, 5_000_000]
results = []

Benchmark.bm(15) do |bm|
  sizes.each do |n|
    list = Array.new(n) { rand(0..n) }
    results_for_n = { size: n }

    # Benchmarking original SortedSet
    bm.report("SortedSet #{n}:") do
      sorted_set = SortedSet.new
      results_for_n[:add_sorted_set] = Benchmark.measure { list.each { |i| sorted_set.add(i) } }.real
      results_for_n[:include_sorted_set] = Benchmark.measure { list.each { |i| sorted_set.include?(i) } }.real
      # rubocop:disable Lint/EmptyBlock
      results_for_n[:loop_sorted_set] = Benchmark.measure { sorted_set.each { |i| } }.real
      # rubocop:enable Lint/EmptyBlock
      results_for_n[:delete_sorted_set] = Benchmark.measure { list.shuffle.each { |i| sorted_set.delete(i) } }.real
    end

    # Benchmarking custom SortedSet
    bm.report("SortedContainers #{n}:") do
      sorted_set = SortedContainers::SortedSet.new
      results_for_n[:add_sorted_containers] = Benchmark.measure { list.each { |i| sorted_set.add(i) } }.real
      results_for_n[:include_sorted_containers] = Benchmark.measure { list.each { |i| sorted_set.include?(i) } }.real
      # rubocop:disable Lint/EmptyBlock
      results_for_n[:loop_sorted_containers] = Benchmark.measure { sorted_set.each { |i| } }.real
      # rubocop:enable Lint/EmptyBlock
      results_for_n[:delete_sorted_containers] = Benchmark.measure do
        list.shuffle.each do |i|
          sorted_set.delete(i)
        end
      end.real
    end

    results << results_for_n
  end
end

# Export results to CSV for visualization
CSV.open("benchmark_results.csv", "wb") do |csv|
  csv << results.first.keys # Adds the headers
  results.each do |data|
    csv << data.values
  end
end
