import 'dart:ui';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  const Board({super.key, required this.size});

  final int size;

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final _controller = TransformationController();

  final double _itemSize = 40;
  final Color _boxColor = Colors.black;
  final Color _boxLatestColor = const Color.fromARGB(255, 69, 69, 68);
  final Color _boxWinningColor = Colors.blueGrey;
  final Color _circleColor = Colors.lightBlueAccent;
  final Color _crossColor = Colors.lightBlueAccent;
  final Color _boarderColor = Colors.grey;

  late int _size = widget.size;
  late final List<List<int>> _board =
      List.generate(_size, (index) => List.generate(_size, (index) => 0));

  int _turn = 1;
  String _latestTurn = '-1,-1';
  List<String> _winTile = List.empty();

  @override
  void initState() {
    super.initState();
    _controller.value = _getBoardCenter();
  }

  @override
  Widget build(BuildContext context) {
    _size = widget.size;
    return InteractiveViewer(
        constrained: false,
        transformationController: _controller,
        child: DataTable(
          dataRowColor: MaterialStateProperty.all(_boxColor),
          border: TableBorder.all(width: 1.5, color: _boarderColor),
          columnSpacing: 0,
          dataRowHeight: _itemSize,
          headingRowHeight: 0,
          horizontalMargin: 0,
          columns: List.generate(
              _size, (index) => const DataColumn(label: Text(''))),
          rows: List.generate(
              _size,
              (r) => DataRow(
                  cells: List.generate(_size,
                      (c) => DataCell(_item(r, c), onTap: _itemClicked(r, c))))),
        ));
  }

  _getColorItem(int row, int column) {
    if (_winTile.isEmpty) {
      if (_latestTurn == '$row,$column') {
        return _boxLatestColor;
      }
      return _boxColor;
    } else {
      for (String element in _winTile) {
        if (element == '$row,$column') {
          return _boxWinningColor;
        }
      }
      return _boxColor;
    }
  }

  _item(int row, int column) {
    int val = _board[row][column];
    if (val == 1) {
      return Container(
          color: _getColorItem(row, column),
          child: SizedBox.square(
              dimension: _itemSize,
              child: Icon(size: 30, color: _crossColor, Icons.clear)));
    } else if (val == 2) {
      return Container(
          color: _getColorItem(row, column),
          child: SizedBox.square(
              dimension: _itemSize,
              child: Icon(size: 30, color: _circleColor, Icons.lens)));
    } else {
      return Container(
          color: _getColorItem(row, column),
          child: SizedBox.square(dimension: _itemSize));
    }
  }

  _itemClicked(int row, int column) {
    if (_winTile.isNotEmpty) {
      if (_board[row][column] == 0) {
        return null;
      } else {
        return () {};
      }
    }
    return () {
      setState(() {
        if (_board[row][column] == 0) {
          _latestTurn = '$row,$column';
          _board[row][column] = _turn;
          if (_turn == 1) {
            _turn = 2;
          } else {
            _turn = 1;
          }
        }
        _validating();
      });
    };
  }

  _validating() {
    for (int i = 0; i < _size; i++) {
      Pair pairX = Pair(0, 0);
      Pair pairY = Pair(0, 0);
      Pair pairCRLR = Pair(0, 0);
      Pair pairCDLR = Pair(0, 0);
      Pair pairCRRL = Pair(0, 0);
      Pair pairCDRL = Pair(0, 0);
      for (int j = 0; j < _size; j++) {
        pairX = _validatingX(pairX, i, j);
        pairY = _validatingY(pairY, j, i);
        pairCRLR = _validatingCRLR(pairCRLR, j, i + j);
        pairCDLR = _validatingCDLR(pairCDLR, i + j + 1, j);
        pairCRRL = _validatingCRRL(pairCRRL, j, i - j);
        pairCDRL = _validatingCDRL(pairCDRL, i + j + 1, (_size - 1) - j);
      }
    }
  }

  _validatingX(Pair pairX, int row, int col) {
    int prevX = pairX.first;
    int timeX = pairX.last;
    if (prevX != 0 && prevX == _board[row][col]) {
      timeX++;
      if (timeX == 4) {
        _winTile = [
          '$row,$col',
          '$row,${col - 1}',
          '$row,${col - 2}',
          '$row,${col - 3}',
          '$row,${col - 4}'
        ];
        return pairX;
      }
    } else {
      timeX = 0;
    }
    prevX = _board[row][col];
    return Pair(prevX, timeX);
  }

  _validatingY(Pair pairY, int row, int col) {
    int prevY = pairY.first;
    int timeY = pairY.last;
    if (prevY != 0 && prevY == _board[row][col]) {
      timeY++;
      if (timeY == 4) {
        _winTile = [
          '$row,$col',
          '${row - 1},$col',
          '${row - 2},$col',
          '${row - 3},$col',
          '${row - 4},$col'
        ];
        return pairY;
      }
    } else {
      timeY = 0;
    }
    prevY = _board[row][col];
    return Pair(prevY, timeY);
  }

  _validatingCRLR(Pair pairCRLR, int row, int col) {
    int prevCRLR = pairCRLR.first;
    int timeCRLR = pairCRLR.last;
    if (col < _size) {
      if (prevCRLR != 0 && prevCRLR == _board[row][col]) {
        timeCRLR++;
        if (timeCRLR == 4) {
          _winTile = [
            '$row,$col',
            '${row - 1},${col - 1}',
            '${row - 2},${col - 2}',
            '${row - 3},${col - 3}',
            '${row - 4},${col - 4}'
          ];
          return pairCRLR;
        }
      } else {
        timeCRLR = 0;
      }
      prevCRLR = _board[row][col];
    }
    return Pair(prevCRLR, timeCRLR);
  }

  _validatingCDLR(Pair pairCDLR, int row, int col) {
    int prevCDLR = pairCDLR.first;
    int timeCDLR = pairCDLR.last;
    if (row < _size) {
      if (prevCDLR != 0 && prevCDLR == _board[row][col]) {
        timeCDLR++;
        if (timeCDLR == 4) {
          _winTile = [
            '$row,$col',
            '${row - 1},${col - 1}',
            '${row - 2},${col - 2}',
            '${row - 3},${col - 3}',
            '${row - 4},${col - 4}'
          ];
          return pairCDLR;
        }
      } else {
        timeCDLR = 0;
      }
      prevCDLR = _board[row][col];
    }
    return Pair(prevCDLR, timeCDLR);
  }

  _validatingCRRL(Pair pairCRRL, int row, int col) {
    int prevCRRL = pairCRRL.first;
    int timeCRRL = pairCRRL.last;
    if (col >= 0) {
      if (prevCRRL != 0 && prevCRRL == _board[row][col]) {
        timeCRRL++;
        if (timeCRRL == 4) {
          _winTile = [
            '$row,$col',
            '${row - 1},${col + 1}',
            '${row - 2},${col + 2}',
            '${row - 3},${col + 3}',
            '${row - 4},${col + 4}'
          ];
          return pairCRRL;
        }
      } else {
        timeCRRL = 0;
      }
      prevCRRL = _board[row][col];
    }
    return Pair(prevCRRL, timeCRRL);
  }

  _validatingCDRL(Pair pairCDRL, int row, int col) {
    int prevCDRL = pairCDRL.first;
    int timeCDRL = pairCDRL.last;
    if (row < _size) {
      if (prevCDRL != 0 && prevCDRL == _board[row][col]) {
        timeCDRL++;
        if (timeCDRL == 4) {
          _winTile = [
            '$row,$col',
            '${row - 1},${col + 1}',
            '${row - 2},${col + 2}',
            '${row - 3},${col + 3}',
            '${row - 4},${col + 4}'
          ];
          return pairCDRL;
        }
      } else {
        timeCDRL = 0;
      }
      prevCDRL = _board[row][col];
    }
    return Pair(prevCDRL, timeCDRL);
  }

  _getBoardCenter() {
    double screenHeight =
        window.physicalSize.longestSide / window.devicePixelRatio;
    double screenWidth =
        window.physicalSize.shortestSide / window.devicePixelRatio;
    double appHeight = AppBar().preferredSize.height;
    double remainHeight = screenHeight - appHeight;
    double boardSize = _size * _itemSize;
    double setHeight;
    if (boardSize < remainHeight) {
      setHeight = 0;
    } else {
      setHeight = (boardSize / 2) - (remainHeight / 2);
    }
    double setWidth;
    if (boardSize < screenWidth) {
      setWidth = 0;
    } else {
      setWidth = (boardSize / 2) - (screenWidth / 2);
    }
    return Matrix4.translationValues(-setWidth, -setHeight, 0);
  }
}
