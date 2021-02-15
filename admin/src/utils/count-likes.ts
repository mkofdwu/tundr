export default (graph: Array<Array<number>>) => {
  const res: number[] = Array(graph.length).fill(0);
  for (const userLiked of graph) {
    for (const index of userLiked) {
      res[index]++;
    }
  }
  return res;
};
