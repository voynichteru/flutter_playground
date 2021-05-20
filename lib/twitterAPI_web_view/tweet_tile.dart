import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'params_enum.dart';

class TweetTile extends StatelessWidget {
  TweetTile(Map<String, String> paramList)
      : tweetId = paramList[RecentSearchParams.id.asString]!,
        authorId = paramList[RecentSearchParams.authorId.asString]!,
        text = paramList[RecentSearchParams.text.asString]!,
        createdAt = paramList[RecentSearchParams.createdAt.asString]!,
        replyCount = paramList[RecentSearchParams.replyCount.asString]!,
        retweetCount = paramList[RecentSearchParams.retweetCount.asString]!,
        likeCount = paramList[RecentSearchParams.likeCount.asString]!,
        name = paramList[RecentSearchParams.name.asString]!,
        userName = paramList[RecentSearchParams.userName.asString]!,
        profileImageUrl =
            paramList[RecentSearchParams.profileImageUrl.asString]! {
    print('profileImageUrl:$profileImageUrl');
  }

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
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 45,
              maxHeight: 45,
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
          /* Column(
            children: [
              Text(text),
              Row(
                children: [
                  SizedBox(
                    child: GestureDetector(
                      onTap: () {
                        // launch url
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.ac_unit),
                          Text(' $userName'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    child: GestureDetector(
                      onTap: () {
                        // launch url
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.terrain),
                          Text(' @$name'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    child: GestureDetector(
                      onTap: () {
                        // url launcher
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.messenger),
                          Text(' $replyCount'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    child: GestureDetector(
                      onTap: () {
                        // url launcher
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.loop),
                          Text(' $retweetCount'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    child: GestureDetector(
                      onTap: () {
                        // url launcher
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.favorite),
                          Text(' $likeCount'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Text(' ${difference.inHours.toString()}時間前'),
                  )
                ],
              ),
            ],
          ) */
        ],
      ),
    );
  }
}
