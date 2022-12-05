part of '../../paged_list_bloc.dart';

class PagedListState<STATE, ITEM> {

  const PagedListState({
    required this.state,
    this.page = 1,
    this.firstPageStatus,
    this.loadMoreStatus,
    this.items = const []
  });

  final STATE state;
  final int page;
  final PageStatus? firstPageStatus;
  final PageStatus? loadMoreStatus;
  final List<ITEM> items;

  PagedListState<STATE, ITEM> copyWith({
    final STATE? state,
    final int? page,
    final PageStatus? firstPageStatus,
    final PageStatus? loadMoreStatus,
    final List<ITEM>? items,
    dynamic error
  }) => PagedListState<STATE, ITEM>(
    state: state ?? this.state,
    page: page ?? this.page,
    firstPageStatus: firstPageStatus ?? this.firstPageStatus,
    loadMoreStatus: loadMoreStatus ??  this.loadMoreStatus,
    items: items ?? this.items
  );

  @override
  bool operator ==(dynamic other) => identical(this, other) ||
    (other.runtimeType == runtimeType &&
    other is PagedListState<STATE, ITEM> &&
    const DeepCollectionEquality().equals(other.state, state) &&
    (identical(other.page, page) || other.page == page) &&
    (identical(other.firstPageStatus, firstPageStatus) ||
      other.firstPageStatus == firstPageStatus) &&
    (identical(other.loadMoreStatus, loadMoreStatus) ||
      other.loadMoreStatus == loadMoreStatus) &&
    const DeepCollectionEquality().equals(other.items, items));

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(state),
    page,
    firstPageStatus,
    loadMoreStatus,
    const DeepCollectionEquality().hash(items)
  );

  @override
  String toString() =>
    'PagedListState<$STATE, $ITEM>('
      'state: $state, '
      'page: $page, '
      'firstPageStatus: $firstPageStatus, '
      'loadMoreStatus: $loadMoreStatus, '
      'items: $items'
    ')';

}