part of '../../paged_list_bloc.dart';

class _ToTopButton extends ValueListenableBuilder<bool> {

  _ToTopButton({
    required final ValueNotifier<bool> notifier,
    required final VoidCallback onTap
  }) : super(
    valueListenable: notifier,
    builder: (context, visible, _) => IgnorePointer(
      ignoring: !visible,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: const Icon(
                  Icons.arrow_drop_up,
                  color: Colors.white
                ),
              ),
            ),
          )
        ),
      ),
    )
  );

}