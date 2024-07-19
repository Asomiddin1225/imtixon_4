import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imtixon_4/cubt/theme_cubit.dart';
import 'package:imtixon_4/services/firebase_auth_service.dart';
import 'package:imtixon_4/services/firebase_service.dart'; // Import FirebaseService
import 'package:imtixon_4/views/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale(
          'en',
        ),
        Locale(
          'uz',
        ),
        Locale(
          'ru',
        ),
      ],
      path: 'assets/translation',
      fallbackLocale: Locale('uz'),
      startLocale: Locale('uz'),
      child: MultiProvider(
        providers: [
          Provider(create: (_) => FirebaseAuthService()),
          Provider(
              create: (_) => FirebaseService()), // Add FirebaseService here
          BlocProvider(create: (context) => ThemeCubit()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: isDark ? ThemeData.dark() : ThemeData.light(),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
