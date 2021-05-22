import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'params_enum.dart';
import 'twitter_web_view.dart';

class TweetTile extends StatelessWidget {
  TweetTile(Map<String, String> paramList)
      : tweetId = paramList[RecentSearchParams.id.asString] ?? 'null',
        authorId = paramList[RecentSearchParams.authorId.asString] ?? 'null',
        text = paramList[RecentSearchParams.text.asString] ?? 'null',
        createdAt = paramList[RecentSearchParams.createdAt.asString] ?? 'null',
        replyCount =
            paramList[RecentSearchParams.replyCount.asString] ?? 'null',
        retweetCount =
            paramList[RecentSearchParams.retweetCount.asString] ?? 'null',
        likeCount = paramList[RecentSearchParams.likeCount.asString] ?? 'null',
        name = paramList[RecentSearchParams.name.asString] ?? 'null',
        userName = paramList[RecentSearchParams.userName.asString] ?? 'null',
        profileImageUrl =
            paramList[RecentSearchParams.profileImageUrl.asString] ??
                'https://p.e-words.jp/img/Null.jpg';

  final String tweetId;
  final String authorId;
  final String text;
  final String createdAt;
  final String replyCount;
  final String retweetCount;
  final String likeCount;
  final String name;
  final String userName;
  final String profileImageUrl;

  void _twitterWebView(
    BuildContext context,
    String path, {
    Map<String, String>? params,
  }) {
    if (userName != 'null') {
      final url = Uri.https(
        'mobile.twitter.com',
        path,
        params,
      );
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (context) {
        return TwitterWebView(url.toString());
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final difference = DateTime.now().difference(DateTime.parse(createdAt));

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 10,
                maxHeight: MediaQuery.of(context).size.width / 10,
              ),
              child: CachedNetworkImage(
                imageUrl: profileImageUrl,
                imageBuilder: (_, imageProvider) {
                  return GestureDetector(
                    onTap: () {
                      _twitterWebView(context, '/$userName');
                    },
                    child: Image(
                      image: imageProvider,
                    ),
                  );
                },
              ),
            ),
          ),
          Flexible(
            /* flex: 5, */
            child: Column(
              children: [
                SizedBox(
                  /* width: MediaQuery.of(context).size.width * 0.9, */
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  child: SizedBox(
                    /* width: MediaQuery.of(context).size.width * 0.9, */
                    child: Row(
                      children: [
                        SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              _twitterWebView(context, '/$userName');
                            },
                            child: Row(
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 12,
                                    maxHeight: 13,
                                  ),
                                  child: Image.asset(
                                      'images/twitter_api/twitter_logo.png'),
                                ),
                                Text(
                                  ' $name @$userName',
                                  style: const TextStyle(fontSize: 12),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _twitterWebView(
                              context,
                              '/intent/tweet',
                              params: {'in_reply_to': tweetId},
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.messenger),
                              replyCount == '0'
                                  ? const Text(' ')
                                  : Text(' $replyCount'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _twitterWebView(
                              context,
                              '/intent/retweet',
                              params: {'tweet_id': tweetId},
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.loop),
                              retweetCount == '0'
                                  ? const Text(' ')
                                  : Text(' $retweetCount'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _twitterWebView(
                              context,
                              '/intent/like',
                              params: {'tweet_id': tweetId},
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.favorite),
                              likeCount == '0'
                                  ? const Text(' ')
                                  : Text(' $likeCount'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: difference.inHours == 0
                          ? Text('${difference.inMinutes.toString()}分前')
                          : Text('${difference.inHours.toString()}時間前'),
                    )
                  ],
                ),
                const Divider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
