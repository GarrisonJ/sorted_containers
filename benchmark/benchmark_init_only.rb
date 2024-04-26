# frozen_string_literal: true

require "benchmark"
require "sorted_set"
require_relative "../lib/sorted_containers/sorted_set"
require "csv"

sizes = [1_000_000, 2_000_000, 3_000_000, 4_000_000, 5_000_000]
#sizes = [100_000, 200_000, 300_000, 400_000, 500_000]
#sizes = [10_000, 20_000, 30_000, 40_000, 50_000]
results = []
runs = 5

Benchmark.bm(15) do |bm|
  sizes.each do |n|
    # The items to be added to the set
    list_adds = (1..n).to_a.shuffle
    results_for_n = { size: n }

    # Benchmarking original SortedSet
    bm.report("SortedSet #{n}:") do
      total_time = {init: 0}
      runs.times do
        total_time[:init] += Benchmark.measure { SortedSet.new(list_adds) }.real
      end
      results_for_n[:init_sorted_set] = total_time[:init] / runs
    end

    # Benchmarking custom SortedSet
    bm.report("SortedContainers #{n}:") do
      total_time = {init: 0}
      runs.times do
        total_time[:init] += Benchmark.measure { SortedContainers::SortedSet.new(list_adds) }.real
      end
      results_for_n[:init_sorted_containers] = total_time[:init] / runs
    end
    results << results_for_n
  end
end

CSV.open("benchmark_results_init.csv", "wb") do |csv|
  csv << results.first.keys
  results.each do |result|
    csv << result.values
  end
end