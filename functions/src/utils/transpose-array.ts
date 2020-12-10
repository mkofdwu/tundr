export default (array: Array<Array<number>>) =>
  array[0].map((_, colIndex) => array.map((row) => row[colIndex]));
