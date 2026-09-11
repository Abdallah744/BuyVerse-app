# Implementation Plan - Fix Compilation Errors

The project currently has numerous compilation errors due to missing dependencies, broken relative imports, missing classes (specifically `HomePage`), and syntax errors in several files. This plan outlines a systematic approach to resolving these issues.

## User Review Required

> [!IMPORTANT]
> A `HomePage` class will be created in `lib/presentation_layer/user_version/pages/home_page.dart`. This page will act as the main container for the application, hosting the `AppBottomNavBar` and managing navigation between different tabs (Home/Products, Favorites, Cart, Orders, Profile).

## Proposed Changes

### Dependencies

#### [MODIFY] [pubspec.yaml](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/pubspec.yaml)
- Add `google_fonts: ^6.2.1` to `dependencies`.

---

### Core Layer & Theming

#### [MODIFY] [app_text_styles.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/core_layer/user/core/theme/app_text_styles.dart)
- Add `import 'package:google_fonts/google_fonts.dart';`.

---

### Presentation Layer (User Version)

#### [NEW] [home_page.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/presentation_layer/user_version/pages/home_page.dart)
- Implement `HomePage` class with a `Scaffold` containing `AppBottomNavBar` and a `PageValue` or `IndexedStack` to switch between:
    - `ProductsPage` (Home)
    - `Placeholder` (Favorites)
    - `CartPage`
    - `OrdersPage`
    - `ProfilePage`

#### [MODIFY] [products_page.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/presentation_layer/user_version/pages/products_page.dart)
- Fix corrupted imports and syntax errors.
- Ensure proper use of `ProductCubit` and `ProductRepositoryImpl`.

#### [MODIFY] [product_details_page.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/presentation_layer/user_version/pages/product_details_page.dart)
- Fix corrupted imports and syntax errors.
- Initialize `authToken` and `product` correctly.

#### [MODIFY] [cart_page.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/presentation_layer/user_version/pages/cart_page.dart)
- Fix broken imports (especially `cart_repository_impl.dart`).
- Use the correct `AppBottomNavBar` or remove it if managed by `HomePage`.

---

### Domain & Data Layer

#### [MODIFY] [order_repository_impl.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/domain_layer/user/repositories/orders/order_repository_impl.dart)
- Fix incorrect import: import the abstract `OrderRepository` from the domain layer, not the admin data layer.

#### [MODIFY] [checkout_repository_impl.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/domain_layer/user/repositories/payment/checkout_repository_impl.dart)
#### [MODIFY] [payment_repository_impl.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/domain_layer/user/repositories/payment/payment_repository_impl.dart)
#### [MODIFY] [payment_process_repository_impl.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/domain_layer/user/repositories/payment/payment_process_repository_impl.dart)
- Fix broken relative imports and ensure they implement the correct interfaces.

#### [MODIFY] [user_repo_impelement.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/domain_layer/user/repositories/user_repo_impelement.dart)
- Fix all broken imports to `core` params, models, and remote data sources.

---

### Authentication Pages

#### [MODIFY] [login_page.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/auth/pages/login_page.dart)
#### [MODIFY] [register_page.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/auth/pages/register_page.dart)
#### [MODIFY] [otp_verify_page.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/auth/pages/otp_verify_page.dart)
- Add `import 'package:buy_verse_app/presentation_layer/user_version/pages/home_page.dart';`.

## Verification Plan

### Manual Verification
- Run `flutter pub get` to ensure all dependencies are fetched.
- Verify that the project compiles without errors in the IDE.
- Test navigation from Login/Register to `HomePage`.
- Verify the Bottom Navigation switches correctly between tabs.
