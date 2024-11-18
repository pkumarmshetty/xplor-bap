import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../gen/assets.gen.dart';

/*
class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key, this.seconds});

  final int? seconds;

  @override
  State<LoadingAnimation> createState() => _WalletLoadingAnimationState();
}

class _WalletLoadingAnimationState extends State<LoadingAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.seconds ?? 2),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: AppColors.white.withOpacity(0.4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          double initialSize = max(20.0 - index * 5.0, 5.0);
          Color dotColor = index.isEven ? appTheme().colors.blue500 : appTheme().colors.grey100;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double size = initialSize + 10.0 * sin(_controller.value * 2 * pi); // Adjust amplitude as needed
              size = max(size, 5.0); // Ensure size is always positive

              return AnimatedContainer(
                duration: const Duration(seconds: 1),
                width: size,
                height: size,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              );
            },
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

*/

/*class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(Assets.files.loader, height: 50, width: 50));
  }
}*/

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // AbsorbPointer disables gestures on the background screen
        const AbsorbPointer(
          absorbing: true, // Set to true to disable gestures
          child: ModalBarrier(
            //color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
            dismissible: false, // Prevents user from dismissing the barrier
          ),
        ),
        Center(
          child: Lottie.asset(
            Assets.files.loader,
            height: 50,
            width: 50,
          ),
        ),
      ],
    );
  }
}
