List<double> pageRank(List<List<int>> graph) {
  final int n = graph.length;
  final List<List<double>> r = List.generate(
    n,
    (_) => List.filled(n, 0, growable: false),
    growable: false,
  );
  graph.asMap().forEach((i, nodes) {
    final double value = 1 / nodes.length;
    nodes.forEach((node) => r[node][i] = value);
  });

  List<double> probabilityMatrix = List.filled(n, 1 / n, growable: false);
  for (int i = 0; i < 99; i++) {
    // FUTURE: this is a temporary solution, increase speed of matrix multiplication in the future.
    final List<double> newProbabilityMatrix = [];
    r.asMap().forEach((i, scores) {
      double sum = 0;
      for (int j = 0; j < n; j++) {
        sum += scores[j] * probabilityMatrix[j];
      }
      newProbabilityMatrix.add(sum); // at i
    });
    probabilityMatrix = newProbabilityMatrix;
  }

  return probabilityMatrix;
}
