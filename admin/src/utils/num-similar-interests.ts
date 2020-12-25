export default (a: Array<number>, b: Array<number>) => {
  if (a.length != b.length) {
    throw (
      'Interest vectors do not have the same length (' +
      a.length +
      ' and ' +
      b.length +
      ')'
    );
  }
  let num = 0;
  for (let i = 0; i < a.length; ++i) {
    num += Math.min(a[i], b[i]);
  }
  return num;
};
