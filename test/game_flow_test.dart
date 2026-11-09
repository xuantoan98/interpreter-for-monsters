import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interpreter_monsters/game/progress_store.dart';
import 'package:interpreter_monsters/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryProgressStore extends ProgressStore {
  GameProgress progress = const GameProgress(soundEnabled: false);

  @override
  Future<GameProgress> load() async => progress;

  @override
  Future<void> save(GameProgress value) async => progress = value;
}

Finder assetImage(String path) => find.byWidgetPredicate(
  (widget) =>
      widget is Image &&
      widget.image is AssetImage &&
      (widget.image as AssetImage).assetName == path,
);

void main() {
  testWidgets('encounter five teaches a warning and unlocks the Bram finale', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final store = MemoryProgressStore()
      ..progress = const GameProgress(
        soundEnabled: false,
        completedEncounterIds: {'ram_01', 'ram_02', 'ram_03', 'ram_04'},
        learnedVocabularyIds: {
          'ram_hungry',
          'ram_thirsty',
          'ram_follow',
          'ram_scared',
        },
      );
    await tester.pumpWidget(MaterialApp(home: GameShell(progressStore: store)));
    await tester.pump(const Duration(milliseconds: 300));

    Future<void> choose(String label) async {
      await tester.ensureVisible(find.text(label));
      await tester.tap(find.text(label));
      await tester.pump(const Duration(milliseconds: 300));
    }

    await tester.scrollUntilVisible(
      find.text('5. Cây cầu thiếu một tấm ván'),
      220,
    );
    await tester.drag(
      find.byKey(const ValueKey('home-list')),
      const Offset(0, 180),
    );
    await tester.pumpAndSettle();
    await choose('5. Cây cầu thiếu một tấm ván');
    expect(assetImage('assets/images/forest_bridge.png'), findsOneWidget);
    expect(assetImage('assets/images/ram_warning.png'), findsOneWidget);
    await choose('Bram rủ bạn chạy qua cầu');
    expect(find.text('Một bước nhảy hơi vội'), findsOneWidget);
    await choose('Thử lại');
    await choose('Bram bảo bạn dừng lại');
    await choose('Chọn cách phản hồi');
    await choose('Dừng lại và xem tấm ván gãy');
    await choose('Xem điều vừa học');
    expect(store.progress.completedEncounterIds, contains('ram_05'));
    expect(store.progress.learnedVocabularyIds, contains('ram_stop'));
    await choose('Cuộc gặp tiếp theo');
    expect(find.text('BRAM · CUỘC GẶP 06'), findsOneWidget);
    expect(assetImage('assets/images/forest_moonlit_nest.png'), findsOneWidget);
    await choose('Bram muốn cùng tìm bạn ở tổ');
    await choose('Chọn cách phản hồi');
    await choose('Leo vào tổ và kêu ụm thật to');
    expect(find.text('Tiếng ụm vang khắp rừng'), findsOneWidget);
    await choose('Thử lại');
    await choose('Cùng Bram tìm dấu vết quanh cây');
    await choose('Xem điều vừa học');
    expect(store.progress.completedEncounterIds, contains('ram_06'));
    expect(store.progress.learnedVocabularyIds, contains('ram_search'));
    await choose('Cuộc gặp tiếp theo');
    expect(find.text('VESPER · CUỘC GẶP 01'), findsOneWidget);
    expect(assetImage('assets/images/vesper_curious.png'), findsOneWidget);
    await choose('Vesper xin đồ ăn');
    expect(find.text('Táo cho... cái tổ?'), findsOneWidget);
    await choose('Thử lại');
    await choose('Vesper hỏi ai đang ở đó');
    await choose('Chọn cách phản hồi');
    await choose('Bước ra và vẫy chào Vesper');
    await choose('Xem điều vừa học');
    expect(store.progress.completedEncounterIds, contains('vesper_01'));
    expect(store.progress.learnedVocabularyIds, contains('vesper_hello'));
    await choose('Cuộc gặp tiếp theo');
    expect(find.text('VESPER · CUỘC GẶP 02'), findsOneWidget);
  });

  testWidgets('finishing encounter two unlocks and opens encounter three', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final store = MemoryProgressStore()
      ..progress = const GameProgress(
        soundEnabled: false,
        completedEncounterIds: {'ram_01'},
        learnedVocabularyIds: {'ram_hungry'},
      );
    await tester.pumpWidget(MaterialApp(home: GameShell(progressStore: store)));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.scrollUntilVisible(find.text('2. Chiếc cốc bên suối'), 220);
    await tester.tap(find.text('2. Chiếc cốc bên suối'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(assetImage('assets/images/forest_stream.png'), findsOneWidget);

    Future<void> choose(String label) async {
      await tester.ensureVisible(find.text(label));
      await tester.tap(find.text(label));
      await tester.pump(const Duration(milliseconds: 300));
    }

    await choose('Bram đang khát');
    await choose('Chọn cách phản hồi');
    await choose('Múc nước vào cốc');
    await choose('Xem điều vừa học');
    expect(store.progress.completedEncounterIds, contains('ram_02'));
    expect(store.progress.learnedVocabularyIds, contains('ram_thirsty'));
    await choose('Cuộc gặp tiếp theo');
    expect(find.text('Bram · Cuộc gặp 03'.toUpperCase()), findsOneWidget);
    expect(assetImage('assets/images/forest_fork.png'), findsOneWidget);
  });

  testWidgets('player can retry, respond, learn a word, and open dictionary', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final store = MemoryProgressStore();
    await tester.pumpWidget(MaterialApp(home: GameShell(progressStore: store)));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.ensureVisible(find.text('Bắt đầu phiên dịch'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Bắt đầu phiên dịch'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.ensureVisible(find.text('Bram muốn nhảy múa'));
    await tester.tap(find.text('Bram muốn nhảy múa'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Một vũ công bất đắc dĩ'), findsOneWidget);
    expect(find.textContaining('chiếc giỏ rỗng'), findsWidgets);

    await tester.ensureVisible(find.text('Thử lại'));
    await tester.tap(find.text('Thử lại'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.ensureVisible(find.text('Bram đang đói'));
    await tester.tap(find.text('Bram đang đói'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(assetImage('assets/images/ram_curious.png'), findsOneWidget);
    expect(assetImage('assets/images/ram_delighted.png'), findsNothing);
    await tester.ensureVisible(find.text('Chọn cách phản hồi'));
    await tester.tap(find.text('Chọn cách phản hồi'));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.ensureVisible(find.text('Đội nấm cho Bram'));
    await tester.tap(find.text('Đội nấm cho Bram'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Vương miện nấm tí hon'), findsOneWidget);
    await tester.ensureVisible(find.text('Thử lại'));
    await tester.tap(find.text('Thử lại'));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.ensureVisible(find.text('Đưa một quả táo'));
    await tester.tap(find.text('Đưa một quả táo'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(assetImage('assets/images/ram_delighted.png'), findsOneWidget);
    await tester.ensureVisible(find.text('Xem điều vừa học'));
    await tester.tap(find.text('Xem điều vừa học'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Cổ sáng ba nhịp + giỏ rỗng'), findsOneWidget);
    expect(store.progress.learnedVocabularyIds, contains('ram_hungry'));

    await tester.ensureVisible(find.text('Mở sổ tay'));
    await tester.tap(find.text('Mở sổ tay'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      find.text('Bram đói · Cổ sáng ba nhịp, mắt hướng về chiếc giỏ rỗng.'),
      findsOneWidget,
    );
  });
}
