import 'dart:async';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Audio audio = Audio.load('assets/audios/alarm.mp3');
  int _countdownSeconds = 0;
  bool _isCountingDown = false;
  Timer? _countdownTimer;

  void _startCountdown(int seconds) {
    
  if (_isCountingDown) {
    // Halihazırda devam eden bir geri sayım varsa, yenisine başlamadan önce eski geri sayımı iptal eder
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
          title: const Text('Yumurtalar Hazır!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Afiyet olsun!'),
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
    await _showDialog(); // Süre bittiğinde pencereyi göster
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yumurta Haşlama Zamanlayıcısı'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg")
          )
        ),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
          
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 50,
                  
                  decoration: const  BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
          
                  child: Text(
                    _isCountingDown
                        ? 'Kalan Süre: $_countdownSeconds saniye'
                        : 'Lütfen Haşlamak İstediğiniz Yumurtayı seçiniz',
                    style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,
                  ),
                ),
          
                const SizedBox(height: 30.0,width: double.infinity,),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
          
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            _startCountdown(3 * 60), // 3 dakika
                        child: EggPhoto(path: ImageItems.three),
                      ),
                    ),
          
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            _startCountdown(5 * 60), // 5 dakika
                        child: EggPhoto(path: ImageItems.five),
                      ),
                    ),
                    
                   Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            _startCountdown(7 * 60), // 7 dakika
                        child: EggPhoto(path: ImageItems.seven),
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(width: double.infinity,height: 50,),          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            _startCountdown(9 * 60), // 9 dakika
                        child: EggPhoto(path: ImageItems.nine),
                      ),
                    ),
          
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            _startCountdown(11 * 60), // 11 dakika
                        child: EggPhoto(path: ImageItems.eleven),
                      ),
                    ),
          
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            _startCountdown(13 * 60), // 13 dakika
                        child: EggPhoto(path: ImageItems.thirteen),
                      ),
                    ),
          
                ],),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class EggPhoto extends StatelessWidget {
  EggPhoto({
    required String this.path,
    super.key,
  });

  String? path;

  @override
  Widget build(BuildContext context) {
    return Container( 
      width: 65,
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(width: 5),
        borderRadius: const BorderRadius.all(Radius.elliptical(20.0,10.0)),
      ),
      child: Image.asset(path!,fit: BoxFit.cover,),
    );
  }
}

class ImageItems{
  static String three = 'assets/images/3.png';
  static String five = 'assets/images/5.png';
  static String seven = 'assets/images/7.png';
  static String nine = 'assets/images/9.png';
  static String eleven = 'assets/images/11.png';
  static String thirteen = 'assets/images/13.png';

}