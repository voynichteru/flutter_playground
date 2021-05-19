// thanks to https://zenn.dev/luecy1/articles/4e6b59aebd9da15dc51f

import 'dart:convert';
import 'package:http/http.dart' as http;

class TwitterApiController {
  static const apiKey = 'd79yUOYr6b86C1tOZ4r3uHxs2';
  static const apiSecretKey =
      'UvhbVquuJppvyRfSWpjumuy7UGYDuJMocOhilBiafzTpYhDqoc';

  Future<String> recentSearch(String searchWords) async {
    if (searchWords.isEmpty) {
      return '';
    }
    final base64encoded = base64.encode(latin1.encode('$apiKey:$apiSecretKey'));

    final response = await http.post(
      Uri.https('api.twitter.com', '/oauth2/token'),
      headers: {'Authorization': 'Basic $base64encoded'},
      body: {'grant_type': 'client_credentials'},
    );

    print(response.body);

    final oauthToken =
        OauthToken.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

    final queryParameters = {
      'query': [searchWords],
      'tweet.fields': [
        'created_at',
        'text',
      ],
      'user.fields': [
        'id',
        'name',
        'username',
        'profile_image_url',
      ],
    };

    // join request queryParameters
    final params = queryParameters.entries.map((paramEntry) {
      final value = paramEntry.value.join(',');
      return '${paramEntry.key}=$value';
    }).reduce((param1, param2) {
      return '$param1&$param2';
    });
    print('params: $params');

    // GET/2/Tweets/search/recent -> see:https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-recent
    final yesterday = DateTime.now()
        .toUtc()
        .subtract(const Duration(days: 1))
        .toIso8601String();
    final urlEx = Uri.parse(
        'https://api.twitter.com/2/tweets/search/recent?query=$searchWords&tweet.fields=created_at,text&user.fields=id,name,username,profile_image_url');
    final url = Uri.https(
      'api.twitter.com',
      '/2/tweets/search/recent',
      <String, dynamic>{
        'query': searchWords,
        'tweet.fields': 'created_at,text',
        'user.fields': 'id,name,username,profile_image_url',
        'start_time': yesterday,
      },
    );

    print(url.toString());
    final result = await http.get(
      urlEx,
      headers: {'Authorization': 'Bearer ${oauthToken.accessToken}'},
    ).catchError((dynamic e) {
      print('ERROR:$e');
    });

    print(result.body);

    final jsonString = json.decode(result.body) as Map<String, dynamic>;

    for (final key in jsonString.keys) {
      switch (key) {
        case 'data':
          print(key);
          final list = List<Map<String, dynamic>>.from(
              jsonString[key] as Iterable<dynamic>);
          for (final tweet in list) {
            tweet.forEach((key, dynamic value) {
              print('$key value:${value.toString()}');
            });
          }
          break;
        case 'meta':
          print(key);
          final map = Map<String, dynamic>.from(jsonString[key] as Map);
          map.forEach((key, dynamic value) {
            print('$key ${value.toString()}');
          });
          break;
        case 'includes':
      }
    }

    return 'YO';
  }
}

class OauthToken {
  const OauthToken(this.tokenType, this.accessToken);
  OauthToken.fromJson(Map<String, dynamic> json)
      : tokenType = json['token_type'] as String,
        accessToken = json['access_token'] as String;

  final String tokenType;
  final String accessToken;
}
