// use rayon::prelude::*;
use std::collections::HashSet;
use std::fs;

fn is_valid(seq: &str) -> bool {
    let len = seq.len();
    if len % 2 != 0 {
        return true;
    }

    let mid = len / 2;
    let (front, back) = seq.split_at(mid);

    front != back
}

fn _part1() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let rows = contents
        .trim()
        .split(',')
        .map(|seq| {
            let mut split = seq.split('-');
            let front: i64 = split.next().unwrap().parse().unwrap();
            let back: i64 = split.next().unwrap().parse().unwrap();
            front..=back
        })
        .collect::<Vec<_>>();
    println!("{rows:?}");
    let num: i64 = rows
        .iter()
        .flat_map(|range| {
            range.clone().flat_map(|num| {
                let mut invalid_nums = vec![];
                if !is_valid(&num.to_string()) {
                    invalid_nums.push(num);
                }
                invalid_nums
            })
        })
        .sum();
    println!("{num}");
}

fn part2() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let rows = contents
        .trim()
        .split(',')
        .map(|seq| {
            let mut split = seq.split('-');
            let front: i64 = split.next().unwrap().parse().unwrap();
            let back: i64 = split.next().unwrap().parse().unwrap();
            front..=back
        })
        .collect::<Vec<_>>();
    // println!("{rows:?}");
    let num: i64 = rows
        .iter()
        .flat_map(|range| {
            range.clone().flat_map(|num| {
                let mut invalid_nums = vec![];
                if !is_valid_part_2(&num.to_string()) {
                    invalid_nums.push(num);
                }
                invalid_nums
            })
        })
        .sum();
    println!("{num}");
}

// string how do I tell if a subsequence is repeated
// check each length up to mid
fn is_valid_part_2(seq: &str) -> bool {
    let len = seq.len();
    for sub_len in 1..=len / 2 {
        if len % sub_len != 0 {
            continue;
        }

        let chars = seq.chars().collect::<Vec<char>>();
        let set: HashSet<_> = chars.chunks(sub_len).collect();
        if set.len() == 1 {
            // println!("{sub_len} {set:?}");
            return false;
        }
    }
    true
}

fn main() {
    // let is_valid = is_valid_part_2("565656");
    // println!("{is_valid}");
    part2();
}
