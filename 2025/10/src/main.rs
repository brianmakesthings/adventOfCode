use cached::proc_macro::cached;
use rayon::{current_num_threads, current_thread_index, prelude::*};
use std::collections::{HashSet, VecDeque};
use std::time::Instant;

use std::fs;

#[derive(Hash, Eq, PartialEq, Debug, Clone)]
struct LightState {
    voltage: Vec<i32>,
}

impl LightState {
    fn from_string(voltage_str: &str) -> LightState {
        let volt_sub_str = &voltage_str[1..voltage_str.len() - 1];
        let volt_vec = volt_sub_str
            .split(",")
            .map(|char| char.parse::<i32>().unwrap())
            .collect::<Vec<_>>();

        LightState { voltage: volt_vec }
    }

    fn find_next_state(&self, button: &Button) -> LightState {
        let mut voltage = self.voltage.clone();
        button.indices.iter().for_each(|idx| voltage[*idx] -= 1);
        LightState { voltage }
    }
}

#[derive(Hash, Eq, PartialEq, Debug, Clone)]
struct Button {
    indices: Vec<usize>,
}

impl Button {
    fn from_string(str: &str) -> Button {
        let sub_str = &str[1..str.len() - 1];
        Button {
            indices: sub_str
                .split(",")
                .map(|char| char.parse::<usize>().unwrap())
                .collect(),
        }
    }
}

fn _part2() {
    let contents = fs::read_to_string("test.txt").unwrap();
    let parsed_data = contents
        .trim()
        .lines()
        .map(|line| {
            let mut split = line.split(" ").collect::<VecDeque<_>>();
            let _desired_end_state = split.pop_front().unwrap();
            let voltages = split.pop_back().unwrap();
            let buttons = split
                .iter()
                .map(|x| Button::from_string(x))
                .collect::<Vec<_>>();

            (LightState::from_string(voltages), buttons)
        })
        .collect::<Vec<_>>();

    println!("{}", current_num_threads());
    let total = parsed_data.len();
    let result: i64 = parsed_data
        .par_iter()
        .enumerate()
        .map(|(idx, (light_state, buttons))| {
            // let cur_thread = current_thread_index().unwrap();
            let cur_thread = 0;
            println!("{}/{} started on thread {}", idx, total, cur_thread);

            let now = Instant::now();
            let res = find_min_button_presses(light_state, buttons).unwrap();
            println!(
                "{}/{} on thread {:?}, took: {:?}",
                idx,
                total,
                cur_thread,
                now.elapsed()
            );

            res
        })
        .sum();

    println!("result: {result}");
}

#[cached(key = "String", convert = r#"{ format!("{:?}", end_light_state) }"#)]
fn find_min_button_presses(end_light_state: &LightState, buttons: &[Button]) -> Option<i64> {
    println!("{end_light_state:?}");
    if end_light_state.voltage.iter().all(|voltage| *voltage == 0) {
        return Some(0);
    }
    if end_light_state.voltage.iter().any(|voltage| *voltage < 0) {
        return None;
    }

    buttons
        .iter()
        .map(|button| find_min_button_presses(&end_light_state.find_next_state(button), buttons))
        .filter_map(|opt| opt)
        .map(|steps| steps + 1)
        .min()
}

fn main() {
    _part2();
}
