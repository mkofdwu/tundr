import 'dart:math';

class Rectangle {
  int x1;
  int y1;
  int x2;
  int y2;

  Rectangle([this.x1, this.y1, this.x2, this.y2]);

  int get width => x2 - x1;

  int get height => y2 - y1;

  bool overlaps(Rectangle other) {
    if (x2 <= other.x1 || other.x2 <= x1) return false;
    if (y2 <= other.y1 || other.y2 <= y1) return false;
    return true;
  }

  @override
  String toString() => 'Rectangle($x1, $y1, $x2, $y2)';
}

class Position {
  int row;
  int column;

  Position(this.row, this.column);

  @override
  bool operator ==(dynamic other) {
    assert(other is Position);
    return row == other.row && column == other.column;
  }

  @override
  int get hashCode => row.hashCode ^ column.hashCode;

  @override
  String toString() => 'Point($row, $column)';
}

class Result {
  List<Rectangle> solutions;
  List<int> unsolved;

  Result({this.solutions, this.unsolved});
}

Result placeRects(Rectangle bound, List<int> rects) {
  final rnd = Random();

  final gridsize = rects.removeLast();

  final r = Rectangle();
  r.x1 = bound.x1 + rnd.nextInt(bound.x2 - gridsize);
  r.y1 = bound.y1 + rnd.nextInt(bound.y2 - gridsize);
  r.x2 = r.x1 + gridsize;
  r.y2 = r.y1 + gridsize;

  final offsetX = (r.x1 - bound.x1) % gridsize;
  final nColumns = (bound.width - offsetX) ~/ gridsize;

  final offsetY = (r.y1 - bound.y1) % gridsize;
  final nRows = (bound.height - offsetY) ~/ gridsize;

  final spaces = <Position>[];
  for (var row = 0; row < nRows; ++row) {
    for (var column = 0; column < nColumns; ++column) {
      spaces.add(Position(row, column));
    }
  }
  spaces.remove(Position((r.y1 - offsetY - bound.y1) ~/ gridsize,
      (r.x1 - offsetX - bound.x1) ~/ gridsize));

  final solutions = <Rectangle>[r];

  while (rects.isNotEmpty) {
    if (spaces.isEmpty) return Result(solutions: solutions, unsolved: rects);

    final position = spaces.removeAt(rnd.nextInt(spaces.length));

    final newBound = Rectangle();
    newBound.x1 = bound.x1 + offsetX + position.column * gridsize;
    newBound.y1 = bound.y1 + offsetY + position.row * gridsize;
    newBound.x2 = newBound.x1 + gridsize;
    newBound.y2 = newBound.y1 + gridsize;

    final result = placeRects(newBound, rects);
    solutions.addAll(result.solutions);
    rects = result.unsolved;
  }

  return Result(
    solutions: solutions,
    unsolved: [],
  );
}
