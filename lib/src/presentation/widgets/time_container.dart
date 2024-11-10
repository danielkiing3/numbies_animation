import 'dart:io';

import 'package:flutter/material.dart';
import 'package:numbies_animation/src/models/time_model.dart';

class TimeContainer extends StatelessWidget {
  const TimeContainer({
    super.key,
    required this.time,
    this.animation = 0,
  });

  /// Timemodal object
  final TimeModel time;

  /// Animation value passed from [ModalContent] class
  final double animation;

  @override
  Widget build(BuildContext context) {
    // final alignmentTween = AlignmentTween(
    //   begin: Alignment.centerLeft,
    //   end: Alignment.center,
    // );

    /// Interpolating between two [AlignmentGeometry] values based on a animation value
    final aligment =
        Alignment.lerp(Alignment.centerLeft, Alignment.center, animation)
            as AlignmentGeometry;

    return Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: time.color,
        borderRadius: BorderRadius.circular(
          Platform.isAndroid ? 10 + (animation * 10) : 20 + (animation * 20),
        ),
      ),
      child: Align(
        alignment: aligment,
        // alignmentTween.evaluate(
        //   AlwaysStoppedAnimation(animation),
        // ),
        child: Transform.scale(
          scale: 1 + (animation * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // -- Actual Time
              Text(
                time.timeInString,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 4),

              // -- Time Count
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(6, (index) {
                  if (index + 1 <= time.timeCount) {
                    return Container(
                      height: 6,
                      width: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    return Container(
                      height: 6,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
