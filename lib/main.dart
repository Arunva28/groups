import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groups/cards.dart';
import 'package:groups/request.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(new MyApp());
}

final ThemeData _theme = new ThemeData(
  primaryColor: Colors.black,
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Groups",
      theme: _theme,
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = new TextEditingController();
  final TextStyle _textstyle =
      new TextStyle(fontWeight: FontWeight.bold, fontSize: 38.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.grey,
        appBar: new AppBar(
          title: new Text("Groups"),
        ),
        body:
            // This is the main page
            new RefreshIndicator(
                child: new ListView.builder(itemBuilder: _itemBuilder),
                onRefresh: _onRefresh),
        floatingActionButton: new FloatingActionButton(
            tooltip: 'Add',
            child: new Icon(Icons.add_location),
            backgroundColor: Colors.grey,
            onPressed: _onFabPressed));
  }

  void _onFabPressed() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new AddEntryDialog();
        },
        fullscreenDialog: true));
  }

  Future<Null> _onRefresh() {
    Completer<Null> completer = new Completer<Null>();
    Timer timer = new Timer(new Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future;
  }

  Widget _itemBuilder(BuildContext context, int index) {
    Cards cards = getCards(index);
    return new CardWidget(cards: cards);
  }

  Cards getCards(int index) {
    return new Cards("Hello", "This is a card");
  }
}

const jsoncodec = const JsonCodec();

_saveData(Request request) async {
  var json = jsoncodec.encode(request);

  var url = "https://groups-66997.firebaseio.com/groups.json";

  var httpClient = createHttpClient();
  var response = await httpClient.post(url, body: json);

  print("response = " + response.body);
}

class CardWidget extends StatefulWidget {
  CardWidget({Key key, this.cards}) : super(key: key);

  final Cards cards;

  @override
  _CardWidgetState createState() => new _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return new Card(
      color: Colors.indigo,
      child: new ListTile(
        title: new Text(widget.cards.title),
        leading: new Text("Some Text"),
        trailing: new Text(widget.cards.info),
        onTap: _onTap,
      ),
    );
  }

  _onTap() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          var center = new Center(
            child: new Container(
              height: 100.0,
              width: 100.0,
              child: new Text("Hello"),
            ),
          );
          return new Scaffold(
            appBar: new AppBar(
              title: new Text("New Title"),
            ),
            body: center = new Center(),
          );
        },
        fullscreenDialog: true));
  }
}

class AddEntryDialog extends StatefulWidget {
  @override
  AddEntryDialogState createState() => new AddEntryDialogState();
}

class AddEntryDialogState extends State<AddEntryDialog> {
  @override
  Widget build(BuildContext context) {
    var _controller;
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('New entry'),
          actions: [
            new FlatButton(
                onPressed: () {
                  _saveData(new Request("101", "10"));
                  Navigator.pop(context);
                },
                child: new Text('SAVE',
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: Colors.white))),
          ],
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new TextField(
                controller: _controller,
                decoration: new InputDecoration(
                  hintText: 'Type something',
                ),
              ),
            ],
          ),
        ));
  }
}
