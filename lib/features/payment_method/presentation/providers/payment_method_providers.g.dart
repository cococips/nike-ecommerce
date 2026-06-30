// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paymentRepository)
final paymentRepositoryProvider = PaymentRepositoryProvider._();

final class PaymentRepositoryProvider
    extends
        $FunctionalProvider<
          FirebasePaymentRepository,
          FirebasePaymentRepository,
          FirebasePaymentRepository
        >
    with $Provider<FirebasePaymentRepository> {
  PaymentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentRepositoryHash();

  @$internal
  @override
  $ProviderElement<FirebasePaymentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebasePaymentRepository create(Ref ref) {
    return paymentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebasePaymentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebasePaymentRepository>(value),
    );
  }
}

String _$paymentRepositoryHash() => r'ea863c720641f812bd9d76460053fa3204870353';

@ProviderFor(paymentMethodList)
final paymentMethodListProvider = PaymentMethodListProvider._();

final class PaymentMethodListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PaymentMethodModel>>,
          List<PaymentMethodModel>,
          FutureOr<List<PaymentMethodModel>>
        >
    with
        $FutureModifier<List<PaymentMethodModel>>,
        $FutureProvider<List<PaymentMethodModel>> {
  PaymentMethodListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentMethodListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentMethodListHash();

  @$internal
  @override
  $FutureProviderElement<List<PaymentMethodModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PaymentMethodModel>> create(Ref ref) {
    return paymentMethodList(ref);
  }
}

String _$paymentMethodListHash() => r'3cf282f656babde80de627cc5a2cc96cd0ae503d';

@ProviderFor(PaymentMethodController)
final paymentMethodControllerProvider = PaymentMethodControllerProvider._();

final class PaymentMethodControllerProvider
    extends $AsyncNotifierProvider<PaymentMethodController, void> {
  PaymentMethodControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentMethodControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentMethodControllerHash();

  @$internal
  @override
  PaymentMethodController create() => PaymentMethodController();
}

String _$paymentMethodControllerHash() =>
    r'f78efdfd91e562ca9cac948f0ffae545901acaf5';

abstract class _$PaymentMethodController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
