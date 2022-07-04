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

import 'package:awesome_drawing_quiz/drawing.dart';

class QuizManager {

  static const _maxGameLevel = 5;

  QuizManager._();

  static final QuizManager _instance = QuizManager._();

  static QuizManager get instance => _instance;

  late Drawing _drawing;

  late String _clue;

  int _currentLevel = 1;

  bool _isHintUsed = false;

  int _disclosedLettersCnt = 1;

  int _correctAnswers = 0;

  QuizEventListener? listener;

  int get currentLevel => _currentLevel;

  Drawing get drawing => _drawing;

  String get clue => _clue;

  bool get isHintUsed => _isHintUsed;

  void startGame() {
    _correctAnswers = 0;
    _startLevel(1);
  }

  void checkAnswer(String answer) {
    bool correct = _drawing.word == answer.toLowerCase();
    
    if (correct) {
      _correctAnswers++;
      if (!_isFinalLevel()) {
        listener?.onLevelCleared();
      }
      nextLevel();
    } else {
      listener?.onWrongAnswer();
    }
  }

  void useHint() {
    _isHintUsed = true;
    _disclosedLettersCnt++;
    _clue = _generateClue();

    listener?.onClueUpdated(_clue);
  }

  void nextLevel() {
    if (!_isFinalLevel()) {
      _startLevel(_currentLevel + 1);
    } else {
      _finishGame();
    }
  }

  void _startLevel(int newLevel) {
    _currentLevel = newLevel;
    _isHintUsed = false;
    _disclosedLettersCnt = 1;
    _drawing = _getDrawingForLevel(newLevel);
    _clue = _generateClue();

    listener?.onNewLevel(_currentLevel, _drawing, _clue);
  }

  bool _isFinalLevel() {
    return _currentLevel == _maxGameLevel;
  }

  void _finishGame() {
    listener?.onGameOver(_correctAnswers);
  }

  Drawing _getDrawingForLevel(int level) {
    switch (level) {
      case 1:
        return Drawing.aircraftCarrier();
      case 2:
        return Drawing.apple();
      case 3:
        return Drawing.helicopter();
      case 4:
        return Drawing.hamburger();
      case 5:
        return Drawing.brain();
      default:
        throw Exception('Invalid level: $level');
    }
  }

  String _generateClue() {
    final b = StringBuffer();
    int charDisclosed = 0;

    for (int i = 0; i < _drawing.word.length; i++) {
      String ch = _drawing.word[i];
      if (ch == ' ') {
        b.write(ch);
      } else if (charDisclosed < _disclosedLettersCnt) {
        b.write(ch);
        charDisclosed++;
      } else {
        b.write('*');
      }
    }
    return b.toString();
  }
}

abstract class QuizEventListener {

  void onClueUpdated(String clue);

  void onGameOver(int correctAnswers);

  void onLevelCleared();

  void onNewLevel(int level, Drawing drawing, String clue);

  void onWrongAnswer();

}