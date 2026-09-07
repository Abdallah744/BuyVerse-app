import 'package:flutter_test/flutter_test.dart';

import 'package:easy_shop_profile/main.dart';

void main() {
  testWidgets('app starts on the create account page', (WidgetTester tester) async {
    await tester.pumpWidget(const EasyShopProfileApp());

    expect(find.text('Create Account'), findsWidgets);
  });
}
