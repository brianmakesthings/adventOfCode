use std::fs;

fn main() {
    let contents = fs::read_to_string("sample.txt").unwrap();
    let rows = contents
        .lines()
        .filter_map(|row| {
            if row.is_empty() {
                return None;
            }
            let row_split = row.split_at(1);
            let direction = row_split.0;
            let amount: i32 = row_split.1.parse().unwrap();

            Some((direction, amount))
        })
        .collect::<Vec<_>>();

    let mut current: i32 = 50;
    let dials: i32 = 100;
    let mut zeros = 0;

    for row in &rows {
        let next = match row {
            ("L", amount) => {
                let total_next = current - amount;
                if total_next < 0 {
                    zeros += -total_next.div_euclid(dials);
                    println!(
                        "total_next {}, {}",
                        total_next,
                        total_next.div_euclid(dials)
                    );
                    // if starting at zero, don't include it as a click
                    if current == 0 {
                        zeros -= 1;
                    }
                }
                let rem = (total_next).rem_euclid(dials);
                // if ending at zero, include a click
                if rem == 0 {
                    zeros += 1;
                }
                println!("rem: {rem}, zeros: {zeros}");
                rem
            }
            ("R", amount) => {
                let total_next = current + amount;
                if total_next >= dials {
                    zeros += total_next.div_euclid(dials);
                }

                (total_next).rem_euclid(dials)
            }
            _ => todo!(),
        };
        // println!("next: {}", next);
        current = next;
    }

    println!("{zeros}");
}
