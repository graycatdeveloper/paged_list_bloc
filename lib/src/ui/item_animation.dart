part of '../../paged_list_bloc.dart';

class _ItemAnimationWidget extends StatefulWidget {

  const _ItemAnimationWidget({
    required Widget child
  }) : _child = child;

  final Widget _child;

  @override
  State createState() => _ItemAnimationState();

}

class _ItemAnimationState extends State<_ItemAnimationWidget>
    with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    value: 0,
    duration: const Duration(seconds: 2),
    vsync: this,
  )..animateTo(1);//..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _animation,
    child: widget._child
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}