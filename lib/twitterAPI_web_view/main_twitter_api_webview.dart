import 'package:flutter/material.dart';
import 'locations_enum.dart';
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
            onTap: () {
              Navigator.of(context)
                  .push<void>(MaterialPageRoute(builder: (context) {
                return const TwitterTrends();
              }));
            },
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
}

class TwitterTrends extends StatefulWidget {
  const TwitterTrends({Key? key}) : super(key: key);

  @override
  _TwitterTrendsState createState() => _TwitterTrendsState();
}

class _TwitterTrendsState extends State<TwitterTrends> {
  String targetLocation = 'Trend検索をする地域を選択してください:)';
  final locationList = [
    Locations.tokyo.asString,
    Locations.ny.asString,
    Locations.london.asString,
    Locations.berlin.asString,
    Locations.rio.asString,
    Locations.moscow.asString,
    Locations.melbourne.asString,
    Locations.beijing.asString,
    Locations.rome.asString,
    Locations.capeTown.asString,
  ];

  TwitterApiController twitterApiController = TwitterApiController();

  Future<void> _chooseLocation() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Choose Location'),
          children: [
            ...locationList.map((location) {
              return SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    targetLocation = location;
                  });
                  Navigator.pop(context);
                },
                child: Text(location),
              );
            }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twitter Trends and WebView'),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Choose Location :) ',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Flexible(
            child: ElevatedButton(
              onPressed: _chooseLocation,
              child: Text(targetLocation),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Get Trends'),
          )
        ],
      ),
    );
  }
}
