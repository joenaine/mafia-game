import 'package:flutter/material.dart';

import 'app_global_loader_widget.dart';

class AppOverlayLoadingWidget extends StatelessWidget {
  final Widget? child;
  final bool? isLoading;
  const AppOverlayLoadingWidget({
    Key? key,
    this.child,
    @required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child!,
        isLoading!
            ? Positioned.fill(
                child: Container(
                  color: Colors.grey.withOpacity(0.6),
                  child: Center(
                    child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 15,
                                color: Colors.grey.withOpacity(0.4))
                          ],
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: AppLoaderWidget()),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
