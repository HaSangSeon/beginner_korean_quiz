import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

import 'services/ad_service.dart';
import 'services/progress_service.dart';
import 'services/quiz_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await QuizRepository.loadQuestions();
  await ProgressService().init();
  await AdService().initialize();
  runApp(const BeginnerKoreanQuizApp());
}

class BeginnerKoreanQuizApp extends StatelessWidget {
  const BeginnerKoreanQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primarySeedColor = Color(0xFF1E40AF);

    return ListenableBuilder(
      listenable: ProgressService(),
      builder: (context, _) => MaterialApp(
        title: 'Beginner Korean Quiz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primarySeedColor,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          cardTheme: const CardThemeData(
            elevation: 0,
            margin: EdgeInsets.zero,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primarySeedColor,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0F172A),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          cardTheme: const CardThemeData(
            elevation: 0,
            margin: EdgeInsets.zero,
          ),
        ),
        themeMode: ProgressService().themeMode,
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          // Protect UI against extreme system font scaling (>1.3x) on small Android screens
          final clampedScaler = mediaQuery.textScaler.clamp(
            minScaleFactor: 0.85,
            maxScaleFactor: 1.30,
          );
          return MediaQuery(
            data: mediaQuery.copyWith(textScaler: clampedScaler),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const HomeScreen(),
      ),
    );
  }
}
