import 'dart:io';

class EnvironmentChecker {
  static Future<bool> checkEnvironment(void Function(String message, {String level}) log) async {
    log('Checking server environment prerequisites...', level: 'info');

    try {
      // Check Flutter
      final flutterRes = await Process.run('flutter', ['--version']);
      if (flutterRes.exitCode != 0) {
        log('Flutter SDK is not installed or not in PATH.', level: 'error');
        return false;
      }
      
      // Extract version string for log
      final flutterVer = flutterRes.stdout.toString().split('\n').first;
      log('Found $flutterVer', level: 'success');

      // Check Git
      final gitRes = await Process.run('git', ['--version']);
      if (gitRes.exitCode != 0) {
        log('Git is not installed or not in PATH.', level: 'error');
        return false;
      }
      
      final gitVer = gitRes.stdout.toString().trim();
      log('Found $gitVer', level: 'success');

      return true;
    } on ProcessException catch (e) {
      log('Command not found: ${e.executable}. Ensure Flutter and Git are installed and on PATH.', level: 'error');
      return false;
    } catch (e) {
      log('Unexpected error checking environment: $e', level: 'error');
      return false;
    }
  }
}
