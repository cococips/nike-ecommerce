// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(addressRepository)
final addressRepositoryProvider = AddressRepositoryProvider._();

final class AddressRepositoryProvider
    extends
        $FunctionalProvider<
          FirebaseAddressRepository,
          FirebaseAddressRepository,
          FirebaseAddressRepository
        >
    with $Provider<FirebaseAddressRepository> {
  AddressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressRepositoryHash();

  @$internal
  @override
  $ProviderElement<FirebaseAddressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseAddressRepository create(Ref ref) {
    return addressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAddressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAddressRepository>(value),
    );
  }
}

String _$addressRepositoryHash() => r'c39da3acffa84805dee4ec57bcdb63a52ebcd182';

@ProviderFor(addressList)
final addressListProvider = AddressListProvider._();

final class AddressListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AddressModel>>,
          List<AddressModel>,
          FutureOr<List<AddressModel>>
        >
    with
        $FutureModifier<List<AddressModel>>,
        $FutureProvider<List<AddressModel>> {
  AddressListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressListHash();

  @$internal
  @override
  $FutureProviderElement<List<AddressModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AddressModel>> create(Ref ref) {
    return addressList(ref);
  }
}

String _$addressListHash() => r'817646e8d52ede3ba64223c34f525c4ca0a6ce52';

@ProviderFor(AddressController)
final addressControllerProvider = AddressControllerProvider._();

final class AddressControllerProvider
    extends $AsyncNotifierProvider<AddressController, void> {
  AddressControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressControllerHash();

  @$internal
  @override
  AddressController create() => AddressController();
}

String _$addressControllerHash() => r'33457d2d573da335f1809c6db24017b700aa1b3b';

abstract class _$AddressController extends $AsyncNotifier<void> {
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
