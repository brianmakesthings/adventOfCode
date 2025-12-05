use std::fs;

fn _part1() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let params = contents.trim().split("\n\n").collect::<Vec<_>>();

    let fresh_ranges = params[0]
        .trim()
        .lines()
        .map(|range_str| {
            let split = range_str.split('-').collect::<Vec<_>>();
            let start = split[0].parse::<i64>().unwrap();
            let end = split[1].parse::<i64>().unwrap();
            start..=end
        })
        .collect::<Vec<_>>();

    println!("{params:?}");

    let item_ids = params[1]
        .trim()
        .lines()
        .map(|id| id.parse::<i64>().unwrap())
        .collect::<Vec<i64>>();

    let mut fresh_count = 0;

    for id in &item_ids {
        if fresh_ranges.iter().any(|range| range.contains(id)) {
            fresh_count += 1;
        };
    }

    println!("{fresh_count:?}");
}

fn _part2() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let params = contents.trim().split("\n\n").collect::<Vec<_>>();

    let mut fresh_ranges = params[0]
        .trim()
        .lines()
        .map(|range_str| {
            let split = range_str.split('-').collect::<Vec<_>>();
            let start = split[0].parse::<i64>().unwrap();
            let end = split[1].parse::<i64>().unwrap();
            (start, end)
        })
        .collect::<Vec<_>>();

    println!("presort: {fresh_ranges:?}");

    fresh_ranges.sort_by(|a, b| a.0.cmp(&b.0));

    println!("post sort; {fresh_ranges:?}");

    let combined_ranges: Vec<(i64, i64)> = fresh_ranges.iter().fold(Vec::new(), |mut acc, val| {
        let maybe_last_range = acc.pop();
        match maybe_last_range {
            Some(last_range) => {
                if val.0 > last_range.1 {
                    acc.push(last_range);
                    acc.push(*val);
                } else {
                    // hehe forgot overlapping windows
                    acc.push((last_range.0, val.1.max(last_range.1)));
                }
            }
            None => {
                acc.push(*val);
            }
        }
        acc
    });
    println!("{combined_ranges:?}");

    let mut last = (0, 0);
    for range in combined_ranges.clone() {
        assert!(range.0 > last.1);
        last = range;
    }
    println!("validated");

    let count: i64 = combined_ranges
        .iter()
        .map(|r| {
            let nums = r.1 - r.0 + 1;
            println!("{nums}");
            nums
        })
        .sum();

    println!("Total Count: {count}");
}

fn main() {
    _part2();
}
