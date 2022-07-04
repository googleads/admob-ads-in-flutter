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

// COMPLETE: Import ad_helper.dart
import 'package:awesome_drawing_quiz/ad_helper.dart';
import 'package:awesome_drawing_quiz/app_theme.dart';
import 'package:awesome_drawing_quiz/drawing.dart';
import 'package:awesome_drawing_quiz/drawing_painter.dart';
import 'package:awesome_drawing_quiz/quiz_manager.dart';
import 'package:flutter/material.dart';

// COMPLETE: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'quiz_manager.dart';

class GameRoute extends StatefulWidget {
  const GameRoute({Key? key}) : super(key: key);

  @override
  State<GameRoute> createState() => _GameRouteState();
}

class _GameRouteState extends State<GameRoute> implements QuizEventListener {
  // COMPLETE: Add _bannerAd
  BannerAd? _bannerAd;

  // COMPLETE: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // COMPLETE: Add _rewardedAd
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();

    QuizManager.instance
      ..listener = this
      ..startGame();

    // COMPLETE: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    // COMPLETE: Load a rewarded Ad
    _loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Level ${QuizManager.instance.currentLevel}/5',
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          var answer = '';

                          return AlertDialog(
                            title: const Text('Enter your answer'),
                            content: TextField(
                              autofocus: true,
                              onChanged: (value) {
                                answer = value;
                              },
                            ),
                            actions: [
                              TextButton(
                                child: Text('submit'.toUpperCase()),
                                onPressed: () {
                                  Navigator.pop(context);
                                  QuizManager.instance.checkAnswer(answer);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Text(
                        QuizManager.instance.clue,
                        style: const TextStyle(
                          fontSize: 24.0
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24.0),
                          child: CustomPaint(
                            size: const Size(300, 300),
                            painter: DrawingPainter(
                              drawing: QuizManager.instance.drawing,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // COMPLETE: Display a banner when ready
            if (_bannerAd != null)
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
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
          children: [
            TextButton(
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

  Widget? _buildFloatingActionButton() {
    // COMPLETE: Return a FloatingActionButton if a Rewarded Ad is available
    return (!QuizManager.instance.isHintUsed && _rewardedAd != null)
        ? FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Need a hint?'),
                    content: const Text('Watch an Ad to get a hint!'),
                    actions: [
                      TextButton(
                        child: Text('cancel'.toUpperCase()),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('ok'.toUpperCase()),
                        onPressed: () {
                          Navigator.pop(context);
                          _rewardedAd?.show(
                            onUserEarnedReward: (_, reward) {
                              QuizManager.instance.useHint();
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
            label: const Text('Hint'),
            icon: const Icon(Icons.card_giftcard),
          )
        : null;
  }

  void _moveToHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // COMPLETE: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _moveToHome();
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  // COMPLETE: Implement _loadRewardedAd()
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void dispose() {
    // COMPLETE: Dispose a BannerAd object
    _bannerAd?.dispose();

    // COMPLETE: Dispose an InterstitialAd object
    _interstitialAd?.dispose();

    // COMPLETE: Dispose a RewardedAd object
    _rewardedAd?.dispose();

    QuizManager.instance.listener = null;

    super.dispose();
  }

  @override
  void onWrongAnswer() {
    _showSnackBar('Wrong answer!');
  }

  @override
  void onNewLevel(int level, Drawing drawing, String clue) {
    setState(() {});

    // COMPLETE: Load an Interstitial Ad
    if (level >= 3 && _interstitialAd == null) {
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
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game over!'),
          content: Text('Score: $correctAnswers/5'),
          actions: [
            TextButton(
              child: Text('close'.toUpperCase()),
              onPressed: () {
                // COMPLETE: Display an Interstitial Ad
                if (_interstitialAd != null) {
                  _interstitialAd?.show();
                } else {
                  _moveToHome();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void onClueUpdated(String clue) {
    setState(() {});

    _showSnackBar('You\'ve got one more clue!');
  }
}
