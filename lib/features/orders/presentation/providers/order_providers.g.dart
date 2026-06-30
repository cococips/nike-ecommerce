// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userOrders)
final userOrdersProvider = UserOrdersProvider._();

final class UserOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderModel>>,
          List<OrderModel>,
          Stream<List<OrderModel>>
        >
    with $FutureModifier<List<OrderModel>>, $StreamProvider<List<OrderModel>> {
  UserOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userOrdersHash();

  @$internal
  @override
  $StreamProviderElement<List<OrderModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<OrderModel>> create(Ref ref) {
    return userOrders(ref);
  }
}

String _$userOrdersHash() => r'1680dff8c5a02e48015a1298afd91b05bd367eb5';

@ProviderFor(CheckoutController)
final checkoutControllerProvider = CheckoutControllerProvider._();

final class CheckoutControllerProvider
    extends $NotifierProvider<CheckoutController, bool> {
  CheckoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutControllerHash();

  @$internal
  @override
  CheckoutController create() => CheckoutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$checkoutControllerHash() =>
    r'54badd4a8b115259c6a88fd37180cc90def4220d';

abstract class _$CheckoutController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(allOrders)
final allOrdersProvider = AllOrdersProvider._();

final class AllOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderModel>>,
          List<OrderModel>,
          Stream<List<OrderModel>>
        >
    with $FutureModifier<List<OrderModel>>, $StreamProvider<List<OrderModel>> {
  AllOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allOrdersHash();

  @$internal
  @override
  $StreamProviderElement<List<OrderModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<OrderModel>> create(Ref ref) {
    return allOrders(ref);
  }
}

String _$allOrdersHash() => r'dc128eace81ad330af31100471d67a6a8aca9bfb';

@ProviderFor(AdminOrderController)
final adminOrderControllerProvider = AdminOrderControllerProvider._();

final class AdminOrderControllerProvider
    extends $NotifierProvider<AdminOrderController, bool> {
  AdminOrderControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminOrderControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminOrderControllerHash();

  @$internal
  @override
  AdminOrderController create() => AdminOrderController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$adminOrderControllerHash() =>
    r'2f1a757e2e8250a3255b5e7d144277781c709cc0';

abstract class _$AdminOrderController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
