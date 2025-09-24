import 'package:flutter/material.dart';

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final scaleAnimation =
                Tween<double>(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            );
            return ScaleTransition(scale: scaleAnimation, child: child);
          },
        );
}

void navigateWithScale(BuildContext context, Widget page) {
  Navigator.of(context).push(ScaleRoute(page: page));
}
