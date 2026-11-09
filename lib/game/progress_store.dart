import 'package:shared_preferences/shared_preferences.dart';

class GameProgress {
  const GameProgress({
    this.completedEncounterIds = const {},
    this.learnedVocabularyIds = const {},
    this.soundEnabled = true,
  });

  final Set<String> completedEncounterIds;
  final Set<String> learnedVocabularyIds;
  final bool soundEnabled;

  GameProgress copyWith({
    Set<String>? completedEncounterIds,
    Set<String>? learnedVocabularyIds,
    bool? soundEnabled,
  }) => GameProgress(
    completedEncounterIds: completedEncounterIds ?? this.completedEncounterIds,
    learnedVocabularyIds: learnedVocabularyIds ?? this.learnedVocabularyIds,
    soundEnabled: soundEnabled ?? this.soundEnabled,
  );
}

class ProgressStore {
  ProgressStore();

  SharedPreferencesAsync? _preferences;
  SharedPreferencesAsync get _prefs =>
      _preferences ??= SharedPreferencesAsync();

  static const _completedKey = 'completed_encounters_v1';
  static const _vocabularyKey = 'learned_vocabulary_v1';
  static const _soundKey = 'sound_enabled_v1';

  Future<GameProgress> load() async => GameProgress(
    completedEncounterIds: (await _prefs.getStringList(_completedKey) ?? [])
        .toSet(),
    learnedVocabularyIds: (await _prefs.getStringList(_vocabularyKey) ?? [])
        .toSet(),
    soundEnabled: await _prefs.getBool(_soundKey) ?? true,
  );

  Future<void> save(GameProgress progress) async {
    await _prefs.setStringList(
      _completedKey,
      progress.completedEncounterIds.toList(),
    );
    await _prefs.setStringList(
      _vocabularyKey,
      progress.learnedVocabularyIds.toList(),
    );
    await _prefs.setBool(_soundKey, progress.soundEnabled);
  }
}
