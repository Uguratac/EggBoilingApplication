import 'dart:async';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:egg_application/constants/constans.dart';
import 'package:egg_application/pages/indicator.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Audio audio; // ses dosyasını kullanmak için
  late int _countdownSeconds; // kalan süre
  late bool _isCountingDown; // geri sayım devam ediyor mu etmiyor mu
  Timer? _countdownTimer; // geri sayım
  int seconds = 0;

  late List<AnimationController> _animationControllers; // animasyon için
  late List<Animation<double>> _animations;
  late List<bool> _isAnimatingList;

  @override
  void initState() {
    super.initState();

    audio = Audio.load(Constants.alarm);
    _countdownSeconds = 0;
    _isCountingDown = false;

    _animationControllers = List.generate(
      4,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      ),
    );

    _animations = _animationControllers
        .map((controller) =>
            Tween<double>(begin: 1.2, end: 1.5).animate(controller))
        .toList();

    _isAnimatingList = List.generate(4, (index) => false);
  }

  void _toggleAnimation(int index) {
    if (_isAnimatingList[index]) {
      if (_countdownSeconds == 0) {
        _animationControllers[index].reverse();
      }
    } else {
      _animationControllers[index].forward();
    }

    setState(() {
      _isAnimatingList[index] = !_isAnimatingList[index];
    });
    seconds = calculateSeconds(index);
    _startCountdown(seconds);
  }

  int calculateSeconds(int index) {
    return (2 * index + 5) * 60;
  }

  void _startCountdown(int seconds) {
    if (_isCountingDown) {
      _cancelCountdown();
    }

    setState(() {
      _countdownSeconds = seconds;
      _isCountingDown = true;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _isCountingDown = false;
          _cancelCountdown();
          _playAlarm();
          _showDialog();
        }
      });
    });
  }

  void _cancelCountdown() {
    if (_countdownTimer != null) {
      _countdownTimer!.cancel();
    }
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Constants.hazir),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(Constants.afiyet),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  void _playAlarm() async {
    await audio.play();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yumurta Haşlama Zamanlayıcısı'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Constants.bg), fit: BoxFit.cover)),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MyIndicator(
              isCountingDown: _isCountingDown,
              countdownSeconds: _countdownSeconds,
              second: seconds,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              height: 50,
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Text(
                _isCountingDown
                    ? "Yumurtanız Haşlanmaya Başladı"
                    : "Haşlamak istediğiniz Yumurtayı Seçiniz",
                style: const TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30.0,
              width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i <= 3; i++)
                  GestureDetector(
                    onTap: () {
                      _toggleAnimation(i);
                      _startCountdown(calculateSeconds(i));

                      // Diğer butonların animasyonunu tersine çevir
                      for (int j = 0; j <= 3; j++) {
                        if (j != i && _isAnimatingList[j]) {
                          _animationControllers[j].reverse();
                          _isAnimatingList[j] = false;
                        }
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _animationControllers[i],
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isCountingDown ? _animations[i].value : 1.2,
                          child: const EggPhoto(),
                        );
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: double.infinity,
              height: 30,
            ),
            const MyMin(),
          ],
        ),
      ),
    );
  }
}

class MyMin extends StatelessWidget {
  const MyMin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (int i = 0; i <= 3; i++)
          Container(
            width: 70,
            height: 50,
            decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(
                  Radius.elliptical(20, 20),
                )),
            child: Center(child: Text("${minute(i)} DK")),
          )
      ],
    );
  }
}

int minute(int i) {
  return 2 * i + 5;
}

class EggPhoto extends StatelessWidget {
  const EggPhoto({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth / 6.0,
      height: screenWidth / 5.0,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Icon2.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
