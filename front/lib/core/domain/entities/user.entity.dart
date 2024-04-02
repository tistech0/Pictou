class UserEntity {
  final String? userId;
  final String? email;
  late final String? accessToken;
  final String? accessTokenExp;
  final String? refreshToken;
  final String? refreshTokenExp;
  final String? name;
  final String? givenName;

  UserEntity({
    required this.userId,
    this.email,
    this.accessToken,
    this.accessTokenExp,
    this.refreshToken,
    this.refreshTokenExp,
    this.name,
    this.givenName,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      userId: json['user_id'] as String?,
      email: json['email'] as String?,
      accessToken: json['access_token'] as String?,
      accessTokenExp: json['access_token_exp'] as String?,
      refreshToken: json['refresh_token'] as String?,
      refreshTokenExp: json['refresh_token_exp'] as String?,
      name: json['name'] as String?,
      givenName: json['given_name'] as String?,
    );
  }
}
