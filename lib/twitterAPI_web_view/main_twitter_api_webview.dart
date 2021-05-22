import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'locations_enum.dart';
import 'tweet_tile.dart';
import 'twitter_api.dart';
import 'twitter_web_view.dart';

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
  static const docsRecentSearch =
      'https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-recent';
  static const docsTrends =
      'https://developer.twitter.com/en/docs/twitter-api/v1/trends/trends-for-location/api-reference/get-trends-place';

  List<Widget> _createListTile(
    BuildContext context,
    String title,
    Widget toScreen,
    String docsUrl,
  ) {
    return [
      ListTile(
        leading: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 30,
              maxWidth: 30,
            ),
            child: Image.asset('images/twitter_api/twitter_logo.png')),
        title: Text(title),
        onTap: () {
          Navigator.of(context)
              .push<void>(MaterialPageRoute(builder: (context) {
            return toScreen;
          }));
        },
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () async {
            await canLaunch(docsUrl)
                ? await launch(docsUrl)
                : Fluttertoast.showToast(
                    msg: 'Could not open dos URL, sorry ;(',
                    toastLength: Toast.LENGTH_LONG,
                  );
          },
        ),
      ),
      const Divider(thickness: 2),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('twitter API brahbrah'),
      ),
      body: ListView(
        children: [
          ..._createListTile(
            context,
            'Recent Search',
            const RecentSearch(),
            docsRecentSearch,
          ),
          ..._createListTile(
            context,
            'Trends and Webview',
            const TwitterTrends(),
            docsTrends,
          )
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
        title: const Text('Recent Search and URL launcher'),
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
          const SizedBox(height: 10),
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
  Locations? targetLocation;
  final locationList = [
    Locations.tokyo,
    Locations.ny,
    Locations.london,
    Locations.berlin,
    Locations.rio,
    Locations.moscow,
    Locations.melbourne,
    Locations.seoul,
    Locations.rome,
    Locations.capeTown,
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
                child: Text(location.asString),
              );
            }),
          ],
        );
      },
    );
  }

  List<String> trendList = [];

  void _setResult(List<String> result) {
    setState(() {
      trendList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twitter Trends and WebView'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: ElevatedButton(
              onPressed: _chooseLocation,
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              child: Text(
                targetLocation?.asString ?? 'Choose Location :)',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: ElevatedButton(
              onPressed: () async {
                if (targetLocation == null) {
                  await Fluttertoast.showToast(msg: 'Choose Location, pls ;)');
                } else {
                  final result = await twitterApiController
                      .getTrendsByLocation(targetLocation!);
                  _setResult(result);
                }
              },
              child: const Text(
                'Fetch Trend List thru Twitter API',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          if (trendList.isNotEmpty)
            ...trendList.map((trend) => Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    top: BorderSide(
                      color: Colors.black45,
                      width: 1,
                    ),
                  )),
                  child: ListTile(
                    onTap: () {
                      final url = Uri.https(
                        'mobile.twitter.com',
                        '/search',
                        <String, dynamic>{
                          'q': trend,
                          'src': 'typed_query',
                        },
                      );
                      print(url.toString());
                      Navigator.of(context)
                          .push<void>(MaterialPageRoute(builder: (context) {
                        return TwitterWebView(url.toString());
                      }));
                    },
                    title: Text(trend),
                  ),
                )),
        ],
      ),
    );
  }
}
