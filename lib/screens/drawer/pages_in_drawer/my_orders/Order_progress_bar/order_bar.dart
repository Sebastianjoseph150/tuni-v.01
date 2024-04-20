import 'package:flutter/material.dart';

class OrderProgressBar extends StatelessWidget {
  final int currentIndex;
  final int totalSteps;

  OrderProgressBar({required this.currentIndex, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Stepper(
        currentStep: currentIndex,
        steps: List.generate(
          totalSteps,
          (index) => Step(
            title: Text('Step ${index + 1}'),
            content: SizedBox.shrink(),
            isActive: index <= currentIndex,
          ),
        ),
      ),
    );
  }
}
