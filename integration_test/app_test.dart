import 'package:buy_verse_app/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('اختبار التطبيق الكامل (End-to-End Test)', () {
    testWidgets('التأكد من تشغيل التطبيق وظهور الشاشة الافتتاحية ثم شاشة الدخول', (
      tester,
    ) async {
      // 1. تشغيل التطبيق
      await app.main();
      await tester.pumpAndSettle();

      // 2. التحقق من وجود الشاشة الافتتاحية (SplashScreen) أو أول شاشة تظهر
      // ملاحظة: بما أن التطبيق يبدأ بـ SplashScreen لمدة 4 ثوانٍ، قد نحتاج للانتظار
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 3. التحقق من الانتقال لشاشة تسجيل الدخول (إذا لم يكن هناك uId محفوظ)
      // سنبحث عن نص "Login" أو أي نص يميز شاشة الدخول
      expect(find.textContaining('Login'), findsWidgets);

      // 4. محاكاة عملية إدخال بيانات (اختياري)
      // await tester.enterText(find.byType(TextFormField).first, 'admin@buyverse.com');
      // await tester.enterText(find.byType(TextFormField).last, 'admin123');
      // await tester.tap(find.byType(MaterialButton));
      // await tester.pumpAndSettle();
    });
  });
}
