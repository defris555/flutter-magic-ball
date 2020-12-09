import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

import './constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final Random _random = Random();
  bool _newAsk = true;
  double _zoomCenter = 0.7;
  double _zoomFont = 0.26;
  String _answer;
  String _nextAnswer;

  Animation _animation;
  Animation _animaFont;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _nextAnswer = Answers[_random.nextInt(Answers.length)];
    ShakeDetector.autoStart(onPhoneShake: () {
      zoomInOut();
    });
  }

  void zoomInOut() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        Tween<double>(begin: 0.7, end: 0.1).animate(_animationController);
    _animaFont =
        Tween<double>(begin: 0.26, end: 0.01).animate(_animationController);
    _animation.addListener(() {
      setState(() {
        _nextAnswer = Answers[_random.nextInt(Answers.length)];
        _zoomCenter = _animation.value;
        _zoomFont = _animaFont.value;
        if (_animation.value.toString() == '0.1') {
          _newAsk = !_newAsk;
        }
      });
    });
    if (_newAsk) {
      _answer = _nextAnswer;
    }
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/ball.png'),
                  ),
                ),
              ),
              Container(
                width: width * _zoomCenter,
                height: height * _zoomCenter,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage('assets/center.png'),
                        ),
                      ),
                    ),
                    _newAsk
                        ? Container(
                            width: width * _zoomFont,
                            child: FittedBox(
                              child: Text(
                                ballText,
                                style: TextStyle(
                                  color: blue,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container(
                            width: width * _zoomFont,
                            child: FittedBox(
                              child: Text(
                                _answer,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: blue,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                    FlatButton(
                      child: Text(''),
                      onPressed: () {
                        zoomInOut();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
