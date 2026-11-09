import 'game_content.dart';

const vesperHello = Encounter(
  id: 'vesper_01',
  number: 1,
  speciesId: 'vesper',
  title: 'Ai dưới tán trăng?',
  situation:
      'Từ chiếc tổ trống, Vesper hé mắt thứ ba và nghiêng đầu về phía bạn.',
  sceneAsset: 'assets/images/forest_moonlit_nest.png',
  characterAsset: 'assets/images/vesper_curious.png',
  successAsset: 'assets/images/vesper_delighted.png',
  failureAsset: 'assets/images/vesper_confused.png',
  audioAsset: 'audio/vesper_hello.wav',
  signals: [
    'Mắt thứ ba chớp nhẹ',
    'Đầu nghiêng về phía bạn',
    'Hú cao · hú cao',
  ],
  signalDescription: 'Hai vạch cao dần: hai tiếng gọi đi lên như một câu hỏi.',
  rhythmBars: [11, 21],
  interpretations: [
    GameChoice(id: 'who', label: 'Vesper hỏi ai đang ở đó', icon: 'wave'),
    GameChoice(id: 'hungry', label: 'Vesper xin đồ ăn', icon: 'apple'),
    GameChoice(id: 'danger', label: 'Vesper báo nguy hiểm', icon: 'shelter'),
  ],
  responses: [
    GameChoice(id: 'greet', label: 'Bước ra và vẫy chào Vesper', icon: 'wave'),
    GameChoice(id: 'feed', label: 'Đặt táo dưới gốc cây', icon: 'apple'),
    GameChoice(id: 'hide', label: 'Núp sau lưng Bram', icon: 'hat'),
  ],
  correctInterpretationId: 'who',
  correctResponseId: 'greet',
  outcomes: {
    'interpretation:who': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Vesper đang hỏi bạn!',
      story: 'Vesper nghiêng đầu thêm chút nữa; hai vòng sáng ở cổ đi lên như dấu hỏi.',
      hint: 'Hãy cho Vesper biết bạn đang ở đây.',
    ),
    'interpretation:hungry': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Táo cho... cái tổ?',
      story: 'Vesper nhìn quả táo, rồi nhìn bạn. Bram lặng lẽ nhặt táo cho vào túi.',
      hint: 'Vesper đang nhìn thẳng vào bạn và gọi hai tiếng cao dần.',
    ),
    'interpretation:danger': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Báo động nhầm giờ',
      story: 'Bạn giơ khiên. Vesper chớp mắt thứ ba rồi vẫn nghiêng đầu chờ câu trả lời.',
      hint: 'Cánh Vesper đang thả lỏng; giọng đi lên giống một câu hỏi.',
    ),
    'response:greet': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Lời chào đầu tiên',
      story:
          'Bạn bước ra. Vesper cười, vỗ cánh một cái và gọi lại hai tiếng êm.',
      hint: 'Sổ tay mở một quy tắc ngôn ngữ mới.',
    ),
    'response:feed': GameOutcome(
      kind: OutcomeKind.surprise,
      title: 'Chiếc táo được chào',
      story: 'Vesper cúi chào quả táo rất lịch sự, rồi quay sang tìm người vừa đặt nó.',
      hint: 'Hãy cho Vesper thấy bạn là ai.',
    ),
    'response:hide': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Hai cái đuôi ló ra',
      story: 'Bạn trốn sau Bram, nhưng đuôi Bram và chân bạn đều lộ ra. Vesper vẫn chờ.',
      hint: 'Một cái vẫy tay sẽ trả lời câu hỏi của Vesper.',
    ),
  },
  explanation: 'Hai tiếng hú đi lên, mắt thứ ba chớp và đầu nghiêng về phía người nghe là câu hỏi “ai ở đó?”. Vòng sáng ở cổ vẽ lại chiều cao của tiếng gọi.',
  vocabularyId: 'vesper_hello',
  vocabularyLabel: 'Hai nhịp đi lên + nghiêng đầu',
  meaningLabel: 'Ai đang ở đó?',
  dictionaryDescription: 'Vesper hỏi người lạ · Hai tiếng hú cao dần, đầu nghiêng và mắt thứ ba chớp.',
);

const vesperPond = Encounter(
  id: 'vesper_02',
  number: 2,
  speciesId: 'vesper',
  title: 'Lối đá trên hồ trăng',
  situation:
      'Vesper chỉ về các phiến đá qua hồ; giọng thấp kéo dài rồi vút cao ngắn.',
  sceneAsset: 'assets/images/moon_pond.png',
  characterAsset: 'assets/images/vesper_guiding.png',
  successAsset: 'assets/images/vesper_delighted.png',
  failureAsset: 'assets/images/vesper_confused.png',
  audioAsset: 'audio/vesper_guide.wav',
  signals: [
    'Cánh chỉ lối qua hồ',
    'Đuôi sao hướng tới bờ xa',
    'Hú dài · hí cao',
  ],
  signalDescription:
      'Một tiếng trầm kéo dài, rồi một tiếng cao ngắn; hai vạch nhịp lên bậc.',
  rhythmBars: [13, 25],
  interpretations: [
    GameChoice(id: 'follow', label: 'Vesper mời bạn qua hồ', icon: 'path'),
    GameChoice(id: 'drink', label: 'Vesper muốn uống nước', icon: 'water'),
    GameChoice(id: 'sleep', label: 'Vesper muốn nghỉ ở đây', icon: 'hat'),
  ],
  responses: [
    GameChoice(id: 'stones', label: 'Đi theo các phiến đá', icon: 'path'),
    GameChoice(id: 'cup', label: 'Múc nước đưa Vesper', icon: 'water'),
    GameChoice(id: 'jump', label: 'Nhảy thẳng xuống hồ', icon: 'rain'),
  ],
  correctInterpretationId: 'follow',
  correctResponseId: 'stones',
  outcomes: {
    'interpretation:follow': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Bạn nghe được lời mời',
      story: 'Vesper gật đầu, đuôi sao lướt dọc những phiến đá sáng trăng.',
      hint: 'Hãy chọn đường đi cùng Vesper.',
    ),
    'interpretation:drink': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Cốc nước đi lạc',
      story: 'Bạn đưa cốc. Vesper dùng cánh xoay cốc thành mũ rồi chỉ lại về bờ bên kia.',
      hint: 'Cánh và đuôi sao cùng hướng qua hồ, không hướng xuống nước.',
    ),
    'interpretation:sleep': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Gối đá mát lạnh',
      story: 'Bạn nằm lên tảng đá. Vesper gọi cao một tiếng và đứng chờ ở phiến kế tiếp.',
      hint: 'Nhịp thấp dài rồi cao ngắn cùng cánh chỉ đường là lời mời di chuyển.',
    ),
    'response:stones': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Băng qua mặt trăng',
      story: 'Bạn bước theo đá. Vesper bay thấp bên cạnh; bóng hai người lấp lánh trên nước.',
      hint: 'Bạn đã biết nhịp gọi dẫn đường của Vesper.',
    ),
    'response:cup': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Mũ cốc phiên bản mới',
      story: 'Vesper đội cốc lên một sừng trăng, trông rất oai, rồi vẫn chỉ qua hồ.',
      hint: 'Hãy nhìn những phiến đá Vesper vừa chỉ.',
    ),
    'response:jump': GameOutcome(
      kind: OutcomeKind.surprise,
      title: 'Một cú tắm trăng',
      story: 'Bạn nhảy xuống hồ cạn và ướt cả hai ống quần. Vesper chìa cánh kéo bạn lên đá.',
      hint: 'Lối qua hồ là các phiến đá đang sáng.',
    ),
  },
  explanation: 'Vesper kéo một tiếng thấp rồi chốt bằng tiếng cao ngắn khi muốn dẫn đường. Cánh và đuôi sao xác nhận hướng; nhịp này khác hai tiếng đi lên dùng để hỏi.',
  vocabularyId: 'vesper_follow',
  vocabularyLabel: 'Thấp dài → cao ngắn + chỉ đường',
  meaningLabel: 'Đi theo Vesper',
  dictionaryDescription: 'Vesper dẫn đường · Một tiếng thấp dài, một tiếng cao ngắn, cánh và đuôi cùng chỉ lối.',
);

const vesperGrove = Encounter(
  id: 'vesper_03',
  number: 3,
  speciesId: 'vesper',
  title: 'Khu vườn đang ngủ',
  situation:
      'Những mầm sáng ngủ dưới gốc cây. Vesper khép cánh, hạ mắt thứ ba.',
  sceneAsset: 'assets/images/sleeping_grove.png',
  characterAsset: 'assets/images/vesper_quiet.png',
  successAsset: 'assets/images/vesper_delighted.png',
  failureAsset: 'assets/images/vesper_confused.png',
  audioAsset: 'audio/vesper_hush.wav',
  signals: [
    'Cánh khép trước ngực',
    'Mắt thứ ba dịu xuống',
    'Hú thấp ... hú thấp',
  ],
  signalDescription:
      'Hai tiếng thấp dần, cách xa nhau; vạch nhịp cũng hạ xuống.',
  rhythmBars: [23, 12],
  interpretations: [
    GameChoice(
      id: 'quiet',
      label: 'Vesper muốn mọi người im lặng',
      icon: 'heart',
    ),
    GameChoice(id: 'sad', label: 'Vesper đang buồn', icon: 'rain'),
    GameChoice(id: 'lost', label: 'Vesper hỏi ai đang ở đó', icon: 'wave'),
  ],
  responses: [
    GameChoice(id: 'dim', label: 'Hạ đèn và bước thật khẽ', icon: 'heart'),
    GameChoice(id: 'sing', label: 'Hát ru thật lớn', icon: 'music'),
    GameChoice(id: 'wave', label: 'Vẫy tay gọi các mầm dậy', icon: 'wave'),
  ],
  correctInterpretationId: 'quiet',
  correctResponseId: 'dim',
  outcomes: {
    'interpretation:quiet': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Bạn nghe thấy sự yên tĩnh',
      story: 'Vesper khép cánh sát hơn; các mầm sáng vẫn ngủ ngon.',
      hint: 'Hãy giữ khu vườn thật êm.',
    ),
    'interpretation:sad': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Chiếc khăn an ủi',
      story: 'Bạn đưa khăn. Vesper dùng khăn che đèn cho dịu, rồi chỉ về các mầm đang ngủ.',
      hint: 'Vesper khép cánh để giữ yên, không cúi đầu vì buồn.',
    ),
    'interpretation:lost': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Chào buổi... nửa đêm',
      story:
          'Bạn vẫy tay. Vesper khẽ khép cánh bạn lại như gấp một chiếc quạt.',
      hint: 'Lần này tiếng gọi đi xuống và cách xa nhau; nhớ hai tiếng đi lên ở cuộc gặp đầu.',
    ),
    'response:dim': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Giấc ngủ của mầm sáng',
      story: 'Bạn hạ đèn, bước khẽ. Ba mầm sáng rúc sâu hơn vào lá; Vesper mỉm cười.',
      hint: 'Sổ tay đã ghi quy tắc giữ yên lặng.',
    ),
    'response:sing': GameOutcome(
      kind: OutcomeKind.surprise,
      title: 'Dàn đồng ca mầm non',
      story: 'Ba mầm bật dậy hát theo, còn Vesper cuống quýt kéo nốt nhạc xuống thấp.',
      hint: 'Ru bằng cách hạ đèn và bước nhẹ sẽ hợp hơn.',
    ),
    'response:wave': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Ba chiếc mũ lá',
      story: 'Các mầm đội lá che mắt. Vesper vẫn khép cánh và gọi hai tiếng nhỏ dần.',
      hint: 'Đừng đánh thức các mầm đang ngủ.',
    ),
  },
  explanation: 'Hai tiếng đi xuống và cách xa nhau, cánh khép, mắt thứ ba dịu là lời nhắc giữ yên lặng. Cùng là hai tiếng hú, chiều cao và khoảng nghỉ đã đổi nghĩa.',
  vocabularyId: 'vesper_quiet',
  vocabularyLabel: 'Hai nhịp đi xuống + cánh khép',
  meaningLabel: 'Giữ yên lặng',
  dictionaryDescription:
      'Vesper nhắc giữ yên · Hai tiếng thấp dần, cánh khép, mắt thứ ba dịu.',
);

const vesperStorm = Encounter(
  id: 'vesper_04',
  number: 4,
  speciesId: 'vesper',
  title: 'Bóng cây trên vách gió',
  situation:
      'Gió mạnh làm cành cây rung trên lối đi. Vesper dang cánh trước mặt bạn.',
  sceneAsset: 'assets/images/storm_ledge.png',
  characterAsset: 'assets/images/vesper_warning.png',
  successAsset: 'assets/images/vesper_delighted.png',
  failureAsset: 'assets/images/vesper_confused.png',
  audioAsset: 'audio/vesper_alarm.wav',
  signals: ['Cánh dang che lối', 'Mắt thứ ba sáng gắt', 'Hí! hí! hí!'],
  signalDescription: 'Ba tiếng cao, ngắn và sát nhau; ba vạch nhịp dồn dập.',
  rhythmBars: [22, 22, 25],
  interpretations: [
    GameChoice(
      id: 'danger',
      label: 'Vesper cảnh báo cành cây sắp rơi',
      icon: 'shelter',
    ),
    GameChoice(id: 'dance', label: 'Vesper muốn múa cùng gió', icon: 'music'),
    GameChoice(
      id: 'follow',
      label: 'Vesper giục chạy về phía trước',
      icon: 'path',
    ),
  ],
  responses: [
    GameChoice(id: 'back', label: 'Lùi khỏi bóng cành cây', icon: 'shelter'),
    GameChoice(id: 'spin', label: 'Xoay vòng theo gió', icon: 'music'),
    GameChoice(id: 'sprint', label: 'Chạy dưới cành cây', icon: 'path'),
  ],
  correctInterpretationId: 'danger',
  correctResponseId: 'back',
  outcomes: {
    'interpretation:danger': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Bạn nhận ra tiếng báo động',
      story: 'Vesper dang cánh che bạn và nhìn lên chiếc cành đang rung mạnh.',
      hint: 'Hãy đưa cả hai ra khỏi vùng nguy hiểm.',
    ),
    'interpretation:dance': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Vũ điệu gió cuốn',
      story:
          'Bạn xoay một vòng; Vesper vội chặn chiếc lá đang bay vào mắt bạn.',
      hint: 'Ba tiếng cao sát nhau và cánh dang che lối là tín hiệu khẩn cấp.',
    ),
    'interpretation:follow': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Chạy sai hướng',
      story:
          'Bạn lao tới. Vesper dùng đuôi sao móc nhẹ áo bạn kéo về phía sau.',
      hint: 'Cánh Vesper đang chắn đường, không chỉ đường như ở hồ trăng.',
    ),
    'response:back': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Tránh được cú rơi',
      story: 'Bạn lùi lại đúng lúc cành cây rơi xuống lối mòn. Chiếc đèn vẫn sáng an toàn.',
      hint: 'Bạn đã học nhịp báo nguy của Vesper.',
    ),
    'response:spin': GameOutcome(
      kind: OutcomeKind.surprise,
      title: 'Cơn lốc tóc rối',
      story: 'Gió xoay bạn thành một quả bông. Vesper dang cánh chắn cành cây cho bạn.',
      hint: 'Lùi về khoảng trống sau lưng Vesper.',
    ),
    'response:sprint': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Lối tắt quá mạo hiểm',
      story: 'Vesper kéo bạn lùi lại trước khi cành rơi. Cả hai nhìn nhau thở phào.',
      hint: 'Đừng chạy dưới bóng cành cây đang rung.',
    ),
  },
  explanation: 'Ba tiếng cao dồn dập, mắt thứ ba sáng và cánh dang che người nghe là cảnh báo. Nhịp gấp và cử chỉ chặn phân biệt với lời mời đi theo ở hồ.',
  vocabularyId: 'vesper_danger',
  vocabularyLabel: 'Ba nhịp cao gấp + cánh dang',
  meaningLabel: 'Có nguy hiểm, lùi lại',
  dictionaryDescription:
      'Vesper báo nguy · Ba tiếng cao sát nhau, mắt thứ ba sáng, cánh che lối.',
);

const vesperFeather = Encounter(
  id: 'vesper_05',
  number: 5,
  speciesId: 'vesper',
  title: 'Chiếc lông trở về tổ',
  situation: 'Trời sắp sáng. Vesper cầm chiếc lông rơi, chỉ về tổ và gọi hai cặp nhịp.',
  sceneAsset: 'assets/images/dawn_nest.png',
  characterAsset: 'assets/images/vesper_feather.png',
  successAsset: 'assets/images/vesper_delighted.png',
  failureAsset: 'assets/images/vesper_confused.png',
  audioAsset: 'audio/vesper_feather.wav',
  signals: [
    'Cầm lông, chỉ về tổ',
    'Cánh khép sau khi gọi',
    'Hú cao hú cao · hú thấp hú thấp',
  ],
  signalDescription: 'Hai tiếng đi lên rồi hai tiếng đi xuống; bốn vạch nhịp chia thành hai cặp.',
  rhythmBars: [10, 20, 23, 12],
  interpretations: [
    GameChoice(
      id: 'return',
      label: 'Vesper nhờ trả lông về tổ thật khẽ',
      icon: 'heart',
    ),
    GameChoice(id: 'keep', label: 'Vesper tặng bạn chiếc lông', icon: 'star'),
    GameChoice(id: 'alarm', label: 'Vesper lại báo nguy hiểm', icon: 'shelter'),
  ],
  responses: [
    GameChoice(
      id: 'place',
      label: 'Đặt lông vào tổ rồi lùi nhẹ',
      icon: 'heart',
    ),
    GameChoice(id: 'hat', label: 'Cài lông lên mũ của mình', icon: 'hat'),
    GameChoice(
      id: 'shout',
      label: 'Gọi thật to cho cả rừng biết',
      icon: 'music',
    ),
  ],
  correctInterpretationId: 'return',
  correctResponseId: 'place',
  outcomes: {
    'interpretation:return': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Bạn ghép được hai lời gọi',
      story: 'Vesper gật đầu, đưa chiếc lông cho bạn rồi khép cánh về phía tổ.',
      hint: 'Hãy giúp Vesper mà không đánh thức khu vườn.',
    ),
    'interpretation:keep': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Món quà gắn nhầm mũ',
      story: 'Bạn cầm chiếc lông ngắm nghía. Vesper nhìn mũ bạn rồi chỉ lại chiếc tổ.',
      hint: 'Vesper chỉ về tổ sau hai nhịp hỏi, rồi khép cánh với hai nhịp đi xuống.',
    ),
    'interpretation:alarm': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Báo động lúc bình minh',
      story: 'Bạn tìm cây gãy. Vesper lắc đầu; mắt thứ ba chỉ sáng dịu khi nhìn chiếc tổ.',
      hint: 'Tiếng báo nguy gồm ba nhịp cao gấp, không phải hai cặp lên rồi xuống.',
    ),
    'response:place': GameOutcome(
      kind: OutcomeKind.correct,
      title: 'Bí mật của chiếc tổ',
      story: 'Bạn đặt lông vào tổ. Những mầm sáng ngủ yên; Vesper và Bram cùng vẫy chào khi mặt trời lên.',
      hint: 'Bạn đã hiểu ngôn ngữ của hai người bạn đầu tiên.',
    ),
    'response:hat': GameOutcome(
      kind: OutcomeKind.surprise,
      title: 'Mũ lông hoàng gia',
      story: 'Bram cúi chào chiếc mũ mới. Vesper cười rồi đưa cánh chỉ chiếc tổ vẫn trống.',
      hint: 'Chiếc lông cần trở về tổ, không ở trên mũ.',
    ),
    'response:shout': GameOutcome(
      kind: OutcomeKind.retry,
      title: 'Cả rừng thức giấc',
      story: 'Ba mầm sáng bật dậy. Vesper khép cánh, nhắc bạn bước nhẹ và đặt lông vào tổ.',
      hint: 'Hai tiếng đi xuống nhắc giữ yên lặng.',
    ),
  },
  explanation: 'Hai tiếng đi lên gọi bạn chú ý; hai tiếng đi xuống và cánh khép nhắc làm thật khẽ. Vesper chỉ chiếc tổ để bạn ghép hai quy tắc đã học thành lời nhờ trả chiếc lông.',
  vocabularyId: 'vesper_return',
  vocabularyLabel: 'Hai nhịp lên + hai nhịp xuống',
  meaningLabel: 'Đưa lông về tổ thật khẽ',
  dictionaryDescription:
      'Vesper nhờ giúp · Gọi bạn chú ý, khép cánh nhắc giữ yên rồi chỉ về tổ.',
);

const vesperEncounters = [
  vesperHello,
  vesperPond,
  vesperGrove,
  vesperStorm,
  vesperFeather,
];
