use core::num;
use std::fs;

#[derive(Debug)]
struct Equation<'a> {
    numbers: Vec<i64>,
    operations: Vec<&'a str>,
}

fn _part1() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let split_input = contents
        .trim()
        .lines()
        .map(|line| {
            line.split(' ')
                .filter(|chunk| !chunk.is_empty())
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();

    let mut equations = split_input[0]
        .iter()
        .map(|_| Equation {
            numbers: vec![],
            operations: vec![],
        })
        .collect::<Vec<Equation>>();
    split_input.iter().enumerate().for_each(|(row_idx, row)| {
        row.iter().enumerate().for_each(|(val_idx, val)| {
            if row_idx == split_input.len() - 1 {
                equations[val_idx].operations.push(val)
            } else {
                equations[val_idx].numbers.push(val.parse::<i64>().unwrap())
            }
        })
    });

    println!("{equations:?}");

    let result: i64 = equations
        .iter()
        .map(|equation| -> i64 {
            let last_operator = *equation.operations.last().unwrap();
            let equation_ans: i64 = match last_operator {
                "+" => equation
                    .numbers
                    .clone()
                    .into_iter()
                    .reduce(|a, b| a + b)
                    .unwrap_or(0),
                "*" => equation
                    .numbers
                    .clone()
                    .into_iter()
                    .reduce(|a, b| a * b)
                    .unwrap_or(0),
                _ => todo!(),
            };
            // println!("{equation_ans}");
            equation_ans
        })
        .sum();

    println!("{result}");
}

#[derive(Debug)]
struct Equation2<'a> {
    numbers: Vec<&'a str>,
    operations: Vec<String>,
}

fn _part2() {
    let contents = fs::read_to_string("input.txt").unwrap();
    let mut lines = contents.lines().collect::<Vec<_>>();
    let operators = lines.split_off(lines.len() - 1);

    let mut op_and_space: Vec<(char, i32)> = vec![];
    let operator_line = operators[0];
    println!("{operator_line:?}");
    operators[0].chars().for_each(|char| match char {
        ' ' => {
            let last = op_and_space.pop().unwrap();
            op_and_space.push((last.0, last.1 + 1))
        }
        '+' | '*' => op_and_space.push((char, 0)),
        _ => todo!(),
    });
    {
        let last = op_and_space.pop().unwrap();
        op_and_space.push((last.0, last.1 + 1));
    }

    println!("{op_and_space:?}");

    let split_input = lines
        .iter()
        .enumerate()
        .map(|(idx, line)| {
            let mut line_splits = vec![];
            let mut chars = line.chars();
            op_and_space.iter().for_each(|(_op, num_spaces)| {
                let chunk = chars.by_ref().take(*num_spaces as usize);
                line_splits.push(chunk.collect::<String>());
                let _ = chars.by_ref().take(1).collect::<Vec<_>>();
            });
            line_splits
        })
        .collect::<Vec<_>>();

    println!("{split_input:?}");

    let mut equations = split_input[0]
        .iter()
        .map(|_| Equation2 {
            numbers: vec![],
            operations: vec![],
        })
        .collect::<Vec<Equation2>>();
    split_input.iter().enumerate().for_each(|(row_idx, row)| {
        row.iter()
            .enumerate()
            .for_each(|(val_idx, val)| equations[val_idx].numbers.push(val))
    });
    op_and_space
        .clone()
        .into_iter()
        .enumerate()
        .for_each(|(val_idx, val)| equations[val_idx].operations.push(val.0.to_string()));

    println!("{equations:?}");

    let result: i64 = equations
        .iter()
        .map(|equation| -> i64 {
            let last_operator = equation.operations.last().unwrap();
            let equation_ans: i64 = match last_operator.as_str() {
                "+" => translate_nums(&equation.numbers)
                    .clone()
                    .into_iter()
                    .reduce(|a, b| a + b)
                    .unwrap_or(0),
                "*" => translate_nums(&equation.numbers)
                    .clone()
                    .into_iter()
                    .reduce(|a, b| a * b)
                    .unwrap_or(0),
                _ => todo!(),
            };
            // println!("{equation_ans}");
            equation_ans
        })
        .sum();

    println!("{result}");
}

fn translate_nums(num_strings: &[&str]) -> Vec<i64> {
    println!("{num_strings:?}");
    let max_len = num_strings.iter().map(|str| str.len()).max().unwrap();

    let mut nums = vec![];
    for i in (0..max_len).rev() {
        let mut num = vec![];
        num_strings
            .iter()
            .for_each(|str| match str.chars().nth(i).unwrap() {
                ' ' => {}
                digit => num.push(digit),
            });

        nums.push(num.iter().collect::<String>().parse::<i64>().unwrap());
    }
    println!("{nums:?}");
    nums
}

fn main() {
    _part2();
}

