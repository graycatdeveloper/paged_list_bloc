part of '../../paged_list_bloc.dart';

class PagedListEvent {
  const PagedListEvent();
}

class _LoadEvent extends PagedListEvent {
  const _LoadEvent();
}

class _LoadMoreEvent extends PagedListEvent {
  const _LoadMoreEvent();
}

class _RetryEvent extends PagedListEvent {
  const _RetryEvent();
}