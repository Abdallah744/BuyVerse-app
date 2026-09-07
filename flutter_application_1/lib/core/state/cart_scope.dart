import 'package:flutter/material.dart';

import 'cart_controller.dart';

/// Makes a single [CartController] available anywhere below it via
/// `CartScope.of(context)`, and rebuilds dependents automatically when
/// the cart changes (inherited from [InheritedNotifier]).
class CartScope extends InheritedNotifier<CartController> {
  const CartScope({
    super.key,
    required CartController controller,
    required super.child,
  }) : super(notifier: controller);

  static CartController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(
        scope != null, 'No CartScope found in context. Wrap the app in one.');
    return scope!.notifier!;
  }
}
