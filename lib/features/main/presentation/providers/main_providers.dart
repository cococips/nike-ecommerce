import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_providers.g.dart';

@riverpod
class MainTabIndex extends _$MainTabIndex {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}
