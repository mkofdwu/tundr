export const pageRank = (graph: Array<Array<number>>): number[] => {
  let n: number = graph.length;
  let R: number[][] = Array(n);
  for (let i: number = 0; i < n; i++) {
    R[i] = Array(n).fill(0);
  }
  graph.forEach((nodes, i) => {
    if (nodes.length == 0) return;
    let value: number = 1 / nodes.length;
    nodes.forEach(node => (R[node][i] = value));
  });

  console.log(R);

  let probabilityMatrix: number[] = Array(n).fill(1 / n);
  for (let i: number = 0; i < 99; i++) {
    // FUTURE: this is a temporary solution, increase efficiency of matrix multiplication in the future.
    let newProbabilityMatrix: number[] = Array(n);
    R.forEach((scores, i) => {
      let sum: number = 0;
      for (let j: number = 0; j < n; j++) {
        sum += scores[j] * probabilityMatrix[j];
      }
      newProbabilityMatrix[i] = sum;
    });
    probabilityMatrix = newProbabilityMatrix;
  }

  console.log(probabilityMatrix);

  return probabilityMatrix;
};
