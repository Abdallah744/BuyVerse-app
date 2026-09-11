import 'package:buy_verse_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('اختبار التطبيق الكامل (End-to-End Test)', () {
    testWidgets(
      'التأكد من تشغيل التطبيق واختيار الدور ثم الوصول لشاشة الدخول',
      (tester) async {
        // 1. تشغيل التطبيق
        await app.main();
        await tester.pumpAndSettle();

        // 2. الانتظار حتى تنتهي الشاشة الافتتاحية
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // 3. التحقق من شاشة اختيار الدور (Role Selection)
        expect(find.text('Choose Your Role'), findsOneWidget);

        // 4. اختيار دور التاجر (Seller Account)
        await tester.tap(find.text('Seller Account'));
        await tester.pumpAndSettle();

        // 5. الضغط على زر المتابعة (Continue)
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        // 6. التحقق من الوصول لشاشة تسجيل الدخول
        // سنبحث عن "Email" أو "البريد الإلكتروني" لضمان التوافق مع اللغتين
        final emailFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              (widget.data == 'Email' || widget.data == 'البريد الإلكتروني'),
        );

        expect(emailFinder, findsWidgets);
      },
    );
  });
}
