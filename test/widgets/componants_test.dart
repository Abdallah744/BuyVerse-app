import 'package:buy_verse_app/admin_version/presentation_layer/widgets/componants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('اختبار الـ Widgets المخصصة (Components Tests)', () {
    testWidgets('يجب أن يعرض defaultButton النص الصحيح ويستجيب للضغط', (
      WidgetTester tester,
    ) async {
      bool isPressed = false;

      // بناء الـ Widget داخل بيئة الاختبار باستخدام Builder لتوفير context حقيقي
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return defaultButton(
                  context: context,
                  text: 'إضافة منتج',
                  function: () {
                    isPressed = true;
                  },
                );
              },
            ),
          ),
        ),
      );

      // التأكد من ظهور النص
      expect(find.text('إضافة منتج'), findsOneWidget);

      // محاكاة الضغط على الزر
      await tester.tap(find.byType(MaterialButton));
      await tester.pump();

      // التأكد من تنفيذ الوظيفة
      expect(isPressed, isTrue);
    });

    testWidgets('يجب أن يعرض defaultTextFormField ويقبل إدخال النص', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return defaultTextFormField(
                  context: context,
                  controller: controller,
                  type: TextInputType.text,
                  validate: (val) => null,
                  label: 'اسم المنتج',
                );
              },
            ),
          ),
        ),
      );

      // التأكد من وجود الحقل عبر الـ label
      expect(find.text('اسم المنتج'), findsOneWidget);

      // إدخال نص في الحقل
      await tester.enterText(find.byType(TextFormField), 'خروف العيد');

      // التأكد من أن الكنترولر استلم النص
      expect(controller.text, 'خروف العيد');
    });
  });
}
