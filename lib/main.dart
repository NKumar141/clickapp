import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;
  int _counter = 0;
  int _button = 0;

  void _incrementCounter() {
    if (_button == 1) {
      setState(() {
        _counter++;
      });
    }
  }

  void reset() {
    setState(() {
      _counter = 0;
      _timer.cancel();
      _start = 30;
      _button = 0;
    });
  }

  late Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _button = 0;
            timer.cancel();
          });
        } else {
          setState(() {
            _button = 1;
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(70, 70),
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    startTimer();
                  },
                  child: Text("start"),
                ),
                ElevatedButton(
                  child: Text("Reset"),
                  onPressed: reset,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(70, 70),
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "$_start",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'You have pushed the button this many times in 30 seconds:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            Text(
              '$_counter',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 10),
            Text(
              'Press Start and Tap on the Below Button',
              style: TextStyle(color: Colors.grey[400], fontSize: 20.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                child: Transform.scale(
                  scale: _scale,
                  child: _animatedButtonUI,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
        height: 70,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                color: Color(0x80000000),
                blurRadius: 30.0,
                offset: Offset(0.0, 5.0),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0000FF),
                Color(0xFFFF3500),
              ],
            )),
        child: Center(
          child: Text(
            'tap',
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      );

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    _incrementCounter();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
