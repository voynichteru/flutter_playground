enum RecentSearchParams {
  id,
  authorId,
  text,
  publicMetrics,
  createdAt,
  replyCount,
  retweetCount,
  likeCount,
  name,
  userName,
  profileImageUrl,
}

extension Extension on RecentSearchParams {
  static final params = {
    RecentSearchParams.id: 'id',
    RecentSearchParams.authorId: 'author_id',
    RecentSearchParams.text: 'text',
    RecentSearchParams.publicMetrics: 'public_metrics',
    RecentSearchParams.createdAt: 'created_at',
    RecentSearchParams.replyCount: 'reply_count',
    RecentSearchParams.retweetCount: 'retweet_count',
    RecentSearchParams.likeCount: 'like_count',
    RecentSearchParams.name: 'name',
    RecentSearchParams.userName: 'username',
    RecentSearchParams.profileImageUrl: 'profile_image_url',
  };
  String get asString => params[this]!;
}
