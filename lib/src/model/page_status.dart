part of '../../paged_list_bloc.dart';

class PageStatus {
  const PageStatus();
  const factory PageStatus.loading() = LoadingPageStatus;
  const factory PageStatus.complete() = CompletePageStatus;
  const factory PageStatus.empty() = EmptyPageStatus;
  const factory PageStatus.error(Object error) = ErrorPageStatus;
}

class LoadingPageStatus extends PageStatus {
  const LoadingPageStatus();
}

class CompletePageStatus extends PageStatus {
  const CompletePageStatus();
}

class EmptyPageStatus extends PageStatus {
  const EmptyPageStatus();
}

class ErrorPageStatus extends PageStatus {
  const ErrorPageStatus(this.error);
  final Object error;
}