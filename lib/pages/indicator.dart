import 'package:egg_application/constants/constans.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyIndicator extends StatefulWidget {
  const MyIndicator(
      {Key? key,
      required bool isCountingDown,
      required int countdownSeconds,
      required int second})
      : _isCountingDown = isCountingDown,
        _countdownSeconds = countdownSeconds,
        seconds = second,
        super(key: key);

  final bool _isCountingDown;
  final int _countdownSeconds;
  final int seconds;

  @override
  State<MyIndicator> createState() => _MyIndicatorState();
}

class _MyIndicatorState extends State<MyIndicator> {
  double percent = 0;

  @override
  Widget build(BuildContext context) {
    if (widget._isCountingDown) {
      percent = 1 - (widget._countdownSeconds / widget.seconds);
    } else {
      percent = 0;
    }

    return Container(
      margin: const EdgeInsets.all(70),
      child: CircularPercentIndicator(
        animation: true,
        animationDuration: widget._isCountingDown
            ? 1 ~/ (widget.seconds)
            : 0, // burda tip dönüşümünden kaynaklı hata var halka yaklaşık 5 saniye kala tam doluyor.
        radius: 100,
        percent: percent,
        lineWidth: 20,
        progressColor: Constants.myColor,
        circularStrokeCap: CircularStrokeCap.round,
        center: Text(
          widget._isCountingDown ? '${widget._countdownSeconds} saniye' : '',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
