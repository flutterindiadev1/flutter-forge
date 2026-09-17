import 'package:flutterforge_backend_client/flutterforge_backend_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late final Client client;

void initServerpodClient() {
  // Initialize the Serverpod client pointing to the backend's local IP/port
  client = Client(
    'http://localhost:8081/',
  )..connectivityMonitor = FlutterConnectivityMonitor();
}
