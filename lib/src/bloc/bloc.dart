part of '../../paged_list_bloc.dart';

abstract class PagedListBloc<STATE, ITEM>
    extends Bloc<PagedListEvent, PagedListState<STATE, ITEM>> {

  PagedListBloc(STATE initialState) :
        super(PagedListState<STATE, ITEM>(state: initialState));

  //int _page = 1;
  bool _hasNextPageRequest = false;
  bool _isLastPage = false;

  @protected
  @nonVirtual
  void onPaged<RESPONSE>({
    required int pageSize,
    required RequestBuilder<RESPONSE> requestBuilder,
    required ResponseMapper<RESPONSE, ITEM> responseMapper,
    OnError<STATE>? onError
  }) {
    Future<void> func(Emitter emit, int page) async {
      emit(state.copyWith(page: page));
      await _request<RESPONSE>(
        requestBuilder: requestBuilder,
        responseMapper: responseMapper,
        page: page,
        pageSize: pageSize,
        emit: emit,
        onError: onError
      );
      _hasNextPageRequest = false;
    }
    on<_LoadEvent>((event, emit) => func(emit, event.page),
        transformer: restartable());
    on<_LoadMoreEvent>((_, emit) => func(emit, state.page + 1),
        transformer: restartable());
    on<_RetryEvent>((_, emit) => func(emit, state.page),
        transformer: restartable());
  }

  Future<void> _request<RESPONSE>({
    required RequestBuilder<RESPONSE> requestBuilder,
    required ResponseMapper<RESPONSE, ITEM> responseMapper,
    required int page,
    required int pageSize,
    required Emitter emit,
    OnError<STATE>? onError
  }) async {
    final isLoadMore = page > 1;
    emit(state.copyWith(
      firstPageStatus: isLoadMore
          ? state.firstPageStatus : const PageStatus.loading(),
      loadMoreStatus: isLoadMore
          ? const PageStatus.loading() : state.loadMoreStatus
    ));
    final cancelToken = CancelToken();
    final request = requestBuilder(page, pageSize, cancelToken);
    final cancelable = CancelableOperation.fromFuture(request, onCancel: () {
      cancelToken.cancel('CANCEL REQUEST: ${cancelToken.requestOptions?.uri}');
    });
    await emit.forEach(cancelable.asStream(),
      onData: (response) {
        if (response.isEmpty) {
          return state.copyWith(
            firstPageStatus: isLoadMore
                ? state.firstPageStatus : const PageStatus.empty(),
            //loadMoreStatus: isLoadMore
                //? PageStatus.empty : state.loadMoreStatus
          );
        }
        _isLastPage = response.length < pageSize;

        final newItems = responseMapper(response);

        final previousItems = page == 1 ? <ITEM>[] : state.items;
        final items = previousItems + newItems;

        return state.copyWith(
          firstPageStatus: isLoadMore
              ? state.firstPageStatus : const PageStatus.complete(),
          loadMoreStatus: isLoadMore
              ? const PageStatus.complete() : state.loadMoreStatus,
          items: items,
          error: null
        );
      },
      onError: (error, _) => state.copyWith(
        state: onError?.call(error, state.state) ?? state.state,
        firstPageStatus: isLoadMore
            ? state.firstPageStatus : PageStatus.error(error),
        loadMoreStatus: isLoadMore
            ? PageStatus.error(error) : state.loadMoreStatus,
        error: error
      )
    );
  }

  void _onRefresh() => pagedLoad(page: 1);
  void _loadMore() => add(const _LoadMoreEvent());
  void _retry() => add(const _RetryEvent());

  void pagedLoad({required int page}) => add(_LoadEvent(page));

}