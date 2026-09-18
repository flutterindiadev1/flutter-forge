import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/wizard/presentation/cubit/wizard_cubit.dart';
import '../features/wizard/presentation/screens/wizard_shell.dart';
import '../features/pipeline/presentation/cubit/pipeline_cubit.dart';
import '../features/pipeline/presentation/screens/pipeline_screen.dart';
import '../features/workspace/presentation/screens/workspace_screen.dart';
import '../features/workspace/presentation/cubit/workspace_cubit.dart';
import '../core/network/api_client.dart';
import 'theme/app_theme.dart';

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => BlocProvider(
        create: (_) => DashboardCubit(),
        child: const DashboardScreen(),
      ),
    ),
    GoRoute(
      path: '/wizard',
      name: 'wizard',
      builder: (context, state) => const WizardShell(),
    ),
    GoRoute(
      path: '/pipeline/:projectId',
      name: 'pipeline',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId'] ?? '';
        return BlocProvider(
          create: (_) => PipelineCubit(projectId: projectId),
          child: const PipelineScreen(),
        );
      },
    ),
    GoRoute(
      path: '/workspace/:projectId',
      name: 'workspace',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId'] ?? '';
        return BlocProvider(
          create: (_) => WorkspaceCubit(projectId: projectId, client: client),
          child: const WorkspaceScreen(),
        );
      },
    ),
  ],
);

class FlutterForgeApp extends StatelessWidget {
  const FlutterForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => WizardCubit()),
      ],
      child: MaterialApp.router(
        title: 'FlutterForge',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: _router,
      ),
    );
  }
}
