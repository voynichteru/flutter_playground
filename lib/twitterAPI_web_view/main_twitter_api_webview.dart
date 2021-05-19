import 'package:flutter/material.dart';
import 'twitter_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String info = 'NO data';
  TwitterApiController twitterApiController = TwitterApiController();

  Future<void> _twitterSearchWithKeywords(String searchWords) async {
    final result = await twitterApiController.recentSearch(searchWords);
    setState(() {
      info = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    var searchWords = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('twitter API and web view'),
      ),
      body: ListView(children: [
        Container(
          alignment: Alignment.center,
          child: const Text(
            'Lets try Twitter Recent Search API',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: 300,
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Keywords :)',
              ),
              onChanged: (input) {
                searchWords = input;
              },
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
            ),
            onPressed: () {
              _twitterSearchWithKeywords(searchWords);
            },
            child: const Text('Search'),
          ),
        ),
        Text(
          '$info',
          style: Theme.of(context).textTheme.headline4,
        ),
      ]),
    );
  }
}
