import 'package:flutter/material.dart';
import 'tweet_tile.dart';
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
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('twitter API brahbrah'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Recent Search'),
            onTap: () {
              Navigator.of(context)
                  .push<void>(MaterialPageRoute(builder: (context) {
                return const RecentSearch();
              }));
            },
          ),
          const Divider(thickness: 2),
          ListTile(
            title: const Text('Trends and WebView'),
            onTap: () {},
          ),
          const Divider(thickness: 2),
        ],
      ),
    );
  }
}

class RecentSearch extends StatefulWidget {
  const RecentSearch({Key? key}) : super(key: key);

  @override
  _RecentSearchState createState() => _RecentSearchState();
}

class _RecentSearchState extends State<RecentSearch> {
  List<Map<String, String>> twitterPramLists = [];
  TwitterApiController twitterApiController = TwitterApiController();

  Future<void> _twitterSearchWithKeywords(String searchWords) async {
    final result = await twitterApiController.recentSearch(searchWords);
    setState(() {
      twitterPramLists = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    var searchWords = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('twitter API and web view'),
      ),
      body: ListView(
        children: [
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
          if (twitterPramLists.isNotEmpty)
            for (var list in twitterPramLists) TweetTile(list),
        ],
      ),
    );
  }

  /* Future<List<Widget>> _tweetsTlieBuilder(List<String> texts) async {
    var result = <Widget>[];
  } */
}
