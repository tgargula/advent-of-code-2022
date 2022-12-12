import 'dart:collection';
import 'dart:io';

class Position {
  final int x;
  final int y;

  Position(this.x, this.y);

  Position add(Position other) {
    return Position(this.x + other.x, this.y + other.y);
  }

  @override
  bool operator ==(Object other) =>
      other is Position &&
      other.runtimeType == this.runtimeType &&
      other.x == this.x &&
      other.y == this.y;

  @override
  int get hashCode => 3 * x.hashCode + 7 * y.hashCode;
}

Position getSourcePosition(List<String> board) {
  for (var i = 0; i < board.length; i++) {
    for (var j = 0; j < board[i].length; j++) {
      if (board[i][j] == 'S') {
        return Position(i, j);
      }
    }
  }

  throw Error();
}

Position getDestinationPosition(List<String> board) {
  for (var i = 0; i < board.length; i++) {
    for (var j = 0; j < board[i].length; j++) {
      if (board[i][j] == 'E') {
        return Position(i, j);
      }
    }
  }

  throw Error();
}

String mapValue(String x) {
  switch (x) {
    case 'S':
      return 'a';
    case 'E':
      return 'z';
    default:
      return x;
  }
}

int bfs(
    List<String> board, Position s, List<String> destinations, bool reversed) {
  var visited = Map<Position, int>();
  var moves = List<Position>.of(
      [Position(-1, 0), Position(0, 1), Position(1, 0), Position(0, -1)]);

  var queue = Queue<Position>();
  queue.add(s);
  visited.putIfAbsent(s, () => 0);

  while (queue.isNotEmpty) {
    var v = queue.removeFirst();

    if (destinations.contains(board[v.x][v.y])) {
      return visited[v]!;
    }

    for (int i = 0; i < moves.length; i++) {
      var u = v.add(moves[i]);
      if (u.x >= 0 &&
          u.x < board.length &&
          u.y >= 0 &&
          u.y < board[i].length &&
          !visited.containsKey(u)) {
        var current = mapValue(board[v.x][v.y]);
        var dest = mapValue(board[u.x][u.y]);

        if (!reversed && dest.codeUnitAt(0) - 1 <= current.codeUnitAt(0) ||
            (reversed && current.codeUnitAt(0) - 1 <= dest.codeUnitAt(0))) {
          visited.putIfAbsent(u, () => visited[v]! + 1);
          queue.add(u);
        }
      }
    }
  }

  return -1;
}

void main() async {
  var step = 2;
  var config = File("data/input.txt");
  var board = await config.readAsLines();
  var s = getSourcePosition(board);
  var t = getDestinationPosition(board);

  if (step == 1) {
    var result = bfs(board, s, ['E'], false);
    print(result);
  } else if (step == 2) {
    var result = bfs(board, t, ['a', 'S'], true);
    print(result);
  }
}
