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

// COMPLETE: Import ad_manager.dart
import 'package:awesome_drawing_quiz/ad_manager.dart';
import 'package:awesome_drawing_quiz/app_theme.dart';
import 'package:awesome_drawing_quiz/drawing.dart';
import 'package:awesome_drawing_quiz/drawing_painter.dart';
import 'package:awesome_drawing_quiz/quiz_manager.dart';
// COMPLETE: Import firebase_admob.dart
import 'package:firebase_admob/firebase_admob.dart';
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

  // COMPLETE: Add _bannerAd
  BannerAd _bannerAd;

  // COMPLETE: Add _interstitialAd
  InterstitialAd _interstitialAd;

  // COMPLETE: Add _isInterstitialAdReady
  bool _isInterstitialAdReady;

  // COMPLETE: Add _isRewardedAdReady
  bool _isRewardedAdReady;

  @override
  void initState() {
    super.initState();

    QuizManager.instance
      ..listener = this
      ..startGame();

    // COMPLETE: Initialize _isInterstitialAdReady
    _isInterstitialAdReady = false;
    // COMPLETE: Initialize _isRewardedAdReady
    _isRewardedAdReady = false;

    // COMPLETE: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );

    // COMPLETE: Initialize _interstitialAd
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );

    // COMPLETE: Set Rewarded Ad Event listener
    RewardedVideoAd.instance.listener = _onRewardedAdEvent;

    // COMPLETE: Load a Banner Ad
    _loadBannerAd();
    // COMPLETE: Load a Rewarded Ad
    _loadRewardedAd();
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
    // COMPLETE: Return a FloatingActionButton if a Rewarded Ad is available
    return (!QuizManager.instance.isHintUsed && _isRewardedAdReady)
        ? FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Need a hint?'),
                    content: Text('Watch an Ad to get a hint!'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('cancel'.toUpperCase()),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('ok'.toUpperCase()),
                        onPressed: () {
                          Navigator.pop(context);
                          RewardedVideoAd.instance.show();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            label: Text('Hint'),
            icon: Icon(Icons.card_giftcard),
          )
        : null;
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

  // COMPLETE: Implement _loadBannerAd()
  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.top);
  }

  // COMPLETE: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  // COMPLETE: Implement _loadRewardedAd()
  void _loadRewardedAd() {
    RewardedVideoAd.instance.load(
      targetingInfo: MobileAdTargetingInfo(),
      adUnitId: AdManager.rewardedAdUnitId,
    );
  }

  // COMPLETE: Implement _onInterstitialAdEvent()
  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        _moveToHome();
        break;
      default:
      // do nothing
    }
  }

  // COMPLETE: Implement _onRewardedAdEvent()
  void _onRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        setState(() {
          _isRewardedAdReady = true;
        });
        break;
      case RewardedVideoAdEvent.closed:
        setState(() {
          _isRewardedAdReady = false;
        });
        _loadRewardedAd();
        break;
      case RewardedVideoAdEvent.failedToLoad:
        setState(() {
          _isRewardedAdReady = false;
        });
        print('Failed to load a rewarded ad');
        break;
      case RewardedVideoAdEvent.rewarded:
        QuizManager.instance.useHint();
        break;
      default:
      // do nothing
    }
  }

  @override
  void dispose() {
    // COMPLETE: Dispose BannerAd object
    _bannerAd?.dispose();
    // COMPLETE: Dispose InterstitialAd object
    _interstitialAd?.dispose();
    // COMPLETE: Remove Rewarded Ad event listener
    RewardedVideoAd.instance.listener = null;
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

    // COMPLETE: Load an Interstitial Ad
    if (level >= 3 && !_isInterstitialAdReady) {
      _loadInterstitialAd();
    }
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
                // COMPLETE: Display an Interstitial Ad
                if (_isInterstitialAdReady) {
                  _interstitialAd.show();
                }
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
