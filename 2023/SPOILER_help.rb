def typed_process_stage(stage)
  _, *ranges = stage.split("\n")
  ranges.map do |line|
    destination_start, source_start, range = line.split(" ").map(&:to_i)
    start_destination_diff = source_start - destination_start
    { interval: (source_start..source_start + range - 1), offset: start_destination_diff }
  end.sort_by do |hash|
    hash[:interval].first
  end
end

def part2(data)
  seeds, *stages = data.split("\n\n")
  seed_nums = seeds.split(":").last.split(" ").map(&:to_i).each_slice(2).map do |start, range|
    # puts(start..start+range)
    (start..(start + range - 1))
  end
  # puts "seed nums processed"
  stage_pipeline = stages.map { |x| typed_process_stage(x) }
  seed_nums.map do |seed_range|
    resulting_ranges = [seed_range]
    stage_pipeline.each do |pipeline|
      # we want to find intervals such that seed_range.first < intervals < seed_range.last
      # we also want to subdivide the intervals into their own segments
      # then we need to transform them by the offset
      new_ranges = []
      resulting_ranges.each do |range|
        intervals = pipeline
          .filter { |candiate_range| candiate_range[:interval].last > range.first }
          .filter { |candiate_range| candiate_range[:interval].first < range.last }

        # binding.irb if intervals.length > 1

        if intervals.empty?
          new_ranges.push(range)
          next
        end

        no_offset_intervals = []

        if range.first < intervals[0][:interval].first
          no_offset_intervals.push(range.first..(intervals[0][:interval].first - 1))
        elsif intervals[0]
          intervals[0][:interval] = range.first..intervals[0][:interval].last
        end

        if range.last > intervals[-1][:interval].last
          no_offset_intervals.push((intervals[-1][:interval].last + 1)..range.last)
        elsif intervals[-1]
          intervals[-1][:interval] = intervals[-1][:interval].first..range.last
        end

        if intervals[0][:interval].first < range.first || intervals[-1][:interval].last > range.last
          binding.irb
        end

        inbetween_no_offset = (0...(intervals.size - 1)).map do |i|
          if intervals[i][:interval].last + 1 != intervals[i + 1][:interval].first
            intervals[i][:interval].last + 1..intervals[i + 1][:interval].first - 1
          end
        end.compact
        no_offset_intervals = no_offset_intervals.concat(inbetween_no_offset)

        # test that we cover the entire range
        expected_range = (range.first..range.last).size
        covered_range =
          intervals.map { |x| x[:interval] }.concat(no_offset_intervals).map(&:size).sum

        if expected_range != covered_range
          binding.irb
        end

        offset_intervals = intervals.map do |interval_hash|
          interval = interval_hash[:interval]
          offset = interval_hash[:offset]
          (interval.first - offset)..(interval.last - offset)
        end
        new_ranges.concat(no_offset_intervals.concat(offset_intervals).sort_by(&:first))
        # nil.panic
      end
      resulting_ranges = new_ranges.sort_by(&:first)
    end
    resulting_ranges
  end
end
