use std::collections::{HashSet, VecDeque};

use std::fs;

struct LightState {
    state: String,
}

impl LightState {
    fn from_string(str: &str) -> LightState {
        let sub_str = &str[1..str.len()];

        LightState {
            state: sub_str.chars().collect(),
        }
    }

    fn find_next_state(&self, button: &Button) -> LightState {
        let mut state = self.state.clone();
        button.indices.iter().for_each(|idx| {
            let current_value = state.chars().nth(*idx).unwrap();
            let replacement_val = if current_value == '.' { '#' } else { '.' };
            state.replace_range(idx..&(idx + 1), &replacement_val.to_string());
        });
        LightState { state }
    }
}

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

fn _part1() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let parsed_data = contents
        .trim()
        .lines()
        .map(|line| {
            let mut split = line.split(" ").collect::<VecDeque<_>>();
            let desired_end_state = split.pop_front().unwrap();
            let _voltages = split.pop_back().unwrap();
            let buttons = split
                .iter()
                .map(|x| Button::from_string(x))
                .collect::<Vec<_>>();

            (LightState::from_string(desired_end_state), buttons)
        })
        .collect::<Vec<_>>();

    let mut result = 0;
    parsed_data.iter().for_each(|(light_state, buttons)| {
        result += find_min_button_presses(light_state, buttons);
    });

    println!("result: {result}");
}

fn find_min_button_presses(end_light_state: &LightState, buttons: &[Button]) -> i64 {
    let initial_state = LightState {
        state: end_light_state.state.clone().replace("#", "."),
    };
    let mut processing_queue = VecDeque::from(vec![(0, initial_state)]);
    let mut visited = HashSet::new();

    let mut result = 0;
    while !processing_queue.is_empty() {
        let (step, cur_state) = processing_queue.pop_front().unwrap();
        println!("{step}");
        if cur_state.state == end_light_state.state {
            result = step;
            break;
        }
        if visited.contains(&cur_state.state) {
            continue;
        }
        visited.insert(cur_state.state.clone());

        let mut next_states = buttons
            .iter()
            .map(|button| (step + 1, cur_state.find_next_state(button)))
            .collect::<VecDeque<_>>();
        processing_queue.append(&mut next_states);
    }

    result
}

fn _part2() {}

fn main() {
    _part1();
}
