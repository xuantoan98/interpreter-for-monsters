import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interpreter_monsters/game/progress_store.dart';
import 'package:interpreter_monsters/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviewStore extends ProgressStore {
  PreviewStore(this.progress);

  GameProgress progress;

  @override
  Future<GameProgress> load() async => progress;

  @override
  Future<void> save(GameProgress value) async => progress = value;
}

Future<void> setupPreview(WidgetTester tester, PreviewStore store) async {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  SharedPreferences.setMockInitialValues({});
  final loader = FontLoader('Nunito')
    ..addFont(rootBundle.load('assets/fonts/Nunito.ttf'));
  await loader.load();
  final iconLoader = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await iconLoader.load();
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Nunito'),
      home: GameShell(progressStore: store),
    ),
  );
  await tester.runAsync(() async {
    final context = tester.element(find.byType(GameShell));
    for (final path in [
      'assets/images/forest_clearing.png',
      'assets/images/forest_stream.png',
      'assets/images/forest_fork.png',
      'assets/images/forest_hollow.png',
      'assets/images/forest_bridge.png',
      'assets/images/forest_moonlit_nest.png',
      'assets/images/ram_curious.png',
      'assets/images/ram_confused.png',
      'assets/images/ram_delighted.png',
      'assets/images/ram_thirsty.png',
      'assets/images/ram_beckoning.png',
      'assets/images/ram_cowering.png',
      'assets/images/ram_warning.png',
      'assets/images/ram_pointing.png',
    ]) {
      await precacheImage(AssetImage(path), context);
    }
  });
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  testWidgets('home design', (tester) async {
    await setupPreview(
      tester,
      PreviewStore(const GameProgress(soundEnabled: false)),
    );
    await expectLater(
      find.byType(GameShell),
      matchesGoldenFile('goldens/home.png'),
    );
  });

  testWidgets('encounter design', (tester) async {
    await setupPreview(
      tester,
      PreviewStore(const GameProgress(soundEnabled: false)),
    );
    await tester.ensureVisible(find.text('Bắt đầu phiên dịch'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Bắt đầu phiên dịch'));
    await tester.pump(const Duration(seconds: 1));
    await expectLater(
      find.byType(GameShell),
      matchesGoldenFile('goldens/encounter.png'),
    );
  });

  testWidgets('dictionary design', (tester) async {
    await setupPreview(
      tester,
      PreviewStore(
        const GameProgress(
          soundEnabled: false,
          learnedVocabularyIds: {'ram_hungry'},
        ),
      ),
    );
    await tester.ensureVisible(find.text('Sổ tay ngôn ngữ'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Sổ tay ngôn ngữ'));
    await tester.pump(const Duration(seconds: 1));
    await expectLater(
      find.byType(GameShell),
      matchesGoldenFile('goldens/dictionary.png'),
    );
  });

  testWidgets('wrong answer reaction design', (tester) async {
    await setupPreview(
      tester,
      PreviewStore(const GameProgress(soundEnabled: false)),
    );
    await tester.ensureVisible(find.text('Bắt đầu phiên dịch'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Bắt đầu phiên dịch'));
    await tester.pump(const Duration(seconds: 1));
    await tester.ensureVisible(find.text('Bram muốn nhảy múa'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Bram muốn nhảy múa'));
    await tester.pump(const Duration(seconds: 1));
    await expectLater(
      find.byType(GameShell),
      matchesGoldenFile('goldens/wrong_answer.png'),
    );
  });

  for (final (number, title, completed) in [
    (2, '2. Chiếc cốc bên suối', {'ram_01'}),
    (3, '3. Lối rẽ đom đóm', {'ram_01', 'ram_02'}),
    (4, '4. Tiếng động dưới lá', {'ram_01', 'ram_02', 'ram_03'}),
    (
      5,
      '5. Cây cầu thiếu một tấm ván',
      {'ram_01', 'ram_02', 'ram_03', 'ram_04'},
    ),
    (
      6,
      '6. Chiếc tổ dưới trăng',
      {'ram_01', 'ram_02', 'ram_03', 'ram_04', 'ram_05'},
    ),
  ]) {
    testWidgets('encounter $number design', (tester) async {
      await setupPreview(
        tester,
        PreviewStore(
          GameProgress(soundEnabled: false, completedEncounterIds: completed),
        ),
      );
      await tester.scrollUntilVisible(find.text(title), 220);
      await tester.pump(const Duration(milliseconds: 300));
      await Scrollable.ensureVisible(
        tester.element(find.text(title)),
        alignment: 0.45,
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(title));
      await tester.pump(const Duration(seconds: 1));
      await expectLater(
        find.byType(GameShell),
        matchesGoldenFile('goldens/encounter_$number.png'),
      );
    });
  }

  for (final (number, title) in [
    (1, 'Gặp Vesper'),
    (2, '2. Lối đá trên hồ trăng'),
    (3, '3. Khu vườn đang ngủ'),
    (4, '4. Bóng cây trên vách gió'),
    (5, '5. Chiếc lông trở về tổ'),
  ]) {
    testWidgets('Vesper encounter $number design', (tester) async {
      final completed = {
        'ram_01',
        'ram_02',
        'ram_03',
        'ram_04',
        'ram_05',
        'ram_06',
        for (var i = 1; i < number; i++) 'vesper_0$i',
      };
      await setupPreview(
        tester,
        PreviewStore(
          GameProgress(soundEnabled: false, completedEncounterIds: completed),
        ),
      );
      await tester.scrollUntilVisible(find.text(title), 300);
      await tester.pumpAndSettle();
      await Scrollable.ensureVisible(
        tester.element(find.text(title)),
        alignment: 0.45,
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(title));
      await tester.pump(const Duration(seconds: 1));
      const sceneAssets = [
        'assets/images/forest_moonlit_nest.png',
        'assets/images/moon_pond.png',
        'assets/images/sleeping_grove.png',
        'assets/images/storm_ledge.png',
        'assets/images/dawn_nest.png',
      ];
      const characterAssets = [
        'assets/images/vesper_curious.png',
        'assets/images/vesper_guiding.png',
        'assets/images/vesper_quiet.png',
        'assets/images/vesper_warning.png',
        'assets/images/vesper_feather.png',
      ];
      await tester.runAsync(() async {
        final context = tester.element(find.byType(GameShell));
        await precacheImage(AssetImage(sceneAssets[number - 1]), context);
        await precacheImage(AssetImage(characterAssets[number - 1]), context);
      });
      await tester.pump(const Duration(milliseconds: 300));
      await expectLater(
        find.byType(GameShell),
        matchesGoldenFile('goldens/vesper_$number.png'),
      );
    });
  }

  testWidgets('compact phone keeps the encounter scrollable', (tester) async {
    await setupPreview(
      tester,
      PreviewStore(const GameProgress(soundEnabled: false)),
    );
    tester.view.physicalSize = const Size(360, 800);
    await tester.pump();
    await tester.ensureVisible(find.text('Bắt đầu phiên dịch'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Bắt đầu phiên dịch'));
    await tester.pump(const Duration(seconds: 1));
    await tester.ensureVisible(find.text('Bram đang sợ'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
    expect(find.text('Bram đang sợ'), findsOneWidget);
  });

  testWidgets('warning signal fits on a compact phone', (tester) async {
    await setupPreview(
      tester,
      PreviewStore(
        const GameProgress(
          soundEnabled: false,
          completedEncounterIds: {'ram_01', 'ram_02', 'ram_03', 'ram_04'},
        ),
      ),
    );
    tester.view.physicalSize = const Size(360, 800);
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('5. Cây cầu thiếu một tấm ván'),
      280,
    );
    await Scrollable.ensureVisible(
      tester.element(find.text('5. Cây cầu thiếu một tấm ván')),
      alignment: 0.45,
      duration: Duration.zero,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('5. Cây cầu thiếu một tấm ván'));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    expect(find.text('Móng xòe chặn lại'), findsOneWidget);
  });
}
