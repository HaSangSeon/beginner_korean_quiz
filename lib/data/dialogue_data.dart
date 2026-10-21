/// 상황별 일상 대화문 (암기용)
/// - 대화 본문은 언어 설정과 무관하게 100% 한국어로 고정
/// - 제목(상황명)만 선택한 언어로 표시
class DialogueLine {
  final String speaker; // '철수' or '영희'
  final String text;
  const DialogueLine(this.speaker, this.text);
}

class Dialogue {
  final int id;
  final String emoji;
  final Map<String, String> titles;
  final List<DialogueLine> lines;

  const Dialogue({
    required this.id,
    required this.emoji,
    required this.titles,
    required this.lines,
  });

  String get audioAsset => 'assets/audio/dialogue_$id.mp3';

  String title(String langCode) =>
      titles[langCode.toUpperCase()] ?? titles['EN'] ?? titles['KO'] ?? '';
}

const List<Dialogue> dialogues = [
  Dialogue(
    id: 1,
    emoji: '👋',
    titles: {
      'KO': '처음 만났을 때',
      'EN': 'First Meeting',
      'VI': 'Lần đầu gặp mặt',
      'ZH': '初次见面',
      'JA': '初めて会ったとき',
      'ES': 'Primer encuentro',
      'PT': 'Primeiro encontro',
    },
    lines: [
      DialogueLine('영희', '안녕하세요? 저는 김영희예요.'),
      DialogueLine('철수', '안녕하세요? 저는 이철수예요.'),
      DialogueLine('영희', '만나서 반갑습니다.'),
      DialogueLine('철수', '저도 반갑습니다. 영희 씨는 학생이에요?'),
      DialogueLine('영희', '네, 저는 대학생이에요. 철수 씨는요?'),
      DialogueLine('철수', '저는 회사원이에요.'),
      DialogueLine('영희', '아, 그래요? 어느 회사에 다녀요?'),
      DialogueLine('철수', '한국전자에 다녀요.'),
      DialogueLine('영희', '앞으로 잘 부탁드려요.'),
      DialogueLine('철수', '네, 잘 부탁드려요.'),
    ],
  ),
  Dialogue(
    id: 2,
    emoji: '🍽️',
    titles: {
      'KO': '식당에서 주문하기',
      'EN': 'Ordering at a Restaurant',
      'VI': 'Gọi món ở nhà hàng',
      'ZH': '在餐厅点餐',
      'JA': '食堂で注文する',
      'ES': 'Pedir en un restaurante',
      'PT': 'Pedindo no restaurante',
    },
    lines: [
      DialogueLine('철수', '어서 오세요. 몇 분이세요?'),
      DialogueLine('영희', '한 명이에요.'),
      DialogueLine('철수', '이쪽으로 앉으세요. 뭐 드릴까요?'),
      DialogueLine('영희', '김치찌개 하나 주세요.'),
      DialogueLine('철수', '네. 음료수도 드릴까요?'),
      DialogueLine('영희', '아니요, 괜찮아요. 물 좀 주세요.'),
      DialogueLine('철수', '물은 저쪽에 있어요. 셀프예요.'),
      DialogueLine('영희', '아, 네. 감사합니다.'),
      DialogueLine('영희', '여기 계산해 주세요.'),
      DialogueLine('철수', '9,000원입니다. 감사합니다.'),
    ],
  ),
  Dialogue(
    id: 3,
    emoji: '☕',
    titles: {
      'KO': '카페에서',
      'EN': 'At a Café',
      'VI': 'Ở quán cà phê',
      'ZH': '在咖啡店',
      'JA': 'カフェで',
      'ES': 'En la cafetería',
      'PT': 'Na cafeteria',
    },
    lines: [
      DialogueLine('철수', '주문하시겠어요?'),
      DialogueLine('영희', '아이스 아메리카노 한 잔 주세요.'),
      DialogueLine('철수', '사이즈는 어떻게 드릴까요?'),
      DialogueLine('영희', '큰 사이즈로 주세요.'),
      DialogueLine('철수', '드시고 가세요? 가져가세요?'),
      DialogueLine('영희', '가져갈게요.'),
      DialogueLine('철수', '4,500원입니다. 카드로 하시겠어요?'),
      DialogueLine('영희', '네, 카드로 할게요.'),
      DialogueLine('철수', '진동벨이 울리면 오세요.'),
      DialogueLine('영희', '네, 감사합니다.'),
    ],
  ),
  Dialogue(
    id: 4,
    emoji: '🗺️',
    titles: {
      'KO': '길 묻기',
      'EN': 'Asking for Directions',
      'VI': 'Hỏi đường',
      'ZH': '问路',
      'JA': '道を尋ねる',
      'ES': 'Preguntar direcciones',
      'PT': 'Pedindo direções',
    },
    lines: [
      DialogueLine('영희', '실례합니다. 지하철역이 어디에 있어요?'),
      DialogueLine('철수', '이 길로 쭉 가세요.'),
      DialogueLine('영희', '여기에서 멀어요?'),
      DialogueLine('철수', '아니요, 안 멀어요. 걸어서 5분쯤 걸려요.'),
      DialogueLine('영희', '쭉 가서 어떻게 가요?'),
      DialogueLine('철수', '은행 앞에서 오른쪽으로 가세요.'),
      DialogueLine('영희', '은행 앞에서 오른쪽이요?'),
      DialogueLine('철수', '네, 그러면 지하철역이 보여요.'),
      DialogueLine('영희', '정말 감사합니다.'),
      DialogueLine('철수', '아니에요. 조심히 가세요.'),
    ],
  ),
  Dialogue(
    id: 5,
    emoji: '🏥',
    titles: {
      'KO': '병원에서',
      'EN': 'At the Hospital',
      'VI': 'Ở bệnh viện',
      'ZH': '在医院',
      'JA': '病院で',
      'ES': 'En el hospital',
      'PT': 'No hospital',
    },
    lines: [
      DialogueLine('철수', '어디가 아파요?'),
      DialogueLine('영희', '머리가 아프고 열이 나요.'),
      DialogueLine('철수', '언제부터 아팠어요?'),
      DialogueLine('영희', '어제 저녁부터 아팠어요.'),
      DialogueLine('철수', '기침도 해요?'),
      DialogueLine('영희', '네, 기침도 조금 해요.'),
      DialogueLine('철수', '감기예요. 약을 드릴게요.'),
      DialogueLine('영희', '약은 언제 먹어요?'),
      DialogueLine('철수', '하루에 세 번, 식사 후에 드세요.'),
      DialogueLine('영희', '네, 감사합니다.'),
    ],
  ),
  Dialogue(
    id: 6,
    emoji: '🍎',
    titles: {
      'KO': '시장에서 물건 사기',
      'EN': 'Shopping at the Market',
      'VI': 'Mua đồ ở chợ',
      'ZH': '在市场买东西',
      'JA': '市場で買い物',
      'ES': 'Comprar en el mercado',
      'PT': 'Comprando no mercado',
    },
    lines: [
      DialogueLine('영희', '사과 얼마예요?'),
      DialogueLine('철수', '한 개에 천 원이에요.'),
      DialogueLine('영희', '그럼 사과 다섯 개 주세요.'),
      DialogueLine('철수', '네, 오천 원입니다. 또 필요한 거 있으세요?'),
      DialogueLine('영희', '바나나도 있어요?'),
      DialogueLine('철수', '네, 한 송이에 삼천 원이에요.'),
      DialogueLine('영희', '바나나도 하나 주세요.'),
      DialogueLine('철수', '모두 팔천 원입니다.'),
      DialogueLine('영희', '여기 만 원이요.'),
      DialogueLine('철수', '거스름돈 이천 원 받으세요. 감사합니다.'),
    ],
  ),
  Dialogue(
    id: 7,
    emoji: '📅',
    titles: {
      'KO': '주말 약속 정하기',
      'EN': 'Making Weekend Plans',
      'VI': 'Hẹn cuối tuần',
      'ZH': '约周末见面',
      'JA': '週末の約束',
      'ES': 'Planes para el fin de semana',
      'PT': 'Combinando o fim de semana',
    },
    lines: [
      DialogueLine('철수', '영희 씨, 주말에 시간 있어요?'),
      DialogueLine('영희', '토요일은 바빠요. 일요일은 괜찮아요.'),
      DialogueLine('철수', '그럼 일요일에 같이 영화 볼까요?'),
      DialogueLine('영희', '좋아요. 몇 시에 만날까요?'),
      DialogueLine('철수', '오후 2시 어때요?'),
      DialogueLine('영희', '좋아요. 어디에서 만날까요?'),
      DialogueLine('철수', '강남역 2번 출구에서 만나요.'),
      DialogueLine('영희', '영화 보고 같이 저녁도 먹어요.'),
      DialogueLine('철수', '좋아요. 그럼 일요일에 봐요.'),
      DialogueLine('영희', '네, 일요일에 봐요.'),
    ],
  ),
  Dialogue(
    id: 8,
    emoji: '📞',
    titles: {
      'KO': '전화하기',
      'EN': 'Making a Phone Call',
      'VI': 'Gọi điện thoại',
      'ZH': '打电话',
      'JA': '電話をかける',
      'ES': 'Hacer una llamada',
      'PT': 'Fazendo uma ligação',
    },
    lines: [
      DialogueLine('철수', '여보세요?'),
      DialogueLine('영희', '여보세요, 철수 씨? 저 영희예요.'),
      DialogueLine('철수', '아, 영희 씨! 무슨 일이에요?'),
      DialogueLine('영희', '내일 한국어 수업이 몇 시예요?'),
      DialogueLine('철수', '오전 10시예요.'),
      DialogueLine('영희', '교실은 어디예요?'),
      DialogueLine('철수', '3층 302호예요.'),
      DialogueLine('영희', '고마워요. 내일 학교에서 만나요.'),
      DialogueLine('철수', '네, 내일 봐요.'),
    ],
  ),
];
