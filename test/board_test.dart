import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/game_page.dart';

void main() {
  testWidgets('Game page', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const GamePage(size: 10));

    final sizeFinder = find.text('Tic Tac Toe');
    expect(sizeFinder, findsOneWidget);
  });

}