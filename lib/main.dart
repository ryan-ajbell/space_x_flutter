import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/spacex/presentation/cubit/latest_launch_cubit.dart';
import 'features/spacex/presentation/cubit/launches_cubit.dart';
import 'features/spacex/presentation/cubit/rockets_cubit.dart';
import 'injection_container.dart';
import 'presentation/pages/launch_detail_page.dart';
import 'presentation/pages/rocket_detail_page.dart';
import 'presentation/pages/root_shell.dart';
import 'presentation/theme/space_theme.dart';
import 'presentation/widgets/launch_card.dart';
import 'presentation/widgets/rocket_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<RocketsCubit>()..load()),
        BlocProvider(create: (_) => sl<LaunchesCubit>()..load()),
        BlocProvider(create: (_) => sl<LatestLaunchCubit>()..load()),
      ],
      child: MaterialApp(
        title: 'SpaceX Explorer',
        debugShowCheckedModeBanner: false,
        theme: SpaceTheme.build(),
        onGenerateRoute: (settings) {
          if (settings.name == '/rocket') {
            return MaterialPageRoute(
              builder: (_) =>
                  RocketDetailPage(rocket: settings.arguments as dynamic),
              fullscreenDialog: true,
            );
          }
          if (settings.name == '/launch') {
            return MaterialPageRoute(
              builder: (_) =>
                  LaunchDetailPage(launch: settings.arguments as dynamic),
              fullscreenDialog: true,
            );
          }
          if (settings.name == '/launch_full') {
            final launch = settings.arguments as dynamic;
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(title: const Text('Launch')),
                body: StarfieldBackground(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: LaunchCard(launch: launch, fullScreen: true),
                  ),
                ),
              ),
            );
          }
          if (settings.name == '/rocket_full') {
            final rocket = settings.arguments as dynamic;
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(title: const Text('Rocket')),
                body: StarfieldBackground(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: RocketCard(rocket: rocket, fullScreen: true),
                  ),
                ),
              ),
            );
          }
          return MaterialPageRoute(builder: (_) => const RootShell());
        },
        home: const RootShell(),
      ),
    );
  }
}
