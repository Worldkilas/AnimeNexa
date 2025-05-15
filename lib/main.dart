import 'package:anime_nexa/core/typedefs.dart';
import 'package:anime_nexa/firebase_options.dart';
import 'package:anime_nexa/providers/global_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import 'core/services/deep_link_handler.dart';
import 'shared/constants/app_theme.dart';

import 'shared/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  DeepLinkHandler.initListener();

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appContextProvider.notifier).state = context;
    });
  }

  @override
  Widget build(BuildContext context) {
    final routerConfig = ref.watch(appRouterProvider);
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp.router(
        routerConfig: routerConfig,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
      );
    });
  }
}
