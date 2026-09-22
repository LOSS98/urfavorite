import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:urfavorite/main.dart';

void main() {
  testWidgets('App renders the catalog screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const UrFavoriteApp());
    await tester.pump();

    expect(find.text('UrFavorite'), findsOneWidget);
  });
}
