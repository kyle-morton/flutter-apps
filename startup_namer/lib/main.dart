// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.blue,
        buttonColor: Colors.red
      ),
    );
  }
}

/// State is what can change over lifetime of widget
class RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[]; // the _ character enforces privacy in Dart lang
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _savedSuggestions = Set<WordPair>();

  /// for each suggestion, builds out a row in the listview
  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd)
          return Divider(); // seperates each row

        final index = i ~/ 2; // divides current row # by 2, returns floor()

        // whenever you reach end of WordPairs, gen 10 more and add to list
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      } // itemBuilder
    );
  } 

  Widget _buildRow(WordPair pair) {
    final _alreadySaved = _savedSuggestions.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (_alreadySaved) {
            _savedSuggestions.remove(pair);
          } else {
            _savedSuggestions.add(pair);
          }
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ]
      ),
      body: _buildSuggestions(),
    );
  }

  /// go to "saved" route
  void _pushSaved() {

    // build the page on the fly, add to nav stack
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _savedSuggestions.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont
                )
              );
            }
          );

          final divided = ListTile.divideTiles( 
            context: context,
            tiles: tiles
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions')
            ),
            body: ListView(children: divided)
          );

        } 
      )
    );
  }

}

// widget itself contains a state that may change (widget itself is immutable)
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}