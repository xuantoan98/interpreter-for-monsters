import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'game/game_content.dart';
import 'game/game_session.dart';
import 'game/progress_store.dart';
import 'game/vesper_content.dart';
import 'ui/game_palette.dart';
import 'ui/monster_art.dart';
import 'ui/starfield.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MonsterTranslatorApp());
}

const ink = GamePalette.night;
const plum = GamePalette.violet;
const cream = GamePalette.parchment;
const mint = GamePalette.mint;

enum AppPage { home, encounter, dictionary }

class MonsterTranslatorApp extends StatelessWidget {
  const MonsterTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Phiên dịch cho quái vật',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Nunito',
      colorScheme: ColorScheme.fromSeed(seedColor: plum),
      scaffoldBackgroundColor: ink,
    ),
    home: const GameShell(),
  );
}

class GameShell extends StatefulWidget {
  const GameShell({super.key, this.progressStore});

  final ProgressStore? progressStore;

  @override
  State<GameShell> createState() => _GameShellState();
}

class _GameShellState extends State<GameShell> {
  late final ProgressStore _store = widget.progressStore ?? ProgressStore();
  AudioPlayer? _audio;
  AudioPlayer get _player => _audio ??= AudioPlayer();
  GameProgress? _progress;
  GameSession? _session;
  AppPage _page = AppPage.home;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loadFailed = false);
    try {
      final progress = await _store.load();
      if (mounted) setState(() => _progress = progress);
    } catch (_) {
      if (mounted) setState(() => _loadFailed = true);
    }
  }

  Future<void> _save(GameProgress progress) async {
    setState(() => _progress = progress);
    try {
      await _store.save(progress);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chưa lưu được tiến độ. Hãy thử lại sau.'),
          ),
        );
      }
    }
  }

  Future<void> _playSound() async {
    if (_progress?.soundEnabled != true) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(_session!.encounter.audioAsset));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Không phát được tiếng của ${_session!.encounter.speciesName}.',
            ),
          ),
        );
      }
    }
  }

  void _start(Encounter encounter) {
    setState(() {
      _session = GameSession(encounter);
      _page = AppPage.encounter;
    });
    _playSound();
  }

  bool _isUnlocked(int index) =>
      index == 0 ||
      _progress!.completedEncounterIds.contains(ramEncounters[index - 1].id);

  bool _isVesperUnlocked(int index) =>
      _progress!.completedEncounterIds.contains(
        index == 0 ? ramEncounters.last.id : vesperEncounters[index - 1].id,
      );

  Encounter? _nextEncounter(Encounter encounter) {
    final encounters = encounter.speciesId == 'vesper'
        ? vesperEncounters
        : ramEncounters;
    if (encounter.number < encounters.length) {
      return encounters[encounter.number];
    }
    if (encounter.speciesId == 'ram') return vesperEncounters.first;
    return null;
  }

  void _choose(GameChoice choice) {
    setState(() {
      if (_session!.stage == SessionStage.interpretation) {
        _session!.chooseInterpretation(choice.id);
      } else {
        _session!.chooseResponse(choice.id);
      }
    });
  }

  Future<void> _advance() async {
    final session = _session!;
    setState(session.advance);
    if (session.stage == SessionStage.complete) {
      final progress = _progress!;
      await _save(
        progress.copyWith(
          completedEncounterIds: {
            ...progress.completedEncounterIds,
            session.encounter.id,
          },
          learnedVocabularyIds: {
            ...progress.learnedVocabularyIds,
            session.encounter.vocabularyId,
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _audio?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_progress == null) {
      return Scaffold(
        body: Center(
          child: _loadFailed
              ? FilledButton(
                  onPressed: _load,
                  child: const Text('Không đọc được tiến độ · Thử lại'),
                )
              : const CircularProgressIndicator(color: mint),
        ),
      );
    }
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [GamePalette.dusk, GamePalette.deepNight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: Starfield()),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: switch (_page) {
                    AppPage.home => _home(),
                    AppPage.encounter => _encounter(),
                    AppPage.dictionary => _dictionary(),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(String title, {bool back = false}) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 6),
    child: Row(
      children: [
        if (back)
          IconButton.filledTonal(
            tooltip: 'Về trang chính',
            onPressed: () => setState(() => _page = AppPage.home),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        if (back) const SizedBox(width: 10),
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: mint,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.8,
            ),
          ),
        ),
        IconButton.filledTonal(
          tooltip: _progress!.soundEnabled ? 'Tắt âm thanh' : 'Bật âm thanh',
          onPressed: () {
            if (_progress!.soundEnabled) _audio?.stop();
            _save(_progress!.copyWith(soundEnabled: !_progress!.soundEnabled));
          },
          icon: Icon(
            _progress!.soundEnabled
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
          ),
        ),
      ],
    ),
  );

  Widget _home() => Column(
    children: [
      _header('Trạm phiên dịch · 01'),
      Expanded(
        child: ListView(
          key: const ValueKey('home-list'),
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
          children: [
            const Text(
              'PHIÊN DỊCH\nCHO QUÁI VẬT',
              style: TextStyle(
                color: cream,
                fontWeight: FontWeight.w900,
                fontSize: 34,
                height: 1.08,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lắng nghe bằng mắt. Trả lời bằng trái tim.',
              style: TextStyle(color: Color(0xFFCEC5DD), fontSize: 15),
            ),
            const SizedBox(height: 24),
            _Panel(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 258,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(26),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/forest_clearing.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: -5,
                          bottom: -3,
                          width: 315,
                          height: 245,
                          child: Image.asset(
                            'assets/images/ram_curious.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: ink.withValues(alpha: 0.78),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome_rounded,
                                  color: cream,
                                  size: 13,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'CHUYẾN PHIÊU LƯU ĐẦU TIÊN',
                                  style: TextStyle(
                                    color: cream,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _Eyebrow('CUỘC GẶP ĐẦU TIÊN'),
                        const SizedBox(height: 6),
                        const Text('Bữa xế của Bram', style: _titleStyle),
                        const SizedBox(height: 6),
                        const Text(
                          'Một sinh vật nhỏ đang cố nói với bạn điều gì đó…',
                          style: TextStyle(
                            color: Color(0xFF625B6C),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _ActionButton(
                          label:
                              _progress!.completedEncounterIds.contains(
                                ramEncounter.id,
                              )
                              ? 'Chơi lại cuộc gặp'
                              : 'Bắt đầu phiên dịch',
                          onPressed: () => _start(ramEncounter),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DarkTile(
              icon: Icons.menu_book_rounded,
              title: 'Sổ tay ngôn ngữ',
              subtitle: _progress!.learnedVocabularyIds.isEmpty
                  ? 'Chưa có từ nào được giải mã'
                  : '${_progress!.learnedVocabularyIds.length} từ đã giải mã',
              onTap: () => setState(() => _page = AppPage.dictionary),
            ),
            const SizedBox(height: 22),
            const Text(
              'CÁC CUỘC GẶP',
              style: TextStyle(
                color: mint,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            for (var index = 1; index < ramEncounters.length; index++) ...[
              _DarkTile(
                icon: _isUnlocked(index)
                    ? Icons.auto_awesome_rounded
                    : Icons.lock_outline_rounded,
                title: '${index + 1}. ${ramEncounters[index].title}',
                subtitle:
                    _progress!.completedEncounterIds.contains(
                      ramEncounters[index].id,
                    )
                    ? 'Đã hiểu tín hiệu · Chơi lại'
                    : _isUnlocked(index)
                    ? 'Thử thách mới đã mở'
                    : 'Hoàn thành cuộc gặp trước để mở',
                onTap: _isUnlocked(index)
                    ? () => _start(ramEncounters[index])
                    : null,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 16),
            const Text(
              'LOÀI 02 · VESPER',
              style: TextStyle(
                color: mint,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            _Panel(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 210,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(26),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/forest_moonlit_nest.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 15,
                          bottom: -8,
                          width: 230,
                          height: 215,
                          child: Image.asset(
                            'assets/images/vesper_curious.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _Eyebrow('CHẶNG TIẾP THEO'),
                        const SizedBox(height: 6),
                        const Text('Tiếng gọi của Vesper', style: _titleStyle),
                        const SizedBox(height: 6),
                        const Text(
                          'Một quái vật cú lai rồng nói bằng nhịp hú, cánh và ánh mắt thứ ba.',
                          style: TextStyle(
                            color: Color(0xFF625B6C),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ActionButton(
                          label: _isVesperUnlocked(0)
                              ? 'Gặp Vesper'
                              : 'Hoàn thành Bram 06 để mở',
                          onPressed: _isVesperUnlocked(0)
                              ? () => _start(vesperEncounters.first)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            for (var index = 1; index < vesperEncounters.length; index++) ...[
              _DarkTile(
                icon: _isVesperUnlocked(index)
                    ? Icons.nightlight_round
                    : Icons.lock_outline_rounded,
                title: '${index + 1}. ${vesperEncounters[index].title}',
                subtitle:
                    _progress!.completedEncounterIds.contains(
                      vesperEncounters[index].id,
                    )
                    ? 'Đã hiểu tín hiệu · Chơi lại'
                    : _isVesperUnlocked(index)
                    ? 'Thử thách mới đã mở'
                    : 'Hoàn thành cuộc gặp trước để mở',
                onTap: _isVesperUnlocked(index)
                    ? () => _start(vesperEncounters[index])
                    : null,
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    ],
  );

  Widget _encounter() {
    final session = _session!;
    final outcome = session.currentOutcome;
    return Column(
      children: [
        _header(
          '${session.encounter.speciesName} · Cuộc gặp ${session.encounter.number.toString().padLeft(2, '0')}',
          back: true,
        ),
        Expanded(
          child: ListView(
            key: ValueKey('encounter-${session.encounter.id}'),
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 30),
            children: [
              Row(
                children: [
                  _step(
                    '1 · Diễn giải',
                    session.stage == SessionStage.interpretation ||
                        (session.stage == SessionStage.outcome &&
                            session.lastChoiceKind ==
                                ChoiceKind.interpretation),
                  ),
                  const SizedBox(width: 6),
                  _step(
                    '2 · Phản hồi',
                    session.stage == SessionStage.response ||
                        (session.stage == SessionStage.outcome &&
                            session.lastChoiceKind == ChoiceKind.response),
                  ),
                  const SizedBox(width: 6),
                  _step('3 · Học từ', session.stage == SessionStage.complete),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 250,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFBDF1CC), Color(0xFF8CDBD0)],
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: MonsterArt(
                  sceneAsset: session.encounter.sceneAsset,
                  characterAsset:
                      session.stage == SessionStage.complete ||
                          (outcome?.kind == OutcomeKind.correct &&
                              session.lastChoiceKind == ChoiceKind.response)
                      ? session.encounter.successAsset
                      : outcome != null && outcome.kind != OutcomeKind.correct
                      ? session.encounter.failureAsset
                      : session.encounter.characterAsset,
                  description: session.encounter.situation,
                ),
              ),
              const SizedBox(height: 16),
              _signalCard(session.encounter),
              const SizedBox(height: 16),
              if (session.stage == SessionStage.complete)
                _completeCard(session.encounter)
              else if (outcome != null)
                _outcomeCard(outcome, session)
              else
                _choiceCard(session),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step(String text, bool active) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: active ? mint : const Color(0xFF493B60),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: active ? ink : cream,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  Widget _signalCard(Encounter encounter) => _Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow('TÍN HIỆU QUÁI VẬT'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _SignalTag(_signalIcon(encounter, 0), encounter.signals[0]),
            _SignalTag(_signalIcon(encounter, 1), encounter.signals[1]),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Semantics(
              label: encounter.signals[2],
              child: Row(
                children: encounter.rhythmBars
                    .map(
                      (h) => Container(
                        width: 7,
                        height: h,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: plum,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                encounter.signals[2],
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            IconButton.filledTonal(
              tooltip: 'Nghe lại tiếng ${encounter.speciesName}',
              onPressed: _progress!.soundEnabled ? _playSound : null,
              icon: Icon(
                _progress!.soundEnabled
                    ? Icons.play_arrow_rounded
                    : Icons.volume_off_rounded,
              ),
            ),
          ],
        ),
        Text(
          encounter.signalDescription,
          style: const TextStyle(fontSize: 12, color: Color(0xFF625B6C)),
        ),
      ],
    ),
  );

  Widget _choiceCard(GameSession session) {
    final interpreting = session.stage == SessionStage.interpretation;
    final choices = interpreting
        ? session.encounter.interpretations
        : session.encounter.responses;
    final attempted = interpreting
        ? session.attemptedInterpretationIds
        : session.attemptedResponseIds;
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Eyebrow(interpreting ? 'BẠN NGHE ĐƯỢC GÌ?' : 'BẠN SẼ LÀM GÌ?'),
          const SizedBox(height: 6),
          Text(
            interpreting
                ? '${session.encounter.speciesName} đang muốn nói gì?'
                : 'Hãy đáp lại ${session.encounter.speciesName}',
            style: _titleStyle,
          ),
          const SizedBox(height: 5),
          Text(
            interpreting
                ? session.encounter.situation
                : '${session.encounter.speciesName} chờ câu trả lời của bạn.',
            style: const TextStyle(color: Color(0xFF625B6C)),
          ),
          const SizedBox(height: 15),
          for (final choice in choices)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Material(
                color: attempted.contains(choice.id)
                    ? const Color(0xFFECE9ED)
                    : Colors.white,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: attempted.contains(choice.id)
                      ? null
                      : () => _choose(choice),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFE4DDEA)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDAE),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Icon(
                            _choiceIcon(choice.icon),
                            color: const Color(0xFF855520),
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            choice.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        attempted.contains(choice.id)
                            ? const Text(
                                'Đã thử',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF71697A),
                                ),
                              )
                            : const Icon(
                                Icons.chevron_right_rounded,
                                color: plum,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _outcomeCard(GameOutcome outcome, GameSession session) {
    final correct = outcome.kind == OutcomeKind.correct;
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Eyebrow(correct ? 'BẠN ĐÃ HIỂU' : 'Ồ, CÓ CHUYỆN RỒI!'),
          const SizedBox(height: 6),
          Text(outcome.title, style: _titleStyle),
          const SizedBox(height: 9),
          Text(
            outcome.story,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: correct
                  ? const Color(0xFFDDF5E7)
                  : const Color(0xFFFFE9D5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(
                  correct
                      ? Icons.auto_awesome_rounded
                      : Icons.lightbulb_rounded,
                  color: correct
                      ? const Color(0xFF18825C)
                      : const Color(0xFFA5652F),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    outcome.hint,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ActionButton(
            label: correct
                ? session.lastChoiceKind == ChoiceKind.interpretation
                      ? 'Chọn cách phản hồi'
                      : 'Xem điều vừa học'
                : 'Thử lại',
            onPressed: _advance,
          ),
        ],
      ),
    );
  }

  Widget _completeCard(Encounter encounter) => _Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Eyebrow('TỪ MỚI ĐÃ MỞ KHÓA'),
        const SizedBox(height: 6),
        Text(encounter.vocabularyLabel, style: _titleStyle),
        const SizedBox(height: 7),
        Text(
          'Ý nghĩa: ${encounter.meaningLabel}',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        const SizedBox(height: 10),
        Text(encounter.explanation, style: const TextStyle(height: 1.5)),
        const SizedBox(height: 17),
        if (_nextEncounter(encounter) case final next?) ...[
          _ActionButton(
            label: 'Cuộc gặp tiếp theo',
            onPressed: () => _start(next),
          ),
          const SizedBox(height: 8),
        ] else ...[
          const Text(
            'Bạn đã hiểu lời của Bram và Vesper. Hãy mở sổ tay để xem những tín hiệu vừa học.',
            style: TextStyle(color: Color(0xFF625B6C), height: 1.4),
          ),
          const SizedBox(height: 12),
        ],
        _ActionButton(
          label: 'Mở sổ tay',
          onPressed: () => setState(() => _page = AppPage.dictionary),
        ),
        TextButton(
          onPressed: () => setState(() => _page = AppPage.home),
          child: const Text('Về trang chính'),
        ),
      ],
    ),
  );

  Widget _dictionary() {
    final learnedCount = [...ramEncounters, ...vesperEncounters]
        .where(
          (encounter) =>
              _progress!.learnedVocabularyIds.contains(encounter.vocabularyId),
        )
        .length;
    return Column(
      children: [
        _header('Sổ tay ngôn ngữ', back: true),
        Expanded(
          child: ListView(
            key: const ValueKey('dictionary-list'),
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 30),
            children: [
              const Text(
                'MỖI LOÀI,\nMỘT CÁCH NÓI.',
                style: TextStyle(
                  color: cream,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Những điều bạn đã nghe, thấy và hiểu.',
                style: TextStyle(color: Color(0xFFCEC5DD)),
              ),
              const SizedBox(height: 20),
              Container(
                height: 174,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4D3978), Color(0xFF1D6471)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 20,
                      top: 20,
                      child: Text(
                        'NHẬT KÝ\nPHIÊN DỊCH',
                        style: TextStyle(
                          color: cream,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 20,
                      child: Text(
                        learnedCount > 0
                            ? '$learnedCount tín hiệu đã hiểu'
                            : 'Hãy gặp Bram để bắt đầu',
                        style: const TextStyle(
                          color: mint,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -12,
                      bottom: -8,
                      width: 250,
                      height: 175,
                      child: Image.asset(
                        'assets/images/ram_curious.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Eyebrow('LOÀI 01'),
                    const SizedBox(height: 5),
                    const Text('Bram', style: _titleStyle),
                    const SizedBox(height: 15),
                    for (final encounter in ramEncounters) ...[
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color:
                              _progress!.learnedVocabularyIds.contains(
                                encounter.vocabularyId,
                              )
                              ? const Color(0xFFDDF5E7)
                              : const Color(0xFFECE7F1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              _progress!.learnedVocabularyIds.contains(
                                    encounter.vocabularyId,
                                  )
                                  ? Icons.auto_awesome_rounded
                                  : Icons.help_outline_rounded,
                              color: plum,
                              size: 27,
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _progress!.learnedVocabularyIds.contains(
                                          encounter.vocabularyId,
                                        )
                                        ? encounter.vocabularyLabel
                                        : 'Tín hiệu ${encounter.number.toString().padLeft(2, '0')} chưa giải mã',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _progress!.learnedVocabularyIds.contains(
                                          encounter.vocabularyId,
                                        )
                                        ? encounter.dictionaryDescription
                                        : 'Gặp Bram để khám phá ý nghĩa của tín hiệu.',
                                    style: const TextStyle(height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (encounter != ramEncounters.last)
                        const SizedBox(height: 9),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 15),
              _Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Eyebrow('LOÀI 02'),
                    const SizedBox(height: 5),
                    const Text('Vesper', style: _titleStyle),
                    const SizedBox(height: 15),
                    for (final encounter in vesperEncounters) ...[
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color:
                              _progress!.learnedVocabularyIds.contains(
                                encounter.vocabularyId,
                              )
                              ? const Color(0xFFDDF5E7)
                              : const Color(0xFFECE7F1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              _progress!.learnedVocabularyIds.contains(
                                    encounter.vocabularyId,
                                  )
                                  ? Icons.auto_awesome_rounded
                                  : Icons.help_outline_rounded,
                              color: plum,
                              size: 27,
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _progress!.learnedVocabularyIds.contains(
                                          encounter.vocabularyId,
                                        )
                                        ? encounter.vocabularyLabel
                                        : 'Tín hiệu ${encounter.number.toString().padLeft(2, '0')} chưa giải mã',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _progress!.learnedVocabularyIds.contains(
                                          encounter.vocabularyId,
                                        )
                                        ? encounter.dictionaryDescription
                                        : 'Gặp Vesper để khám phá ý nghĩa của tín hiệu.',
                                    style: const TextStyle(height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (encounter != vesperEncounters.last)
                        const SizedBox(height: 9),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

IconData _choiceIcon(String name) => switch (name) {
  'apple' => Icons.spa_rounded,
  'music' => Icons.music_note_rounded,
  'rain' => Icons.umbrella_rounded,
  'hat' => Icons.face_rounded,
  'water' => Icons.water_drop_rounded,
  'path' => Icons.signpost_rounded,
  'wave' => Icons.waving_hand_rounded,
  'star' => Icons.star_rounded,
  'shelter' => Icons.roofing_rounded,
  'heart' => Icons.favorite_rounded,
  _ => Icons.auto_awesome_rounded,
};

IconData _signalIcon(Encounter encounter, int position) =>
    switch ((encounter.speciesId, encounter.number, position)) {
      ('vesper', 1, 0) => Icons.visibility_rounded,
      ('vesper', 1, 1) => Icons.face_rounded,
      ('vesper', 2, 0) => Icons.waving_hand_rounded,
      ('vesper', 2, 1) => Icons.stars_rounded,
      ('vesper', 3, 0) => Icons.pan_tool_rounded,
      ('vesper', 3, 1) => Icons.nightlight_round,
      ('vesper', 4, 0) => Icons.warning_amber_rounded,
      ('vesper', 4, 1) => Icons.visibility_rounded,
      ('vesper', 5, 0) => Icons.auto_awesome_rounded,
      ('vesper', 5, 1) => Icons.home_rounded,
      ('ram', 1, 0) => Icons.flare_rounded,
      ('ram', 1, 1) => Icons.shopping_basket_rounded,
      ('ram', 2, 0) => Icons.flare_rounded,
      ('ram', 2, 1) => Icons.local_drink_rounded,
      ('ram', 3, 0) => Icons.waving_hand_rounded,
      ('ram', 3, 1) => Icons.blur_circular_rounded,
      ('ram', 4, 0) => Icons.flare_rounded,
      ('ram', 4, 1) => Icons.loop_rounded,
      ('ram', 5, 0) => Icons.pan_tool_rounded,
      ('ram', 5, 1) => Icons.loop_rounded,
      ('ram', 6, 0) => Icons.egg_alt_rounded,
      ('ram', 6, 1) => Icons.blur_circular_rounded,
      _ => Icons.auto_awesome_rounded,
    };

const _titleStyle = TextStyle(
  color: ink,
  fontSize: 23,
  fontWeight: FontWeight.w900,
);

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding = const EdgeInsets.all(20)});
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: cream,
      borderRadius: BorderRadius.circular(26),
    ),
    child: child,
  );
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFF754C9E),
      fontSize: 11,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.5,
    ),
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: plum,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
      ),
    ),
  );
}

class _SignalTag extends StatelessWidget {
  const _SignalTag(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFFFEDAE),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: const Color(0xFF875D12)),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

class _DarkTile extends StatelessWidget {
  const _DarkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xFF473859),
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: mint, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: cream,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFCEC5DD),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right_rounded, color: cream),
          ],
        ),
      ),
    ),
  );
}
