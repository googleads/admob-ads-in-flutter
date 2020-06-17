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
// COMPLETE: Import firebase_admob.dart
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initAdMob(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          List<Widget> children = <Widget>[
            Text(
              "Awesome Drawing Quiz!",
              style: TextStyle(
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 72),
            ),
          ];

          if (snapshot.hasData) {
            children.add(RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text(
                "Let's get started!".toUpperCase(),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 48,
              ),
              onPressed: () => Navigator.of(context).pushNamed('/game'),
            ));
          } else if (snapshot.hasError) {
            children.addAll(<Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
            ]);
          } else {
            children.add(SizedBox(
              child: CircularProgressIndicator(),
              width: 48,
              height: 48,
            ));
          }

          return Scaffold(
            backgroundColor: AppTheme.primary,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }
}
