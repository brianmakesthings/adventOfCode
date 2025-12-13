use std::collections::HashMap;
use std::collections::HashSet;
use std::fs;

type Point = (i64, i64, i64);

#[derive(Debug)]
struct DisjointSet {
    parents: HashMap<Point, Point>,
}

// probs could use path compression
impl DisjointSet {
    fn find(&self, point: Point) -> Point {
        // kinda gross, think about how to make it prettier
        if let Some(parent) = self.parents.get(&point) {
            if *parent == point {
                return point;
            }
            let ultimate_parent = self.find(*parent);
            return ultimate_parent;
        } else {
            return point;
        }
    }

    fn union(&mut self, point1: Point, point2: Point) {
        let parent1 = self.find(point1);
        let parent2 = self.find(point2);
        if parent1 != parent2 {
            self.parents.insert(parent1, parent2);
            self.parents.insert(parent2, parent2);
        }
    }

    fn materialize(&self) -> Vec<HashSet<Point>> {
        let mut sets: HashMap<Point, HashSet<Point>> = HashMap::new();
        for point in self.parents.keys() {
            let parent = self.find(*point);
            if let Some(set) = sets.get_mut(&parent) {
                set.insert(*point);
            } else {
                sets.insert(parent, HashSet::from([*point]));
            }
        }

        sets.into_values().collect()
    }
}

fn _part1() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let points = contents
        .trim()
        .lines()
        .map(|line| {
            let mut nums_iter = line
                .split(',')
                .map(|num| num.trim().parse::<i64>().unwrap());
            (
                nums_iter.next().unwrap(),
                nums_iter.next().unwrap(),
                nums_iter.next().unwrap(),
            )
        })
        .collect::<Vec<_>>();

    println!("{points:?}\n");

    let mut distances: Vec<(f64, (Point, Point))> = vec![];
    for i in 0..points.len() {
        for j in i + 1..points.len() {
            let point1 = points[i];
            let point2 = points[j];
            distances.push((distance(point1, point2), (point1, point2)));
        }
    }

    distances.sort_by(|dist0, dist1| dist0.0.total_cmp(&dist1.0));
    // println!("{distances:?}\n");

    // distances are edges and weights
    let mut set = DisjointSet {
        parents: HashMap::new(),
    };
    // let mut circuits: HashMap<Point, HashSet<Point>> = HashMap::new();
    let max_connections = 1000;
    let mut connections = 0;
    for (_distance, (point1, point2)) in distances {
        if connections == max_connections {
            break;
        }
        let set1 = set.find(point1);
        let set2 = set.find(point2);
        if set1 != set2 {
            set.union(set1, set2);
        }
        connections += 1;
        println!("{point1:?} {point2:?}");
        let materialized_sets = set.materialize();
        println!(
            "{:?}",
            materialized_sets
                .iter()
                .map(|set| set.len())
                .collect::<Vec<_>>()
        );
    }

    let materialized_sets = set.materialize();
    println!(
        "{:?}",
        materialized_sets
            .iter()
            .map(|set| set.len())
            .collect::<Vec<_>>()
    );

    let mut set_sizes = materialized_sets
        .iter()
        .map(|set| set.len())
        .collect::<Vec<usize>>();

    set_sizes.sort();
    set_sizes.reverse();

    let result = set_sizes.into_iter().take(3).reduce(|a, b| a * b).unwrap();
    println!("{result}");
}

fn distance(point1: Point, point2: Point) -> f64 {
    (((point1.0 - point2.0).pow(2) + (point1.1 - point2.1).pow(2) + (point1.2 - point2.2).pow(2))
        as f64)
        .sqrt()
}

fn _part2() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let points = contents
        .trim()
        .lines()
        .map(|line| {
            let mut nums_iter = line
                .split(',')
                .map(|num| num.trim().parse::<i64>().unwrap());
            (
                nums_iter.next().unwrap(),
                nums_iter.next().unwrap(),
                nums_iter.next().unwrap(),
            )
        })
        .collect::<Vec<_>>();

    println!("{points:?}\n");

    let mut distances: Vec<(f64, (Point, Point))> = vec![];
    for i in 0..points.len() {
        for j in i + 1..points.len() {
            let point1 = points[i];
            let point2 = points[j];
            distances.push((distance(point1, point2), (point1, point2)));
        }
    }

    distances.sort_by(|dist0, dist1| dist0.0.total_cmp(&dist1.0));
    // println!("{distances:?}\n");

    // distances are edges and weights
    let mut set = DisjointSet {
        parents: HashMap::new(),
    };
    // let mut circuits: HashMap<Point, HashSet<Point>> = HashMap::new();
    let mut last_connection = None;
    for (_distance, (point1, point2)) in distances {
        let set1 = set.find(point1);
        let set2 = set.find(point2);
        println!("{point1:?} {point2:?}");
        if set1 != set2 {
            set.union(set1, set2);
            last_connection = Some((point1, point2));
        }
    }

    let result = last_connection.unwrap().0 .0 * last_connection.unwrap().1 .0;
    println!("{result}");
}

fn main() {
    _part1();
}
