
// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:firebase_crud_project/models/display_data.dart';

enum NumpadData {
  num0,
  num1,
  num2,
  num3,
  num4,
  num5,
  num6,
  num7,
  num8,
  num9,
  space,
  delete,
}
typedef OnNumpadTapEvent = void Function(NumpadData aNumpad);

class NumpadWidget extends StatelessWidget {
  final OnNumpadTapEvent? onNumpadTap;
  final List<NumpadData> _numpadList = [
    NumpadData.num1,
    NumpadData.num2,
    NumpadData.num3,
    NumpadData.num4,
    NumpadData.num5,
    NumpadData.num6,
    NumpadData.num7,
    NumpadData.num8,
    NumpadData.num9,
    NumpadData.space,
    NumpadData.num0,
    NumpadData.delete,
  ];

  Widget? _buildButton(NumpadData aNumpadData) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: (aNumpadData == NumpadData.space)
          ? const SizedBox()
          : FloatingActionButton(
              onPressed: () {
                if (this.onNumpadTap != null) this.onNumpadTap!(aNumpadData);
              },
              backgroundColor: Colors.amber,
              splashColor: Colors.greenAccent,
              child: (aNumpadData == NumpadData.delete)
                  ? const Icon(
                      Icons.arrow_back,
                      color: Colors.red,
                      size: 34,
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${aNumpadData.index}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
    );
  }

  Widget? _buildNumpadGrid(List<NumpadData> aNumList) {
    const double runSpacing = 12;
    const double spacing = 12;
    const columnCount = 3;
    final keyboardSize = displayWidth()! * 0.65;
    final buttonSize =
        (keyboardSize - spacing * (columnCount - 1)) / columnCount;
    return Wrap(
      runSpacing: runSpacing,
      spacing: spacing,
      runAlignment: WrapAlignment.center,
      children: List.generate(
        aNumList.length,
        (index) => SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: _buildButton(aNumList[index]),
        ),
      ),
    );
  }

  NumpadWidget({Key? key, required this.onNumpadTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: _buildNumpadGrid(_numpadList),
        ),
      ],
    );
  }
}

class PasscodeDot extends StatelessWidget {
  final double dotSize = 14;
  final bool filled;
  final double shakeOffset = 0;

  const PasscodeDot({Key? key, required this.filled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: shakeOffset),
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              blurRadius: 3.0,
              color: Colors.black26,
              offset: Offset(3.0, 3.0),
              spreadRadius: 1.0),
        ],
        borderRadius: BorderRadius.circular(14),
        color: (filled) ? Colors.amber : Colors.red,
      ),
    );
  }
}
