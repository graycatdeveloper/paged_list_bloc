part of '../../paged_list_bloc.dart';

class PagedList<BLOC extends PagedListBloc<STATE, ITEM>, STATE, ITEM>
    extends StatelessWidget {

  PagedList({
    required final ItemWidgetBuilder<ITEM> itemBuilder,
    final List<Widget>? beforeSlivers,
    final OnPageStatus? onFirstLoad,
    final OnPageStatus? onLoadMore,
    //final OnPageError? onError,
    super.key
  }) : _itemBuilder = itemBuilder,
       _beforeSlivers = beforeSlivers,
       _onFirstLoad = onFirstLoad,
       _onLoadMore = onLoadMore;
       //_onError = onError;

  final ItemWidgetBuilder<ITEM> _itemBuilder;
  final List<Widget>? _beforeSlivers;
  final OnPageStatus? _onFirstLoad;
  final OnPageStatus? _onLoadMore;
  //final OnPageError? _onError;

  final _scrollController = ScrollController();
  final _toToButtonVisible = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BLOC>(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final topMargin = statusBarHeight + kToolbarHeight;
    return MultiBlocListener(
      listeners: [
        BlocListener<BLOC, PagedListState<ITEM, STATE>>(
          listenWhen: (p, c) =>
            _onFirstLoad != null &&
            c.firstPageStatus != null && (
            c.firstPageStatus is LoadingPageStatus ||
            p.firstPageStatus != c.firstPageStatus),
          listener: (context, state) {
            _onFirstLoad!(state.firstPageStatus!);
          },
        ),
        BlocListener<BLOC, PagedListState<ITEM, STATE>>(
          listenWhen: (p, c) =>
            _onLoadMore != null &&
            c.loadMoreStatus != null && (
            c.loadMoreStatus is LoadingPageStatus ||
            p.loadMoreStatus != c.loadMoreStatus),
          listener: (context, state) {
            _onLoadMore!(state.loadMoreStatus!);
          },
        ),
        /*BlocListener<BLOC, PagedListState<ITEM, STATE>>(
          listenWhen: (p, c) => _onError != null && p.error != c.error,
          listener: (context, state) {
            _onError!(state.error);
          },
        ),*/
      ],
      child: RefreshIndicator(
        edgeOffset: topMargin,
        notificationPredicate: (notification) {
          _toToButtonVisible.value = notification.metrics.pixels >= 200;
          if (notification.metrics.maxScrollExtent - notification.metrics.pixels <= 500) {
            //bloc.onLoadMore();
          }
          if (notification.metrics.atEdge) {
            if (notification.metrics.pixels == 0) {
              //top
            } else {
              //bottom
            }
          }
          return notification.depth == 0;
        },
        onRefresh: () => Future.sync(bloc.load),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PrimaryScrollController(
              controller: _scrollController,
              child: RawScrollbar(
                mainAxisMargin: 15,
                crossAxisMargin: 10,
                padding: EdgeInsets.only(top: topMargin),
                thumbColor: Colors.redAccent.withOpacity(.1),
                radius: const Radius.circular(3),
                thickness: 5,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    ...?_beforeSlivers,
                    //SliverPersistentHeader(),
                    BlocSelector<BLOC, PagedListState<ITEM, STATE>, PageStatus?>(
                      selector: (state) => state.firstPageStatus,
                      builder: (_, status) {
                        Widget child;
                        if (status is LoadingPageStatus) {
                          child = _loading();
                        } else if (status is EmptyPageStatus) {
                          child = _empty(bloc);
                        } else if (status is ErrorPageStatus) {
                          child = _error(bloc, status.error);
                        } else {
                          child = _complete(bloc);
                        }
                        return SliverAnimatedSwitcher(
                          duration: const Duration(microseconds: 500),
                          child: Container(
                            key: ObjectKey(status),
                            child: child,
                          )
                        );
                      }
                    )
                  ],
                ),
              )
            ),
            _toTopButton()
          ]
        )
      )
    );
  }

  Widget _toTopButton() => _ToTopButton(
    notifier: _toToButtonVisible,
    onTap: () => _scrollController.animateTo(0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear
    )
  );

  Widget _loading() => const SliverFillRemaining(
    hasScrollBody: false,
    child: Center(
      child: CircularProgressIndicator(
        color: Colors.redAccent
      )
    )
  );

  Widget _empty(BLOC bloc) => const SliverFillRemaining(
    hasScrollBody: false,
    child: Center(
      child: Text('empty')
    )
  );

  Widget _error(BLOC bloc, Object error) => SliverFillRemaining(
    hasScrollBody: false,
    child: Center(
      child: Text('error: $error')
    )
  );

  Widget _complete(BLOC bloc) =>
    BlocSelector<BLOC, PagedListState<ITEM, STATE>, List<ITEM>>(
      selector: (state) => state.items,
      builder: (_, items) => SliverList(
        delegate: SliverChildBuilderDelegate(
          semanticIndexCallback: (_, index) =>
          index.isEven ? index ~/ 2 : null,
          childCount: items.length * 2 + (!bloc._isLastPage ? 1 : -1),
          (context, index) {
            final itemIndex = index ~/ 2;
            if (items.isNotEmpty && itemIndex == items.length) {
              return _LoadMoreWidget<BLOC, STATE, ITEM>();
            }
            if (index.isEven) {
              _nextPageRequest(bloc, itemIndex, items);
              return _item(itemIndex);
            }
            return _divider();
          }
        )
      )
    );

  void _nextPageRequest(BLOC bloc, int itemIndex, List<ITEM> items) {
    if (!bloc._hasNextPageRequest) {
      final trigger = items.isNotEmpty &&
          itemIndex == math.max(0, items.length - 1);
      if (!bloc._isLastPage && trigger) {
        WidgetsBinding.instance.addPostFrameCallback((_) => bloc.loadMore());
        bloc._hasNextPageRequest = true;
      }
    }
  }

  Widget _item(int itemIndex) =>
    BlocSelector<BLOC, PagedListState<ITEM, STATE>, ITEM?>(
      key: UniqueKey(),
      selector: (state) => state.items.elementAtOrNull(itemIndex),
      builder: (context, item) {
        if (item != null) {
          return _ItemAnimationWidget(
            child: _itemBuilder(context, itemIndex, item)
          );
        }
        return const SizedBox.shrink();
      }
    );

  Widget _divider() => Container(
    width: double.infinity,
    height: 1,
    color: Colors.black.withOpacity(.1)
  );

}