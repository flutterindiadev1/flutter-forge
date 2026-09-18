import 'dart:io';
import 'dart:convert';
import '../generated/protocol.dart';

class DependencyEvent {
  final String message;
  final String level;
  final double progress;
  final bool isError;

  DependencyEvent({
    required this.message,
    this.level = 'info',
    this.progress = 0.0,
    this.isError = false,
  });
}

class DependencyInstaller {
  Stream<DependencyEvent> install(ProjectConfig config) async* {
    yield DependencyEvent(message: 'Resolving dependencies...', progress: 0.0);
    
    final projectId = config.projectId ?? 'unknown_project';
    final projectDir = Directory('/tmp/flutterforge/$projectId');
    
    final Set<String> packages = {};
    
    // 1. Explicit Dependencies
    for (final dep in config.dependencies) {
      packages.add(dep.version != null ? '${dep.packageName}:${dep.version}' : dep.packageName);
    }
    
    // 2. Architecture & State Management
    final arch = config.architecture;
    if (arch != null) {
      // State Management
      if (arch.stateManagement == 'bloc') packages.addAll(['flutter_bloc', 'equatable']);
      if (arch.stateManagement == 'riverpod') packages.addAll(['flutter_riverpod']);
      if (arch.stateManagement == 'provider') packages.addAll(['provider']);
      
      // DI
      if (arch.di == 'get_it') packages.addAll(['get_it']);
      if (arch.di == 'injectable') packages.addAll(['get_it', 'injectable']); // Note: needs dev_dependencies too
      
      // Navigation
      if (arch.navigation == 'go_router') packages.addAll(['go_router']);
      if (arch.navigation == 'auto_route') packages.addAll(['auto_route']); // Note: needs dev_dependencies
      
      // Network
      if (arch.network == 'dio') packages.addAll(['dio']);
      if (arch.network == 'http') packages.addAll(['http']);
      
      // Storage
      if (arch.localStorage == 'hive') packages.addAll(['hive', 'hive_flutter']);
      if (arch.localStorage == 'isar') packages.addAll(['isar', 'isar_flutter_libs']); // Note: needs dev_dependencies
      if (arch.localStorage == 'shared_prefs') packages.addAll(['shared_preferences']);
    }
    
    // 3. Integrations
    final intg = config.integrations;
    bool needsFirebaseCore = false;
    
    if (intg.firebaseAuth) { packages.add('firebase_auth'); needsFirebaseCore = true; }
    if (intg.firebaseFirestore) { packages.add('cloud_firestore'); needsFirebaseCore = true; }
    if (intg.firebaseStorage) { packages.add('firebase_storage'); needsFirebaseCore = true; }
    if (intg.firebaseAnalytics) { packages.add('firebase_analytics'); needsFirebaseCore = true; }
    if (intg.firebaseCrashlytics) { packages.add('firebase_crashlytics'); needsFirebaseCore = true; }
    if (needsFirebaseCore) packages.add('firebase_core');
    
    if (intg.stripe) packages.add('flutter_stripe');
    if (intg.revenueCat || config.monetization?.provider?.name == 'revenueCat') packages.add('purchases_flutter');
    if (intg.googleMaps) packages.add('google_maps_flutter');
    if (intg.mapbox) packages.add('mapbox_maps_flutter');
    
    // Core and module specific packages
    packages.add('internet_connection_checker');
    
    if (config.features.any((f) => f.name.toLowerCase() == 'settings')) {
      packages.add('in_app_review');
    }
    
    if (packages.isEmpty) {
      yield DependencyEvent(message: 'No dependencies to install.', progress: 1.0);
      return;
    }

    yield DependencyEvent(
      message: 'Installing ${packages.length} packages...',
      progress: 0.1,
    );

    try {
      // Batch install is much faster
      final args = ['pub', 'add', ...packages];
      final process = await Process.start(
        'flutter',
        args,
        workingDirectory: projectDir.path,
      );

      final stderrFuture = process.stderr.transform(utf8.decoder).join();

      // Stream output
      double currentProgress = 0.1;
      await for (final line in process.stdout.transform(utf8.decoder).transform(const LineSplitter())) {
        currentProgress = (currentProgress + 0.05).clamp(0.1, 0.95);
        yield DependencyEvent(message: '  $line', progress: currentProgress);
      }

      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        final stderrStr = await stderrFuture;
        yield DependencyEvent(
          message: 'Failed to add packages: $stderrStr',
          level: 'error',
          progress: 1.0,
          isError: true,
        );
        return;
      }

      yield DependencyEvent(
        message: 'All dependencies installed successfully.',
        level: 'success',
        progress: 1.0,
      );
    } catch (e) {
      yield DependencyEvent(
        message: 'Error installing packages: $e',
        level: 'error',
        progress: 1.0,
        isError: true,
      );
    }
  }
}
