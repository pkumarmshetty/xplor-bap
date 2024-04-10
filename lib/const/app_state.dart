enum AppPageStatus { initial, success, error, loading, finish }

extension AppPageEx on AppPageStatus {
  bool get isInitial => this == AppPageStatus.initial;

  bool get isSuccess => this == AppPageStatus.success;

  bool get isError => this == AppPageStatus.error;

  bool get isLoading => this == AppPageStatus.loading;

  bool get finish => this == AppPageStatus.finish;
}
