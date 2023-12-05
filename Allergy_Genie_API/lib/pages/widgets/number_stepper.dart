import 'package:flutter/material.dart';

class NumberStepper extends StatefulWidget {
  final int initialValue;
  final int min;
  final int max;
  final int step;
  final Function(int) onChanged;

  NumberStepper({
    required this.initialValue,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  @override
  _NumberStepperState createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              if (_currentValue > widget.min) {
                _currentValue -= widget.step;
                widget.onChanged(_currentValue);
              }
            });
          },
          icon: Icon(Icons.remove_circle, color: Colors.blueGrey),
        ),
        Text(
          _currentValue.toString(),
          style: TextStyle(fontSize: 25),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (_currentValue < widget.max) {
                _currentValue += widget.step;
                widget.onChanged(_currentValue);
              }
            });
          },
          icon: Icon(Icons.add_circle, color: Colors.blueGrey),
        ),
      ],
    );
  }
}
