export default (arr: Array<Array<number>>) =>
  arr.map((_, colIndex) => arr.map((row) => row[colIndex]));
