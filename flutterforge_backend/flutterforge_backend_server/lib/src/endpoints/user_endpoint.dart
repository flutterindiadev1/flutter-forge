import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class UserEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<UserSettings> getSettings(Session session) async {
    final userInfoId = session.authenticated?.userIdentifier;
    if (userInfoId == null) {
      throw Exception('Not authenticated');
    }

    var settings = await UserSettings.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );

    if (settings == null) {
      settings = UserSettings(userInfoId: userInfoId);
      settings = await UserSettings.db.insertRow(session, settings);
    }

    return settings;
  }

}
