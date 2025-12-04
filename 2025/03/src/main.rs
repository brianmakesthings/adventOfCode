// use rayon::prelude::*;
// use std::collections::HashSet;
use std::fs;

fn _part1() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let rows = contents
        .trim()
        .lines()
        .map(|seq| {
            seq.chars()
                .map(|c| c.to_string().parse::<i64>().unwrap())
                .collect::<Vec<i64>>()
        })
        .collect::<Vec<_>>();
    println!("{rows:?}");

    let sum: i64 = rows.iter().map(|batteries| _max_combo(batteries)).sum();
    println!("{sum}");
}

fn _max_combo(batteries: &[i64]) -> i64 {
    let mut max = 0;
    let mut left: usize = 0;

    for right in 1..batteries.len() {
        let candidate = batteries[left] * 10 + batteries[right];
        if candidate > max {
            max = candidate;
        }

        if batteries[right] > batteries[left] {
            left = right;
        }
    }

    max
}

fn _part2() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let rows = contents
        .trim()
        .lines()
        .map(|seq| {
            seq.chars()
                .map(|c| c.to_string().parse::<i64>().unwrap())
                .collect::<Vec<i64>>()
        })
        .collect::<Vec<_>>();
    println!("{rows:?}");

    let sum: i64 = rows.iter().map(|batteries| _max_n(batteries, 0, 12)).sum();
    println!("{sum}");
}

fn _max_n(batteries: &Vec<i64>, start: usize, n: usize) -> i64 {
    if n == 0 {
        return 0;
    }
    // greedy
    let mut max_in_range = 0;
    let mut max_idx = start;

    for (i, num) in batteries
        .iter()
        .enumerate()
        .skip(start)
        .take(batteries.len() - (n - 1))
    {
        if *num > max_in_range {
            max_in_range = *num;
            max_idx = i;
        }
    }

    max_in_range * 10_i64.pow(u32::try_from(n).unwrap() - 1) + _max_n(batteries, max_idx + 1, n - 1)
}

fn main() {
    _part2();
    // let is_valid = is_valid_part_2("565656");
    // println!("{is_valid}");
    // part2();
}
