import 'package:flutterforge_backend_client/flutterforge_backend_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

late final Client client;
late final SessionManager sessionManager;
late final Stream<dynamic> pipelineBroadcastStream;

Future<void> initServerpodClient() async {
  // Initialize the Serverpod client pointing to the backend's local IP/port
  client = Client(
    'http://localhost:8081/',
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

  // Initialize SessionManager for authentication
  sessionManager = SessionManager(
    caller: client.modules.auth,
  );
  
  await sessionManager.initialize();
  
  pipelineBroadcastStream = client.pipeline.stream.asBroadcastStream();
}
