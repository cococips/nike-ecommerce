import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/logger.dart';

/// An observer that logs Riverpod state changes.
final class AppProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    log.d('Provider Added: ${context.provider.name ?? context.provider.runtimeType}');
  }

  @override
  void didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue) {
    log.t('Provider Updated: ${context.provider.name ?? context.provider.runtimeType}');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    log.d('Provider Disposed: ${context.provider.name ?? context.provider.runtimeType}');
  }

  @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
    log.e('Provider Failed: ${context.provider.name ?? context.provider.runtimeType}', error: error, stackTrace: stackTrace);
  }
}
