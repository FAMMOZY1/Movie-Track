/// Async status used across all cubit states (Sennalabs convention) —
/// preferred over booleans for loading/success/error tracking.
enum NetWorkStatus { initial, loading, error, success, restate }

extension NetWorkStatusX on NetWorkStatus {
  bool get isInitial => this == NetWorkStatus.initial;
  bool get isLoading => this == NetWorkStatus.loading;
  bool get isError => this == NetWorkStatus.error;
  bool get isSuccess => this == NetWorkStatus.success;
  bool get isRestate => this == NetWorkStatus.restate;
}
