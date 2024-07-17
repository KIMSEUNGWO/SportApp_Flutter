
class SocialResult {

  final String socialId;
  final Provider provider;
  final String accessToken;

  SocialResult({required this.socialId, required this.provider, required this.accessToken});
}

enum Provider {

  LINE,
}