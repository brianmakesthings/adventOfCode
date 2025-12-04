// read the input.txt
import * as fs from "fs";
// get the first command line argument
let file = process.argv[2];
const input = fs.readFileSync(file, "utf8");

let rounds = input.split("\n").map((line) => line.split(" "));
rounds = rounds.slice(0, -1);
// console.log(rounds);

const letterToSymbol = (letter: string) => {
  if (letter === "A" || letter === "X") {
    return "rock";
  } else if (letter === "B" || letter === "Y") {
    return "paper";
  }
  return "scissors";
};

const getWinner = (input0: string, input1: string) => {
  if (input0 === input1) {
    return "Tie";
  } else if (
    (input0 === "rock" && input1 === "scissors") ||
    (input0 === "paper" && input1 === "rock") ||
    (input0 === "scissors" && input1 === "paper")
  ) {
    return 0;
  }
  return 1;
};

const pointPerInput = (input: string) => {
  if (input === "rock") {
    return 1;
  } else if (input === "paper") {
    return 2;
  }
  return 3;
};

const symbol = ["rock", "paper", "scissors"];

let wins = [0, 0];
for (let round of rounds) {
  let input0 = letterToSymbol(round[0]);
  //   let input1 = letterToSymbol(round[1]);
  let input1: string;
  switch (round[1]) {
    case "X":
      let index = (symbol.indexOf(input0) - 1) % symbol.length;
      if (index < 0) {
        index += symbol.length;
      }
      input1 = symbol[index];
      break;
    case "Y":
      input1 = input0;
      break;
    case "Z":
      input1 = symbol[(symbol.indexOf(input0) + 1) % symbol.length];
      break;
  }
  console.table({ input0, col2: round[1], input1 });

  let winner = getWinner(input0, input1);
  if (winner === "Tie") {
    wins[0] += 3;
    wins[1] += 3;
  } else {
    wins[winner] += 6;
  }
  wins[0] += pointPerInput(input0);
  wins[1] += pointPerInput(input1);
}
console.log(wins);
