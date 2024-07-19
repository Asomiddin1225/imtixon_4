import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imtixon_4/cubt/theme_cubit.dart';
import 'package:imtixon_4/services/firebase_auth_service.dart';
import 'package:imtixon_4/services/firebase_service.dart';
import 'package:imtixon_4/views/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  // Flutter va Firebase initializatsiyasini bajarish
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase'ni inicializatsiya qilish
  await EasyLocalization
      .ensureInitialized(); // EasyLocalization'ni inicializatsiya qilish

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('uz'),
        Locale('ru'),
      ],
      path: 'assets/translation',
      fallbackLocale:
          Locale('uz'), // Agar til mavjud bo'lmasa, fallback tilni o'rnatish
      startLocale:
          Locale('uz'), // Ilovaning boshlang'ich tilini o'zbek tiliga o'rnatish
      child: MultiProvider(
        providers: [
          Provider(
              create: (_) =>
                  FirebaseAuthService()), // FirebaseAuthService ni Provider orqali yaratish
          Provider(
              create: (_) =>
                  FirebaseService()), // FirebaseService ni Provider orqali yaratish
          BlocProvider(
              create: (context) =>
                  ThemeCubit()), // ThemeCubit ni BlocProvider orqali yaratish
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
          localizationsDelegates: context
              .localizationDelegates, // Lokalizatsiya uchun delegatlarni o'rnatish
          supportedLocales: context
              .supportedLocales, // Qo'llab-quvvatlanadigan tillarni o'rnatish
          locale: context.locale, // Hozirgi tilni o'rnatish
          theme: isDark ? ThemeData.dark() : ThemeData.light(),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
