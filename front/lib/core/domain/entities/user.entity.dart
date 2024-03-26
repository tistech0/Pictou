class UserEntity {
  final String userId;
  final String email;
  String accessToken;
  final String accessTokenExp;
  final String refreshToken;
  final String refreshTokenExp;
  final String name;
  final String givenName;

  UserEntity({
    required this.userId,
    required this.email,
    required this.accessToken,
    required this.accessTokenExp,
    required this.refreshToken,
    required this.refreshTokenExp,
    required this.name,
    required this.givenName,
  });

  UserEntity copyWith({
    String? userId,
    String? email,
    String? accessToken,
    String? accessTokenExp,
    String? refreshToken,
    String? refreshTokenExp,
    String? name,
    String? givenName,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
      accessTokenExp: accessTokenExp ?? this.accessTokenExp,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshTokenExp: refreshTokenExp ?? this.refreshTokenExp,
      name: name ?? this.name,
      givenName: givenName ?? this.givenName,
    );
  }
}
