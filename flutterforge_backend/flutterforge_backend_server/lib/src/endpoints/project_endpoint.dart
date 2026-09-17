import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ProjectEndpoint extends Endpoint {
  Future<String> submitConfig(Session session, ProjectConfig config) async {
    session.log('Received project config for: ${config.projectName}');
    session.log('Platforms: ${config.platforms.join(', ')}');
    session.log('Architecture: ${config.architecture?.pattern}');
    
    // In a real application, you would store this in the database
    // and queue a background job to start the code generation pipeline.
    return 'Project ${config.projectName} accepted.';
  }
}
