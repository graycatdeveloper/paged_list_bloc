part of '../../paged_list_bloc.dart';

class PagedListState<ITEM, STATE> {

  const PagedListState({
    required this.state,
    this.firstPageStatus,// = const PageStatus.loading(),
    this.loadMoreStatus,// = const PageStatus.loading(),
    this.items = const [],
    //this.error
  });

  final STATE state;
  final PageStatus? firstPageStatus;
  final PageStatus? loadMoreStatus;
  final List<ITEM> items;
  //final dynamic error;

  PagedListState<ITEM, STATE> copyWith({
    final STATE? state,
    final PageStatus? firstPageStatus,
    final PageStatus? loadMoreStatus,
    final List<ITEM>? items,
    dynamic error
  }) => PagedListState<ITEM, STATE>(
    state: state ?? this.state,
    firstPageStatus: firstPageStatus ?? this.firstPageStatus,
    loadMoreStatus: loadMoreStatus ??  this.loadMoreStatus,
    items: items ?? this.items,
    //error: error ?? this.error
  );

  @override
  bool operator ==(dynamic other) => identical(this, other) ||
    (other.runtimeType == runtimeType &&
    other is PagedListState<ITEM, STATE> &&
    const DeepCollectionEquality().equals(other.state, state) &&
    (identical(other.firstPageStatus, firstPageStatus) ||
      other.firstPageStatus == firstPageStatus) &&
    (identical(other.loadMoreStatus, loadMoreStatus) ||
      other.loadMoreStatus == loadMoreStatus) &&
    const DeepCollectionEquality().equals(other.items, items)/* &&
    const DeepCollectionEquality().equals(other.error, error)*/);

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(state),
    firstPageStatus,
    loadMoreStatus,
    const DeepCollectionEquality().hash(items),
    //const DeepCollectionEquality().hash(error)
  );

  @override
  String toString() =>
    'PagedListState<$ITEM, $STATE>('
      'state: $state, '
      'firstPageStatus: $firstPageStatus, '
      'loadMoreStatus: $loadMoreStatus, '
      'items: $items'
      //'error: $error'
    ')';

}