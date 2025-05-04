import 'package:anime_nexa/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import 'shared/constants/app_theme.dart';

import 'shared/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
