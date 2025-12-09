use std::collections::HashMap;
use std::collections::HashSet;
use std::fs;

fn _part1() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let grid = contents
        .trim()
        .lines()
        .map(|line| line.chars().collect::<Vec<_>>())
        .collect::<Vec<_>>();

    let mut beams = HashSet::new();
    let initial_beam = grid
        .first()
        .unwrap()
        .iter()
        .position(|char| *char == 'S')
        .unwrap();
    beams.insert(initial_beam);

    let mut num_splits = 0;
    grid.iter().for_each(|row| {
        println!("{beams:?}");
        println!("{num_splits}");
        let splitters = row
            .iter()
            .enumerate()
            .filter(|(_idx, char)| **char == '^')
            .map(|(idx, _char)| idx)
            .collect::<HashSet<_>>();

        if splitters.is_empty() {
            return;
        }

        let mut unsplits = HashSet::new();
        let mut splits = HashSet::new();

        beams.iter().for_each(|beam| {
            if splitters.contains(beam) {
                splits.insert(*beam);
            } else {
                unsplits.insert(*beam);
            }
        });

        num_splits += splits.len();
        let new_beams = splits
            .into_iter()
            .flat_map(|split_point| vec![split_point - 1, split_point + 1])
            .collect::<HashSet<_>>();
        beams = unsplits
            .into_iter()
            .chain(new_beams.iter().cloned())
            .collect::<HashSet<_>>();
    });

    println!("{num_splits}");
}

fn _part2() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let grid = contents
        .trim()
        .lines()
        .map(|line| line.chars().collect::<Vec<_>>())
        .collect::<Vec<_>>();

    let mut beams = HashMap::new();
    let initial_beam = grid
        .first()
        .unwrap()
        .iter()
        .position(|char| *char == 'S')
        .unwrap();
    beams.insert(initial_beam, 1);

    let mut num_splits = 0;
    grid.iter().for_each(|row| {
        let splitters = row
            .iter()
            .enumerate()
            .filter(|(_idx, char)| **char == '^')
            .map(|(idx, _char)| idx)
            .collect::<HashSet<_>>();

        if splitters.is_empty() {
            return;
        }
        // println!("{beams:?}");

        let mut new_beams = HashMap::new();

        let mut new_timelines = 0_i64;
        beams.clone().into_iter().for_each(|(beam, count)| {
            if splitters.contains(&beam) {
                if let Some(existing) = new_beams.get(&(beam - 1)) {
                    new_beams.insert(beam - 1, *existing + count);
                } else {
                    new_beams.insert(beam - 1, count);
                }
                if let Some(existing) = new_beams.get(&(beam + 1)) {
                    new_beams.insert(beam + 1, *existing + count);
                } else {
                    new_beams.insert(beam + 1, count);
                }
                new_timelines += 2;
            } else {
                if let Some(existing) = new_beams.get(&beam) {
                    new_beams.insert(beam, *existing + count);
                } else {
                    new_beams.insert(beam, count);
                }
            }
        });
        beams = new_beams;
        println!("{:?}", beams);
        println!("{}", sum_map(&beams));
        num_splits += new_timelines;
    });

    println!("{:?}", beams);
    println!("{}", sum_map(&beams));
}

fn sum_map(map: &HashMap<usize, i64>) -> i64 {
    map.iter().map(|(_idx, ways)| ways).sum::<i64>()
}

fn main() {
    _part2();
}
