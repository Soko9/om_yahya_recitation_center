import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';

class AppLoader extends StatefulWidget {
  const new({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 3.sec)
      ..repeat(reverse: true);
    _animation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: AppColors.orange, end: AppColors.red),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: AppColors.red, end: AppColors.green),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: AppColors.green, end: AppColors.orange),
        weight: 1,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => CircularProgressIndicator(
        color: _animation.value,
        strokeWidth: 24,
        strokeCap: .round,
      ),
    );
  }
}
