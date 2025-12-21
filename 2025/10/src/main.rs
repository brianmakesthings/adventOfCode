use rayon::{current_num_threads, prelude::*};
use std::collections::VecDeque;
use std::time::Instant;
use z3::ast::Int;
use z3::Optimize;

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
    let contents = fs::read_to_string("input.txt").unwrap();
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

fn find_min_button_presses(end_light_state: &LightState, buttons: &[Button]) -> Option<i64> {
    let optimizer = Optimize::new();
    let switches: Vec<Int> = buttons
        .iter()
        .enumerate()
        .map(|(idx, _button)| Int::fresh_const(&idx.to_string()))
        .collect();

    for switch in &switches {
        optimizer.assert(&switch.ge(0));
    }

    end_light_state
        .voltage
        .iter()
        .enumerate()
        .for_each(|(volt_idx, volt_num)| {
            optimizer.assert(
                &buttons
                    .iter()
                    .enumerate()
                    .filter(|(_btn_and_var_idx, button)| button.indices.contains(&volt_idx))
                    .map(|(btn_and_var_idx, _button)| switches[btn_and_var_idx].clone())
                    .reduce(|a, b| a + b)
                    .unwrap()
                    .eq(*volt_num),
            );
        });
    for (volt_idx, &volt_num) in end_light_state.voltage.iter().enumerate() {
        let sum = &buttons
            .iter()
            .enumerate()
            .filter(|(_btn_and_var_idx, button)| button.indices.contains(&volt_idx))
            .map(|(btn_and_var_idx, _button)| switches[btn_and_var_idx].clone())
            .reduce(|a, b| a + b)?;

        optimizer.assert(&sum.eq(volt_num))
    }

    let total = switches.iter().map(|x| x.clone()).reduce(|a, b| a + b)?;

    optimizer.minimize(&total);
    optimizer.check(&[]);
    let model = optimizer.get_model()?;
    let result = switches
        .iter()
        .map(|switch| model.eval(switch, true)?.as_i64())
        .sum::<Option<i64>>()?;
    println!("{result:?}");
    Some(result)
}

fn main() {
    _part2();
}
