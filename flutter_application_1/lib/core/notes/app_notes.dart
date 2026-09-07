/// Shared product notes for the Easy Shop profile flow.
///
/// This keeps the app's feature structure and navigation order documented in a
/// single place so new screens follow the same naming and flow conventions.
class AppNotes {
  const AppNotes._();

  static const String appName = 'Easy Shop';
  static const String summary =
      'Auth onboarding → shopping → profile management → checkout completion';

  static const List<String> featureGroups = <String>[
    'auth',
    'shop',
    'profile',
  ];

  static const List<String> flowOrder = <String>[
    '/auth/register',
    '/auth/otp-verify',
    '/auth/welcome',
    '/shop/home',
    '/profile',
    '/profile/edit',
    '/profile/orders',
    '/profile/favorites',
    '/shop/cart',
    '/shop/checkout',
    '/shop/order-success',
  ];

  static const Map<String, List<String>> featureMap = <String, List<String>>{
    'auth': <String>['/auth/register', '/auth/otp-verify'],
    'shop': <String>[
      '/shop/home',
      '/shop/cart',
      '/shop/checkout',
      '/shop/order-success'
    ],
    'profile': <String>[
      '/profile',
      '/profile/edit',
      '/profile/orders',
      '/profile/favorites'
    ],
  };
}
