import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:knuffiworkout/main.dart';
import 'package:knuffiworkout/src/app_drawer.dart';
import 'package:knuffiworkout/src/storage/in_memory/storage.dart';
import 'package:knuffiworkout/src/login/fake.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knuffiworkout/src/widgets/knuffi_card.dart';
import 'package:knuffiworkout/src/widgets/set_button.dart';

void main() {
  group('Knuffiworkout', () {
    InMemoryStorage storage;

    setUp(() async {
      storage = InMemoryStorage();
    });

    testWidgets('saves completed reps in past workouts', (tester) async {
      await loadTestApp(storage, tester);

      var cards = find.byType(KnuffiCard);
      expect(cards, findsNWidgets(4));

      expectHasTextWidget(cards.first, 'Chinups');

      final buttons =
          find.descendant(of: cards.first, matching: find.byType(SetButton));
      expect(buttons, findsNWidgets(3));

      await tester.tap(buttons.first);

      expectHasTextWidget(buttons.first, '5');

      await goToDrawerItem('Past workouts', tester);

      cards = find.byType(KnuffiCard);
      expect(cards, findsOneWidget);
      expect(allText(cards.first), contains('5/0/0'));
    });
  });
}

/// Goes to the item with [name] in the app drawer menu.
Future<void> goToDrawerItem(String name, WidgetTester tester) async {
  final menuIcon = find.byIcon(Icons.menu).first;
  await tester.tap(menuIcon);
  await tester.pumpAndSettle();
  final drawer = find.byType(AppDrawer);
  expect(drawer, findsOneWidget);
  final item = find.descendant(of: drawer, matching: find.text(name));
  expect(item, findsOneWidget);
  await tester.tap(item);
  await tester.pumpAndSettle();
}

/// Expects that there's a widget with text [text] somewhere below [finder].
void expectHasTextWidget(Finder finder, String text) {
  expect(
      find.descendant(of: finder, matching: find.text(text)), findsOneWidget);
}

/// All text below [finder] concatenated.
String allText(Finder finder) {
  var result = '';
  final finders = find.descendant(of: finder, matching: find.byType(Text));
  for (final element in finders.evaluate()) {
    final widget = element.widget as Text;
    result += widget.data ?? widget.textSpan?.toPlainText() ?? '';
  }
  return result;
}

/// Loads a test version of [App].
Future<void> loadTestApp(InMemoryStorage storage, WidgetTester tester) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(App(storage, fakeLogIn));
    await tester.pumpAndSettle();
  });
}
