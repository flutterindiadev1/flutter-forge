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

  Future<void> saveApiKey(Session session, String key) async {
    final settings = await getSettings(session);
    settings.geminiApiKey = key;
    await UserSettings.db.updateRow(session, settings);
  }

  Future<void> deleteApiKey(Session session) async {
    final settings = await getSettings(session);
    settings.geminiApiKey = null;
    await UserSettings.db.updateRow(session, settings);
  }

  Future<void> saveGithubToken(Session session, String key) async {
    final settings = await getSettings(session);
    settings.githubToken = key;
    await UserSettings.db.updateRow(session, settings);
  }

  Future<void> deleteGithubToken(Session session) async {
    final settings = await getSettings(session);
    settings.githubToken = null;
    await UserSettings.db.updateRow(session, settings);
  }
}
