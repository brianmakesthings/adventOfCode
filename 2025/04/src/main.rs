// use rayon::prelude::*;
use std::collections::HashMap;
use std::fs;

fn _part1() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let rows = contents
        .trim()
        .lines()
        .map(|seq| seq.chars().collect::<Vec<char>>())
        .collect::<Vec<_>>();
    //println!("{rows:?}");

    let max_y = rows.len();
    let max_x = rows[0].len();

    let mut graph = HashMap::new();
    rows.iter().enumerate().for_each(|(y, col)| {
        col.iter().enumerate().for_each(|(x, val)| {
            graph.insert((x as i32, y as i32), *val);
        });
    });
    // println!("{graph:?}");

    let traversals: Vec<i32> = vec![-1, 0, 1];
    let mut dirs = vec![];
    for dx in traversals.clone() {
        for dy in traversals.clone() {
            if dx == 0 && dy == 0 {
                continue;
            }

            dirs.push((dx, dy));
        }
    }
    println!("{dirs:?}");

    let mut rolls = 0;
    for x in 0..max_x as i32 {
        for y in 0..max_y as i32 {
            let maybe_center = graph.get(&(x, y));
            if let Some('@') = maybe_center {
                let adjacent_rolls = dirs
                    .iter()
                    .filter_map(|(dx, dy)| {
                        let maybe_adj_cell = graph.get(&(x + dx, y + dy));
                        maybe_adj_cell.and_then(|adj_cell| match adj_cell {
                            '@' => Some(()),
                            _ => None,
                        })
                    })
                    .collect::<Vec<_>>()
                    .len();

                if adjacent_rolls < 4 {
                    rolls += 1;
                }
            }
        }
    }

    println!("{rolls}");
}

fn _part2() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let rows = contents
        .trim()
        .lines()
        .map(|seq| seq.chars().collect::<Vec<char>>())
        .collect::<Vec<_>>();
    //println!("{rows:?}");

    let max_y = rows.len();
    let max_x = rows[0].len();

    let mut graph = HashMap::new();
    rows.iter().enumerate().for_each(|(y, col)| {
        col.iter().enumerate().for_each(|(x, val)| {
            graph.insert((x as i32, y as i32), *val);
        });
    });
    // println!("{graph:?}");
    let mut prev_total_rolls = -1;
    let mut total_rolls = 0;
    let mut next_graph = graph;
    while total_rolls != prev_total_rolls {
        // println!("{next_graph:?}");
        let (add_rolls, new_graph) = remove_rolls(max_x as i32, max_y as i32, next_graph);
        prev_total_rolls = total_rolls;
        total_rolls += add_rolls;
        next_graph = new_graph;
    }

    println!("{total_rolls}");
}

fn remove_rolls(
    max_x: i32,
    max_y: i32,
    graph: HashMap<(i32, i32), char>,
) -> (i32, HashMap<(i32, i32), char>) {
    let traversals: Vec<i32> = vec![-1, 0, 1];
    let mut dirs = vec![];
    for dx in traversals.clone() {
        for dy in traversals.clone() {
            if dx == 0 && dy == 0 {
                continue;
            }

            dirs.push((dx, dy));
        }
    }

    let mut rolls = 0;
    let mut new_graph = graph.clone();
    for x in 0..max_x {
        for y in 0..max_y {
            let maybe_center = graph.get(&(x, y));
            if let Some('@') = maybe_center {
                let adjacent_rolls = dirs
                    .iter()
                    .filter_map(|(dx, dy)| {
                        let maybe_adj_cell = graph.get(&(x + dx, y + dy));
                        maybe_adj_cell.and_then(|adj_cell| match adj_cell {
                            '@' => Some(()),
                            _ => None,
                        })
                    })
                    .collect::<Vec<_>>()
                    .len();

                if adjacent_rolls < 4 {
                    new_graph.insert((x, y), 'x');
                    rolls += 1;
                }
            }
        }
    }

    (rolls, new_graph)
}

fn main() {
    _part2();
}
