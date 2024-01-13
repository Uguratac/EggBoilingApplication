import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyIndicator extends StatefulWidget {
  const MyIndicator({
    Key? key,
    required bool isCountingDown,
    required int countdownSeconds,
    required int buttonIndex,
  })  : _isCountingDown = isCountingDown,
        _countdownSeconds = countdownSeconds,
        _buttonIndex = buttonIndex,
        super(key: key);

  final bool _isCountingDown;
  final int _countdownSeconds;
  final int _buttonIndex;

  @override
  State<MyIndicator> createState() => _MyIndicatorState();
}

class _MyIndicatorState extends State<MyIndicator> {
  double percent = 0;
  
 

  @override
  Widget build(BuildContext context) {
    int buttonIndex = widget._buttonIndex;

    
    int val = ((2 * buttonIndex + 5) * 60);

    if(widget._isCountingDown)
    {
      percent = 1 - (widget._countdownSeconds / val);
    }else{
      percent = 0;
    }

    

    return Container(
      margin: const EdgeInsets.all(70),
      child: CircularPercentIndicator(
        animation: true,
        animationDuration: 1 ~/
            (val), // burda tip dönüşümünden kaynaklı hata var halka yaklaşık 5 saniye kala tam doluyor.
        radius: 100,
        percent: percent,
        lineWidth: 20,
        progressColor: Colors.deepPurple.shade300,
        circularStrokeCap: CircularStrokeCap.round,
        center: Text(
          widget._isCountingDown ? '${widget._countdownSeconds} saniye' : '',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
