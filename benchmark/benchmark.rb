# frozen_string_literal: true

require "benchmark"
require "sorted_set"
require_relative "../lib/sorted_containers/sorted_set"
require "csv"

sizes = [1_000_000, 2_000_000, 3_000_000, 4_000_000, 5_000_000]
# sizes = [100_000, 200_000, 300_000, 400_000, 500_000]
# sizes = [10_000, 20_000, 30_000, 40_000, 50_000]
results = []
runs = 5

Benchmark.bm(15) do |bm|
  sizes.each do |n|
    # The items to be added to the set
    list_adds = (1..n).to_a.shuffle
    results_for_n = { size: n }

    # Benchmarking original SortedSet
    bm.report("SortedSet #{n}:") do
      total_time = { initialize: 0, add: 0, include: 0, loop: 0, delete: 0 }
      runs.times do
        sorted_set = SortedSet.new
        total_time[:initialize] += Benchmark.measure { SortedSet.new(list_adds) }.real
        total_time[:add] += Benchmark.measure { list_adds.each { |i| sorted_set.add(i) } }.real
        total_time[:include] += Benchmark.measure do
          (1..n).map do
            rand((-0.5 * n).to_i..(n * 1.5).to_i)
          end.each { |i| sorted_set.include?(i) }
        end.real
        total_time[:loop] += Benchmark.measure { sorted_set.each { |i| } }.real
        total_time[:delete] += Benchmark.measure do
          list_adds.shuffle.each do |i|
            sorted_set.delete(i)
          end
        end.real
      end
      results_for_n[:initialize_sorted_set] = total_time[:initialize] / runs
      results_for_n[:add_sorted_set] = total_time[:add] / runs
      results_for_n[:include_sorted_set] = total_time[:include] / runs
      results_for_n[:loop_sorted_set] = total_time[:loop] / runs
      results_for_n[:delete_sorted_set] = total_time[:delete] / runs
    end

    # Benchmarking custom SortedSet
    bm.report("SortedContainers #{n}:") do
      total_time = { initialize: 0, add: 0, include: 0, loop: 0, delete: 0 }
      runs.times do
        sorted_set = SortedContainers::SortedSet.new
        total_time[:initialize] += Benchmark.measure { SortedContainers::SortedSet.new(list_adds) }.real
        total_time[:add] += Benchmark.measure { list_adds.each { |i| sorted_set.add(i) } }.real
        total_time[:include] += Benchmark.measure do
          (1..n).map do
            rand((-0.5 * n).to_i..(n * 1.5).to_i)
          end.each { |i| sorted_set.include?(i) }
        end.real
        total_time[:loop] += Benchmark.measure { sorted_set.each { |i| } }.real
        total_time[:delete] += Benchmark.measure do
          list_adds.shuffle.each do |i|
            sorted_set.delete(i)
          end
        end.real
      end
      results_for_n[:initialize_sorted_containers] = total_time[:initialize] / runs
      results_for_n[:add_sorted_containers] = total_time[:add] / runs
      results_for_n[:include_sorted_containers] = total_time[:include] / runs
      results_for_n[:loop_sorted_containers] = total_time[:loop] / runs
      results_for_n[:delete_sorted_containers] = total_time[:delete] / runs
    end
    results << results_for_n
  end
end

CSV.open("benchmark_results.csv", "wb") do |csv|
  csv << results.first.keys
  results.each do |result|
    csv << result.values
  end
end
