import 'package:flutter_test/flutter_test.dart';
import 'package:interpreter_monsters/game/game_content.dart';
import 'package:interpreter_monsters/game/game_session.dart';
import 'package:interpreter_monsters/game/vesper_content.dart';

void main() {
  test('all six Bram encounters have complete answer and retry content', () {
    expect(ramEncounters.map((encounter) => encounter.number).toList(), [
      1,
      2,
      3,
      4,
      5,
      6,
    ]);
    for (final encounter in ramEncounters) {
      for (final choice in encounter.interpretations) {
        final outcome = encounter.outcomeFor(
          ChoiceKind.interpretation,
          choice.id,
        );
        expect(outcome.story, isNotEmpty);
        expect(outcome.hint, isNotEmpty);
      }
      for (final choice in encounter.responses) {
        final outcome = encounter.outcomeFor(ChoiceKind.response, choice.id);
        expect(outcome.story, isNotEmpty);
        expect(outcome.hint, isNotEmpty);
      }
      final session = GameSession(encounter);
      session.chooseInterpretation(encounter.correctInterpretationId);
      session.advance();
      expect(session.stage, SessionStage.response);
      session.chooseResponse(encounter.correctResponseId);
      session.advance();
      expect(session.stage, SessionStage.complete);
    }
  });
  test(
    'wrong interpretation gives a clue and retries without losing progress',
    () {
      final session = GameSession(ramEncounter);

      session.chooseInterpretation('play');
      expect(session.stage, SessionStage.outcome);
      expect(session.currentOutcome!.kind, OutcomeKind.retry);
      expect(session.currentOutcome!.hint, isNotEmpty);
      session.advance();

      expect(session.stage, SessionStage.interpretation);
      expect(session.wrongAttempts, 1);
      expect(session.attemptedInterpretationIds, contains('play'));
      expect(() => session.chooseInterpretation('play'), throwsStateError);
    },
  );

  test('unexpected response is funny, gives a clue, and can be retried', () {
    final session = GameSession(ramEncounter);
    session.chooseInterpretation('hungry');
    session.advance();
    session.chooseResponse('hat');

    expect(session.currentOutcome!.kind, OutcomeKind.surprise);
    expect(session.currentOutcome!.hint, isNotEmpty);
    session.advance();
    expect(session.stage, SessionStage.response);
    expect(session.attemptedResponseIds, contains('hat'));

    session.chooseResponse('apple');
    session.advance();
    expect(session.stage, SessionStage.complete);
    expect(session.wrongAttempts, 1);
  });

  test('unknown answer does not change the session', () {
    final session = GameSession(ramEncounter);
    expect(() => session.chooseInterpretation('unknown'), throwsArgumentError);
    expect(session.stage, SessionStage.interpretation);
  });

  test('five Vesper encounters have complete visual and answer content', () {
    expect(vesperEncounters.map((e) => e.id), [
      'vesper_01',
      'vesper_02',
      'vesper_03',
      'vesper_04',
      'vesper_05',
    ]);
    for (final encounter in vesperEncounters) {
      expect(encounter.signals.length, 3);
      expect(encounter.rhythmBars, isNotEmpty);
      expect(encounter.signalDescription, isNotEmpty);
      expect(encounter.interpretations.length, 3);
      expect(encounter.responses.length, 3);
      for (final choice in encounter.interpretations) {
        final outcome = encounter.outcomeFor(
          ChoiceKind.interpretation,
          choice.id,
        );
        expect(outcome.story, isNotEmpty);
        expect(outcome.hint, isNotEmpty);
      }
      for (final choice in encounter.responses) {
        final outcome = encounter.outcomeFor(ChoiceKind.response, choice.id);
        expect(outcome.story, isNotEmpty);
        expect(outcome.hint, isNotEmpty);
      }
      final session = GameSession(encounter);
      session.chooseInterpretation(encounter.correctInterpretationId);
      session.advance();
      expect(session.stage, SessionStage.response);
      session.chooseResponse(encounter.correctResponseId);
      session.advance();
      expect(session.stage, SessionStage.complete);
    }
  });
}
