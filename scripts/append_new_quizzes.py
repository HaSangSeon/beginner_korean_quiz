import json
import re

raw_items = [
  {
    "type": "sentence",
    "category": "핵심표현·의사소통",
    "level": 1,
    "visual": "🪟 🥵",
    "keyword": "열다",
    "speechBubble": "창문 좀 열어 주세요.",
    "situations": {
      "KO": "방 안이 더워서 상대방에게 창문을 열어 달라고 정중하게 부탁하는 상황입니다.",
      "EN": "A situation where you politely ask someone to open the window because the room is hot.",
      "VI": "Tình huống nhờ đối phương mở cửa sổ một cách lịch sự vì trong phòng nóng.",
      "ZH": "房间里很热，礼貌地拜托对方打开窗户的情况。",
      "JA": "部屋の中が暑くて、相手に窓を開けてほしいと丁寧にお願いする場面です。"
    },
    "questions": {
      "KO": "가: 더워요? 창문을 열어 줄까요?\n나: 네, 창문 좀 (   )."
    },
    "options": [
      "열어 주세요",
      "열어 가세요",
      "열고 있어요",
      "열지 마세요"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "동사 뒤에 '-아/어 주세요'를 붙여 상대방에게 어떤 행동을 해 달라고 정중하게 요청할 수 있습니다. '열다'의 어간 모음이 'ㅕ'이므로 '열어 주세요'가 됩니다.",
      "EN": "Attach '-아/어 주세요' after a verb to politely request someone to do an action. Since the vowel of the stem '열-' is 'ㅕ', it becomes '열어 주세요'.",
      "VI": "Gắn '-아/어 주세요' sau động từ để yêu cầu ai đó làm việc gì một cách lịch sự. Vì nguyên âm gốc của '열다' là 'ㅕ' nên chia thành '열어 주세요'.",
      "ZH": "在动词后加上'-아/어 주세요'，表示礼貌地请求对方做某事。因为'열다'词干的元音是'ㅕ'，所以变成'열어 주세요'。",
      "JA": "動詞の後に「-아/어 주세요」をつけて、相手に何かをしてほしいと丁寧にお願いすることができます。「열다」の語幹の母音が「ㅕ」なので「열어 주세요」になります。"
    }
  },
  {
    "type": "sentence",
    "category": "핵심표현·의사소통",
    "level": 1,
    "visual": "🎂 🛍️",
    "keyword": "사다",
    "speechBubble": "딸기 케이크를 사 주세요.",
    "situations": {
      "KO": "무엇을 사 줄지 묻는 상대방에게 딸기 케이크를 사 달라고 요청하는 상황입니다.",
      "EN": "A situation where someone asks what to buy for you, and you ask them to buy a strawberry cake.",
      "VI": "Tình huống đối phương hỏi mua gì cho bạn và bạn nhờ họ mua bánh kem dâu tây.",
      "ZH": "对方问要给你买什么，你请求对方买草莓蛋糕的情况。",
      "JA": "何を買ってあげようかと聞く相手に、イチゴのケーキを買ってほしいとお願いする場面です。"
    },
    "questions": {
      "KO": "가: 뭘 사 줄까요?\n나: 딸기 케이크를 (   )."
    },
    "options": [
      "사 주세요",
      "사 볼게요",
      "사 드세요",
      "사 오세요"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "상대방이 '뭘 사 줄까요?'라고 도움을 제안했을 때, '사다'에 요청 표현 '-아/어 주세요'를 결합해 '사 주세요'라고 답합니다.",
      "EN": "When someone offers help by asking '뭘 사 줄까요?' (What shall I buy for you?), combine '사다' (to buy) with '-아/어 주세요' to form '사 주세요'.",
      "VI": "Khi đối phương đề nghị giúp đỡ bằng câu '뭘 사 줄까요?', hãy kết hợp '사다' với '-아/어 주세요' để trả lời là '사 주세요'.",
      "ZH": "当对方问'뭘 사 줄까요?'（要我给你买什么吗？）时，将'사다'与请求表达'-아/어 주세요'结合，回答'사 주세요'。",
      "JA": "相手が「뭘 사 줄까요?（何を買ってあげましょうか？）」と申し出た時、「사다（買う）」に依頼表現の「-아/어 주세요」を組み合わせて「사 주세요」と答えます。"
    }
  },
  {
    "type": "sentence",
    "category": "핵심표현·의사소통",
    "level": 2,
    "visual": "📷 🤝",
    "keyword": "돕다",
    "speechBubble": "무엇을 도와줄까요?",
    "situations": {
      "KO": "상대방에게 어떤 도움을 줄지 물어보고 사진을 찍어 달라고 부탁받는 상황입니다.",
      "EN": "A situation where you ask how you can help someone, and they ask you to take a photo.",
      "VI": "Tình huống bạn hỏi có thể giúp gì cho đối phương và được nhờ chụp ảnh giúp.",
      "ZH": "询问对方需要什么帮助，对方拜托拍照的情况。",
      "JA": "相手に何を手伝おうかと尋ね、写真を撮ってほしいと頼まれる場面です。"
    },
    "questions": {
      "KO": "가: 무엇을 (   )?\n나: 사진을 찍어 주세요."
    },
    "options": [
      "도와줄까요",
      "도와주세요",
      "돕어 줄까요",
      "도와 드세요"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "'돕다'는 'ㅂ' 불규칙 동사로, 모음 어미 '-아/어' 앞에서 'ㅂ'이 '오'로 바뀌어 '도와'가 됩니다. 상대방에게 도움을 제안할 때는 '도와줄까요?'라고 표현합니다.",
      "EN": "'돕다' (to help) is a 'ㅂ' irregular verb. Before a vowel ending like '-아/어', 'ㅂ' changes to '오', becoming '도와'. To offer help, say '도와줄까요?'.",
      "VI": "'돕다' là động từ bất quy tắc 'ㅂ'. Trước đuôi từ bắt đầu bằng nguyên âm '-아/어', 'ㅂ' chuyển thành '오' tạo thành '도와'. Khi đề nghị giúp đỡ, dùng '도와줄까요?'.",
      "ZH": "'돕다'（帮助）是'ㅂ'不规则动词，在元音词尾'-아/어'前，'ㅂ'变成'오'，成为'도와'。主动提出帮助时使用'도와줄까요?'。",
      "JA": "「돕다（手伝う）」は「ㅂ」不規則動詞で、母音語尾「-아/어」の前で「ㅂ」が「오」に変わり「도와」になります。手助けを申し出る時は「도와줄까요?」と表現します。"
    }
  },
  {
    "type": "sentence",
    "category": "핵심표현·의사소통",
    "level": 2,
    "visual": "🎧 🗣️",
    "keyword": "듣다",
    "speechBubble": "잘 들어 주세요.",
    "situations": {
      "KO": "발표나 설명을 하면서 상대방에게 이야기를 잘 들어 달라고 요청하는 상황입니다.",
      "EN": "A situation where you ask someone to listen carefully during a presentation or explanation.",
      "VI": "Tình huống yêu cầu đối phương lắng nghe kỹ khi đang thuyết trình hoặc giải thích.",
      "ZH": "在发表或说明时，请对方仔细倾听的情况。",
      "JA": "発表や説明をしながら、相手に話をよく聞いてほしいとお願いする場面です。"
    },
    "questions": {
      "KO": "가: 지금부터 안내 말씀을 드리겠습니다. 잘 (   ).\n나: 네, 알겠습니다."
    },
    "options": [
      "들어 주세요",
      "듣어 주세요",
      "들아 주세요",
      "듣고 주세요"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "'듣다'는 'ㄷ' 불규칙 동사입니다. 어간 뒤에 모음으로 시작하는 '-어 주세요'가 오면 받침 'ㄷ'이 'ㄹ'로 바뀌어 '들어 주세요'가 됩니다.",
      "EN": "'듣다' (to listen) is a 'ㄷ' irregular verb. When followed by a vowel ending like '-어 주세요', the final consonant 'ㄷ' changes to 'ㄹ', becoming '들어 주세요'.",
      "VI": "'듣다' (nghe) là động từ bất quy tắc 'ㄷ'. Khi theo sau là đuôi từ bắt đầu bằng nguyên âm như '-어 주세요', phụ âm cuối 'ㄷ' chuyển thành 'ㄹ', thành '들어 주세요'.",
      "ZH": "'듣다'（听）是'ㄷ'不规则动词。当词干后接以元音开头的'-어 주세요'时，收音'ㄷ'变成'ㄹ'，成为'들어 주세요'。",
      "JA": "「듣다（聞く）」は「ㄷ」不規則動詞です。語幹の後に母音で始まる「-어 주세요」が来ると、パッチム「ㄷ」が「ㄹ」に変わり「들어 주세요」になります。"
    }
  },
  {
    "type": "sentence",
    "category": "식당·외식·이동",
    "level": 1,
    "visual": "🏠 🚶",
    "keyword": "집",
    "speechBubble": "집으로 가요.",
    "situations": {
      "KO": "어디로 이동하는지 방향이나 목적지를 묻고 답하는 상황입니다.",
      "EN": "A situation of asking and answering about the direction or destination you are heading to.",
      "VI": "Tình huống hỏi và trả lời về phương hướng hoặc điểm đến đang di chuyển.",
      "ZH": "询问并回答移动方向或目的地的情况。",
      "JA": "どこへ移動するのか、方向や目的地を尋ねて答える場面です。"
    },
    "questions": {
      "KO": "가: 지금 어디로 가요?\n나: (   ) 가요."
    },
    "options": [
      "집으로",
      "집로",
      "집에서",
      "집을"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "이동의 방향이나 목적지를 나타낼 때는 장소 명사 뒤에 조사 '-(으)로'를 씁니다. '집'은 받침이 있으므로 '집으로'가 맞습니다.",
      "EN": "Use the particle '-(으)로' after a place noun to indicate the direction or destination of movement. Since '집' ends in a consonant, '집으로' is correct.",
      "VI": "Dùng tiểu từ '-(으)로' sau danh từ chỉ địa điểm để biểu thị phương hướng hoặc điểm đến. Vì '집' có phụ âm cuối nên dùng '집으로'.",
      "ZH": "表示移动的方向或目的地时，在场所名词后使用助词'-(으)로'。因为'집'有收音，所以用'집으로'。",
      "JA": "移動の方向や目的地を表す時は、場所の名詞の後に助詞「-(으)로」を使います。「집」はパッチムがあるため「집으로」が正しいです。"
    }
  },
  {
    "type": "sentence",
    "category": "식당·외식·이동",
    "level": 1,
    "visual": "✈️ 🌴",
    "keyword": "제주도",
    "speechBubble": "제주도로 여행 가요.",
    "situations": {
      "KO": "어디로 여행을 가는지 목적지를 묻고 답하는 상황입니다.",
      "EN": "A situation where two people ask and answer about their travel destination.",
      "VI": "Tình huống hỏi và trả lời về địa điểm sẽ đi du lịch.",
      "ZH": "询问并回答去哪里旅行的情况。",
      "JA": "どこへ旅行に行くのか目的地を尋ねて答える場面です。"
    },
    "questions": {
      "KO": "가: 이번 휴가에 어디로 여행 가요?\n나: (   ) 여행 가요."
    },
    "options": [
      "제주도로",
      "제주도으로",
      "제주도를",
      "제주도에서"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "방향이나 목적지를 나타내는 조사 '-(으)로'는 받침이 없는 명사나 'ㄹ' 받침 명사 뒤에서 '로'로 결합합니다. '제주도'는 받침이 없으므로 '제주도로'가 됩니다.",
      "EN": "The direction particle '-(으)로' attaches as '로' after nouns ending in a vowel or the consonant 'ㄹ'. Since '제주도' has no final consonant, it becomes '제주도로'.",
      "VI": "Tiểu từ chỉ phương hướng '-(으)로' kết hợp thành '로' sau danh từ không có 받침 hoặc có 받침 'ㄹ'. Vì '제주도' không có phụ âm cuối nên thành '제주도로'.",
      "ZH": "表示方向或目的地的助词'-(으)로'在没有收音或收音为'ㄹ'的名词后写作'로'。因为'제주도'没有收音，所以是'제주도로'。",
      "JA": "方向や目的地を表す助詞「-(으)로」は、パッチムがない名詞や「ㄹ」パッチムの名詞の後に「로」がつきます。「제주도」はパッチムがないので「제주도로」になります。"
    }
  },
  {
    "type": "sentence",
    "category": "일상생활·장소",
    "level": 1,
    "visual": "🎒 🙋",
    "keyword": "가방",
    "speechBubble": "줄리앙의 가방입니다.",
    "situations": {
      "KO": "가방의 주인이 누구인지 물어보고 대답하는 상황입니다.",
      "EN": "A situation where you ask and answer who owns a bag.",
      "VI": "Tình huống hỏi và trả lời xem chủ nhân của chiếc cặp là ai.",
      "ZH": "询问并回答包的主人是谁的情况。",
      "JA": "かばんの持ち主が誰なのかを尋ねて答える場面です。"
    },
    "questions": {
      "KO": "가: 이거는 누구의 가방입니까?\n나: (   ) 가방입니다."
    },
    "options": [
      "줄리앙의",
      "줄리앙을",
      "줄리앙에",
      "줄리앙으로"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "명사와 명사 사이에서 소유 관계를 나타낼 때는 조사 '의'를 사용합니다. 줄리앙이 소유한 가방이므로 '줄리앙의 가방'이라고 표현합니다.",
      "EN": "Use the particle '의' between two nouns to express possession. Since the bag belongs to Julian, say '줄리앙의 가방' (Julian's bag).",
      "VI": "Khi biểu thị quan hệ sở hữu giữa danh từ và danh từ, ta dùng tiểu từ '의'. Vì là chiếc cặp của Julian nên nói là '줄리앙의 가방'.",
      "ZH": "在名词和名词之间表示所属关系时使用助词'의'。因为是朱利安的包，所以表达为'줄리앙의 가방'。",
      "JA": "名詞と名詞の間で所有関係を表す時は助詞「의（〜の）」を使います。ジュリアンの所有するかばんなので「줄리앙의 가방」と表現します。"
    }
  },
  {
    "type": "sentence",
    "category": "핵심표현·의사소통",
    "level": 1,
    "visual": "⌚ 🙋‍♂️",
    "keyword": "시계",
    "speechBubble": "네, 제 시계예요.",
    "situations": {
      "KO": "상대방이 내 물건이 맞는지 물어봤을 때 내 것이 맞다고 대답하는 상황입니다.",
      "EN": "A situation where someone asks if an item is yours, and you confirm that it is yours.",
      "VI": "Tình huống đối phương hỏi món đồ có phải của bạn không và bạn xác nhận đó là đồ của mình.",
      "ZH": "对方询问物品是不是你的，你回答确实是自己的东西的情况。",
      "JA": "相手が自分の持ち物かどうかを尋ねた時、自分のものだと答える場面です。"
    },
    "questions": {
      "KO": "가: 스티븐 씨, 이거 스티븐 씨 시계예요?\n스티븐: 네, (   ) 시계예요."
    },
    "options": [
      "제",
      "저를",
      "제가",
      "저에"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "격식 있거나 정중한 자리에서 '나의'를 낮추어 말할 때는 '저의'의 줄임말인 '제'를 명사 앞에 붙여 '제 시계'라고 말합니다.",
      "EN": "In polite conversation, to humble '나의' (my), place '제' (contraction of '저의') before the noun, as in '제 시계' (my watch).",
      "VI": "Trong giao tiếp lịch sự, để khiêm nhường hóa từ '나의' (của tôi), hãy dùng '제' (dạng rút gọn của '저의') trước danh từ như '제 시계'.",
      "ZH": "在礼貌场合将'나의'（我的）谦称时，在名词前加上'저의'的缩略形'제'，说成'제 시계'（我的手表）。",
      "JA": "丁寧な場面で「나의（私の）」をへりくだって言う時は、「저의」の縮約形である「제」を名詞の前につけて「제 시계（私の時計）」と言います。"
    }
  }
]

def main():
    json_path = 'assets/data/questions.json'
    dart_path = 'lib/data/quiz_data.dart'

    with open(json_path, 'r', encoding='utf-8') as f:
        existing = json.load(f)

    start_id = max(q['id'] for q in existing) + 1
    print(f"Adding questions starting from ID {start_id}...")

    new_questions = []
    dart_blocks = []

    for i, it in enumerate(raw_items):
        qid = start_id + i
        item_dict = {
            "id": qid,
            "category": it["category"],
            "type": it["type"],
            "level": it["level"],
            "visual": it["visual"],
            "keyword": it["keyword"],
            "speechBubble": it["speechBubble"],
            "situations": it["situations"],
            "questions": it["questions"],
            "options": it["options"],
            "answerIndex": it["answerIndex"],
            "explanations": it["explanations"],
        }
        new_questions.append(item_dict)

        # Build Dart block
        situations_dart = ",\n".join([f'      "{k}": {json.dumps(v, ensure_ascii=False)}' for k, v in it["situations"].items()])
        questions_dart = ",\n".join([f'      "{k}": {json.dumps(v, ensure_ascii=False)}' for k, v in it["questions"].items()])
        options_dart = ", ".join([json.dumps(opt, ensure_ascii=False) for opt in it["options"]])
        explanations_dart = ",\n".join([f'      "{k}": {json.dumps(v, ensure_ascii=False)}' for k, v in it["explanations"].items()])

        dart_code = f'''  QuizQuestion(
    id: {qid},
    category: "{it["category"]}",
    type: "{it["type"]}",
    level: {it["level"]},
    visual: "{it["visual"]}",
    keyword: "{it["keyword"]}",
    speechBubble: "{it["speechBubble"]}",
    situations: {{
{situations_dart},
    }},
    questions: {{
{questions_dart},
    }},
    options: [{options_dart}],
    answerIndex: {it["answerIndex"]},
    explanations: {{
{explanations_dart},
    }},
  ),'''
        dart_blocks.append(dart_code)

    # 1. Update questions.json
    all_questions = existing + new_questions
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(all_questions, f, ensure_ascii=False, indent=2)
    print(f"Updated {json_path}: Total questions is now {len(all_questions)}")

    # 2. Update quiz_data.dart
    with open(dart_path, 'r', encoding='utf-8') as f:
        dart_content = f.read()

    last_bracket = dart_content.rfind('];')
    if last_bracket == -1:
        raise ValueError("Could not find ]; in quiz_data.dart")

    new_dart_content = dart_content[:last_bracket] + "\n".join(dart_blocks) + "\n" + dart_content[last_bracket:]
    with open(dart_path, 'w', encoding='utf-8') as f:
        f.write(new_dart_content)
    print(f"Updated {dart_path} with {len(dart_blocks)} new Dart QuizQuestion instances.")

if __name__ == '__main__':
    main()
