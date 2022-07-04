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

import 'dart:convert';
import 'dart:math';

class Drawing {
  static const _aircraftCarrier =
      "{\"word\":\"aircraft carrier\",\"drawing\":[[[31,32],[0,7]],[[27,37,38,35,21],[4,4,6,7,3]],[[25,28,38,39],[5,10,10,7]],[[33,34,32],[4,33,44]],[[5,188,254,251,241,185,45,9,0],[50,50,54,83,86,90,86,77,52]],[[35,35,43,125,126],[85,91,92,96,90]],[[35,76,80,77],[35,37,41,47]],[[53,50,54,80,78],[34,23,22,23,34]]]}";
  static const _apple =
      "{\"word\":\"apple\",\"drawing\":[[[255,255],[0,0]],[[255,255],[0,0]],[[255,255],[0,0]],[[255,254],[0,1]],[[131,124,114,69,37,10,0,0,5,16,31,50,68,86,101,115,126,135,137,135,122,106],[50,39,39,59,89,127,172,194,215,233,244,249,249,241,225,203,174,143,114,88,65,45]],[[84,77,81,88,99,122,138,161,180],[97,85,52,34,18,4,1,2,12]]]}";
  static const _brain =
      "{\"word\":\"brain\",\"drawing\":[[[35,38,46,62,80,94,99,104,110,128,149,167,179,181,175,160,183,199,211,212,197,181,168,151,140,132,140,150,154,155,146,124,114,87,75,60,48,48,58,64,69,68,62,49,42,22,9,4,8,17,25,27,26,20,15,7,2,0,4,11,22,41],[55,36,21,7,0,2,6,14,35,20,13,20,36,60,72,85,87,99,118,139,173,187,192,191,188,180,177,185,194,212,232,250,253,254,251,241,220,203,179,174,176,187,193,198,196,178,157,140,116,105,109,115,124,132,133,128,117,101,83,70,58,52]],[[107,53,40,44,69],[26,61,81,115,167]],[[122,88,77,71,75],[36,84,110,135,194]],[[150,118,75],[26,113,196]],[[37,63,111,162,198],[55,74,100,134,164]],[[11,23,103,143,171],[105,108,144,168,193]],[[48,73,100,164],[183,187,186,168]]]}";
  static const _hamburger =
      "{\"word\":\"hamburger\",\"drawing\":[[[42,41,51,53,59,67,72,86,92,100,104,108,118,122,129,141,156,177,187,192,196,203,215,221,227,211,192,98,65,42],[96,113,102,108,105,121,121,99,120,104,119,123,108,135,144,113,139,110,131,130,120,131,112,126,106,98,95,97,92,96]],[[40,47,54,61,190,204,213,217,217],[107,131,140,144,161,160,157,140,119]],[[50,38,24,21,21,24,120,207,232,231,213],[143,143,148,155,162,164,180,184,166,163,160]],[[44,6,24,42,68,79,109,177,206,229,255,251,220],[96,95,51,28,8,3,0,30,46,64,98,101,105]],[[10,2,0,20,46],[159,165,176,201,217]]]}";
  static const _helicopter =
      "{\"word\":\"helicopter\",\"drawing\":[[[136,88,0],[14,22,24]],[[127,98,22],[18,29,39]],[[102,49],[11,0]],[[131,254,238],[9,7,12]],[[134,164,186],[19,20,25]],[[106,107],[18,42]],[[105,34,25,21,22,29,65,99,130,146,170,173,173,167,155,109,97,89],[51,51,54,61,88,99,127,137,140,131,102,93,76,60,50,41,42,49]],[[50,37,139,225,218,198,144,131,129,148,142],[51,109,121,124,120,116,108,108,103,36,41]]]}";

  String _word;

  List<Stroke> _strokes;
  
  String get word => _word;
  
  List<Stroke> get strokes => _strokes;

  Drawing(this._word, this._strokes);

  Drawing.aircraftCarrier() : this._fromJsonString(_aircraftCarrier);

  Drawing.apple() : this._fromJsonString(_apple);

  Drawing.brain() : this._fromJsonString(_brain);

  Drawing.hamburger() : this._fromJsonString(_hamburger);

  Drawing.helicopter() : this._fromJsonString(_helicopter);

  Drawing._fromJson(Map<String, dynamic> json)
      : _word = json['word'],
        _strokes = (json['drawing'] as Iterable)
            .map((e) => Stroke.fromIterable(e[0], e[1]))
            .toList();

  Drawing._fromJsonString(String jsonString)
      : this._fromJson(jsonDecode(jsonString));
}

class Stroke {
  late List<Point> _points;
  
  List<Point> get points => _points;

  Stroke.fromIterable(Iterable xCoords, Iterable yCoords)
      : this._fromCoordinatesList(xCoords.map((e) => e as int).toList(),
            yCoords = yCoords.map((e) => e as int).toList());

  Stroke._fromCoordinatesList(List<int> xCoords, List<int> yCoords) {
    assert(xCoords.length == yCoords.length);

    List<Point<double>> pts = [];
    for (int i = 0; i < xCoords.length; i++) {
      pts.add(Point(xCoords[i].toDouble(), yCoords[i].toDouble()));
    }
    _points = pts;
  }
}
