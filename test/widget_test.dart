import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beginner_korean_quiz/main.dart';

void main() {
  testWidgets('Korean default nuance quiz flow with multilingual switching',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BeginnerKoreanQuizApp());

    // 1. HomeScreen checks (Default is Korean KO)
    expect(find.text('퀴즈 시작하기 (Start)'), findsOneWidget);
    expect(find.text('리얼 한국어:\n실전 뉘앙스 퀴즈'), findsOneWidget);
    expect(find.text('KO • 한국어 (기본)'), findsOneWidget);
    expect(find.text('EN • English'), findsOneWidget);
    expect(find.text('ES • Español'), findsOneWidget);
    expect(find.text('JA • 日本語'), findsOneWidget);

    // Test dynamic language switching on Home Dashboard (English)
    await tester.tap(find.text('EN • English'));
    await tester.pumpAndSettle();
    expect(find.text('Start Quiz'), findsOneWidget);
    expect(find.text('Real Korean:\nNuance & Quiz'), findsOneWidget);
    expect(find.text('NUANCE OF THE DAY'), findsOneWidget);

    // Switch back to Korean for Quiz
    await tester.tap(find.text('KO • 한국어 (기본)'));
    await tester.pumpAndSettle();
    expect(find.text('퀴즈 시작하기 (Start)'), findsOneWidget);

    // 2. Start Quiz directly with Korean default
    await tester.tap(find.text('퀴즈 시작하기 (Start)'));
    await tester.pumpAndSettle();

    // 3. Verify Quiz 1 is presented in Korean
    expect(find.text('문제 1 / 4'), findsOneWidget);
    expect(find.text('존댓말'), findsOneWidget);
    expect(find.text('상황 맥락'), findsOneWidget);
    expect(
      find.text('한국인이 윗사람이나 선배에게 가장 자연스럽고 공손하게 건네는 점심 안부 인사는?'),
      findsOneWidget,
    );

    // 4. Select Correct Korean Answer: 식사하셨어요?
    await tester.tap(find.text('식사하셨어요? (Siksahasyeosseoyo?)'));
    await tester.pumpAndSettle();

    expect(find.text('정답입니다! 🎉'), findsOneWidget);
    expect(find.text('대학교 강사의 뉘앙스 해설'), findsOneWidget);
    expect(
      find.textContaining('가장 자연스러운 표준 높임말 인사입니다'),
      findsOneWidget,
    );

    // 5. Switch language to Spanish (ES) using the AppBar dropdown
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ES • Español').last);
    await tester.pumpAndSettle();

    // Verify explanation and headers dynamically switched to Spanish
    expect(find.text('¡Correcto! 🎉'), findsOneWidget);
    expect(
      find.textContaining('combina el sustantivo honorífico'),
      findsOneWidget,
    );

    // Go to Question 2
    await tester.tap(find.text('Siguiente Pregunta'));
    await tester.pumpAndSettle();

    // 6. Question 2 (Particles) in Spanish
    expect(find.text('Pregunta 2 de 4'), findsOneWidget);
    expect(find.text('Partículas'), findsOneWidget);

    await tester.tap(find.text('제가 만들었어요. (Jega mandeureosseoyo.)'));
    await tester.pumpAndSettle();
    expect(find.text('¡Correcto! 🎉'), findsOneWidget);

    // Go to Question 3
    await tester.tap(find.text('Siguiente Pregunta'));
    await tester.pumpAndSettle();

    // 7. Question 3 (Real-life)
    expect(find.text('Pregunta 3 de 4'), findsOneWidget);
    await tester.tap(find.text('저기요! (Jeogiyo!)'));
    await tester.pumpAndSettle();
    expect(find.text('¡Correcto! 🎉'), findsOneWidget);

    // Go to Question 4
    await tester.tap(find.text('Siguiente Pregunta'));
    await tester.pumpAndSettle();

    // 8. Question 4 (Declining with 괜찮습니다)
    expect(find.text('Pregunta 4 de 4'), findsOneWidget);
    await tester.tap(find.text('아, 저는 괜찮습니다. (Ah, jeoneun gwaenchanhseumnida.)'));
    await tester.pumpAndSettle();
    expect(find.text('¡Correcto! 🎉'), findsOneWidget);
    expect(find.text('Ver Resultados'), findsOneWidget);

    // 9. Navigate to ResultScreen
    await tester.tap(find.text('Ver Resultados'));
    await tester.pumpAndSettle();

    expect(find.text('¡Quiz Completado! 🎉'), findsOneWidget);
    expect(find.text('Puntuación: 4 / 4'), findsOneWidget);
    expect(find.text('100% Precisión Natural'), findsOneWidget);
    expect(
      find.textContaining('¡Intuición de nivel nativo!'),
      findsOneWidget,
    );
    expect(find.text('Intentar de Nuevo'), findsOneWidget);
    expect(find.text('Ir al Inicio'), findsOneWidget);

    // 10. Back to Home
    final homeButtonFinder = find.text('Ir al Inicio');
    await tester.ensureVisible(homeButtonFinder);
    await tester.tap(homeButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('퀴즈 시작하기 (Start)'), findsOneWidget);
  });

  testWidgets('HomeScreen full multilingual UI localization test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BeginnerKoreanQuizApp());

    // 1. Default: Korean
    expect(find.text('리얼 한국어:\n실전 뉘앙스 퀴즈'), findsOneWidget);
    expect(find.text('퀴즈 시작하기 (Start)'), findsOneWidget);

    // 2. Switch to English
    await tester.tap(find.text('EN • English'));
    await tester.pumpAndSettle();
    expect(find.text('Real Korean:\nNuance & Quiz'), findsOneWidget);
    expect(find.text('Start Quiz'), findsOneWidget);
    expect(find.text('NUANCE OF THE DAY'), findsOneWidget);

    // 3. Switch to Spanish
    await tester.tap(find.text('ES • Español'));
    await tester.pumpAndSettle();
    expect(find.text('Coreano Real:\nMatices y Quiz'), findsOneWidget);
    expect(find.text('Comenzar Quiz'), findsOneWidget);
    expect(find.text('MATIZ DEL DÍA'), findsOneWidget);

    // 4. Switch to Chinese
    await tester.tap(find.text('ZH • 中文'));
    await tester.pumpAndSettle();
    expect(find.text('地道韩语：\n实战语感测验'), findsOneWidget);
    expect(find.text('开始测验'), findsOneWidget);
    expect(find.text('今日实用语感'), findsOneWidget);
  });
}
