// thanks to https://zenn.dev/luecy1/articles/4e6b59aebd9da15dc51f

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'params_enum.dart';

class TwitterApiController {
  static const apiKey = 'd79yUOYr6b86C1tOZ4r3uHxs2';
  static const apiSecretKey =
      'UvhbVquuJppvyRfSWpjumuy7UGYDuJMocOhilBiafzTpYhDqoc';

  Future<List<Map<String, String>>> recentSearch(String searchWords) async {
    if (searchWords.isEmpty) {
      return [];
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
        'https://api.twitter.com/2/tweets/search/recent?query=$searchWords&expansions=author_id&tweet.fields=created_at,text,public_metrics&user.fields=id,name,username,profile_image_url');
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

    print(urlEx.toString());
    final result = await http.get(
      urlEx,
      headers: {'Authorization': 'Bearer ${oauthToken.accessToken}'},
    ).catchError((dynamic e) {
      print('ERROR:$e');
    });

    print(result.body);

    final jsonString = json.decode(result.body) as Map<String, dynamic>;
    final lists = List.generate(10, (index) => <String, String>{});

    for (final key in jsonString.keys) {
      switch (key) {
        case 'data':
          print(key);
          final dataObject = List<Map<String, dynamic>>.from(
              jsonString[key] as Iterable<dynamic>);
          for (final tweet in dataObject) {
            final index = dataObject.indexOf(tweet);

            tweet.forEach((key, dynamic value) {
              if (key == RecentSearchParams.id.asString) {
                lists[index][RecentSearchParams.id.asString] =
                    tweet[RecentSearchParams.id.asString].toString();
              } else if (key == RecentSearchParams.authorId.asString) {
                lists[index][RecentSearchParams.authorId.asString] =
                    tweet[RecentSearchParams.authorId.asString].toString();
              } else if (key == RecentSearchParams.text.asString) {
                final modifiedText =
                    tweet[RecentSearchParams.text.asString].toString().trim();
                lists[index][RecentSearchParams.text.asString] = modifiedText;
              } else if (key == RecentSearchParams.createdAt.asString) {
                lists[index][RecentSearchParams.createdAt.asString] =
                    tweet[RecentSearchParams.createdAt.asString].toString();
              } else if (key == RecentSearchParams.publicMetrics.asString) {
                final publicMetricsObject = value as Map<String, dynamic>;
                publicMetricsObject.forEach((key, dynamic value) {
                  if (key == RecentSearchParams.replyCount.asString) {
                    lists[index][RecentSearchParams.replyCount.asString] =
                        value.toString();
                  } else if (key == RecentSearchParams.retweetCount.asString) {
                    lists[index][RecentSearchParams.retweetCount.asString] =
                        value.toString();
                  } else if (key == RecentSearchParams.likeCount.asString) {
                    lists[index][RecentSearchParams.likeCount.asString] =
                        value.toString();
                  }
                });
              } else {
                print('ERROR:Unexpected field found inside data Object');
                throw AssertionError('Unexpected type: $this}');
              }

              /* for (final list in lists[index]) {
                print('list index num : ${lists[index].length}');
                print('${lists[index].indexOf(list)}:$list');
              } */
            });
          }
          break;
        case 'includes':
          print(key);
          final includesObject =
              Map<String, dynamic>.from(jsonString[key] as Map);
          includesObject.forEach((key, dynamic value) {
            print(key);
            if (key == 'users') {
              for (final userData in value as List) {
                final index = value.indexOf(userData);
                print(userData.toString());
                lists[index][RecentSearchParams.name.asString] =
                    userData[RecentSearchParams.name.asString].toString();
                lists[index][RecentSearchParams.userName.asString] =
                    userData[RecentSearchParams.userName.asString].toString();
                lists[index][RecentSearchParams.profileImageUrl.asString] =
                    userData[RecentSearchParams.profileImageUrl.asString]
                        .toString();
              }
            }
          });
          break;
        case 'meta':
          print(key);
          final map = Map<String, dynamic>.from(jsonString[key] as Map);
          map.forEach((key, dynamic value) {
            print('$key ${value.toString()}');
          });
          break;
        default:
          print('Unexpected Object Found');
          throw AssertionError('Unexpected type: $this}');
      }
    }
    print('listsLength -> ${lists.length}');
    for (var list in lists) {
      print('listLength : ${list.length}');

      print(list['text']);
    }

    return lists;
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
