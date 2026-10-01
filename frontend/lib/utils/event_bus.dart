import 'dart:async';

class GlobalEventBus {
  static final StreamController<void> _refreshController =
      StreamController<void>.broadcast();

  static Stream<void> get onRefresh => _refreshController.stream;

  static void triggerRefresh() {
    _refreshController.add(null);
  }
}
