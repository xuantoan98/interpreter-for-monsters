import 'game_content.dart';

enum SessionStage { interpretation, response, outcome, complete }

class GameSession {
  GameSession(this.encounter);

  final Encounter encounter;
  SessionStage stage = SessionStage.interpretation;
  ChoiceKind? lastChoiceKind;
  GameOutcome? currentOutcome;
  int wrongAttempts = 0;
  final Set<String> attemptedInterpretationIds = {};
  final Set<String> attemptedResponseIds = {};

  void chooseInterpretation(String id) {
    if (stage != SessionStage.interpretation) {
      throw StateError('Interpretation is unavailable at $stage');
    }
    if (!encounter.interpretations.any((choice) => choice.id == id)) {
      throw ArgumentError.value(id, 'id', 'Unknown interpretation');
    }
    if (attemptedInterpretationIds.contains(id)) {
      throw StateError('Interpretation was already attempted');
    }
    _choose(ChoiceKind.interpretation, id);
  }

  void chooseResponse(String id) {
    if (stage != SessionStage.response) {
      throw StateError('Response is unavailable at $stage');
    }
    if (!encounter.responses.any((choice) => choice.id == id)) {
      throw ArgumentError.value(id, 'id', 'Unknown response');
    }
    if (attemptedResponseIds.contains(id)) {
      throw StateError('Response was already attempted');
    }
    _choose(ChoiceKind.response, id);
  }

  void _choose(ChoiceKind kind, String id) {
    lastChoiceKind = kind;
    currentOutcome = encounter.outcomeFor(kind, id);
    if (currentOutcome!.kind != OutcomeKind.correct) {
      wrongAttempts++;
      if (kind == ChoiceKind.interpretation) {
        attemptedInterpretationIds.add(id);
      } else {
        attemptedResponseIds.add(id);
      }
    }
    stage = SessionStage.outcome;
  }

  void advance() {
    if (stage != SessionStage.outcome || currentOutcome == null) {
      throw StateError('There is no outcome to advance from');
    }
    if (currentOutcome!.kind == OutcomeKind.correct) {
      stage = lastChoiceKind == ChoiceKind.interpretation
          ? SessionStage.response
          : SessionStage.complete;
    } else {
      stage = lastChoiceKind == ChoiceKind.interpretation
          ? SessionStage.interpretation
          : SessionStage.response;
    }
    currentOutcome = null;
  }
}
