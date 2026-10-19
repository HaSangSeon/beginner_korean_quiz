import '../models/quiz_question.dart';

class LanguageOption {
  final String code;
  final String label;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.label,
    required this.flag,
  });
}

const List<LanguageOption> supportedLanguages = [
  LanguageOption(code: 'KO', label: '한국어 (기본)', flag: '🇰🇷'),
  LanguageOption(code: 'EN', label: 'English', flag: '🇺🇸'),
  LanguageOption(code: 'ZH', label: '中文', flag: '🇨🇳'),
  LanguageOption(code: 'JA', label: '日本語', flag: '🇯🇵'),
  LanguageOption(code: 'VI', label: 'Tiếng Việt', flag: '🇻🇳'),
];

/// Sample high-quality Korean nuance questions translated across 6 major languages.
final List<QuizQuestion> sampleQuizQuestions = [
  const QuizQuestion(
    id: 1,
    category: 'Honorifics',
    situations: {
      'KO':
          '낮 12시 30분경, 사무실이나 캠퍼스에서 교수님, 직장 상사, 선배를 마주쳤습니다. 예의를 갖추면서도 자연스럽게 식사 여부를 묻는 상황입니다.',
      'EN':
          'You meet your boss or an older colleague at the office around 12:30 PM. In your language, you might casually ask: "Did you eat?" or "Had lunch?"',
      'ES':
          'Te encuentras con tu jefe o un compañero mayor en la oficina alrededor de las 12:30 PM. De manera informal preguntarías: "¿Comiste?" o "¿Almorzaste?"',
      'ZH':
          '中午12:30左右，你在办公室遇到了上司或年长同事。日常打招呼时想问对方"吃过饭了吗？"',
      'JA':
          'お昼の12時30分頃、職場で上司や先輩に出会いました。気軽に「ご飯食べましたか？」と挨拶したい場面です。',
      'VI':
          'Bạn gặp sếp hoặc đồng nghiệp lớn tuổi tại văn phòng vào khoảng 12:30 trưa. Bạn muốn chào hỏi lịch sự: "Anh/chị đã ăn trưa chưa?"',
      'PT':
          'Você encontra seu chefe ou um colega mais velho no trabalho por volta das 12h30. Você quer perguntar de forma respeitosa: "Já almoçou?"',
    },
    questions: {
      'KO':
          '한국인이 윗사람이나 선배에게 가장 자연스럽고 공손하게 건네는 점심 안부 인사는?',
      'EN':
          'Which respectful greeting would a native Korean naturally use without sounding overly casual or stiff?',
      'ES':
          '¿Qué saludo respetuoso usaría un coreano nativo sin sonar demasiado informal ni rígido?',
      'ZH':
          '韩国人对上司或长辈最自然、得体的敬语问候是哪一个？',
      'JA':
          '上司や先輩に対して、失礼にならず自然に敬意を表す挨拶はどれでしょうか？',
      'VI':
          'Lời chào hỏi kính ngữ tự nhiên và đúng mực nhất của người Hàn là gì?',
      'PT':
          'Qual saudação respeitosa um coreano nativo usaria sem parecer informal demais nem engessado?',
    },
    options: [
      '식사하셨어요? (Siksahasyeosseoyo?)',
      '밥 먹었어요? (Bap meogeosseoyo?)',
      '점심 드세요? (Jeomsim deuseyo?)',
      '식사했니? (Siksahaenni?)',
    ],
    answerIndex: 0,
    explanations: {
      'KO':
          "'식사하셨어요?'는 높임 명사 '식사'와 존칭 접미사 '-시-'가 결합된 가장 자연스러운 표준 높임말 인사입니다. '밥 먹었어요?'는 끝에 '-요'가 붙었어도 상사나 교수님께 쓰기에는 다소 버릇없게 느껴질 수 있습니다.",
      'EN':
          "'식사하셨어요?' combines the honorific noun '식사' (meal) with the polite suffix '-시-'. While '밥 먹었어요?' has the polite '-요' ending, it is considered too casual for superiors in Korean workplace culture.",
      'ES':
          "'식사하셨어요?' combina el sustantivo honorífico '식사' (comida) con el sufijo de respeto '-시-'. Aunque '밥 먹었어요?' termina en '-요', resulta demasiado informal para jefes y mayores.",
      'ZH':
          "'식사하셨어요?'使用了敬语名词'식사'（用餐）和尊敬词尾'-시-'。虽然'밥 먹었어요?'带有敬语'-요'，但在职场中对上司或长辈依然显得过于随意。",
      'JA':
          '「식사하셨어요?」は敬語名詞「식사（お食事）」と尊敬接尾辞「-시-」を使った標準的な丁寧表現です。「밥 먹었어요?」は日常会話的で、職場の上司には馴れ馴れしく聞こえます。',
      'VI':
          "'식사하셨어요?' kết hợp danh từ kính ngữ '식사' (bữa ăn) và hậu tố tôn kính '-시-'. Dù '밥 먹었어요?' có đuôi '-요', nó vẫn quá suồng sã khi nói với sếp hoặc người lớn tuổi.",
      'PT':
          "'식사하셨어요?' usa o substantivo honorífico '식사' (refeição) com o sufixo de respeito '-시-'. Embora '밥 먹었어요?' termine em '-요', soa informal demais para superiores.",
    },
  ),
  const QuizQuestion(
    id: 2,
    category: 'Particles',
    situations: {
      'KO':
          '친구들과 모인 자리에서 누군가 "누가 이 맛있는 케이크 만들었어요?"라고 물어봤습니다. "내가 만들었어요!"라고 만든 주체(나)를 확실하게 강조하려는 상황입니다.',
      'EN':
          'At a party, a friend tastes a dish and asks: "누가 이 케이크 만들었어요? (Who made this cake?)" You want to answer: "I made it!" — spotlighting YOU as the person who did it.',
      'ES':
          'En una fiesta, un amigo prueba un pastel y pregunta: "¿Quién hizo este pastel?" Quieres responder: "¡Yo lo hice!" — destacando que fuiste TÚ.',
      'ZH':
          '在聚会上，朋友尝了蛋糕后问："누가 이 케이크 만들었어요?（谁做的这个蛋糕？）"你想回答："我做的！"——重点强调是你本人做的。',
      'JA':
          'パーティーで友達が「누가 이 케이크 만들었어요?（誰がこのケーキを作ったの？）」と尋ねました。「私が作りました！」と自分自身にスポットを当てて答えたい場面です。',
      'VI':
          'Tại bữa tiệc, một người bạn nếm bánh và hỏi: "Ai đã làm chiếc bánh này?" Bạn muốn trả lời: "Chính tôi làm đấy!" — nhấn mạnh vào người thực hiện là BẠN.',
      'PT':
          'Em uma festa, um amigo experimenta um bolo e pergunta: "Quem fez este bolo?" Você quer responder: "Fui EU quem fiz!" — destacando a sua pessoa.',
    },
    questions: {
      'KO':
          '‘누가’라는 질문에 대해 행동의 주체를 확실하게 강조하는 올바른 조사는?',
      'EN':
          'Which sentence uses the correct particle to highlight the subject answering "WHO"?',
      'ES':
          '¿Qué oración usa la partícula correcta para enfatizar el sujeto respondiendo "QUIÉN"?',
      'ZH':
          '哪句话使用了正确的助词，用来强调回答"谁"的主语？',
      'JA':
          '「誰」という疑問に焦点を当てて主語を強調する正しい助词はどれでしょうか？',
      'VI':
          'Câu nào sử dụng đúng trợ từ để nhấn mạnh chủ ngữ trả lời cho câu hỏi "AI"?',
      'PT':
          'Qual frase usa a partícula correta para destacar o sujeito respondendo "QUEM"?',
    },
    options: [
      '제가 만들었어요. (Jega mandeureosseoyo.)',
      '저는 만들었어요. (Jeoneun mandeureosseoyo.)',
      '저를 만들었어요. (Jeoreul mandeureosseoyo.)',
      '저의 만들었어요. (Jeoui mandeureosseoyo.)',
    ],
    answerIndex: 0,
    explanations: {
      'KO':
          "'이/가'(제 + 가 = 제가)는 '누가'라는 질문에 직접 답하며 행동의 주어를 확실하게 특정해 강조합니다. 반면 '저는'은 화제 제시나 타인과의 비교·대조 뉘앙스('다른 사람은 몰라도 나는...')여서 이 맥락에서는 어색합니다.",
      'EN':
          "'이/가' (here: 제 + 가 = 제가) places the spotlight on the subject to answer a 'who' question. In contrast, '저는' is a topic marker that implies contrast (e.g., 'As for me, I made it [unlike others]'), which sounds unnatural here.",
      'ES':
          "'이/가' (제 + 가 = 제가) pone el foco en el sujeto para responder 'quién'. En cambio, '저는' es una partícula de tema que denota contraste ('En cuanto a mí, lo hice...'), lo cual suena forzado aquí.",
      'ZH':
          "'이/가'（제 + 가 = 제가）将焦点直接放在回答'谁'的主语上。而'저는'是主题助词，通常带有对比意味（如'别人我不知道，至于我嘛...'），在此处显得不自然。",
      'JA':
          '「이/가」（ここでは 제 + 가 = 제가）は「誰が」という疑問に直接答えて主語を際立たせます。一方「저는」は主題や対比を表すため、ここでは不自然に聞こえます。',
      'VI':
          "'이/가' (ở đây: 제 + 가 = 제가) làm nổi bật chủ ngữ để trả lời cho câu hỏi 'ai'. Ngược lại, '저는' là trợ từ chủ đề mang hàm ý so sánh/đối lập nên không tự nhiên ở ngữ cảnh này.",
      'PT':
          "'이/가' (제 + 가 = 제가) coloca o foco no sujeito respondendo 'quem'. Já '저는' é uma partícula de tópico que implica contraste ('Quanto a mim, eu fiz...'), soando estranho aqui.",
    },
  ),
  const QuizQuestion(
    id: 3,
    category: 'Real-life',
    situations: {
      'KO':
          '한국의 번화한 식당에서 반찬을 더 받고 싶거나 주문을 하려고 직원을 불러야 하는 상황입니다.',
      'EN':
          'You are seated at a busy restaurant in Seoul and need the server to bring you extra napkins or take your order.',
      'ES':
          'Estás sentado en un restaurante concurrido en Seúl y necesitas que el mesero te traiga servilletas o tome tu orden.',
      'ZH':
          '你坐在首尔一家热闹的餐厅里，需要服务员拿纸巾或者过来点单。',
      'JA':
          'ソウルの賑やかな食堂で、店員さんを呼んで注文したりティッシュをもらいたい場面です。',
      'VI':
          'Bạn đang ngồi trong một nhà hàng nhộn nhịp ở Seoul và muốn gọi nhân viên phục vụ để gọi món hoặc xin thêm khăn giấy.',
      'PT':
          'Você está em um restaurante movimentado em Seul e quer chamar o garçom para fazer o pedido ou pedir guardanapos.',
    },
    questions: {
      'KO':
          '식당 직원을 부를 때 외국인 학습자가 가장 안전하고 예의 바르게 쓸 수 있는 표준 호칭은?',
      'EN':
          'What is the most natural and culturally appropriate way to call the attention of the restaurant staff?',
      'ES':
          '¿Cuál es la forma más natural y culturalmente adecuada de llamar al personal del restaurante?',
      'ZH':
          '在韩国餐厅里，招呼服务员最自然、地道的方式是什么？',
      'JA':
          '韓国の飲食店で店員さんを呼ぶとき、最も自然で一般的な表現はどれでしょうか？',
      'VI':
          'Cách gọi nhân viên nhà hàng tự nhiên và chuẩn văn hóa Hàn Quốc nhất là gì?',
      'PT':
          'Qual é a maneira mais natural e adequada culturalmente de chamar o garçom?',
    },
    options: [
      '저기요! (Jeogiyo!)',
      '웨이터! (Weiteo!)',
      '선생님! (Seonsaengnim!)',
      '이봐요! (Ibwayo!)',
    ],
    answerIndex: 0,
    explanations: {
      'KO':
          "'저기요!'는 모르는 사람의 주의를 환기할 때 쓰는 가장 보편적이고 안전한 표준 표현입니다. 직역된 '웨이터!'나 '이봐요!'는 무례하게 들릴 수 있으며, '아줌마'는 불쾌감을 줄 수 있어 '저기요'나 '사장님'을 쓰는 것이 좋습니다.",
      'EN':
          "Literal textbook translations like '웨이터!' (Waiter!) or '이봐요!' (Hey!) sound comical or impolite in Korea. Native Koreans universally call staff with '저기요!' (literally 'Over there, please!') or '사장님!' (Boss/Owner).",
      'ES':
          "Traducciones literales como '웨이터!' (¡Mesero!) o '이봐요!' (¡Oye tú!) suenan cómicas o groseras. Los coreanos siempre llaman diciendo '저기요!' (literalmente '¡Por allí, por favor!') o '사장님!'.",
      'ZH':
          "教科书式的直译如'웨이터!'（服务生！）或'이봐요!'（喂！）在韩国听起来滑稽甚至不礼貌。韩国人一律用'저기요!'（打扰一下！）或'사장님!'（老板！）来呼唤店员。",
      'JA':
          '教科書的な直訳「웨이터!（ウェイター！）」や「이봐요!（おい！）」は不自然または失礼に聞こえます。韓国では「저기요!（すみません！）」や「사장님!（社長さん/店員さん！）」と呼ぶのが定番です。',
      'VI':
          "Các cách dịch như '웨이터!' (Bồi bàn!) hoặc '이봐요!' (Này!) nghe rất buồn cười hoặc bất lịch sự. Người Hàn luôn dùng '저기요!' (Xin lỗi, đằng ấy ơi!) hoặc '사장님!'.",
      'PT':
          "Traduções literais como '웨이터!' (Garçom!) ou '이봐요!' (Ei você!) soam cômicas ou rudes. Os coreanos usam universalmente '저기요!' (literalmente 'Aí, por favor!') ou '사장님!'.",
    },
  ),
  const QuizQuestion(
    id: 4,
    category: 'Real-life',
    situations: {
      'KO':
          '한국인 호스트가 음식을 더 권했지만, 배가 너무 불러서 상대방의 성의를 생각하며 기분 상하지 않게 거절하고 싶은 상황입니다.',
      'EN':
          'A hospitable Korean host offers you a second helping of food, but you are completely full and want to decline politely without sounding harsh.',
      'ES':
          'Un anfitrión coreano muy atento te ofrece otra porción de comida, pero estás lleno y quieres rechazar amablemente sin sonar cortante.',
      'ZH':
          '热情的韩国房东或朋友要给你添饭，但你已经吃得很饱了，想礼貌拒绝而不显得生硬无礼。',
      'JA':
          '親切な韓国人のホストがおかわりを勧めてくれましたが、お腹がいっぱいです。失礼にならず柔らかく断りたい場面です。',
      'VI':
          'Một người chủ nhà Hàn Quốc hiếu khách muốn mời bạn ăn thêm, nhưng bạn đã quá no và muốn từ chối khéo léo mà không thô lỗ.',
      'PT':
          'Um anfitrião coreano gentil oferece mais comida, mas você está satisfeito e quer recusar educadamente sem parecer grosseiro.',
    },
    questions: {
      'KO':
          '상대방의 호의나 제안을 기분 상하지 않고 정중하게 거절(사양)할 때 쓰는 가장 자연스러운 표현은?',
      'EN':
          'What universally accepted phrase do native Koreans say to soften a polite refusal?',
      'ES':
          '¿Qué frase universal usan los coreanos nativos para suavizar una negativa cortés?',
      'ZH':
          '韩国人为了委婉礼貌地表达拒绝，最常说的地道口头禅是哪一句？',
      'JA':
          '角を立てずに柔らかく丁寧に断るとき、韓国人が決まって使う表現はどれでしょうか？',
      'VI':
          'Câu nói chuẩn mực nhất mà người Hàn thường dùng để từ chối một cách lịch thiệp là gì?',
      'PT':
          'Qual frase universal os coreanos nativos usam para suavizar uma recusa educada?',
    },
    options: [
      '아, 저는 괜찮습니다. (Ah, jeoneun gwaenchanhseumnida.)',
      '아니요, 싫어요. (Aniyo, sireoyo.)',
      '안 먹을 거예요. (An meogeul geoyeyo.)',
      '그만 줘요. (Geuman jwoyo.)',
    ],
    answerIndex: 0,
    explanations: {
      'KO':
          "한국 문화에서는 '싫어요'나 '안 먹어요'처럼 직설적으로 거절하면 매우 차갑거나 공격적으로 들릴 수 있습니다. 대신 '아, 저는 괜찮습니다 / 괜찮아요'라고 부드럽게 사양하는 것이 배려가 담긴 자연스러운 한국어입니다.",
      'EN':
          "Korean culture avoids blunt refusals. Saying '싫어요' (I dislike/don't want it) sounds aggressive. Instead, native speakers say '괜찮아요 / 괜찮습니다' (literally 'It is fine / I am good') with a smile to decline gracefully.",
      'ES':
          "La cultura coreana evita negativas directas. Decir '싫어요' (no quiero) suena agresivo. En su lugar, los nativos dicen '괜찮아요 / 괜찮습니다' (literalmente 'está bien / así estoy bien') con una sonrisa.",
      'ZH':
          "韩国文化极力避免直白的拒绝。说'싫어요'（我不喜欢/我不要）听起来非常生硬冒犯。韩国人习惯带着微笑说'괜찮아요 / 괜찮습니다'（我很好/不用了，谢谢）来得体婉拒。",
      'JA':
          '韓国の文化では直接的な拒絶を避けます。「싫어요（嫌です/要りません）」は非常にきつく聞こえます。ネイティブは笑顔で「괜찮아요 / 괜찮습니다（大丈夫です/結構です）」と言って優しく断ります。',
      'VI':
          "Văn hóa Hàn Quốc kiêng kỵ việc từ chối thẳng thừng. Nói '싫어요' (Tôi không thích) nghe rất thô. Người bản xứ luôn mỉm cười và nói '괜찮아요 / 괜찮습니다' (Tôi ổn rồi/Thôi ạ) để từ chối khéo.",
      'PT':
          "A cultura coreana evita recusas diretas. Dizer '싫어요' (não quero) soa agressivo. Os nativos preferem sorrir e dizer '괜찮아요 / 괜찮습니다' (está tudo bem / estou satisfeito) para recusar com gentileza.",
    },
  ),
];
