import 'package:test/test.dart';
import 'package:pictou_api/pictou_api.dart';

/// tests for AuthApi
void main() {
  final instance = PictouApi().getAuthApi();

  group(AuthApi, () {
    // OAuth2 callback endpoint. Must not be called directly.
    //
    // OAuth2 callback endpoint. Must not be called directly.  This endpoint is called by the OAuth provider after the user has authenticated. This documentation is here to show the structure of the body received by this endpoint, not to call this endpoint.
    //
    //Future<AuthenticationResponse> callback(String provider) async
    test('test callback', () async {
      // TODO
    });

    // *The* Authorization/Authentication endpoint.
    //
    // *The* Authorization/Authentication endpoint.  User information is sent to /auth/callback/{provider} when the user is authenticated.
    //
    //Future login(String provider) async
    test('test login', () async {
      // TODO
    });

    // Revoke the refresh token of the user.
    //
    // Revoke the refresh token of the user. The user may still be authenticated with the access token (for up to 3 minutes, by default), but the refresh token is invalidated.
    //
    //Future logout() async
    test('test logout', () async {
      // TODO
    });

    // Allows the user to request another access token after it expired.
    //
    // Allows the user to request another access token after it expired. This route checks the opaque refresh token against the database before granting (or not) the new access token.
    //
    //Future<AuthenticationResponse> refreshToken(RefreshTokenParams refreshTokenParams) async
    test('test refreshToken', () async {
      // TODO
    });
  });
}
