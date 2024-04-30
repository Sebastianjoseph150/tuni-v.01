import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderProgressBar extends StatelessWidget {
  final int currentIndex;
  final int totalSteps;

  const OrderProgressBar(
      {super.key, required this.currentIndex, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Platform.isIOS
          ? CupertinoScrollbar(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: totalSteps,
                itemBuilder: (context, index) {
                  final isActive = index <= currentIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? CupertinoColors.activeBlue
                                : CupertinoColors.systemGrey,
                          ),
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                color: isActive
                                    ? CupertinoColors.white
                                    : CupertinoColors.systemGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Step ${index + 1}',
                          style: TextStyle(
                            color: isActive
                                ? CupertinoColors.black
                                : CupertinoColors.systemGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : Stepper(
              currentStep: currentIndex,
              steps: List.generate(
                totalSteps,
                (index) => Step(
                  title: Text('Step ${index + 1}'),
                  content: const SizedBox.shrink(),
                  isActive: index <= currentIndex,
                ),
              ),
            ),
    );
  }
}
