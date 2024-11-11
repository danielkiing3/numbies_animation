import 'package:flutter/material.dart';

class TransparentElevatedButton extends StatelessWidget {
  const TransparentElevatedButton({
    super.key,
    required this.isExpanded,
  });

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    int animationValue = 200;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: animationValue),
        curve: Curves.decelerate,
        decoration: BoxDecoration(
          color: isExpanded
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
        ),
        height: 54,
        width: double.infinity,
        child: Center(
          child: AnimatedDefaultTextStyle(
            style: TextStyle(
              fontSize: 20,
              color: isExpanded ? Colors.white : Colors.black,
            ),
            duration: Duration(milliseconds: animationValue),
            child: AnimatedSwitcher(
              //TODO: Add a transition builder to fix the transition
              duration: Duration(milliseconds: animationValue),
              child: Text(
                isExpanded ? 'Start Session' : 'Cancel',
                key: ValueKey(isExpanded),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
