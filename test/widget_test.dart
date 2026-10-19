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

    // 1. HomeScreen checks (Default is Korean KO, Vocab track)
    expect(find.text('퀴즈 시작하기 (Start)'), findsOneWidget);
    expect(find.text('📚 기초 어휘'), findsOneWidget);
    expect(find.text('💬 실전 문장·뉘앙스'), findsOneWidget);
    expect(find.text('필수 기초 어휘:\n사물·생활·반대말 퀴즈'), findsOneWidget);
    expect(find.text('KO • 한국어 (기본)'), findsOneWidget);
    expect(find.text('EN • English'), findsOneWidget);
    expect(find.text('VI • Tiếng Việt'), findsOneWidget);
    expect(find.text('JA • 日本語'), findsOneWidget);

    // Switch to Sentence & Nuance track
    await tester.tap(find.text('💬 실전 문장·뉘앙스'));
    await tester.pumpAndSettle();
    expect(find.text('한국어:\n실전 대화 퀴즈'), findsOneWidget);

    // Test dynamic language switching on Home Dashboard (English)
    await tester.tap(find.text('EN • English'));
    await tester.pumpAndSettle();
    expect(find.text('Start Quiz'), findsOneWidget);
    expect(find.text('Korean:\nDaily Conversation Quiz'), findsOneWidget);
    expect(find.text('NUANCE OF THE DAY'), findsOneWidget);

    // Switch back to Korean for Quiz
    await tester.tap(find.text('KO • 한국어 (기본)'));
    await tester.pumpAndSettle();
    expect(find.text('퀴즈 시작하기 (Start)'), findsOneWidget);

    // 2. Start Quiz directly with Korean default
    await tester.tap(find.text('퀴즈 시작하기 (Start)'));
    await tester.pumpAndSettle();

    // 3. Verify Quiz 1 is presented in Korean (Sentence Exercise: 능력·가능)
    expect(find.text('문제 1 / 10'), findsOneWidget);
    expect(find.text('실전 문장 연습'), findsOneWidget); // AppBar title
    expect(find.text('문장 연습'), findsOneWidget); // Visual card pill
    expect(find.text('한국어를 할 수 있어요?'), findsOneWidget);
    expect(find.text('네, (                 ).'), findsOneWidget);
    expect(find.text('🗣️ 🇰🇷'), findsOneWidget);

    // 4. Select Correct Korean Answer: 할 수 있어요
    await tester.tap(find.text('할 수 있어요'));
    await tester.pumpAndSettle();

    expect(find.text('정답입니다! 🎉'), findsOneWidget);
    expect(find.text('문장 해설 & 팁'), findsOneWidget);
    expect(
      find.textContaining('-(으)ㄹ 수 있어요'),
      findsOneWidget,
    );

    // 5. Switch language to English (EN) using the AppBar dropdown
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('EN • English').last);
    await tester.pumpAndSettle();

    // Verify explanation and headers dynamically switched to English
    expect(find.text('Spot on!'), findsOneWidget);
    expect(
      find.textContaining('can'),
      findsOneWidget,
    );

    // Go to Question 2 (운전할 수 있어요?)
    await tester.tap(find.text('Next Question'));
    await tester.pumpAndSettle();

    expect(find.text('Question 2 of 10'), findsOneWidget);
    expect(find.text('운전할 수 있어요?'), findsOneWidget);

    await tester.tap(find.text('운전할 수 있어요'));
    await tester.pumpAndSettle();
    expect(find.text('Spot on!'), findsOneWidget);

    // Go to Question 3 (케이크를 만들 수 있어요?)
    await tester.tap(find.text('Next Question'));
    await tester.pumpAndSettle();

    expect(find.text('Question 3 of 10'), findsOneWidget);
    await tester.tap(find.text('만들 수 있어요'));
    await tester.pumpAndSettle();
    expect(find.text('Spot on!'), findsOneWidget);

    // Go to Question 4 (김치를 먹을 수 있어요? - 못 먹어요)
    await tester.tap(find.text('Next Question'));
    await tester.pumpAndSettle();

    expect(find.text('Question 4 of 10'), findsOneWidget);
    await tester.tap(find.text('못 먹어요'));
    await tester.pumpAndSettle();
    expect(find.text('Spot on!'), findsOneWidget);

    // Questions 5 to 10
    final remainingAnswers = [
      '못 타요', // Q5 스키
      '산책하러 공원에 가요', // Q6 공원
      '책을 빌리러 도서관에 가요', // Q7 도서관
      '물건을 사러 편의점에 가요', // Q8 편의점
      '친구를 만나러 부산에 가요', // Q9 부산
      '한국어를 배우러 왔어요', // Q10 한국
    ];

    for (int i = 0; i < remainingAnswers.length; i++) {
      await tester.tap(find.text('Next Question'));
      await tester.pumpAndSettle();

      expect(find.text('Question ${i + 5} of 10'), findsOneWidget);
      await tester.tap(find.text(remainingAnswers[i]));
      await tester.pumpAndSettle();
      expect(find.text('Spot on!'), findsOneWidget);
    }

    expect(find.text('See Results'), findsOneWidget);

    // 9. Navigate to ResultScreen
    await tester.tap(find.text('See Results'));
    await tester.pumpAndSettle();

    expect(find.text('Assessment Finished!'), findsOneWidget);
    expect(find.text('Score: 10 / 10'), findsOneWidget);
    expect(find.text('100% Natural Accuracy'), findsOneWidget);
    expect(
      find.textContaining('Native-level Intuition!'),
      findsOneWidget,
    );
    expect(find.text('Try Again'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    // 10. Back to Home
    final homeButtonFinder = find.text('Home');
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

    // 1. Default: Korean (Vocab track)
    expect(find.text('필수 기초 어휘:\n사물·생활·반대말 퀴즈'), findsOneWidget);
    expect(find.text('퀴즈 시작하기 (Start)'), findsOneWidget);
    expect(find.text('📚 기초 어휘'), findsOneWidget);

    // 2. Switch to English
    await tester.tap(find.text('EN • English'));
    await tester.pumpAndSettle();
    expect(find.text('Essential Vocab:\nObjects & Daily Words'), findsOneWidget);
    expect(find.text('Start Quiz'), findsOneWidget);
    expect(find.text('📚 Basic Vocab'), findsOneWidget);
    expect(find.text('NUANCE OF THE DAY'), findsOneWidget);

    // Switch to Sentence track in English
    await tester.tap(find.text('💬 Real Sentences'));
    await tester.pumpAndSettle();
    expect(find.text('Korean:\nDaily Conversation Quiz'), findsOneWidget);

    // 3. Switch to Vietnamese (Tiếng Việt)
    await tester.tap(find.text('VI • Tiếng Việt'));
    await tester.pumpAndSettle();
    expect(find.text('Tiếng Hàn:\nLuyện Câu Đàm Thoại'), findsOneWidget);
    expect(find.text('Bắt đầu làm bài'), findsOneWidget);
    expect(find.text('SẮC THÁI HÔM NAY'), findsOneWidget);

    // 4. Switch to Chinese
    await tester.tap(find.text('ZH • 中文'));
    await tester.pumpAndSettle();
    expect(find.text('韩语：\n日常会话测验'), findsOneWidget);
    expect(find.text('开始测验'), findsOneWidget);
    expect(find.text('今日实用语感'), findsOneWidget);
  });

  testWidgets('Textbook picture vocabulary quiz flow test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BeginnerKoreanQuizApp());
    await tester.pumpAndSettle();

    // 1. Vocab track is selected by default (18 Qs)
    expect(find.text('📚 기초 어휘'), findsOneWidget);
    await tester.tap(find.text('퀴즈 시작하기 (Start)'));
    await tester.pumpAndSettle();

    // 2. Question 1 should display picture illustration card (🌹 꽃) and dynamic AppBar title
    expect(find.text('기초 어휘 퀴즈'), findsOneWidget);
    expect(find.text('기초 단어'), findsOneWidget);
    expect(find.text('※ 그림을 보고 알맞은 것을 고르십시오.'), findsOneWidget);
    expect(find.text('🌹'), findsOneWidget);
    expect(find.text('철수'), findsOneWidget);
    expect(find.text('이것이 무엇입니까?'), findsOneWidget);
    expect(find.text('영희'), findsOneWidget);
    expect(find.text('(       )입니다.'), findsOneWidget);

    // Select correct answer: 꽃
    await tester.tap(find.text('꽃'));
    await tester.pumpAndSettle();

    expect(find.text('정답입니다! 🎉'), findsOneWidget);
    expect(find.text('단어 해설 & 팁'), findsOneWidget);
    expect(find.text('다음 문제'), findsOneWidget);
  });
}

