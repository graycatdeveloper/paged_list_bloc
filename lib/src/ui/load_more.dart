part of '../../paged_list_bloc.dart';

class _LoadMoreWidget<
  BLOC extends PagedListBloc<STATE, ITEM>,
  STATE, ITEM
> extends StatelessWidget {

  const _LoadMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BLOC>(context);
    return BlocSelector<BLOC, PagedListState<STATE, ITEM>, PageStatus?>(
      selector: (state) => state.loadMoreStatus,
      builder: (_, status) {
        var color = Colors.transparent;
        VoidCallback? onTap;
        Widget child;
        if (status is LoadingPageStatus) {
          child = const CircularProgressIndicator(
            color: Colors.redAccent
          );
        } else if (status is EmptyPageStatus) {
          child = const Text('empty');
        } else if (status is ErrorPageStatus) {
          color = Colors.redAccent.withOpacity(.5);
          onTap = bloc._retry;
          child = Text(
            'Error: ${status.error}',
            style: const TextStyle(
              color: Colors.white
            )
          );
        } else {
          child = const Icon(
            Icons.check_circle,
            color: Colors.green
          );
        }
        return ListTile(
          onTap: onTap,
          tileColor: color,
          contentPadding: const EdgeInsets.all(10),
          title: Center(
            child: child
          ),
        );
      }
    );
  }

}