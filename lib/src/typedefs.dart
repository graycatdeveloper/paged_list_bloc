part of '../paged_list_bloc.dart';

typedef RequestBuilder<RESPONSE> = Future<List<RESPONSE>>
  Function(int page, int pageSize, CancelToken cancelToken);

typedef ResponseMapper<RESPONSE, ITEM> =
  List<ITEM> Function(List<RESPONSE> response);

typedef OnError<STATE> =
  STATE Function(Object error, STATE state);

typedef ItemWidgetBuilder<ITEM> = Widget
  Function(BuildContext context, int index, ITEM item);

typedef OnPageStatus = Function(PageStatus status);
typedef OnPageError = Function(Object error);