import 'learning_order.dart';

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

  String get category {
    switch (id) {
      case 2:
      case 3:
      case 24:
      case 30:
      case 42:
      case 43:
        return 'food';
      case 4:
      case 10:
      case 12:
      case 15:
      case 17:
      case 25:
      case 37:
      case 44:
      case 45:
        return 'transit';
      case 1:
      case 6:
      case 7:
      case 8:
      case 9:
      case 11:
      case 16:
      case 18:
      case 28:
      case 38:
      case 40:
      case 41:
      case 46:
      case 47:
      case 51:
        return 'life';
      case 14:
      case 19:
      case 20:
      case 22:
      case 23:
      case 27:
      case 33:
      case 34:
      case 35:
      case 36:
      case 39:
      case 48:
      case 49:
        return 'public';
      case 5:
      case 13:
      case 21:
      case 26:
      case 29:
      case 31:
      case 32:
      case 50:
        return 'health';
      default:
        return 'life';
    }
  }
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
  Dialogue(
    id: 9,
    emoji: '🏪',
    titles: {
      'KO': '편의점에서',
      'EN': 'At the Convenience Store',
      'VI': 'Ở cửa hàng tiện lợi',
      'ZH': '在便利店',
      'JA': 'コンビニで',
    },
    lines: [
      DialogueLine('영희', '안녕하세요. 교통카드 충전해 주세요.'),
      DialogueLine('철수', '네, 얼마 충전해 드릴까요?'),
      DialogueLine('영희', '2만 원 충전해 주세요.'),
      DialogueLine('철수', '카드를 단말기 위에 올려놓아 주세요.'),
      DialogueLine('철수', '충전 완료되었습니다. 영수증 필요하세요?'),
      DialogueLine('영희', '아니요, 버려 주세요.'),
      DialogueLine('영희', '참, 봉투 하나만 주세요.'),
      DialogueLine('철수', '봉투는 100원 추가됩니다.'),
      DialogueLine('영희', '네, 같이 결제해 주세요.'),
      DialogueLine('철수', '감사합니다. 또 오세요.'),
    ],
  ),
  Dialogue(
    id: 10,
    emoji: '🚇',
    titles: {
      'KO': '지하철 타기',
      'EN': 'Taking the Subway',
      'VI': 'Đi tàu điện ngầm',
      'ZH': '乘坐地铁',
      'JA': '地下鉄に乗る',
    },
    lines: [
      DialogueLine('철수', '영희 씨, 명동에 어떻게 가요?'),
      DialogueLine('영희', '지하철 4호선을 타고 가세요.'),
      DialogueLine('철수', '여기에서 몇 정거장 가야 해요?'),
      DialogueLine('영희', '다섯 정거장 가면 돼요.'),
      DialogueLine('철수', '중간에 갈아타야 해요?'),
      DialogueLine('영희', '아니요, 갈아타지 않고 한 번에 가요.'),
      DialogueLine('철수', '시간은 얼마나 걸려요?'),
      DialogueLine('영희', '15분 정도 걸려요.'),
      DialogueLine('철수', '고마워요. 지하철역으로 갈게요.'),
      DialogueLine('영희', '네, 조심히 다녀오세요.'),
    ],
  ),
  Dialogue(
    id: 11,
    emoji: '👗',
    titles: {
      'KO': '옷 가게에서',
      'EN': 'At the Clothing Store',
      'VI': 'Ở cửa hàng quần áo',
      'ZH': '在服装店',
      'JA': '服屋で',
    },
    lines: [
      DialogueLine('철수', '어서 오세요. 찾으시는 옷 있으세요?'),
      DialogueLine('영희', '이 바지 다른 색상도 있어요?'),
      DialogueLine('철수', '네, 검은색과 진청색이 있어요.'),
      DialogueLine('영희', '한번 입어 봐도 돼요?'),
      DialogueLine('철수', '네, 저쪽에 탈의실이 있어요.'),
      DialogueLine('영희', '조금 작은데, 더 큰 사이즈 있어요?'),
      DialogueLine('철수', '네, 미디엄 사이즈로 가져다 드릴게요.'),
      DialogueLine('영희', '이게 딱 맞네요. 이걸로 살게요.'),
      DialogueLine('철수', '네, 계산대로 안내해 드릴게요.'),
      DialogueLine('영희', '교환이나 환불은 언제까지 돼요?'),
      DialogueLine('철수', '택을 떼지 않고 일주일 안에 영수증과 함께 가져오시면 돼요.'),
    ],
  ),
  Dialogue(
    id: 12,
    emoji: '🚕',
    titles: {
      'KO': '택시 타기',
      'EN': 'Taking a Taxi',
      'VI': 'Đi taxi',
      'ZH': '乘出租车',
      'JA': 'タクシーに乗る',
    },
    lines: [
      DialogueLine('철수', '어서 오세요. 어디로 모실까요?'),
      DialogueLine('영희', '서울역으로 가 주세요.'),
      DialogueLine('철수', '네, 서울역으로 가겠습니다.'),
      DialogueLine('영희', '기사님, 30분 안에 도착할 수 있을까요?'),
      DialogueLine('철수', '지금 길이 조금 막히지만 서둘러 볼게요.'),
      DialogueLine('영희', '기차 시간이 얼마 안 남아서요. 부탁드려요.'),
      DialogueLine('철수', '네, 안 막히는 길로 가겠습니다.'),
      DialogueLine('철수', '서울역 도착했습니다.'),
      DialogueLine('영희', '얼마 나왔어요?'),
      DialogueLine('철수', '8,500원입니다.'),
      DialogueLine('영희', '카드로 결제할게요. 감사합니다!'),
    ],
  ),
  Dialogue(
    id: 13,
    emoji: '💊',
    titles: {
      'KO': '약국에서',
      'EN': 'At the Pharmacy',
      'VI': 'Ở hiệu thuốc',
      'ZH': '在药店',
      'JA': '薬局で',
    },
    lines: [
      DialogueLine('철수', '어서 오세요. 어디가 불편하세요?'),
      DialogueLine('영희', '소화가 안 되고 속이 쓰려요.'),
      DialogueLine('철수', '소화제와 위장약 드릴게요.'),
      DialogueLine('영희', '하루에 몇 번 먹어야 해요?'),
      DialogueLine('철수', '식사 후에 물과 함께 한 알씩 드세요.'),
      DialogueLine('영희', '두통약도 같이 살 수 있을까요?'),
      DialogueLine('철수', '네, 여기 진통제도 있습니다.'),
      DialogueLine('영희', '약 먹고 운전해도 되나요?'),
      DialogueLine('철수', '졸릴 수 있으니까 운전은 피하세요.'),
      DialogueLine('영희', '알겠습니다. 모두 얼마예요?'),
      DialogueLine('철수', '7,000원입니다.'),
    ],
  ),
  Dialogue(
    id: 14,
    emoji: '🏠',
    titles: {
      'KO': '원룸 생활 문의',
      'EN': 'Studio Apartment Living',
      'VI': 'Hỏi về phòng trọ',
      'ZH': '一居室生活咨询',
      'JA': 'ワンルーム生活の相談',
    },
    lines: [
      DialogueLine('영희', '아주머니, 안녕하세요. 301호예요.'),
      DialogueLine('철수', '아, 영희 씨! 무슨 일 있어요?'),
      DialogueLine('영희', '방에 따뜻한 물이 안 나와요.'),
      DialogueLine('철수', '보일러 온수 버튼을 켰어요?'),
      DialogueLine('영희', '네, 켰는데 찬물만 나와요.'),
      DialogueLine('철수', '내가 지금 올라가서 확인해 볼게요.'),
      DialogueLine('영희', '네, 감사합니다. 그리고 쓰레기 배출일이 언제예요?'),
      DialogueLine('철수', '일반 쓰레기는 화요일, 목요일 저녁에 내놓으면 돼요.'),
      DialogueLine('영희', '네, 잘 알겠습니다. 감사합니다!'),
      DialogueLine('철수', '불편한 거 있으면 언제든 연락해요.'),
    ],
  ),
  Dialogue(
    id: 15,
    emoji: '✈️',
    titles: {
      'KO': '공항 입국 심사',
      'EN': 'Airport Immigration',
      'VI': 'Thủ tục nhập cảnh sân bay',
      'ZH': '机场入境审查',
      'JA': '空港の入国審査',
    },
    lines: [
      DialogueLine('철수', '여권과 입국 신고서 보여주세요.'),
      DialogueLine('영희', '네, 여기 있습니다.'),
      DialogueLine('철수', '한국에 무슨 일로 오셨습니까?'),
      DialogueLine('영희', '한국어 공부하러 왔습니다.'),
      DialogueLine('철수', '얼마나 머무를 예정입니까?'),
      DialogueLine('영희', '6개월 동안 머무를 예정입니다.'),
      DialogueLine('철수', '어디에서 지내십니까?'),
      DialogueLine('영희', '대학교 기숙사에서 지냅니다.'),
      DialogueLine('철수', '네, 확인되었습니다. 좋은 시간 보내세요.'),
      DialogueLine('영희', '감사합니다. 수고하세요!'),
    ],
  ),
  Dialogue(
    id: 16,
    emoji: '💄',
    titles: {
      'KO': '올리브영에서 화장품 고르기',
      'EN': 'Shopping at Olive Young',
      'VI': 'Mua sắm mỹ phẩm tại Olive Young',
      'ZH': '在欧利芙洋选购化妆品',
      'JA': 'オリーブヤングでコスメを選ぶ',
    },
    lines: [
      DialogueLine('영희', '저기요, 요즘 제일 잘나가는 선크림이 뭐예요?'),
      DialogueLine('철수', '이 제품이 끈적이지 않고 인기가 많아요.'),
      DialogueLine('영희', '손등에 테스트해 봐도 돼요?'),
      DialogueLine('철수', '네, 앞에 있는 테스터를 사용해 보세요.'),
      DialogueLine('영희', '향도 좋고 촉촉하네요. 이걸로 하나 주세요.'),
      DialogueLine('철수', '네. 봉투 필요하세요?'),
      DialogueLine('영희', '아니요, 가방에 넣어 갈게요.'),
      DialogueLine('철수', 'CJ ONE 포인트 적립하시겠어요?'),
      DialogueLine('영희', '외국인도 적립할 수 있어요?'),
      DialogueLine('철수', '네, 전화번호로 간편하게 적립돼요.'),
    ],
  ),
  Dialogue(
    id: 17,
    emoji: '🚄',
    titles: {
      'KO': 'KTX 기차표 예매하기',
      'EN': 'Booking a KTX Train Ticket',
      'VI': 'Đặt vé tàu KTX',
      'ZH': '预订KTX高铁票',
      'JA': 'KTXの切符を予約する',
    },
    lines: [
      DialogueLine('영희', '안녕하세요, 오늘 부산 가는 KTX 표 있어요?'),
      DialogueLine('철수', '네, 몇 시 출발을 원하세요?'),
      DialogueLine('영희', '오후 2시 이후로 가장 빠른 기차요.'),
      DialogueLine('철수', '2시 15분 열차가 있습니다. 일반실로 드릴까요?'),
      DialogueLine('영희', '네. 창가 쪽 자리로 부탁드려요.'),
      DialogueLine('철수', '창가 5A 좌석 배정해 드렸습니다. 59,800원입니다.'),
      DialogueLine('영희', '카드로 결제할게요.'),
      DialogueLine('철수', '영수증과 승차권 여기 있습니다.'),
      DialogueLine('영희', '기차 타는 곳은 몇 번 플랫폼인가요?'),
      DialogueLine('철수', '3번 타는 곳으로 내려가시면 됩니다.'),
    ],
  ),
  Dialogue(
    id: 18,
    emoji: '🧺',
    titles: {
      'KO': '무인 코인 빨래방 이용하기',
      'EN': 'Using a Coin Laundromat',
      'VI': 'Sử dụng tiệm giặt sấy tự động',
      'ZH': '使用无人投币洗衣房',
      'JA': 'コインランドリーを利用する',
    },
    lines: [
      DialogueLine('영희', '저기요, 여기 빨래방 처음인데 어떻게 해요?'),
      DialogueLine('철수', '세탁기에 빨래를 넣고 문을 닫으세요.'),
      DialogueLine('영희', '세제는 어디에 넣어요?'),
      DialogueLine('철수', '세제는 자동으로 나오니까 따로 안 넣어도 돼요.'),
      DialogueLine('영희', '동전만 돼요? 카드 결제도 되나요?'),
      DialogueLine('철수', '키오스크에서 신용카드로 결제하면 돼요.'),
      DialogueLine('영희', '세탁은 시간이 얼마나 걸려요?'),
      DialogueLine('철수', '표준 세탁은 35분 정도 걸려요.'),
      DialogueLine('영희', '다 끝나면 건조기도 돌려야겠네요.'),
      DialogueLine('철수', '네, 바로 옆 건조기에 옮겨서 돌리면 돼요.'),
    ],
  ),
  Dialogue(
    id: 19,
    emoji: '💇',
    titles: {
      'KO': '미용실에서 머리하기',
      'EN': 'Getting a Haircut at a Salon',
      'VI': 'Cắt tóc tại tiệm làm tóc',
      'ZH': '在美发沙龙理发',
      'JA': '美容室で髪を切る',
    },
    lines: [
      DialogueLine('철수', '어서 오세요. 예약하셨나요?'),
      DialogueLine('영희', '네, 3시에 예약한 영희예요.'),
      DialogueLine('철수', '이쪽으로 앉으세요. 오늘 머리 어떻게 해 드릴까요?'),
      DialogueLine('영희', '길이는 조금만 다듬어 주시고 숱 좀 쳐 주세요.'),
      DialogueLine('철수', '앞머리도 잘라 드릴까요?'),
      DialogueLine('영희', '눈썹 가릴 정도로만 살짝 잘라 주세요.'),
      DialogueLine('철수', '샴푸실로 이동해서 머리 감겨 드릴게요.'),
      DialogueLine('영희', '네, 물 온도는 딱 좋아요.'),
      DialogueLine('철수', '드라이 마쳤습니다. 마음에 드시나요?'),
      DialogueLine('영희', '네, 가볍고 마음에 들어요. 감사합니다!'),
    ],
  ),
  Dialogue(
    id: 20,
    emoji: '🏢',
    titles: {
      'KO': '부동산에서 원룸 구하기',
      'EN': 'Finding a Studio at Real Estate',
      'VI': 'Tìm thuê phòng trọ tại công ty bất động sản',
      'ZH': '在房产中介租单间公寓',
      'JA': '不動産でワンルームを探す',
    },
    lines: [
      DialogueLine('철수', '어서 오세요. 어떤 방을 찾으시나요?'),
      DialogueLine('영희', '대학교 근처에 원룸을 구하고 있어요.'),
      DialogueLine('철수', '생각하시는 보증금과 월세 예산이 얼마인가요?'),
      DialogueLine('영희', '보증금 500에 월세 45만 원 정도 생각해요.'),
      DialogueLine('철수', '관리비 포함인가요?'),
      DialogueLine('영희', '관리비에 인터넷과 수도세가 포함되면 좋겠어요.'),
      DialogueLine('철수', '역에서 걸어서 5분 거리에 풀옵션 원룸이 하나 있어요.'),
      DialogueLine('영희', '냉장고와 세탁기, 에어컨도 다 있나요?'),
      DialogueLine('철수', '네, 몸만 들어오시면 돼요. 지금 보러 갈까요?'),
      DialogueLine('영희', '네, 지금 바로 보러 가요!'),
    ],
  ),
  Dialogue(
    id: 21,
    emoji: '🤒',
    titles: {
      'KO': '회사에서 감기 기운',
      'EN': 'Feeling Sick at Work',
      'VI': 'Bị cảm ở công ty',
      'ZH': '在公司感冒了',
      'JA': '会社で風邪気味',
    },
    lines: [
      DialogueLine('철수', '영희 씨, 오늘 얼굴이 좀 창백해요. 어디 안 좋아요?'),
      DialogueLine('영희', '어젯밤부터 으슬으슬 춥고 목이 따끔거려요.'),
      DialogueLine('철수', '요즘 사무실 에어컨이 너무 세서 그런가 봐요.'),
      DialogueLine('영희', '그런 것 같아요. 아침에 따뜻한 차를 마셨는데도 계속 그래요.'),
      DialogueLine('철수', '점심시간에 회사 앞 약국에 같이 가 볼까요?'),
      DialogueLine('영희', '좋아요. 오후에 회의가 있어서 빨리 나아야 해요.'),
      DialogueLine('철수', '팀장님께 말씀드리고 오늘은 일찍 퇴근하는 게 어때요?'),
      DialogueLine('영희', '회의 끝나고 여쭤볼게요. 신경 써 줘서 고마워요.'),
    ],
  ),
  Dialogue(
    id: 22,
    emoji: '📚',
    titles: {
      'KO': '도서관에서 책 빌리기',
      'EN': 'Borrowing Books at the Library',
      'VI': 'Mượn sách ở thư viện',
      'ZH': '在图书馆借书',
      'JA': '図書館で本を借りる',
    },
    lines: [
      DialogueLine('철수', '안녕하세요. 이 책들을 대출하고 싶어요.'),
      DialogueLine('영희', '네, 도서관 회원증이나 신분증을 보여주시겠어요?'),
      DialogueLine('철수', '모바일 회원증도 가능한가요?'),
      DialogueLine('영희', '네, 바코드를 여기에 스캔해 주세요.'),
      DialogueLine('철수', '책은 며칠 동안 빌릴 수 있나요?'),
      DialogueLine('영희', '대출 기간은 2주이고, 최대 다섯 권까지 가능합니다.'),
      DialogueLine('철수', '기간 연장도 할 수 있나요?'),
      DialogueLine('영희', '예약자가 없으면 홈페이지에서 일주일 연장하실 수 있어요.'),
      DialogueLine('철수', '알겠습니다. 감사합니다!'),
      DialogueLine('영희', '좋은 하루 보내세요.'),
    ],
  ),
  Dialogue(
    id: 23,
    emoji: '🏦',
    titles: {
      'KO': '은행에서 통장 만들기',
      'EN': 'Opening a Bank Account',
      'VI': 'Mở tài khoản ngân hàng',
      'ZH': '在银行开户',
      'JA': '銀行で口座を開設する',
    },
    lines: [
      DialogueLine('철수', '어서 오세요. 어떤 업무를 도와드릴까요?'),
      DialogueLine('영희', '입출금 통장과 체크카드를 만들고 싶어요.'),
      DialogueLine('철수', '신분증과 재직증명서나 학생증을 가지고 오셨나요?'),
      DialogueLine('영희', '네, 외국인등록증과 학생증 여기 있어요.'),
      DialogueLine('철수', '서류 확인했습니다. 이 신청서에 서명해 주세요.'),
      DialogueLine('영희', '인터넷 뱅킹도 같이 신청할 수 있나요?'),
      DialogueLine('철수', '물론입니다. 보안카드와 체크카드도 바로 발급해 드릴게요.'),
      DialogueLine('영희', '카드는 오늘부터 바로 사용할 수 있나요?'),
      DialogueLine('철수', '네, 지금부터 바로 결제와 출금이 가능합니다.'),
      DialogueLine('영희', '친절하게 도와주셔서 감사합니다.'),
    ],
  ),
  Dialogue(
    id: 24,
    emoji: '🍕',
    titles: {
      'KO': '한강에서 배달 주문하기',
      'EN': 'Ordering Delivery at Hangang Park',
      'VI': 'Đặt giao đồ ăn ở công viên sông Hàn',
      'ZH': '在汉江公园叫外卖',
      'JA': '漢江公園で出前を頼む',
    },
    lines: [
      DialogueLine('철수', '날씨가 정말 좋다! 우리 치킨 시켜 먹을까?'),
      DialogueLine('영희', '좋아! 배달 앱으로 시키면 한강에서도 받을 수 있어?'),
      DialogueLine('철수', '응, 한강공원 배달존으로 주문하면 돼.'),
      DialogueLine('영희', '배달존이 어디에 있어?'),
      DialogueLine('철수', '여의도나루역 2번 출구 근처에 2번 배달존이 있어.'),
      DialogueLine('영희', '그렇구나. 치킨 도착하면 배달원 아저씨한테 전화 오지?'),
      DialogueLine('철수', '맞아. 전화 오면 가서 받아오면 돼. 돗자리 펴고 기다리자.'),
      DialogueLine('영희', '시원한 음료수도 같이 주문했어?'),
      DialogueLine('철수', '응, 콜라도 큰 걸로 같이 주문했어!'),
      DialogueLine('영희', '완벽하다! 얼른 먹고 싶어.'),
    ],
  ),
  Dialogue(
    id: 25,
    emoji: '🚕',
    titles: {
      'KO': '택시 타고 목적지 가기',
      'EN': 'Taking a Taxi to Destination',
      'VI': 'Đi taxi đến điểm đến',
      'ZH': '乘出租车去目的地',
      'JA': 'タクシーで目的地へ行く',
    },
    lines: [
      DialogueLine('철수', '어서 오세요. 어디로 모실까요?'),
      DialogueLine('영희', '기사님, 서울역으로 가주세요.'),
      DialogueLine('철수', '네, 알겠습니다. 고속도로로 갈까요, 일반 도로로 갈까요?'),
      DialogueLine('영희', '기차 시간이 얼마 안 남았는데, 빠른 길로 가주세요.'),
      DialogueLine('철수', '네, 그럼 도시고속도로를 타겠습니다.'),
      DialogueLine('영희', '서울역까지 대략 몇 분 정도 걸릴까요?'),
      DialogueLine('철수', '지금 차가 안 막혀서 20분이면 도착합니다.'),
      DialogueLine('영희', '다행이네요. 감사합니다.'),
      DialogueLine('철수', '서울역 도착했습니다. 요금은 만 이천 원입니다.'),
      DialogueLine('영희', '카드로 결제할게요. 영수증도 주세요.'),
    ],
  ),
  Dialogue(
    id: 26,
    emoji: '🏋️',
    titles: {
      'KO': '헬스장 등록 및 상담',
      'EN': 'Registering at a Gym',
      'VI': 'Đăng ký tập gym',
      'ZH': '健身房咨询与登记',
      'JA': 'ジムの登録と相談',
    },
    lines: [
      DialogueLine('철수', '안녕하세요! 헬스장 회원 등록하러 왔는데요.'),
      DialogueLine('영희', '환영합니다! 헬스 이용만 하시나요, PT도 생각 중이신가요?'),
      DialogueLine('철수', '우선 3개월 회원권 가격이 궁금해요.'),
      DialogueLine('영희', '3개월 등록하시면 운동복과 라커룸 무료 혜택이 있어요.'),
      DialogueLine('철수', '체성분 분석(인바디)도 해볼 수 있나요?'),
      DialogueLine('영희', '네, 가입하시면 전문 트레이너가 인바디 측정과 운동 상담을 해드려요.'),
      DialogueLine('철수', '운영 시간은 어떻게 되나요?'),
      DialogueLine('영희', '평일은 아침 6시부터 밤 12시까지, 주말은 밤 9시까지입니다.'),
      DialogueLine('철수', '시설이 참 좋네요. 3개월로 등록할게요.'),
      DialogueLine('영희', '네, 이쪽에 회원 정보 작성 부탁드립니다.'),
    ],
  ),
  Dialogue(
    id: 27,
    emoji: '👓',
    titles: {
      'KO': '안경점에서 시력 검사하기',
      'EN': 'At the Optician\'s',
      'VI': 'Khám mắt ở tiệm kính',
      'ZH': '在眼镜店检查视力',
      'JA': '眼鏡店で視力検査をする',
    },
    lines: [
      DialogueLine('철수', '어서 오세요. 안경 맞추러 오셨나요?'),
      DialogueLine('영희', '네, 요즘 눈이 침침해서 도수를 다시 맞추고 싶어요.'),
      DialogueLine('철수', '그러시면 먼저 안쪽 검사실에서 시력 검사부터 받으실게요.'),
      DialogueLine('영희', '네, 알겠습니다.'),
      DialogueLine('철수', '턱을 받치고 화면 가운데 빨간 기구를 보세요.'),
      DialogueLine('영희', '네, 잘 보여요.'),
      DialogueLine('철수', '난시가 조금 있으시네요. 도수를 한 단계 올려드렸습니다.'),
      DialogueLine('영희', '아, 지금 보니까 훨씬 선명하고 또렷하게 보여요.'),
      DialogueLine('철수', '이제 마음에 드시는 안경테를 골라보세요.'),
      DialogueLine('영희', '네, 가볍고 둥근 테로 추천해 주세요.'),
    ],
  ),
  Dialogue(
    id: 28,
    emoji: '🍎',
    titles: {
      'KO': '전통시장에서 장보기',
      'EN': 'Shopping at a Traditional Market',
      'VI': 'Đi chợ truyền thống',
      'ZH': '在传统市场买菜',
      'JA': '伝統市場で買い物をする',
    },
    lines: [
      DialogueLine('철수', '어서 오세요! 싱싱한 사과랑 딸기 보고 가세요!'),
      DialogueLine('영희', '사장님, 이 사과 한 바구니에 얼마예요?'),
      DialogueLine('철수', '맛있는 꿀사과 다섯 개에 만 원이에요. 하나 먹어봐요!'),
      DialogueLine('영희', '와, 정말 달고 맛있네요. 세 바구니 주세요.'),
      DialogueLine('철수', '많이 사시니까 덤으로 사과 두 개 더 드릴게요!'),
      DialogueLine('영희', '감사합니다 사장님! 딸기도 아주 신선해 보이네요.'),
      DialogueLine('철수', '오늘 아침에 갓 따온 딸기예요. 딸기는 오천 원에 줄게요.'),
      DialogueLine('영희', '그럼 딸기도 한 상자 같이 주세요. 계좌이체 되나요?'),
      DialogueLine('철수', '네, 여기 벽에 적힌 번호로 보내주시면 됩니다.'),
      DialogueLine('영희', '네, 보냈습니다. 많이 파세요!'),
    ],
  ),
  Dialogue(
    id: 29,
    emoji: '♨️',
    titles: {
      'KO': '찜질방 이용하기',
      'EN': 'Visiting a Korean Spa',
      'VI': 'Đi xông hơi Jjimjilbang',
      'ZH': '去汗蒸房',
      'JA': 'チムジルバンを利用する',
    },
    lines: [
      DialogueLine('철수', '찜질방 성인 한 명 결제할게요.'),
      DialogueLine('영희', '네, 만 오천 원입니다. 찜질복과 수건, 라커 열쇠 받으세요.'),
      DialogueLine('철수', '감사합니다. 안에서 음식 사 먹을 때는 어떻게 결제하나요?'),
      DialogueLine('영희', '라커 키로 찍고 결제하신 뒤에, 나갈 때 정산하시면 됩니다.'),
      DialogueLine('철수', '매점에는 어떤 메뉴가 있나요?'),
      DialogueLine('영희', '구운 달걀과 식혜가 제일 인기 많아요.'),
      DialogueLine('철수', '찜질방 안에 수면실과 와이파이도 있나요?'),
      DialogueLine('영희', '네, 2층에 여성 전용 수면실과 공용 휴게실이 다 있습니다.'),
      DialogueLine('철수', '친절한 설명 감사해요. 편하게 쉬다 갈게요.'),
      DialogueLine('영희', '따뜻하고 즐거운 시간 보내세요!'),
    ],
  ),
  Dialogue(
    id: 30,
    emoji: '🥐',
    titles: {
      'KO': '빵집에서 빵 고르기',
      'EN': 'Buying Bread at a Bakery',
      'VI': 'Mua bánh ở tiệm bánh',
      'ZH': '在面包店选购面包',
      'JA': 'パン屋でパンを選ぶ',
    },
    lines: [
      DialogueLine('철수', '빵 냄새가 정말 좋다! 너는 어떤 빵 좋아해?'),
      DialogueLine('영희', '나는 갓 구운 소금빵이랑 단팥빵을 좋아해.'),
      DialogueLine('철수', '여기 트레이랑 집게 챙겨. 소금빵 방금 나왔대!'),
      DialogueLine('영희', '정말? 따끈따끈해서 진짜 맛있겠다. 두 개 담을게.'),
      DialogueLine('철수', '나는 샌드위치랑 크루아상 골라야겠다.'),
      DialogueLine('영희', '식빵도 하나 살까? 내일 아침에 토스트 해 먹게.'),
      DialogueLine('철수', '그래, 우유 식빵으로 하나 담자.'),
      DialogueLine('영희', '계산하러 가자. 커피도 같이 주문할래?'),
      DialogueLine('철수', '좋아, 나는 시원한 아이스 라테 마실래.'),
      DialogueLine('영희', '내가 계산할 테니까 넌 창가 자리 잡아둬!'),
    ],
  ),
  Dialogue(
    id: 31,
    emoji: '🦷',
    titles: {
      'KO': '치과에서 정기 검진',
      'EN': 'Dental Clinic Checkup',
      'VI': 'Khám định kỳ tại nha khoa',
      'ZH': '在牙科诊所定期检查',
      'JA': '歯科で定期検診を受ける',
    },
    lines: [
      DialogueLine('철수', '안녕하세요, 3시에 스케일링 예약한 이철수입니다.'),
      DialogueLine('영희', '네, 철수 님! 진료실 2번 체어로 안내해 드릴게요.'),
      DialogueLine('철수', '스케일링할 때 많이 아픈가요? 제가 치과를 좀 무서워해서요.'),
      DialogueLine('영희', '살짝 시릴 수는 있지만 아프지 않게 조심히 해드릴게요.'),
      DialogueLine('철수', '혹시 충치가 있는지도 같이 봐주실 수 있나요?'),
      DialogueLine('영희', '네, 원장님께서 스케일링 후에 충치 검진도 꼼꼼히 해주실 거예요.'),
      DialogueLine('철수', '잇몸에서 가끔 피가 나는데 왜 그럴까요?'),
      DialogueLine('영희', '치석이 쌓이면 잇몸에 염증이 생길 수 있어요. 6개월마다 받으시는 게 좋아요.'),
      DialogueLine('철수', '그렇군요. 앞으로 정기적으로 와야겠어요.'),
      DialogueLine('영희', '네, 이제 의자 뒤로 눕혀드리겠습니다. 편하게 계세요.'),
    ],
  ),
  Dialogue(
    id: 32,
    emoji: '🍿',
    titles: {
      'KO': '영화관에서 예매와 간식',
      'EN': 'At the Movie Theater',
      'VI': 'Đặt vé và mua bỏng ngô ở rạp phim',
      'ZH': '在电影院买票和零食',
      'JA': '映画館でチケットとポップコーンを買う',
    },
    lines: [
      DialogueLine('철수', '오늘 개봉한 한국 영화 예매했어?'),
      DialogueLine('영희', '응, 키오스크에서 모바일 예매권 출력했어. 자리는 H열 중간이야!'),
      DialogueLine('철수', '자리 명당으로 잘 잡았다! 팝콘이랑 콜라 사러 갈까?'),
      DialogueLine('영희', '응! 나는 달콤한 캐러멜 팝콘 먹고 싶어.'),
      DialogueLine('철수', '좋아, 반반 팝콘으로 캐러멜이랑 어니언 맛 시키자.'),
      DialogueLine('영희', '음료는 제로 콜라로 부탁해.'),
      DialogueLine('철수', '알겠어. 영화 시작 10분 전이니까 지금 상영관 들어가자.'),
      DialogueLine('영희', '상영관 입구에서 티켓 바코드 보여줘야 해.'),
      DialogueLine('철수', '핸드폰 켜둘게. 팝콘 들고 조심히 들어가자.'),
      DialogueLine('영희', '응, 재미있겠다! 기대돼.'),
    ],
  ),
  Dialogue(
    id: 33,
    emoji: '📦',
    titles: {
      'KO': '우체국에서 EMS 보내기',
      'EN': 'Sending EMS at the Post Office',
      'VI': 'Gửi bưu phẩm EMS tại bưu điện',
      'ZH': '在邮局寄国际特快(EMS)',
      'JA': '郵便局でEMSを送る',
    },
    lines: [
      DialogueLine('철수', '어서 오세요. 어떤 우편물 보내시나요?'),
      DialogueLine('영희', '베트남에 있는 가족에게 국제특급(EMS) 택배를 보내려고요.'),
      DialogueLine('철수', '상자 안에 음식물이나 배터리 같은 위험물이 들어있나요?'),
      DialogueLine('영희', '옷이랑 김, 과자만 들어있어요. 액체류는 없습니다.'),
      DialogueLine('철수', '저울 위에 상자를 올려주세요. 무게는 3.5kg입니다.'),
      DialogueLine('영희', '도착하는 데 며칠 정도 걸리나요?'),
      DialogueLine('철수', '보통 4일에서 5일 정도 소요됩니다.'),
      DialogueLine('영희', '운송장 번호로 배송 조회가 가능한가요?'),
      DialogueLine('철수', '네, 영수증에 적힌 등기번호로 인터넷에서 실시간 조회가 가능합니다.'),
      DialogueLine('영희', '정말 다행이네요. 카드로 결제할게요.'),
    ],
  ),
  Dialogue(
    id: 34,
    emoji: '💇',
    titles: {
      'KO': '미용실에서 머리하기',
      'EN': 'Getting a Haircut at a Salon',
      'VI': 'Cắt tóc ở tiệm làm tóc',
      'ZH': '在美发沙龙理发',
      'JA': '美容室で髪を切る',
    },
    lines: [
      DialogueLine('철수', '어서 오세요! 예약하셨나요?'),
      DialogueLine('영희', '네, 2시에 커트 예약한 영희예요.'),
      DialogueLine('철수', '이쪽으로 앉으세요. 오늘 어떤 스타일로 해드릴까요?'),
      DialogueLine('영희', '끝에 상한 머리만 다듬고 층을 조금 내주세요.'),
      DialogueLine('철수', '기장은 어느 정도로 유지하고 싶으세요?'),
      DialogueLine('영희', '어깨 밑 5cm 정도로만 잘라주시면 좋겠어요. 앞머리도 살짝 다듬어주세요.'),
      DialogueLine('철수', '네, 자연스러운 느낌으로 예쁘게 잘라드릴게요.'),
      DialogueLine('영희', '샴푸 후에 드라이도 해주시나요?'),
      DialogueLine('철수', '네, 예쁘게 C컬 드라이까지 넣어드릴게요.'),
      DialogueLine('영희', '감사합니다! 기대돼요.'),
    ],
  ),
  Dialogue(
    id: 35,
    emoji: '👔',
    titles: {
      'KO': '세탁소에서 옷 맡기기',
      'EN': 'At the Dry Cleaner\'s',
      'VI': 'Gửi đồ ở tiệm giặt ủi',
      'ZH': '在洗衣店送洗衣物',
      'JA': 'クリーニング店で服を預ける',
    },
    lines: [
      DialogueLine('철수', '안녕하세요! 패딩 점퍼와 정장 드라이클리닝 맡기러 왔어요.'),
      DialogueLine('영희', '네, 정장과 패딩 먼저 상태 확인해 볼게요. 여기 소매에 얼룩이 있네요?'),
      DialogueLine('철수', '아, 커피를 조금 쏟았는데 깨끗하게 지워질까요?'),
      DialogueLine('영희', '특수 세탁으로 최대한 흔적 없이 빼드리겠습니다.'),
      DialogueLine('철수', '언제쯤 찾으러 오면 될까요?'),
      DialogueLine('영희', '모레 오후 5시 이후에 오시면 됩니다.'),
      DialogueLine('철수', '혹시 세탁 다 되면 문자나 카톡으로 알려주시나요?'),
      DialogueLine('영희', '네, 완료되면 안내 메시지 바로 보내드려요.'),
      DialogueLine('철수', '비용은 지금 결제하나요, 찾을 때 결제하나요?'),
      DialogueLine('영희', '지금 미리 선결제해 주시면 됩니다.'),
    ],
  ),
  Dialogue(
    id: 36,
    emoji: '🏛️',
    titles: {
      'KO': '주민센터에서 서류 발급',
      'EN': 'Getting Documents at Community Center',
      'VI': 'Xin giấy tờ ở trung tâm hành chính',
      'ZH': '在居民中心办理证明',
      'JA': '住民センターで書類を発行する',
    },
    lines: [
      DialogueLine('철수', '번호표 뽑으셨나요? 45번 손님 창구로 오세요.'),
      DialogueLine('영희', '안녕하세요. 외국인등록 사실증명서를 발급받으러 왔어요.'),
      DialogueLine('철수', '네, 신분증 확인을 위해 외국인등록증 주세요.'),
      DialogueLine('영희', '여기 외국인등록증 있습니다.'),
      DialogueLine('철수', '몇 통 필요하신가요?'),
      DialogueLine('영희', '비자 연장 제출용으로 한 통 필요합니다.'),
      DialogueLine('철수', '발급 수수료는 한 통당 2,000원입니다.'),
      DialogueLine('영희', '카드로 결제해도 되나요?'),
      DialogueLine('철수', '네, 앞쪽 단말기에 카드 꽂아주세요.'),
      DialogueLine('영희', '서류 바로 나오나요? 감사합니다.'),
    ],
  ),
  Dialogue(
    id: 37,
    emoji: '🚌',
    titles: {
      'KO': '버스 환승하기',
      'EN': 'Transferring Buses',
      'VI': 'Chuyển tuyến xe buýt',
      'ZH': '换乘市内公交',
      'JA': 'バスを乗り換える',
    },
    lines: [
      DialogueLine('철수', '영희야, 여기서 홍대입구역까지 어떻게 가?'),
      DialogueLine('영희', '여기서 271번 버스를 타고 가다가 신촌역에서 갈아타야 해.'),
      DialogueLine('철수', '버스에서 내릴 때도 교통카드를 찍어야 환승 할인이 되지?'),
      DialogueLine('영희', '맞아! 하차 태그를 꼭 찍어야 30분 이내에 환승 할인이 적용돼.'),
      DialogueLine('철수', '환승은 몇 번까지 가능한 거야?'),
      DialogueLine('영희', '최대 네 번까지 환승 할인을 받을 수 있어.'),
      DialogueLine('철수', '저기 우리가 탈 버스가 오고 있다!'),
      DialogueLine('영희', '앞문으로 타면서 카드 먼저 찍어.'),
      DialogueLine('철수', '자리가 없어서 서서 가야겠네. 손잡이 꽉 잡아!'),
      DialogueLine('영희', '응, 흔들리니까 조심하자.'),
    ],
  ),
  Dialogue(
    id: 38,
    emoji: '🏪',
    titles: {
      'KO': '편의점에서 택배 접수하기',
      'EN': 'Sending a Parcel at Convenience Store',
      'VI': 'Gửi bưu phẩm ở cửa hàng tiện lợi',
      'ZH': '在便利店寄快递',
      'JA': 'コンビニで宅配便を出す',
    },
    lines: [
      DialogueLine('철수', '편의점 택배 기계는 어디에 있나요?'),
      DialogueLine('영희', '계산대 옆에 있는 포스트박스 기계를 이용하시면 됩니다.'),
      DialogueLine('철수', '미리 앱으로 예약했는데 어떻게 로그인하나요?'),
      DialogueLine('영희', '회원 접수를 누르고 핸드폰 번호와 비밀번호를 입력하세요.'),
      DialogueLine('철수', '예약 내역이 떴네요! 이제 상자를 저울에 올리면 되나요?'),
      DialogueLine('영희', '네, 상자를 올려서 무게를 측정해 주세요.'),
      DialogueLine('철수', '무게 측정이 끝나고 운송장 스티커가 출력되었어요.'),
      DialogueLine('영희', '스티커 큰 쪽은 박스에 붙이시고, 바코드 부분을 카운터로 가져오세요.'),
      DialogueLine('철수', '계산대에서 배송비 결제하면 끝인가요?'),
      DialogueLine('영희', '네, 결제하시고 보관함에 상자를 넣어두시면 기사님이 수거해 가십니다.'),
    ],
  ),
  Dialogue(
    id: 39,
    emoji: '📸',
    titles: {
      'KO': '여권 사진 찍기',
      'EN': 'Taking Passport Photos',
      'VI': 'Chụp ảnh hộ chiếu',
      'ZH': '拍护照证件照',
      'JA': 'パスポート写真を撮る',
    },
    lines: [
      DialogueLine('철수', '어서 오세요! 어떤 사진 찍으러 오셨나요?'),
      DialogueLine('영희', '여권 갱신용 사진을 찍으려고요.'),
      DialogueLine('철수', '어느 나라 여권이신가요? 국가마다 규정이 조금씩 다른데, 한국 여권 규격으로 찍어 드릴까요?'),
      DialogueLine('영희', '네, 한국 여권 사진 규격에 맞춰서 찍어 주세요.'),
      DialogueLine('철수', '흰 배경이라 흰색 옷은 피해야 하고, 귀와 눈썹이 잘 보여야 해요.'),
      DialogueLine('영희', '아, 거울 보고 머리 좀 정리하고 올게요. 준비 다 됐습니다!'),
      DialogueLine('철수', '의자에 허리를 펴고 앉으시고 턱을 살짝만 당겨주세요.'),
      DialogueLine('영희', '촬영할 때 살짝 웃어도 되나요?'),
      DialogueLine('철수', '여권 사진은 치아가 보이지 않게 입을 다물고 무표정으로 찍어야 해요. 자, 찍습니다! 하나, 둘, 셋!'),
      DialogueLine('영희', '사진 인화하는 데 시간 얼마나 걸려요?'),
    ],
  ),
  Dialogue(
    id: 40,
    emoji: '🤝',
    titles: {
      'KO': '중고 직거래하기',
      'EN': 'Second-hand Direct Trading',
      'VI': 'Giao dịch đồ cũ trực tiếp',
      'ZH': '二手物品线下交易',
      'JA': '中古品の直接取引をする',
    },
    lines: [
      DialogueLine('철수', '당근마켓에서 전공 서적 구매하기로 한 분 맞으시죠?'),
      DialogueLine('영희', '네, 맞아요! 3번 출구 앞 빨간 패딩 입고 계신 분이죠?'),
      DialogueLine('철수', '네, 반갑습니다! 책 여기 있습니다. 상태 한번 확인해 보세요.'),
      DialogueLine('영희', '와, 필기도 거의 없고 책이 정말 깨끗하네요!'),
      DialogueLine('철수', '한 학기 동안 조심히 봐서 거의 새 책이에요.'),
      DialogueLine('영희', '거래 금액이 2만 원 맞죠? 현금으로 드릴까요, 계좌로 보내드릴까요?'),
      DialogueLine('철수', '편하신 대로 해주세요. 계좌이체도 괜찮습니다.'),
      DialogueLine('영희', '지금 바로 입금해 드렸어요. 확인해 보시겠어요?'),
      DialogueLine('철수', '네, 입금 확인되었습니다. 공부 열심히 하세요!'),
      DialogueLine('영희', '친절한 거래 감사드립니다. 조심히 들어가세요!'),
    ],
  ),
  Dialogue(
    id: 41,
    emoji: '🎂',
    titles: {
      'KO': '생일 축하하기',
      'EN': 'Celebrating a Birthday',
      'VI': 'Chúc mừng sinh nhật',
      'ZH': '庆祝生日',
      'JA': '誕生日を祝う',
    },
    lines: [
      DialogueLine('철수', '영희야, 생일 축하해! 이거 네 생일 선물이야.'),
      DialogueLine('영희', '와, 철수야! 기억하고 있었어? 정말 감동이야!'),
      DialogueLine('철수', '예전부터 갖고 싶어 했던 예쁜 다이어리랑 만년필이야.'),
      DialogueLine('영희', '내가 정말 필요했던 건데! 고마워, 소중하게 잘 쓸게.'),
      DialogueLine('철수', '우리 같이 케이크 초 불자. 불 끄기 전에 소원 먼저 빌어!'),
      DialogueLine('영희', '음... 올해 한국어 시험 꼭 합격하게 해달라고 빌었어!'),
      DialogueLine('철수', '하하, 열심히 공부했으니까 넌 꼭 합격할 거야!'),
      DialogueLine('영희', '맛있는 케이크랑 커피 같이 먹자. 내가 잘라줄게.'),
      DialogueLine('철수', '오늘 가장 행복하고 특별한 하루 보내!'),
      DialogueLine('영희', '축하해 줘서 정말 고마워, 철수야!'),
    ],
  ),
  Dialogue(
    id: 42,
    emoji: '🍱',
    titles: {
      'KO': '도시락 고르기',
      'EN': 'Choosing a Lunch Box',
      'VI': 'Chọn cơm hộp',
      'ZH': '挑选便当',
      'JA': 'お弁当を選ぶ',
    },
    lines: [
      DialogueLine('철수', '어서 오세요. 어떤 도시락을 찾으세요?'),
      DialogueLine('영희', '고기가 없는 도시락이 있어요?'),
      DialogueLine('철수', '네, 이 도시락에는 밥과 채소, 달걀이 들어 있어요.'),
      DialogueLine('영희', '좋아요. 이걸로 하나 주세요.'),
      DialogueLine('철수', '지금 데워 드릴까요?'),
      DialogueLine('영희', '아니요, 집에 가서 먹을 거예요.'),
      DialogueLine('철수', '네, 여기 있습니다.'),
      DialogueLine('영희', '감사합니다.'),
    ],
  ),
  Dialogue(
    id: 43,
    emoji: '🍵',
    titles: {
      'KO': '카페에서 컵 바꾸기',
      'EN': 'Changing a Cup at a Café',
      'VI': 'Đổi cốc ở quán cà phê',
      'ZH': '在咖啡店换杯子',
      'JA': 'カフェでカップを替えてもらう',
    },
    lines: [
      DialogueLine('철수', '실례합니다. 컵이 조금 더러워요.'),
      DialogueLine('영희', '죄송합니다. 새 컵으로 바꿔 드릴게요.'),
      DialogueLine('철수', '감사합니다. 물도 조금 주실 수 있어요?'),
      DialogueLine('영희', '네, 차가운 물로 드릴까요?'),
      DialogueLine('철수', '아니요, 따뜻한 물로 주세요.'),
      DialogueLine('영희', '네, 새 컵과 따뜻한 물 여기 있습니다.'),
      DialogueLine('철수', '감사합니다.'),
      DialogueLine('영희', '불편하게 해 드려서 죄송합니다.'),
    ],
  ),
  Dialogue(
    id: 44,
    emoji: '🚌',
    titles: {
      'KO': '버스 정류장 확인하기',
      'EN': 'Finding the Right Bus Stop',
      'VI': 'Tìm đúng trạm xe buýt',
      'ZH': '确认公交车站',
      'JA': 'バス停を確認する',
    },
    lines: [
      DialogueLine('철수', '실례합니다. 여기서 시청 가는 버스를 타요?'),
      DialogueLine('영희', '아니요, 길 건너편에서 타세요.'),
      DialogueLine('철수', '저쪽 정류장 말씀이세요?'),
      DialogueLine('영희', '네, 빵집 앞에 있는 정류장이에요.'),
      DialogueLine('철수', '어디에서 길을 건너면 돼요?'),
      DialogueLine('영희', '오른쪽에 횡단보도가 있어요.'),
      DialogueLine('철수', '알려 주셔서 감사합니다.'),
      DialogueLine('영희', '네, 조심히 가세요.'),
    ],
  ),
  Dialogue(
    id: 45,
    emoji: '🚶',
    titles: {
      'KO': '걸어서 약속 장소 가기',
      'EN': 'Walking to a Meeting Place',
      'VI': 'Đi bộ đến điểm hẹn',
      'ZH': '步行前往见面地点',
      'JA': '待ち合わせ場所まで歩く',
    },
    lines: [
      DialogueLine('철수', '지금 어디예요?'),
      DialogueLine('영희', '도서관 앞에 있어요. 카페가 가까워요?'),
      DialogueLine('철수', '네, 걸어서 오 분쯤 걸려요.'),
      DialogueLine('영희', '어느 쪽으로 가요?'),
      DialogueLine('철수', '도서관에서 나와서 왼쪽으로 오세요.'),
      DialogueLine('영희', '카페 옆에 뭐가 있어요?'),
      DialogueLine('철수', '꽃집이 있어요. 제가 카페 앞에서 기다릴게요.'),
      DialogueLine('영희', '네, 곧 갈게요.'),
    ],
  ),
  Dialogue(
    id: 46,
    emoji: '🔌',
    titles: {
      'KO': '충전기 빌리기',
      'EN': 'Borrowing a Charger',
      'VI': 'Mượn bộ sạc',
      'ZH': '借充电器',
      'JA': '充電器を借りる',
    },
    lines: [
      DialogueLine('철수', '휴대폰 배터리가 거의 없어요.'),
      DialogueLine('영희', '제 충전기를 빌려 드릴까요?'),
      DialogueLine('철수', '네, 잠깐 빌려도 돼요?'),
      DialogueLine('영희', '그럼요. 여기 있어요.'),
      DialogueLine('철수', '고마워요. 어디에 꽂으면 돼요?'),
      DialogueLine('영희', '책상 아래에 콘센트가 있어요.'),
      DialogueLine('철수', '다 쓰고 바로 돌려드릴게요.'),
      DialogueLine('영희', '네, 천천히 쓰세요.'),
    ],
  ),
  Dialogue(
    id: 47,
    emoji: '🏠',
    titles: {
      'KO': '집에 친구 초대하기',
      'EN': 'Inviting a Friend Home',
      'VI': 'Mời bạn đến nhà',
      'ZH': '邀请朋友来家里',
      'JA': '友達を家に招く',
    },
    lines: [
      DialogueLine('철수', '토요일에 우리 집에 놀러 올래요?'),
      DialogueLine('영희', '좋아요. 몇 시에 갈까요?'),
      DialogueLine('철수', '오후 두 시는 어때요?'),
      DialogueLine('영희', '괜찮아요. 집이 어디예요?'),
      DialogueLine('철수', '학교 앞 편의점 옆 건물이에요.'),
      DialogueLine('영희', '제가 간식을 좀 가져갈게요.'),
      DialogueLine('철수', '고마워요. 저는 차를 준비할게요.'),
      DialogueLine('영희', '네, 토요일에 봐요.'),
    ],
  ),
  Dialogue(
    id: 48,
    emoji: '📚',
    titles: {
      'KO': '도서관에서 반납 장소 묻기',
      'EN': 'Returning a Library Book',
      'VI': 'Hỏi nơi trả sách ở thư viện',
      'ZH': '询问图书馆还书地点',
      'JA': '図書館で返却場所を聞く',
    },
    lines: [
      DialogueLine('철수', '안녕하세요. 이 책을 반납하려고요.'),
      DialogueLine('영희', '네, 책을 여기 올려 주세요.'),
      DialogueLine('철수', '다음에는 밖에 있는 반납함에 넣어도 돼요?'),
      DialogueLine('영희', '네, 도서관이 닫혀 있을 때는 거기에 넣으세요.'),
      DialogueLine('철수', '오늘은 몇 시에 문을 닫아요?'),
      DialogueLine('영희', '오늘은 오후 여섯 시에 닫아요.'),
      DialogueLine('철수', '네, 알려 주셔서 감사합니다.'),
      DialogueLine('영희', '안녕히 가세요.'),
    ],
  ),
  Dialogue(
    id: 49,
    emoji: '🧑‍🏫',
    titles: {
      'KO': '한국어 수업 준비하기',
      'EN': 'Preparing for Korean Class',
      'VI': 'Chuẩn bị cho lớp tiếng Hàn',
      'ZH': '准备韩语课',
      'JA': '韓国語の授業の準備',
    },
    lines: [
      DialogueLine('철수', '안녕하세요. 오늘 처음 수업을 들어요.'),
      DialogueLine('영희', '반가워요. 이름이 어떻게 되세요?'),
      DialogueLine('철수', '저는 민수예요. 어디에 앉으면 돼요?'),
      DialogueLine('영희', '창문 옆 빈자리에 앉으세요.'),
      DialogueLine('철수', '책은 몇 쪽을 펴요?'),
      DialogueLine('영희', '십 쪽을 펴세요. 공책도 준비해 주세요.'),
      DialogueLine('철수', '네, 연필로 써도 돼요?'),
      DialogueLine('영희', '그럼요. 연필로 쓰세요.'),
    ],
  ),
  Dialogue(
    id: 50,
    emoji: '🤒',
    titles: {
      'KO': '몸이 안 좋아 약속 바꾸기',
      'EN': 'Rescheduling When Feeling Unwell',
      'VI': 'Đổi lịch hẹn vì không khỏe',
      'ZH': '因身体不适更改约定',
      'JA': '体調が悪くて約束を変更する',
    },
    lines: [
      DialogueLine('철수', '미안해요. 오늘은 만나기 어려울 것 같아요.'),
      DialogueLine('영희', '무슨 일 있어요?'),
      DialogueLine('철수', '몸이 좀 안 좋아요. 집에서 쉬려고요.'),
      DialogueLine('영희', '알겠어요. 오늘은 푹 쉬세요.'),
      DialogueLine('철수', '고마워요. 다음 주에 만나도 될까요?'),
      DialogueLine('영희', '네, 괜찮아요. 괜찮아지면 연락해 주세요.'),
      DialogueLine('철수', '네, 다시 연락할게요.'),
      DialogueLine('영희', '무리하지 말고 잘 쉬세요.'),
    ],
  ),
  Dialogue(
    id: 51,
    emoji: '🧢',
    titles: {
      'KO': '잃어버린 모자 찾기',
      'EN': 'Looking for a Lost Hat',
      'VI': 'Tìm mũ bị mất',
      'ZH': '寻找丢失的帽子',
      'JA': 'なくした帽子を探す',
    },
    lines: [
      DialogueLine('철수', '실례합니다. 여기 모자 두고 간 것 없나요?'),
      DialogueLine('영희', '어떤 색 모자예요?'),
      DialogueLine('철수', '파란색이에요. 앞에 하얀 글씨가 있어요.'),
      DialogueLine('영희', '혹시 이 모자예요?'),
      DialogueLine('철수', '네, 제 모자예요. 어디에 있었어요?'),
      DialogueLine('영희', '창가 의자 위에 있었어요.'),
      DialogueLine('철수', '찾아 주셔서 정말 감사합니다.'),
      DialogueLine('영희', '다행이네요. 여기 있습니다.'),
    ],
  ),
];

/// A copy so sorting never changes source IDs or recorded-audio mappings.
List<Dialogue> get dialoguesInLearningOrder => List<Dialogue>.from(dialogues)
  ..sort((a, b) {
    final order = LearningOrder.dialoguePriority(a.id)
        .compareTo(LearningOrder.dialoguePriority(b.id));
    return order != 0 ? order : a.id.compareTo(b.id);
  });
