use std::collections::HashMap;
use std::collections::HashSet;
use std::fs;

use geo::Contains;
use geo::LineString;
use geo::Polygon;

type Point = (i64, i64);

fn area(point1: Point, point2: Point) -> i64 {
    ((point1.0 - point2.0).abs() + 1) * ((point1.1 - point2.1).abs() + 1)
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
            (nums_iter.next().unwrap(), nums_iter.next().unwrap())
        })
        .collect::<Vec<Point>>();

    let mut max_area = 0;
    for i in 0..points.len() - 1 {
        for j in (i + 1)..points.len() {
            let candidate_area = area(points[i], points[j]);
            if candidate_area > max_area {
                max_area = candidate_area;
                println!("{:?}, {:?} = {:?}", points[i], points[j], max_area);
            }
        }
    }

    println!("{max_area}");
}

fn _part2() {
    let contents = fs::read_to_string("sample.txt").unwrap();
    let points = contents
        .trim()
        .lines()
        .map(|line| {
            let mut nums_iter = line
                .split(',')
                .map(|num| num.trim().parse::<i64>().unwrap());
            (nums_iter.next().unwrap(), nums_iter.next().unwrap())
        })
        .collect::<Vec<Point>>();
    let edges = {
        let mut edges = points
            .windows(2)
            .map(|window| (window[0], window[1]))
            .collect::<Vec<(Point, Point)>>();
        edges.push((*points.last().unwrap(), *points.first().unwrap()));
        edges
    };

    let mut max_area = 0;
    for i in 0..points.len() - 1 {
        for j in (i + 1)..points.len() {
            let candidate_area = area(points[i], points[j]);
            let (point3, point4) = complement_points(points[i], points[j]);
            if !point_in_shape(point3, &edges) || !point_in_shape(point4, &edges) {
                continue;
            }
            if candidate_area > max_area {
                max_area = candidate_area;
                // println!("{:?}, {:?} = {:?}", points[i], points[j], max_area);
            }
        }
    }
    println!("{max_area}");
}

fn complement_points(point1: Point, point2: Point) -> (Point, Point) {
    ((point1.0, point2.1), (point2.0, point1.1))
}

fn point_in_shape(point: Point, edges: &Vec<(Point, Point)>) -> bool {
    let raycast_end = (point.0, 100_000_i64);
    let mut intersections = 0;
    edges.iter().for_each(|edge| {
        if intersects((point, raycast_end), *edge) {
            intersections += 1;
        }
    });
    return intersections % 2 == 1;
}

fn intersects(segment1: (Point, Point), segment2: (Point, Point)) -> bool {
    if (segment2.0 .0 - segment2.1 .0) == 0 {
        // matches the raycast vertical line
        return segment1.0 .0 == segment2.0 .0;
    }

    // assume segment2 is horizontal
    let vertical = segment1;
    let horizontal = segment2;

    let smallest_x = horizontal.0 .0.min(horizontal.1 .0);
    let largest_x = horizontal.0 .0.max(horizontal.1 .0);
    let smallest_y = vertical.0 .1.min(vertical.1 .1);
    let largest_y = vertical.0 .1.max(vertical.1 .1);

    (smallest_x..=largest_x).contains(&vertical.0 .0)
        && (smallest_y..=largest_y).contains(&horizontal.0 .1)
}

// idek
fn intersects_big_brain(segment1: (Point, Point), segment2: (Point, Point)) -> bool {
    ccw(segment1.0, segment2.0, segment2.1) != ccw(segment1.1, segment2.0, segment2.1)
        && ccw(segment1.0, segment1.1, segment2.0) != ccw(segment1.0, segment1.1, segment2.1)
}

fn ccw(a: Point, b: Point, c: Point) -> bool {
    (c.1 - a.1) * (b.0 - a.0) >= (b.1 - a.1) * (c.0 - a.0)
}

fn intersects_line_approach(segment1: (Point, Point), segment2: (Point, Point)) -> bool {
    let slope1 = slope(segment1);
    let slope2 = slope(segment2);
    let intercept1 = y_intercept(segment1, slope1);
    let intercept2 = y_intercept(segment2, slope2);
    // (b2 -b1)/(m1-m2)
    let x_interscetion_point = (intercept2 - intercept1) / (slope1 - slope2);
    let y_intersection_point = x_interscetion_point * slope1 + intercept1;

    point_on_line((x_interscetion_point, y_intersection_point), segment2)
}

fn point_on_line(point: Point, line: (Point, Point)) -> bool {
    let smallest_x = line.0 .0.min(line.1 .0);
    let largest_x = line.0 .0.max(line.1 .0);
    let smallest_y = line.0 .1.min(line.1 .1);
    let largest_y = line.0 .1.max(line.1 .1);

    (smallest_x..=largest_x).contains(&point.0) && (smallest_y..=largest_y).contains(&point.1)
}

fn slope(segment: (Point, Point)) -> i64 {
    (segment.1 .1 - segment.0 .1) / (segment.1 .0 - segment.0 .1)
}

fn y_intercept(segment: (Point, Point), slope: i64) -> i64 {
    slope * -segment.0 .0 + segment.0 .1
}

fn print_grid(grid: Vec<Vec<char>>) {
    grid.iter().for_each(|row| {
        row.iter().for_each(|character| {
            print!("{}", character);
        });
        println!("");
    });
}

type PointFloat = (f64, f64);
fn _part2_cheese() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let points = contents
        .trim()
        .lines()
        .map(|line| {
            let mut nums_iter = line
                .split(',')
                .map(|num| num.trim().parse::<f64>().unwrap());
            (nums_iter.next().unwrap(), nums_iter.next().unwrap())
        })
        .collect::<Vec<PointFloat>>();
    // let edges = {
    //     let mut edges = points
    //         .windows(2)
    //         .map(|window| (window[0], window[1]))
    //         .collect::<Vec<(Point, Point)>>();
    //     edges.push((*points.last().unwrap(), *points.first().unwrap()));
    //     edges
    // };
    let bounding_gon = Polygon::new(LineString::from(points.clone()), vec![]);

    let mut max_area = 0;
    for i in 0..points.len() - 1 {
        for j in (i + 1)..points.len() {
            let candidate_area = area(
                (points[i].0 as i64, points[i].1 as i64),
                (points[j].0 as i64, points[j].1 as i64),
            );
            let (point3, point4) = complement_points(
                (points[i].0 as i64, points[i].1 as i64),
                (points[j].0 as i64, points[j].1 as i64),
            );
            let candi_gon = Polygon::new(
                LineString::from(vec![
                    points[i],
                    (point3.0 as f64, point3.1 as f64),
                    points[j],
                    (point4.0 as f64, point4.1 as f64),
                ]),
                vec![],
            );
            if !bounding_gon.contains(&candi_gon) {
                continue;
            }
            if candidate_area > max_area {
                max_area = candidate_area;
                // println!("{:?}, {:?} = {:?}", points[i], points[j], max_area);
            }
        }
    }
    println!("{max_area}");
}

fn main() {
    // println!("{}", intersects(((0, 0), (0, 10)), ((0, 5), (4, 5))));
    _part2_cheese();
}
