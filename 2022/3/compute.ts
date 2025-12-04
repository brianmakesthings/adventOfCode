// read the input.txt
import * as fs from "fs";
// get the first command line argument
let file = process.argv[2];
const input = fs.readFileSync(file, "utf8");

let letterToIndex = (letter: string) => {
  if (
    letter.charCodeAt(0) >= "a".charCodeAt(0) &&
    letter.charCodeAt(0) <= "z".charCodeAt(0)
  ) {
    return letter.charCodeAt(0) - "a".charCodeAt(0);
  } else if (
    letter.charCodeAt(0) >= "A".charCodeAt(0) &&
    letter.charCodeAt(0) <= "Z".charCodeAt(0)
  ) {
    return letter.charCodeAt(0) - "A".charCodeAt(0) + 26;
  }
  return -1;
};

let partOne = (input) => {
  let lines = input
    .split("\n")
    .filter((line) => line.length > 0)
    .map((line) => [
      line.slice(0, Math.floor(line.length / 2)),
      line.slice(Math.floor(line.length / 2)),
    ]);

  let sum = 0;
  lines.forEach((line) => {
    let [left, right] = line;
    let seenLeft = [];
    seenLeft.length = 52;
    seenLeft.fill(0);
    let seenRight = [];
    seenRight.length = 52;
    seenRight.fill(0);
    for (let i = 0; i < left.length; i++) {
      if (seenLeft[letterToIndex(left[i])] > 0) {
        continue;
      }
      seenLeft[letterToIndex(left[i])]++;
    }
    for (let i = 0; i < right.length; i++) {
      if (seenRight[letterToIndex(right[i])] > 0) {
        continue;
      }
      seenRight[letterToIndex(right[i])]++;
    }
    for (let i = 0; i < seenLeft.length; i++) {
      if (seenLeft[i] == 1 && seenRight[i] == seenLeft[i]) {
        //   console.log(String.fromCharCode(i + "a".charCodeAt(0)));
        sum += i + 1;
      }
    }
  });
  console.log(sum);
};

let partTwo = (input: string) => {
  let lines = input
    .split("\n")
    .filter((line) => line.length > 0)
    .reduce(
      (acc, line) => {
        if (acc[acc.length - 1].length < 3) {
          acc[acc.length - 1].push(line);
        } else {
          acc.push([line]);
        }
        return acc;
      },
      [[]]
    )
    .map((line) => {
      let seen = [];
      seen.length = 52;
      seen.fill(0);
      for (let i = 0; i < line.length; i++) {
        let seenThisIter = [];
        seenThisIter.length = 52;
        seenThisIter.fill(0);
        for (let j = 0; j < line[i].length; j++) {
          if (
            seen[letterToIndex(line[i][j])] > i ||
            seenThisIter[letterToIndex(line[i][j])] > 0
          ) {
            continue;
          }
          seen[letterToIndex(line[i][j])]++;
          seenThisIter[letterToIndex(line[i][j])]++;
        }
      }
      return seen.indexOf(3) + 1;
    })
    .reduce((acc, line) => acc + line, 0);
  console.log(lines);
};

partTwo(input);
