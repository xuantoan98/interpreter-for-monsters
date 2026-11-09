enum ChoiceKind { interpretation, response }

enum OutcomeKind { correct, retry, surprise }

class GameChoice {
  const GameChoice({required this.id, required this.label, required this.icon});

  final String id;
  final String label;
  final String icon;
}

class GameOutcome {
  const GameOutcome({
    required this.kind,
    required this.title,
    required this.story,
    required this.hint,
  });

  final OutcomeKind kind;
  final String title;
  final String story;
  final String hint;
}

class Encounter {
  const Encounter({
    required this.id,
    required this.number,
    required this.speciesId,
    required this.title,
    required this.situation,
    required this.sceneAsset,
    required this.characterAsset,
    required this.successAsset,
    required this.failureAsset,
    required this.audioAsset,
    required this.signals,
    required this.signalDescription,
    this.rhythmBars = const [17, 12],
    required this.interpretations,
    required this.responses,
    required this.correctInterpretationId,
    required this.correctResponseId,
    required this.outcomes,
    required this.explanation,
    required this.vocabularyId,
    required this.vocabularyLabel,
    required this.meaningLabel,
    required this.dictionaryDescription,
  });

  final String id;
  final int number;
  final String speciesId;
  final String title;
  final String situation;
  final String sceneAsset;
  final String characterAsset;
  final String successAsset;
  final String failureAsset;
  final String audioAsset;
  final List<String> signals;
  final String signalDescription;
  final List<double> rhythmBars;
  final List<GameChoice> interpretations;
  final List<GameChoice> responses;
  final String correctInterpretationId;
  final String correctResponseId;
  final Map<String, GameOutcome> outcomes;
  final String explanation;
  final String vocabularyId;
  final String vocabularyLabel;
  final String meaningLabel;
  final String dictionaryDescription;

  String get speciesName => speciesId == 'vesper' ? 'Vesper' : 'Bram';

  GameOutcome outcomeFor(ChoiceKind kind, String choiceId) {
    final key = '${kind.name}:$choiceId';
    final outcome = outcomes[key];
    if (outcome == null) {
      throw StateError('Missing outcome for $key in $id');
    }
    return outcome;
  }
}

const ramEncounter = Encounter(
  id: 'ram_01',
  number: 1,
  speciesId: 'ram',
  title: 'Bữa xế của Bram',
  situation: 'Bram đứng cạnh chiếc giỏ rỗng và nhìn bạn chăm chú.',
  sceneAsset: 'assets/images/forest_clearing.png',
  characterAsset: 'assets/images/ram_curious.png',
  successAsset: 'assets/images/ram_delighted.png',
  failureAsset: 'assets/images/ram_confused.png',
  audioAsset: 'audio/ram_bup.wav',
  signals: ['Cổ sáng 3 nhịp', 'Mắt nhìn giỏ rỗng', 'Ụm · ụm · ụm'],
  signalDescription: 'Ba vạch thể hiện ba tiếng gọi từ cổ Bram.',
  rhythmBars: [12, 24, 17],
  interpretations: [
    GameChoice(id: 'hungry', label: 'Bram đang đói', icon: 'apple'),
    GameChoice(id: 'play', label: 'Bram muốn nhảy múa', icon: 'music'),
    GameChoice(id: 'scared', label: 'Bram đang sợ', icon: 'rain'),
  ],
  responses: [
    GameChoice(id: 'apple', label: 'Đưa một quả táo', icon: 'apple'),
    GameChoice(id: 'dance', label: 'Nhảy cùng Bram', icon: 'music'),
    GameChoice(id: 'hat', label: 'Đội nấm cho Bram', icon: 'hat'),
  ],
  correctInterpretationId: 'hungry',
  correctResponseId: 'apple',
  outcomes: {
    'interpretation:hungry': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Bạn đã hiểu Bram!',
      story: 'Cổ Bram sáng thêm một nhịp. Đuôi nó khẽ gõ vào chiếc giỏ.',
      hint: 'Bây giờ hãy chọn cách đáp lại.',
    ),
    'interpretation:play': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Một vũ công bất đắc dĩ',
      story: 'Bạn nhảy theo. Bram giậm một chân làm nấm bật lên, rồi bụng nó kêu ọc ọc!',
      hint: 'Nhìn chiếc giỏ rỗng và ba nhịp sáng ở cổ Bram nhé.',
    ),
    'interpretation:scared': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Chiếc ô hơi quá sớm',
      story: 'Bạn che ô cho Bram. Chiếc ô nằm gọn trên một chiếc sừng; Bram vẫn nhìn giỏ.',
      hint: 'Bram đang tìm thứ có thể ăn, không phải chỗ trú.',
    ),
    'response:apple': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Phiên dịch thành công!',
      story: 'Bram nhón quả táo bằng hai móng, nhai một miếng bé xíu rồi vui vẻ chia cho bạn.',
      hint: 'Một từ mới đã được ghi vào sổ tay.',
    ),
    'response:dance': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Điệu nhảy bụng đói',
      story: 'Bram giậm theo một nhịp. Mặt đất rung nhẹ, bụng nó vẫn kêu.',
      hint: 'Bạn đã hiểu Bram đói; hãy thử đưa thứ gì ăn được.',
    ),
    'response:hat': GameOutcome(
      kind: OutcomeKind.surprise,
      title: 'Vương miện nấm tí hon',
      story: 'Bạn đặt cây nấm lên sừng Bram. Nó đứng tạo dáng rất oai, nhưng bụng vẫn kêu.',
      hint: 'Vương miện hợp thật đấy! Bây giờ thử giải quyết cơn đói.',
    ),
  },
  explanation: 'Bram phát ba nhịp sáng ở cổ, kêu ba tiếng ụm và nhìn chiếc giỏ rỗng để xin đồ ăn. Phải đọc cả tín hiệu và vật chứng trong cảnh.',
  vocabularyId: 'ram_hungry',
  vocabularyLabel: 'Cổ sáng ba nhịp + giỏ rỗng',
  meaningLabel: 'Bram đang đói',
  dictionaryDescription:
      'Bram đói · Cổ sáng ba nhịp, mắt hướng về chiếc giỏ rỗng.',
);

const ramStream = Encounter(
  id: 'ram_02',
  number: 2,
  speciesId: 'ram',
  title: 'Chiếc cốc bên suối',
  situation: 'Bram đưa móng về dòng suối, bên cạnh là chiếc cốc rỗng.',
  sceneAsset: 'assets/images/forest_stream.png',
  characterAsset: 'assets/images/ram_thirsty.png',
  successAsset: 'assets/images/ram_delighted.png',
  failureAsset: 'assets/images/ram_confused.png',
  audioAsset: 'audio/ram_stream.wav',
  signals: ['Cổ sáng dịu đi', 'Móng với về cốc rỗng', 'Ụm... ụm...'],
  signalDescription: 'Hai vạch cách xa nhau thể hiện hai tiếng gọi chậm.',
  interpretations: [
    GameChoice(id: 'thirsty', label: 'Bram đang khát', icon: 'water'),
    GameChoice(id: 'hungry', label: 'Bram lại đói', icon: 'apple'),
    GameChoice(id: 'play', label: 'Bram muốn bơi', icon: 'music'),
  ],
  responses: [
    GameChoice(id: 'water', label: 'Múc nước vào cốc', icon: 'water'),
    GameChoice(id: 'apple', label: 'Đưa thêm một quả táo', icon: 'apple'),
    GameChoice(id: 'splash', label: 'Tạt nước cho vui', icon: 'rain'),
  ],
  correctInterpretationId: 'thirsty',
  correctResponseId: 'water',
  outcomes: {
    'interpretation:thirsty': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Đúng rồi, là nước!',
      story: 'Bram nhìn chiếc cốc, cổ sáng lên một vòng êm dịu.',
      hint: 'Bạn sẽ giúp Bram thế nào?',
    ),
    'interpretation:hungry': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Táo hơi khô cổ',
      story: 'Bram giả vờ nhai táo rồi thè lưỡi khô khốc.',
      hint: 'Bram đang chỉ về chiếc cốc rỗng cạnh dòng suối.',
    ),
    'interpretation:play': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Cú nhảy hụt',
      story: 'Bạn rủ Bram bơi. Nó nhấc một bàn chân to hơn cả con suối rồi lắc đầu.',
      hint: 'Bram muốn thứ ở trong suối, không muốn xuống suối.',
    ),
    'response:water': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Một ngụm mát lành',
      story: 'Bram uống một ngụm; túi sáng ở cổ lại rực lên và nó kêu hai tiếng ụm vui vẻ.',
      hint: 'Bạn vừa học thêm một tín hiệu.',
    ),
    'response:apple': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Tiệc táo lần hai?',
      story: 'Bram dùng quả táo làm nút đậy cốc. Cốc vẫn trống!',
      hint: 'Thử dùng chiếc cốc đúng công dụng của nó.',
    ),
    'response:splash': GameOutcome(
      kind: OutcomeKind.surprise,
      title: 'Tắm bất đắc dĩ',
      story: 'Bram hắt hơi làm con suối bắn thành một vòi phun tí hon, rồi chỉ lại vào cốc.',
      hint: 'Bram cần nước để uống, không phải để tắm.',
    ),
  },
  explanation: 'Cổ Bram sáng dịu và móng với về chiếc cốc rỗng: lần này Bram khát. Cử chỉ và vật chứng phân biệt với ba nhịp sáng báo đói.',
  vocabularyId: 'ram_thirsty',
  vocabularyLabel: 'Ánh cổ dịu + cốc rỗng',
  meaningLabel: 'Bram đang khát',
  dictionaryDescription:
      'Bram khát · Ánh cổ dịu đi, móng với về chiếc cốc rỗng.',
);

const ramFork = Encounter(
  id: 'ram_03',
  number: 3,
  speciesId: 'ram',
  title: 'Lối rẽ đom đóm',
  situation:
      'Bram vẫy móng ở ngã rẽ. Ba vòng sáng chạy dọc đuôi về phía lối mòn.',
  sceneAsset: 'assets/images/forest_fork.png',
  characterAsset: 'assets/images/ram_beckoning.png',
  successAsset: 'assets/images/ram_delighted.png',
  failureAsset: 'assets/images/ram_confused.png',
  audioAsset: 'audio/ram_fork.wav',
  signals: ['Móng vẫy gọi', 'Ba vòng đuôi sáng', 'Ụm-ụm!'],
  signalDescription: 'Hai vạch liền nhau thể hiện tiếng gọi gấp.',
  interpretations: [
    GameChoice(id: 'follow', label: 'Bram muốn bạn đi theo', icon: 'path'),
    GameChoice(id: 'hungry', label: 'Bram muốn ăn đom đóm', icon: 'apple'),
    GameChoice(id: 'goodbye', label: 'Bram đang chào tạm biệt', icon: 'wave'),
  ],
  responses: [
    GameChoice(id: 'follow', label: 'Đi theo lối có đom đóm', icon: 'path'),
    GameChoice(id: 'wait', label: 'Đứng lại chờ Bram', icon: 'hat'),
    GameChoice(id: 'catch', label: 'Bắt đom đóm bỏ vào túi', icon: 'star'),
  ],
  correctInterpretationId: 'follow',
  correctResponseId: 'follow',
  outcomes: {
    'interpretation:follow': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Bram đang dẫn đường',
      story: 'Bram vẫy móng thêm một lần; ánh sáng chạy dọc đuôi khi nó ngoái lại chờ bạn.',
      hint: 'Hãy chọn cách đáp lại lời mời.',
    ),
    'interpretation:hungry': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Bữa tối biết bay',
      story: 'Bạn chỉ vào đom đóm. Bram lắc đầu, móng vẫn hướng về con đường.',
      hint: 'Nhìn hướng móng và thứ tự sáng trên đuôi Bram.',
    ),
    'interpretation:goodbye': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Tạm biệt hơi sớm',
      story: 'Bạn vẫy chào. Bram đi một đoạn, đuôi sáng lại ba vòng rồi quay lại đợi.',
      hint: 'Bram không rời đi một mình; nó muốn bạn cùng bước.',
    ),
    'response:follow': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Bạn bắt kịp Bram!',
      story: 'Bạn đi theo Bram qua vòm cây; cái đuôi phát sáng như một chiếc đèn dẫn đường.',
      hint: 'Sổ tay ghi lại tín hiệu dẫn đường trên đuôi.',
    ),
    'response:wait': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Ai chờ ai đây?',
      story: 'Bram ngồi xuống chờ bạn. Hai người cùng nhìn nhau, còn đuôi nó vẫn chỉ về lối mòn.',
      hint: 'Bram đã chỉ rõ con đường muốn đi.',
    ),
    'response:catch': GameOutcome(
      kind: OutcomeKind.surprise,
      title: 'Túi đèn tí hon',
      story: 'Đom đóm làm chiếc túi sáng rực; Bram vẫn vẫy móng về lối mòn.',
      hint: 'Đom đóm đang dẫn đường, không cần bắt chúng.',
    ),
  },
  explanation: 'Bram vẫy móng, đuôi sáng lần lượt ba vòng rồi quay lại chờ: đó là lời mời đi theo. Đom đóm trong cảnh giúp xác nhận hướng đi.',
  vocabularyId: 'ram_follow',
  vocabularyLabel: 'Vẫy móng + ba vòng đuôi',
  meaningLabel: 'Đi theo Bram',
  dictionaryDescription:
      'Bram muốn bạn đi theo · Vẫy móng, đuôi sáng ba vòng rồi chờ.',
);

const ramHollow = Encounter(
  id: 'ram_04',
  number: 4,
  speciesId: 'ram',
  title: 'Tiếng động dưới lá',
  situation:
      'Bram cuộn đuôi ôm thân cạnh chiếc lá lớn, mắt nhìn về hốc cây xào xạc.',
  sceneAsset: 'assets/images/forest_hollow.png',
  characterAsset: 'assets/images/ram_cowering.png',
  successAsset: 'assets/images/ram_delighted.png',
  failureAsset: 'assets/images/ram_cowering.png',
  audioAsset: 'audio/ram_hollow.wav',
  signals: ['Cổ vẫn sáng vàng', 'Đuôi cuộn ôm thân', 'Ụm... ụm...'],
  signalDescription: 'Hai vạch nhỏ cách xa nhau thể hiện tiếng kêu dè dặt.',
  interpretations: [
    GameChoice(id: 'scared', label: 'Bram đang sợ', icon: 'shelter'),
    GameChoice(id: 'hungry', label: 'Bram đang đói', icon: 'apple'),
    GameChoice(id: 'sleepy', label: 'Bram muốn ngủ', icon: 'hat'),
  ],
  responses: [
    GameChoice(
      id: 'comfort',
      label: 'Ngồi cạnh và trấn an Bram',
      icon: 'heart',
    ),
    GameChoice(id: 'apple', label: 'Đưa Bram một quả táo', icon: 'apple'),
    GameChoice(id: 'shout', label: 'Hét thật to vào hốc cây', icon: 'music'),
  ],
  correctInterpretationId: 'scared',
  correctResponseId: 'comfort',
  outcomes: {
    'interpretation:scared': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Bạn thấy Bram đang lo',
      story: 'Bram khép vây sừng, nép gần bạn hơn và nhìn về phía hốc cây.',
      hint: 'Một lời đáp dịu dàng sẽ giúp Bram.',
    ),
    'interpretation:hungry': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Mũ bảo hiểm bằng táo',
      story: 'Bram đặt quả táo lên sừng như mũ bảo hiểm rồi vẫn cuộn đuôi thật chặt.',
      hint: 'Cổ từng sáng vàng khi Bram đói, nhưng lần này hãy nhìn cái đuôi.',
    ),
    'interpretation:sleepy': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Giường lá hơi rung',
      story: 'Bạn ru ngủ. Một tiếng xào xạc vang lên; vây sừng Bram dựng đứng.',
      hint: 'Bram nhìn chằm chằm vào hốc cây và cuộn đuôi để tự che mình.',
    ),
    'response:comfort': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Có bạn ở đây rồi',
      story: 'Bạn ngồi xuống. Đuôi Bram thả lỏng; một chú sóc nhỏ ló ra từ hốc cây.',
      hint: 'Một quy tắc về ngữ cảnh đã được ghi lại.',
    ),
    'response:apple': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Mũ táo phiên bản hai',
      story: 'Bram lại đặt táo lên sừng, nhưng đuôi vẫn cuộn chặt khi lá rung lên.',
      hint: 'Bram cần cảm giác an toàn hơn là đồ ăn.',
    ),
    'response:shout': GameOutcome(
      kind: OutcomeKind.surprise,
      title: 'Cả rừng cùng giật mình',
      story: 'Tiếng hét dội lại ba lần. Bram giật mình, chú sóc lăn tọt vào hốc cây.',
      hint: 'Hãy thử đến gần và trấn an Bram.',
    ),
  },
  explanation: 'Ánh cổ vàng không tự mang nghĩa “đói”. Khi Bram cuộn đuôi ôm thân, khép vây sừng và nhìn về hốc cây, tổ hợp ấy cho thấy Bram đang sợ.',
  vocabularyId: 'ram_scared',
  vocabularyLabel: 'Ánh cổ vàng + đuôi cuộn',
  meaningLabel: 'Bram đang sợ',
  dictionaryDescription:
      'Bram sợ · Cổ vẫn sáng vàng, nhưng đuôi cuộn để tự che thân.',
);

const ramBridge = Encounter(
  id: 'ram_05',
  number: 5,
  speciesId: 'ram',
  title: 'Cây cầu thiếu một tấm ván',
  situation:
      'Bram chặn bạn trước cây cầu gãy. Một móng xòe ra, đuôi cuộn sát thân.',
  sceneAsset: 'assets/images/forest_bridge.png',
  characterAsset: 'assets/images/ram_warning.png',
  successAsset: 'assets/images/ram_delighted.png',
  failureAsset: 'assets/images/ram_cowering.png',
  audioAsset: 'audio/ram_hollow.wav',
  signals: ['Móng xòe chặn lại', 'Đuôi cuộn sát thân', 'Ụm... ụm...'],
  signalDescription: 'Hai vạch cách xa nhau thể hiện hai tiếng gọi dè dặt.',
  interpretations: [
    GameChoice(id: 'stop', label: 'Bram bảo bạn dừng lại', icon: 'shelter'),
    GameChoice(id: 'follow', label: 'Bram rủ bạn chạy qua cầu', icon: 'path'),
    GameChoice(id: 'hungry', label: 'Bram muốn ăn trước khi đi', icon: 'apple'),
  ],
  responses: [
    GameChoice(
      id: 'check',
      label: 'Dừng lại và xem tấm ván gãy',
      icon: 'shelter',
    ),
    GameChoice(id: 'run', label: 'Nhắm mắt chạy qua cầu', icon: 'path'),
    GameChoice(id: 'apple', label: 'Đưa táo để Bram bình tĩnh', icon: 'apple'),
  ],
  correctInterpretationId: 'stop',
  correctResponseId: 'check',
  outcomes: {
    'interpretation:stop': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Đúng, khoan đi đã!',
      story: 'Bram gật đầu, giữ móng trước bạn và nhìn xuống khoảng trống trên cầu.',
      hint: 'Hãy đáp lại lời cảnh báo của Bram.',
    ),
    'interpretation:follow': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Một bước nhảy hơi vội',
      story: 'Bạn lấy đà. Bram vội dùng đuôi làm rào chắn mềm, rồi chỉ vào tấm ván đã rơi.',
      hint: 'Móng Bram xòe ra để chặn, không vẫy gọi như ở lối rẽ.',
    ),
    'interpretation:hungry': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Bữa xế giữa đường?',
      story: 'Bạn lục túi tìm táo. Bram kéo chiếc túi khỏi mép cầu và nhìn xuống dòng nước.',
      hint: 'Đuôi cuộn báo lo lắng; lần này không có giỏ rỗng.',
    ),
    'response:check': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Cứu được đôi giày khô!',
      story: 'Bạn dừng lại. Tấm ván lỏng rơi xuống suối, còn Bram tìm thấy lối vòng an toàn.',
      hint: 'Bạn đã biết cách nhận ra lời cảnh báo.',
    ),
    'response:run': GameOutcome(
      kind: OutcomeKind.surprise,
      title: 'Cú nhảy và chiếc lá',
      story:
          'Bram túm áo bạn kịp lúc; chỉ một chiếc lá gan dạ rơi qua khe cầu.',
      hint: 'Hãy nhìn chỗ móng Bram đang chặn và kiểm tra cây cầu.',
    ),
    'response:apple': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Táo biết bơi',
      story: 'Quả táo lăn qua khe ván. Bram nhìn theo nó rồi kéo bạn lùi khỏi mép cầu.',
      hint: 'Bram đang cảnh báo nguy hiểm ở cây cầu, không cần đồ ăn.',
    ),
  },
  explanation: 'Móng xòe ra trước mặt là “dừng lại”; đuôi cuộn và tiếng gọi chậm cho biết Bram lo lắng. Cùng là đuôi cuộn như ở hốc cây, nhưng lần này Bram cảnh báo nguy hiểm cho bạn.',
  vocabularyId: 'ram_stop',
  vocabularyLabel: 'Móng xòe chặn + đuôi cuộn',
  meaningLabel: 'Dừng lại, phía trước nguy hiểm',
  dictionaryDescription:
      'Bram cảnh báo · Móng xòe chặn đường, đuôi cuộn, tiếng gọi chậm.',
);

const ramNest = Encounter(
  id: 'ram_06',
  number: 6,
  speciesId: 'ram',
  title: 'Chiếc tổ dưới trăng',
  situation: 'Qua lối vòng, Bram chỉ lên chiếc tổ trống. Ba vòng đuôi sáng về phía cây.',
  sceneAsset: 'assets/images/forest_moonlit_nest.png',
  characterAsset: 'assets/images/ram_pointing.png',
  successAsset: 'assets/images/ram_delighted.png',
  failureAsset: 'assets/images/ram_confused.png',
  audioAsset: 'audio/ram_fork.wav',
  signals: ['Móng chỉ lên tổ trống', 'Đuôi sáng 3 vòng về phía cây', 'Ụm-ụm!'],
  signalDescription: 'Hai vạch sát nhau thể hiện tiếng gọi gấp của Bram.',
  interpretations: [
    GameChoice(
      id: 'search',
      label: 'Bram muốn cùng tìm bạn ở tổ',
      icon: 'path',
    ),
    GameChoice(id: 'sleep', label: 'Bram muốn ngủ trong tổ', icon: 'hat'),
    GameChoice(id: 'hungry', label: 'Bram muốn ăn trứng', icon: 'apple'),
  ],
  responses: [
    GameChoice(
      id: 'look',
      label: 'Cùng Bram tìm dấu vết quanh cây',
      icon: 'path',
    ),
    GameChoice(id: 'nap', label: 'Trải chăn ngủ dưới gốc cây', icon: 'hat'),
    GameChoice(
      id: 'climb',
      label: 'Leo vào tổ và kêu ụm thật to',
      icon: 'music',
    ),
  ],
  correctInterpretationId: 'search',
  correctResponseId: 'look',
  outcomes: {
    'interpretation:search': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Bạn hiểu lời rủ của Bram',
      story: 'Bram gật đầu. Ánh sáng chạy dọc đuôi, dừng lại ngay dưới chiếc tổ trống.',
      hint: 'Hãy chọn cách cùng Bram tìm người bạn ấy.',
    ),
    'interpretation:sleep': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Giường hơi cao',
      story: 'Bạn chỉ vào tổ để ngủ. Bram thử ngước nhìn rồi lắc đầu: cái tổ nhỏ hơn một bàn chân nó.',
      hint: 'Bram đang chỉ vào chiếc tổ trống, giống lời mời đi theo ở lối rẽ.',
    ),
    'interpretation:hungry': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Thực đơn không có trứng',
      story: 'Bram che cái tổ bằng móng, vẻ mặt sốt ruột vì bạn hiểu lầm.',
      hint: 'Bram chỉ lên tổ trống và đuôi sáng dẫn hướng; không có tín hiệu xin ăn.',
    ),
    'response:look': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Một giọng nói mới',
      story: 'Bạn tìm thấy chiếc lông óng ánh dưới gốc cây. Từ xa vọng lại tiếng “hú-hú” và hai chấm sáng trong đêm.',
      hint: 'Chặng Bram khép lại; một ngôn ngữ mới đang chờ được khám phá.',
    ),
    'response:nap': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Chiếc chăn biến thành mũ',
      story: 'Bram đội chăn lên sừng cho vui, rồi lại chỉ về dấu lông dưới gốc cây.',
      hint: 'Người bạn ở tổ chưa về; thử tìm dấu vết quanh cây.',
    ),
    'response:climb': GameOutcome(
      kind: OutcomeKind.surprise,
      title: 'Tiếng ụm vang khắp rừng',
      story: 'Một đàn đom đóm tưởng bạn hát song ca, bay quanh tổ; Bram vội ra hiệu nhìn dưới gốc cây.',
      hint: 'Không cần leo lên tổ; hãy tìm từ mặt đất cùng Bram.',
    ),
  },
  explanation: 'Móng Bram chỉ lên chiếc tổ trống, đuôi sáng ba vòng về phía cây và tiếng gọi gấp: đó là lời rủ cùng đi tìm một người bạn. Bạn đã biết ghép hướng đuôi, cử chỉ và bối cảnh để hiểu Bram.',
  vocabularyId: 'ram_search',
  vocabularyLabel: 'Chỉ tổ trống + đuôi dẫn hướng',
  meaningLabel: 'Cùng tìm người bạn vắng mặt',
  dictionaryDescription:
      'Bram rủ tìm bạn · Móng chỉ tổ trống, đuôi sáng dẫn tới gốc cây.',
);

const ramEncounters = [
  ramEncounter,
  ramStream,
  ramFork,
  ramHollow,
  ramBridge,
  ramNest,
];
