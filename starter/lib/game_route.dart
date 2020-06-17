// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// TODO: Import ad_manager.dart

// TODO: Import firebase_admob.dart


import 'package:awesome_drawing_quiz/app_theme.dart';
import 'package:awesome_drawing_quiz/drawing.dart';
import 'package:awesome_drawing_quiz/drawing_painter.dart';
import 'package:awesome_drawing_quiz/quiz_manager.dart';
import 'package:flutter/material.dart';

class GameRoute extends StatefulWidget {
  @override
  _GameRouteState createState() => _GameRouteState();
}

class _GameRouteState extends State<GameRoute> implements QuizEventListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _level;

  Drawing _drawing;

  String _clue;

  // TODO: Add _bannerAd


  // TODO: Add _interstitialAd


  // TODO: Add _isInterstitialAdReady


  // TODO: Add _isRewardedAdReady


  @override
  void initState() {
    super.initState();

    QuizManager.instance
      ..listener = this
      ..startGame();

    // TODO: Initialize _isInterstitialAdReady


    // TODO: Initialize _isRewardedAdReady


    // TODO: Initialize _bannerAd


    // TODO: Initialize _interstitialAd


    // TODO: Set Rewarded Ad Event listener


    // TODO: Load a Banner Ad


    // TODO: Load a Rewarded Ad

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.primary,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Level $_level/5',
                    style: TextStyle(fontSize: 32),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlineButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          String _answer = '';

                          return AlertDialog(
                            title: Text('Enter your answer'),
                            content: TextField(
                              autofocus: true,
                              onChanged: (value) {
                                _answer = value;
                              },
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('submit'.toUpperCase()),
                                onPressed: () {
                                  Navigator.pop(context);
                                  QuizManager.instance.checkAnswer(_answer);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      _clue,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(24),
                          child: CustomPaint(
                            size: Size(300, 300),
                            painter: DrawingPainter(
                              drawing: _drawing,
                            ),
                          ),
                        )
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: EdgeInsets.all(16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        child: ButtonBar(
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            FlatButton(
              child: Text('Skip this level'.toUpperCase()),
              onPressed: () {
                QuizManager.instance.nextLevel();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    // TODO: Return a FloatingActionButton if a Rewarded Ad is available
    return null;
  }

  void _moveToHome() {
    Navigator.pushNamedAndRemoveUntil(
        _scaffoldKey.currentContext, '/', (_) => false);
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // TODO: Implement _loadBannerAd()


  // TODO: Implement _loadInterstitialAd()


  // TODO: Implement _loadRewardedAd()


  // TODO: Implement _onInterstitialAdEvent()


  // TODO: Implement _onRewardedAdEvent()


  @override
  void dispose() {
    // TODO: Dispose BannerAd object


    // TODO: Dispose InterstitialAd object


    // TODO: Remove Rewarded Ad event listener


    QuizManager.instance.listener = null;

    super.dispose();
  }

  @override
  void onWrongAnswer() {
    _showSnackBar('Wrong answer!');
  }

  @override
  void onNewLevel(int level, Drawing drawing, String clue) {
    setState(() {
      _level = level;
      _drawing = drawing;
      _clue = clue;
    });

    // TODO: Load an Interstitial Ad

  }

  @override
  void onLevelCleared() {
    _showSnackBar('Good job!');
  }

  @override
  void onGameOver(int correctAnswers) {
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialog(
          title: Text('Game over!'),
          content: Text('Score: $correctAnswers/5'),
          actions: <Widget>[
            FlatButton(
              child: Text('close'.toUpperCase()),
              onPressed: () {
                // TODO: Display an Interstitial Ad


                _moveToHome();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void onClueUpdated(String clue) {
    setState(() {
      _clue = clue;
    });

    _showSnackBar('You\'ve got one more clue!');
  }
}
