import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'params_enum.dart';

class TweetTile extends StatelessWidget {
  TweetTile(Map<String, String> paramList)
      : tweetId = paramList[RecentSearchParams.id.asString] ?? 'ERROR',
        authorId = paramList[RecentSearchParams.authorId.asString] ?? 'ERROR',
        text = paramList[RecentSearchParams.text.asString] ?? 'null',
        createdAt = paramList[RecentSearchParams.createdAt.asString] ?? 'ERROR',
        replyCount =
            paramList[RecentSearchParams.replyCount.asString] ?? 'ERROR',
        retweetCount =
            paramList[RecentSearchParams.retweetCount.asString] ?? 'ERROR',
        likeCount = paramList[RecentSearchParams.likeCount.asString] ?? 'ERROR',
        name = paramList[RecentSearchParams.name.asString] ?? 'ERROR',
        userName = paramList[RecentSearchParams.userName.asString] ?? 'ERROR',
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

  @override
  Widget build(BuildContext context) {
    final difference = DateTime.now().difference(DateTime.parse(createdAt));
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
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
                        // launch url
                      },
                      child: Image(
                        image: imageProvider,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Flexible(
            flex: 5,
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
                              // launch url
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.ac_unit),
                                Text(
                                  ' $name',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              // launch url
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.terrain),
                                Text(
                                  ' @$userName',
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                          ),
                        ),
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
                            // url launcher
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
                            // url launcher
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
                            // url launcher
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
