// quickly assembled

const center = (arr: Array<number>) => {
  let sum = 0;
  let num = 0;
  arr.forEach((val) => {
    if (val == null) return;
    sum += val;
    ++num;
  });
  const mean = sum / num;
  return arr.map((val) => {
    if (val == null) return 0;
    return val - mean;
  });
};

const cosSimilarity = (a: Array<number>, b: Array<number>) => {
  if (a.length != b.length)
    throw Error(
      "cannot compute cos similarity: arrays are not of the same length"
    );

  let top = 0;
  for (let i = 0; i < a.length; ++i) top += a[i] * b[i];

  let aSqSum = 0;
  a.forEach((val) => (aSqSum += val ** 2));

  let bSqSum = 0;
  b.forEach((val) => (bSqSum += val ** 2));

  return top / (aSqSum * bSqSum);
};

export default (arr1: Array<number>, arr2: Array<number>) => {
  return cosSimilarity(center(arr1), center(arr2));
};
