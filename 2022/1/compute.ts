// read the input.txt
import * as fs from "fs";
const input = fs.readFileSync("input.txt", "utf8");

let groups = input.split("\n\n");

let elves: number[] = [];
groups.forEach((group, index) => {
  let sum = 0;
  group.split("\n").forEach((value) => (sum += Number(value)));
  elves.push(sum);
});

console.log(Math.max(...elves));

// Part 2
let top_vals: number[] = [];
for (let elf of elves) {
  if (top_vals.length < 3) {
    top_vals.push(elf);
    continue;
  }

  if (elf > Math.min(...top_vals)) {
    top_vals[top_vals.indexOf(Math.min(...top_vals))] = elf;
  }
}
console.log(top_vals.reduce((a, b) => a + b, 0));
console.log(
  elves
    .sort((a, b) => b - a)
    .slice(0, 3)
    .reduce((a, b) => a + b, 0)
);
