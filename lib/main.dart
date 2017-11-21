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
        backgroundColor: Colors.white30,
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
            backgroundColor: new Color(0x00FFFFFF),
            child: new Icon(Icons.add_location),
            onPressed: _onFabPressed));
  }

  void _onFabPressed() {
    showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Do you want to check in?"),
          children: <Widget>[
            new TextFormField(
              controller: _controller,
              decoration: new InputDecoration(
                hintText: 'Place Name',
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new ButtonTheme.bar(
                  child: new ButtonBar(
                    children: <Widget>[
                      new FlatButton(
                        child: const Text('PROCEED'),
                        onPressed: _onYesPressed,
                      ),
                      new FlatButton(
                        child: const Text('CANCEL'),
                        onPressed: _onNoPressed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  _onYesPressed() {
    _saveData(new Request("101", "10"));
    Navigator.pop(context);
  }

  void _onNoPressed() {
    Navigator.pop(context);
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
      child: new ListTile(
        title: new Text(widget.cards.title),
        leading: new Text("Some Text"),
        trailing: new Text(widget.cards.info),
        onTap: _onTap,
      ),
    );
  }

    _onTap() {

  }
}
