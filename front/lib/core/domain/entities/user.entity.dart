class UserEntity {
  final String id;
  String accessToken;
  final String refreshToken;

  UserEntity({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
  });

  UserEntity copyWith({
    String? id,
    String? accessToken,
    String? refreshToken,
  }) {
    return UserEntity(
      id: id ?? this.id,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
