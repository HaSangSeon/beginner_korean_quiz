import json

new_40 = [
  # 561
  {
    "id": 561,
    "category": "핵심표현·의사소통",
    "type": "sentence",
    "level": 1,
    "visual": "🧳 🤝",
    "speechBubble": "무거운 여행 가방을 좀 들어 주세요.",
    "keyword": "들어 주세요",
    "situations": {
      "KO": "계단을 올라갈 때 짐이 너무 무거워 지나가는 사람이나 친구에게 도움을 정중하게 요청하는 상황입니다.",
      "EN": "Politely asking someone for assistance to help carry a heavy travel suitcase up the stairs.",
      "VI": "Nhờ người khác giúp đỡ mang hộ chiếc vali du lịch nặng khi đang bước lên cầu thang.",
      "ZH": "上楼梯时行李太重，礼貌请求路人或朋友帮忙拎一下箱子的场景。",
      "JA": "階段を上がる時に荷物が重すぎて、通りがかりの人や友達に手伝いを頼む場面です。"
    },
    "questions": {
      "KO": "가: 짐이 너무 무거워서 계단을 올라가기 힘들어요. 실례지만 이 캐리어 좀 (   )?\n나: 네, 제가 위층까지 같이 들어드릴게요."
    },
    "options": ["들어 주지 마세요", "들어 주세요", "들지 마세요", "들고 싶어요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "다른 사람에게 자신을 도와줄 것을 공손하게 요청할 때는 '-아/어 주다'에 '-(으)세요'를 붙여 '들어 주세요'라고 말해요!",
      "EN": "Use '-아/어 주세요' to politely ask someone for help or a favor: '들어 주세요' (Please help lift/carry it)!",
      "VI": "Dùng '-아/어 주세요' khi lịch sự nhờ vả ai đó giúp đỡ mình: '들어 주세요' (Xin hãy xách hộ tôi với ạ)!",
      "ZH": "礼貌请求他人给予帮助时使用'-아/어 주세요'，'들어 주세요'表示'请帮我拎一下'！",
      "JA": "他人に手助けを丁寧に頼む時は「-아/어 주세요」を使い、「들어 주세요（持ってください・運んでください）」と言います！"
    }
  },
  # 562
  {
    "id": 562,
    "category": "식당·외식·이동",
    "type": "sentence",
    "level": 1,
    "visual": "☕ 🚶",
    "speechBubble": "시원한 커피를 마시러 카페에 가요.",
    "keyword": "마시러",
    "situations": {
      "KO": "점심 식사 후 갈증을 해소하고 잠을 깨우기 위해 카페로 이동하는 목적을 밝히는 상황입니다.",
      "EN": "Stating the purpose of heading to a café to grab an iced coffee after lunch.",
      "VI": "Nói về mục đích đi tới quán cà phê sau bữa trưa để uống cà phê mát lạnh.",
      "ZH": "说明午餐后前往咖啡厅喝冰咖啡提神的目的。",
      "JA": "昼食後に喉を潤し眠気を覚ますためカフェへ行く目的を説明する場面です。"
    },
    "questions": {
      "KO": "가: 민수 씨, 식사하고 어디 가세요?\n나: 오후에 마실 아이스 아메리카노 한 잔 (   ) 회사 앞 카페에 다녀오려고요."
    },
    "options": ["마시기 때문에", "마시러", "마시면서", "마신 후에"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 장소로 이동하는 목적을 나타낼 때는 동사 뒤에 '-(으)러'를 붙여요. '마시다'에 받침이 없으므로 '마시러'가 정답입니다.",
      "EN": "Use '-(으)러' attached to a verb to express the purpose of going somewhere: '마시러' (in order to drink)!",
      "VI": "Dùng '-(으)러' gắn sau động từ để chỉ mục đích di chuyển đến một nơi nào đó: '마시러' (để uống)!",
      "ZH": "表示前往某处目的时在动词后接'-(으)러'。'마시다'无收音，接'러'变为'마시러'（为了喝）！",
      "JA": "ある場所へ移動する目的を表す時は動詞に「-(으)러」をつけます。「마시다」には「마시러（飲みに）」がつきます。"
    }
  },
  # 563
  {
    "id": 563,
    "category": "음식·음료",
    "type": "sentence",
    "level": 1,
    "visual": "🍳 ❓",
    "speechBubble": "매운 닭볶음탕을 만들 줄 몰라요.",
    "keyword": "만들 줄 몰라요",
    "situations": {
      "KO": "요리 경험이나 조리법에 대한 지식이 없어 특정 한식 요리를 직접 만들 수 없다고 말하는 상황입니다.",
      "EN": "Explaining that you do not know how to cook a specific spicy Korean dish.",
      "VI": "Nói rằng mình không biết cách nấu món gà xào cay Hàn Quốc do thiếu kinh nghiệm nấu nướng.",
      "ZH": "表示自己缺乏烹饪经验，不知道该怎么做辣炒鸡汤这道韩国料理。",
      "JA": "作り方の知識がなく特定の韓国料理を自分で作ることができないと話す場面です。"
    },
    "questions": {
      "KO": "가: 지우 씨는 한국 요리 중에 매운 닭볶음탕 직접 요리해 봤어요?\n나: 아니요, 요리법을 몰라서 아직 집에서 (   ). 그냥 식당에서 사 먹어요."
    },
    "options": ["만들 줄 알아요", "만들 줄 몰라요", "만들고 싶어요", "만들기 쉬워요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 일을 하는 방법이나 능력이 없음을 나타낼 때는 '-(으)ㄹ 줄 모르다'를 써서 '만들 줄 몰라요'라고 답해요!",
      "EN": "Use '-(으)ㄹ 줄 모르다' to express not knowing how to do something: '만들 줄 몰라요' (I don't know how to make it)!",
      "VI": "Dùng '-(으)ㄹ 줄 모르다' để diễn tả việc không biết cách làm: '만들 줄 몰라요' (Tôi không biết nấu/làm)!",
      "ZH": "表示不会做某事或不知道方法时使用'-(으)ㄹ 줄 모르다'，'만들 줄 몰라요'表示'不会做'！",
      "JA": "やり方を知らなかったり能力がないことを表す時は「-(으)ㄹ 줄 모르다」を使い、「만들 줄 몰라요（作れません）」と言います！"
    }
  },
  # 564
  {
    "id": 564,
    "category": "신체·건강",
    "type": "sentence",
    "level": 1,
    "visual": "🥱 😴",
    "speechBubble": "오늘 안색이 무척 피곤해 보여요.",
    "keyword": "피곤해 보여요",
    "situations": {
      "KO": "상대방의 지친 표정과 충혈된 눈을 보고 피로가 쌓여 보인다고 시각적 인상을 추측해 걱정해 주는 상황입니다.",
      "EN": "Showing concern after observing someone looking visibly tired from their pale face and fatigued expression.",
      "VI": "Bày tỏ sự lo lắng khi thấy sắc mặt và ánh mắt mệt mỏi rõ rệt của đối phương.",
      "ZH": "看到对方疲惫的面容和红肿的双眼，推测其过度劳累并表达关心。",
      "JA": "相手の疲れた表情を見て、とても疲れているように見えると視覚的印象から心配する場面です。"
    },
    "questions": {
      "KO": "가: 민수 씨, 어젯밤에 잠을 잘 못 잤어요? 오늘 얼굴이 너무 (   ).\n나: 네, 과제 하느라 밤을 새웠더니 다크서클이 심하네요."
    },
    "options": ["피곤하지 않아요", "피곤해 보여요", "피곤하기 때문에", "피곤할 줄 알아요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "시각적으로 관찰된 모습을 바탕으로 상대방의 상태를 추측할 때는 형용사 뒤에 '-아/어 보이다'를 써서 '피곤해 보여요'라고 해요!",
      "EN": "Use '-아/어 보이다' to express an impression based on visual observation: '피곤해 보여요' (You look tired)!",
      "VI": "Dùng '-아/어 보이다' để phỏng đoán trạng thái dựa trên vẻ bề ngoài quan sát được: '피곤해 보여요' (Trông bạn có vẻ mệt mỏi)!",
      "ZH": "根据外表观察推断对方的状态时在形容词后接'-아/어 보이다'，'피곤해 보여요'表示'看起来很累'！",
      "JA": "見た目をもとに相手の状態を推測して言う時は「-아/어 보이다」を使い、「피곤해 보여요（疲れて見えます）」と言います！"
    }
  },
  # 565
  {
    "id": 565,
    "category": "시간·일정·문장완성",
    "type": "sentence",
    "level": 1,
    "visual": "🇰🇷 📅",
    "speechBubble": "한국에 유학 온 지 벌써 1년 됐어요.",
    "keyword": "온 지",
    "situations": {
      "KO": "외국인이 한국에 입국하여 생활을 시작한 이후 지금까지 흘러간 시간의 경과를 이야기하는 상황입니다.",
      "EN": "Stating the elapsed duration of time since arriving in Korea to live or study.",
      "VI": "Nói về khoảng thời gian đã trôi qua kể từ khi đặt chân đến Hàn Quốc học tập và sinh sống.",
      "ZH": "讲述自来到韩国留学生活以来到现在为止所度过的时间跨度。",
      "JA": "韓国に入国して生活を始めてから現在までに経過した期間を話す場面です。"
    },
    "questions": {
      "KO": "가: 한국어를 정말 유창하게 잘하시네요! 한국에 오신 지 얼마나 되셨어요?\n나: 칭찬 감사해요. 대학교 어학당에 유학 (   ) 벌써 1년이 지났어요."
    },
    "options": ["오기 전에", "온 지", "오면서", "오려고"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 행동을 한 시점부터 지금까지 얼마의 시간이 흘렀는지를 나타낼 때는 '-(으)ㄴ 지 [시간] 되다'를 써서 '온 지'라고 표현해요!",
      "EN": "Use '-(으)ㄴ 지 [time] 되다' to express how much time has passed since doing an action: '온 지' (since coming)!",
      "VI": "Dùng '-(으)ㄴ 지 [thời gian] 되다' để chỉ khoảng thời gian đã trôi qua kể từ khi làm việc gì: '온 지' (kể từ khi đến)!",
      "ZH": "表示做某事之后经过了多长时间时使用'-(으)ㄴ 지 [时间] 되다'，'온 지'表示'来到这里已经……'！",
      "JA": "ある行動をしてから現在までにどれくらいの時間が経過したかを表す時は「-(으)ㄴ 지 [期間] 되다」を使い、「온 지」とします！"
    }
  },
  # 566
  {
    "id": 566,
    "category": "패션·의류",
    "type": "sentence",
    "level": 1,
    "visual": "👗 🛍️",
    "speechBubble": "겨울 코트를 사려고 쇼핑몰에 갔어요.",
    "keyword": "사려고",
    "situations": {
      "KO": "새로운 겨울 외투를 구매하겠다는 목적과 의도를 가지고 대형 아울렛 쇼핑몰로 향했던 행동을 설명하는 상황입니다.",
      "EN": "Explaining the intention of visiting the outlet shopping mall to purchase a new winter coat.",
      "VI": "Giải thích mục đích đến trung tâm mua sắm là để chọn mua một chiếc áo khoác mùa đông mới.",
      "ZH": "说明前往购物中心是为了买一件新冬装大衣的目的与意图。",
      "JA": "新しい冬のコートを買うという意図を持ってショッピングモールへ出かけた行動を説明する場面です。"
    },
    "questions": {
      "KO": "가: 어제 주말에 백화점에 무슨 일로 다녀오셨어요?\n나: 날씨가 갑자기 쌀쌀해져서 따뜻한 패딩 점퍼를 하나 (   ) 다녀왔어요."
    },
    "options": ["사기 전에", "사려고", "산 후에", "사지 않고"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 행동을 하려는 목적이나 의도를 뒤의 행동과 연결할 때는 '-(으)려고'를 사용해요. '사다'에 붙어 '사려고'가 됩니다.",
      "EN": "Use '-(으)려고' to connect an intention or purpose to a subsequent action: '사려고' (in order to buy)!",
      "VI": "Dùng '-(으)려고' để nối mục đích hoặc ý định với hành động theo sau: '사려고' (định mua / để mua)!",
      "ZH": "将打算做某事的意图与后续行动连接时使用'-(으)려고'。'사다'接'려고'变为'사려고'（打算买/为了买）！",
      "JA": "ある行動をする目的や意図を後ろの行動と繋ぐ時は「-(으)려고」を使います。「사다」について「사려고（買おうと）」になります。"
    }
  },
  # 567
  {
    "id": 567,
    "category": "자연·날씨",
    "type": "sentence",
    "level": 1,
    "visual": "☀️ 🧺",
    "speechBubble": "주말 소풍날에 날씨가 맑으면 좋겠어요.",
    "keyword": "맑으면 좋겠어요",
    "situations": {
      "KO": "다가오는 주말 야외 피크닉 일정에 비가 오지 않고 화창한 햇살이 비추기를 간절히 바라는 희망을 표현하는 상황입니다.",
      "EN": "Expressing your wish for sunny and clear weather for the upcoming outdoor weekend picnic.",
      "VI": "Bày tỏ hy vọng thời tiết cuối tuần sẽ nắng ráo đẹp trời để chuyến dã ngoại ngoài trời diễn ra thuận lợi.",
      "ZH": "表达对周末户外野餐时天气晴朗无雨的热切期盼与愿望。",
      "JA": "週末の野外ピクニックの日に雨が降らず晴天であってほしいという願いを表現する場面です。"
    },
    "questions": {
      "KO": "가: 이번 주 토요일에 한강 공원으로 다 같이 피크닉 가기로 했잖아요.\n나: 맞아요, 그날 바람도 선선하고 하늘이 (   ) 참 행복할 것 같아요!"
    },
    "options": ["맑지 않으면", "맑으면 좋겠어요", "맑아도 돼요", "맑을 줄 알아요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 일이 실현되기를 바라는 희망이나 소망을 나타낼 때는 '-(으)면 좋겠다'를 써서 '맑으면 좋겠어요'라고 말해요!",
      "EN": "Use '-(으)면 좋겠다' to express a hope or wish: '맑으면 좋겠어요' (I hope it is clear/sunny)!",
      "VI": "Dùng '-(으)면 좋겠다' để thể hiện mong ước hay hy vọng: '맑으면 좋겠어요' (Ước gì trời nắng đẹp)!",
      "ZH": "表示期望某事得以实现的愿望时使用'-(으)면 좋겠다'，'맑으면 좋겠어요'表示'要是天气晴朗就好了'！",
      "JA": "何かが実現することを願う希望を表す時は「-(으)면 좋겠다」を使い、「맑으면 좋겠어요（晴れてほしいです）」と言います！"
    }
  },
  # 568
  {
    "id": 568,
    "category": "교통·길찾기·택시",
    "type": "sentence",
    "level": 1,
    "visual": "🗺️ 🚏",
    "speechBubble": "지하철역 출구는 표지판을 보고 찾기 쉬워요.",
    "keyword": "찾기 쉬워요",
    "situations": {
      "KO": "길을 찾을 때 안내 표지판이 명확하게 설치되어 있어 혼자서도 헤매지 않고 수월하게 찾을 수 있음을 알리는 상황입니다.",
      "EN": "Reassuring someone that a destination is easy to find without getting lost thanks to clear signage.",
      "VI": "Trấn an đối phương rằng đích đến rất dễ tìm thấy nhờ có biển chỉ dẫn rõ ràng.",
      "ZH": "告知对方指示牌十分清晰，能够毫不费力轻松找到目的地。",
      "JA": "案内標識が分かりやすく設置されているため迷わずに簡単に見つけられることを伝える場面です。"
    },
    "questions": {
      "KO": "가: 제가 길치라서 약속 장소인 서점을 잘 찾아갈 수 있을지 걱정돼요.\n나: 강남역 10번 출구 바로 앞이라서 눈에 띄어 (   ). 걱정 마세요!"
    },
    "options": ["찾기 어려워요", "찾기 쉬워요", "찾지 마세요", "찾을 줄 몰라요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 행동을 하기가 수월하고 용이함을 나타낼 때는 동사 어간에 '-기 쉽다'를 붙여 '찾기 쉬워요'라고 표현해요!",
      "EN": "Use '-기 쉽다' to indicate that an action is easy to do: '찾기 쉬워요' (It is easy to find)!",
      "VI": "Gắn '-기 쉽다' vào sau động từ để diễn tả việc gì đó dễ thực hiện: '찾기 쉬워요' (Dễ tìm lắm)!",
      "ZH": "表示做某事顺畅容易时在动词后接'-기 쉽다'，'찾기 쉬워요'表示'很容易找到'！",
      "JA": "ある行動をすることが容易であることを表す時は動詞に「-기 쉽다」をつけて「찾기 쉬워요（見つけやすいです）」と言います！"
    }
  },
  # 569
  {
    "id": 569,
    "category": "교통·길찾기·택시",
    "type": "sentence",
    "level": 1,
    "visual": "🎫 🚄",
    "speechBubble": "명절 연휴에는 KTX 기차표를 예매하기 어려워요.",
    "keyword": "예매하기 어려워요",
    "situations": {
      "KO": "설날이나 추석 등 명절에 고향으로 가는 승객이 몰려 열차 표를 구하는 과정이 대단히 힘들고 까다로움을 설명하는 상황입니다.",
      "EN": "Explaining that booking KTX train tickets during major national holidays is extremely difficult due to high demand.",
      "VI": "Giải thích việc đặt trước vé tàu KTX vào các dịp lễ tết rất khó khăn do lượng người về quê quá đông.",
      "ZH": "说明逢年过节客流量极大，预订KTX高铁火车票非常困难的现实情况。",
      "JA": "連休に帰省客が集中し列車のチケットを予約することが非常に困難であることを説明する場面です。"
    },
    "questions": {
      "KO": "가: 추석 명절에 부산 가는 KTX 표를 지금 예약할 수 있을까요?\n나: 명절 기간에는 몇 초 만에 매진되기 때문에 표를 (   )."
    },
    "options": ["예매하기 쉬워요", "예매하기 어려워요", "예매해도 돼요", "예매하지 마세요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 행동을 실행하는 데 난이도가 높고 힘듦을 나타낼 때는 동사 어간에 '-기 어렵다'를 써서 '예매하기 어려워요'라고 말해요!",
      "EN": "Use '-기 어렵다' to express that an action is hard or difficult to perform: '예매하기 어려워요' (It is hard to book)!",
      "VI": "Dùng '-기 어렵다' khi diễn tả việc gì đó gặp nhiều khó khăn, vất vả: '예매하기 어려워요' (Rất khó đặt vé)!",
      "ZH": "表示做某件事难度大、不容易完成时在动词后接'-기 어렵다'，'예매하기 어려워요'表示'很难预订'！",
      "JA": "ある行動を実行するのが困難で大変であることを表す時は「-기 어렵다」を使い、「예매하기 어려워요（予約しにくいです）」と言います！"
    }
  },
  # 570
  {
    "id": 570,
    "category": "시간·일정·문장완성",
    "type": "sentence",
    "level": 1,
    "visual": "🤝 ⏰",
    "speechBubble": "내일 오후 3시에 도서관 앞에서 만나기로 했어요.",
    "keyword": "만나기로 했어요",
    "situations": {
      "KO": "친구와 약속 시간과 장소를 사전에 합의하여 그렇게 실행하기로 결정했음을 전달하는 상황입니다.",
      "EN": "Stating a confirmed mutual decision or appointment made with a friend regarding time and place.",
      "VI": "Thông báo về cuộc hẹn đã thống nhất trước với bạn về thời gian và địa điểm gặp mặt.",
      "ZH": "传达事先与朋友商定好时间和地点并决定赴约的约定。",
      "JA": "友達と日時と場所を事前に約束し、会うことに決定した事実を伝える場面です。"
    },
    "questions": {
      "KO": "가: 내일 수업 끝나고 민수 씨랑 특별한 일정 있어요?\n나: 네, 팀 과제 회의를 하려고 3시에 카페에서 (   )."
    },
    "options": ["만나지 마세요", "만나기로 했어요", "만난 적이 없어요", "만나기 싫어요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "다른 사람과 어떤 일을 하기로 약속하거나 스스로 결정한 내용을 표현할 때는 '-기로 하다'를 써서 '만나기로 했어요'라고 해요!",
      "EN": "Use '-기로 하다' to express a promise, agreement, or decision made to do something: '만나기로 했어요' (We decided to meet)!",
      "VI": "Dùng '-기로 하다' khi nói về cuộc hẹn hoặc quyết định đã thống nhất làm gì: '만나기로 했어요' (Đã hẹn gặp nhau)!",
      "ZH": "表示与他人约定或自身决定做某事时使用'-기로 하다'，'만나기로 했어요'表示'决定见面'！",
      "JA": "人と約束したり自分自身で決定した事柄を表す時は「-기로 하다」を使い、「만나기로 했어요（会うことにしました）」と言います！"
    }
  },
  # 571
  {
    "id": 571,
    "category": "핵심표현·의사소통",
    "type": "sentence",
    "level": 1,
    "visual": "🎶 😃",
    "speechBubble": "신나는 노래를 들을 때마다 기분이 좋아져요.",
    "keyword": "들을 때마다",
    "situations": {
      "KO": "특정한 음악을 감상하는 매 순간마다 예외 없이 마음이 유쾌해지고 행복해지는 반복적 상태를 나타내는 상황입니다.",
      "EN": "Describing that every single time you listen to a cheerful song, your mood reliably lifts.",
      "VI": "Diễn tả tâm trạng luôn trở nên vui vẻ, sảng khoái mỗi lần nghe một khúc nhạc yêu thích.",
      "ZH": "表达每次听欢快的歌曲时毫无例外心情都会随之变好的心理感受。",
      "JA": "特定の音楽を聴くたびに毎回気分が良くなる反復的な心理状態を表す場面です。"
    },
    "questions": {
      "KO": "가: 지민 씨는 스트레스받을 때 어떻게 풀어요?\n나: 저는 좋아하는 아이돌 노래를 (   ) 에너지가 생기고 기분이 상쾌해져요."
    },
    "options": ["듣기 전에", "들을 때마다", "듣지 않고", "들은 후에"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 일을 행하는 매 시점마다 예외 없이 같은 결과가 일어남을 나타낼 때는 '-(으)ㄹ 때마다'를 써요. '듣다'는 '들을 때마다'가 됩니다.",
      "EN": "Use '-(으)ㄹ 때마다' to indicate that every single time an action occurs, the same result happens: '들을 때마다' (every time I listen)!",
      "VI": "Dùng '-(으)ㄹ 때마다' để diễn tả mỗi lần hành động xảy ra là lại có kết quả tương tự: '들을 때마다' (Mỗi khi nghe)!",
      "ZH": "表示每当做某事时无一例外都会产生相同结果使用'-(으)ㄹ 때마다'。'듣다'变为'들을 때마다'（每次听的时候）！",
      "JA": "ある行動をするたびに毎回決まって同じ状態になることを表す時は「-(으)ㄹ 때마다」を使います。「듣다」は「들을 때마다」になります。"
    }
  },
  # 572
  {
    "id": 572,
    "category": "자연·날씨",
    "type": "sentence",
    "level": 1,
    "visual": "🌧️ 💧",
    "speechBubble": "바닥이 젖은 걸 보니 밤새 비가 온 것 같아요.",
    "keyword": "온 것 같아요",
    "situations": {
      "KO": "아침에 일어나 길거리 바닥이 흠뻑 젖어 있는 흔적을 관찰하고 밤사이 비가 내렸을 것이라고 과거 사건을 추측하는 상황입니다.",
      "EN": "Supposing that it rained overnight based on the evidence of wet streets in the morning.",
      "VI": "Phỏng đoán rằng đêm qua trời đã mưa dựa trên dấu vết đường sá ướt đẫm vào buổi sáng.",
      "ZH": "早晨看到地面湿漉漉的痕迹，推测昨夜可能下过雨。",
      "JA": "朝起きて道路が濡れている痕跡を見て、夜の間に雨が降ったのだろうと過去の出来事を推測する場面です。"
    },
    "questions": {
      "KO": "가: 아침에 창문을 열어보니 마당 아스팔트가 축축하게 다 젖어 있네요.\n나: 그러네요! 우리가 자는 동안 새벽에 소나기가 (   )."
    },
    "options": ["오지 않아요", "온 것 같아요", "오기 전에", "오면 안 돼요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "현재 남아 있는 단서나 흔적을 근거로 과거에 일어난 일을 짐작하여 추측할 때는 '-(으)ㄴ 것 같다'를 써서 '온 것 같아요'라고 표현해요!",
      "EN": "Use '-(으)ㄴ 것 같다' to express a deduction or guess about a past event: '온 것 같아요' (It seems to have rained)!",
      "VI": "Dùng '-(으)ㄴ 것 같다' khi dựa vào dấu vết hiện tại để phỏng đoán về sự việc trong quá khứ: '온 것 같아요' (Có vẻ như đã mưa)!",
      "ZH": "根据现存线索对过去发生过的事情进行推测时使用'-(으)ㄴ 것 같다'，'온 것 같아요'表示'好像下过（雨）了'！",
      "JA": "残された手がかりをもとに過去に起きた出来事を推測する時は「-(으)ㄴ 것 같다」を使い、「온 것 같아요（降ったようです）」と言います！"
    }
  },
  # 573
  {
    "id": 573,
    "category": "일상생활·장소",
    "type": "sentence",
    "level": 1,
    "visual": "🪟 🍃",
    "speechBubble": "실내 공기 환기를 위해 창문을 열어 놓았어요.",
    "keyword": "열어 놓았어요",
    "situations": {
      "KO": "방 안의 탁한 공기를 빼내기 위해 창문을 열어두고 그 열린 상태가 유지되도록 둔 상황입니다.",
      "EN": "Opening the window to air out the room and keeping it open in that continuous state.",
      "VI": "Mở cửa sổ cho thoáng phòng và giữ nguyên trạng thái mở đó để không khí lưu thông.",
      "ZH": "为了通风给房间换气而将窗户打开，并保持着打开状态。",
      "JA": "部屋の換気のために窓を開け、その開いた状態を維持している場面です。"
    },
    "questions": {
      "KO": "가: 방 안 공기가 정말 상쾌하고 시원하네요.\n나: 요리 후 음식 냄새를 빼려고 거실 창문을 활짝 (   )."
    },
    "options": ["닫지 마세요", "열어 놓았어요", "열기 전에", "열면 안 돼요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 행동을 끝마친 후 그 완료된 결과 상태를 그대로 유지함을 나타낼 때는 '-아/어 놓다'를 써서 '열어 놓았어요'라고 말해요!",
      "EN": "Use '-아/어 놓다' to indicate that the resulting state of an action is maintained: '열어 놓았어요' (left it open)!",
      "VI": "Dùng '-아/어 놓다' khi hoàn thành hành động và giữ nguyên trạng thái kết quả đó: '열어 놓았어요' (Đã mở sẵn ra đó)!",
      "ZH": "动作完成后保持其结果状态时使用'-아/어 놓다'，'열어 놓았어요'表示'（特意）敞开着'！",
      "JA": "ある行動を終えた後、その完了した状態をそのまま保つことを表す時は「-아/어 놓다」を使い、「열어 놓았어요（開けておきました）」と言います！"
    }
  },
  # 574
  {
    "id": 574,
    "category": "자연·날씨",
    "type": "sentence",
    "level": 1,
    "visual": "🌸 🌡️",
    "speechBubble": "봄이 오면서 날씨가 점점 따뜻해졌어요.",
    "keyword": "따뜻해졌어요",
    "situations": {
      "KO": "추운 겨울이 지나고 따스한 봄철로 접어들면서 기온이 점진적으로 올라가는 상태의 변화를 설명하는 상황입니다.",
      "EN": "Describing the transition in weather becoming warmer as winter gives way to spring.",
      "VI": "Miêu tả sự thay đổi của thời tiết khi chuyển từ mùa đông lạnh giá sang mùa xuân ấm áp hơn.",
      "ZH": "说明严冬已过、随着春天到来天气逐渐转暖的状态变化过程。",
      "JA": "冬が過ぎて春になり、気温が次第に暖かく変化していく様子を説明する場面です。"
    },
    "questions": {
      "KO": "가: 얼마 전까지만 해도 두꺼운 패딩을 입었는데 이제 가벼운 옷을 입어도 괜찮네요.\n나: 맞아요, 3월이 되면서 날씨가 많이 (   )."
    },
    "options": ["추워졌어요", "따뜻해졌어요", "따뜻하지 않아요", "따뜻하면 안 돼요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "시간이 흐르며 상태가 이전과 다르게 변화함을 나타낼 때는 형용사에 '-아/어지다'를 써요. '따뜻하다'가 '따뜻해졌어요'가 됩니다.",
      "EN": "Use '-아/어지다' with adjectives to express a change in state over time: '따뜻해졌어요' (It became warm)!",
      "VI": "Gắn '-아/어지다' sau tính từ để diễn tả trạng thái thay đổi dần theo thời gian: '따뜻해졌어요' (Đã ấm lên nhiều)!",
      "ZH": "表示状态随着时间推移发生变化时在形容词后接'-아/어지다'。'따뜻하다'变为'따뜻해졌어요'（变暖和了）！",
      "JA": "時間の経過とともに状態が変化することを表す時は形容詞に「-아/어지다」をつけます。「따뜻해졌어요（暖かくなりました）」になります。"
    }
  },
  # 575
  {
    "id": 575,
    "category": "자기소개·직업",
    "type": "sentence",
    "level": 1,
    "visual": "🏢 🏙️",
    "speechBubble": "회사 발령 때문에 서울에서 살게 되었어요.",
    "keyword": "살게 되었어요",
    "situations": {
      "KO": "자신의 의도라기보다는 회사의 전근 발령 등 외부적 계기로 인해 서울로 이주하여 살게 된 상황을 전달하는 상황입니다.",
      "EN": "Explaining that you ended up moving and living in Seoul due to an external circumstance like a company transfer.",
      "VI": "Kể về việc mình chuyển đến sống ở Seoul là do hoàn cảnh khách quan như công ty điều động công tác.",
      "ZH": "说明并非个人本意、而是由于公司调动等外部客观原因最终在首尔生活的情形。",
      "JA": "自分の個人的な意思というより会社の転勤発令など外部の事情によりソウルで暮らすことになった場面です。"
    },
    "questions": {
      "KO": "가: 원래 고향이 부산이라고 들었는데 서울에는 어떻게 오셨나요?\n나: 지난달에 회사 본사로 발령을 받아서 서울에서 (   )."
    },
    "options": ["살지 않아요", "살게 되었어요", "살기 전에", "살지 마세요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "자신의 직접적 의지보다는 환경이나 외부 조건에 의해 새로운 상황에 이르게 됨을 나타낼 때는 '-게 되다'를 써서 '살게 되었어요'라고 해요!",
      "EN": "Use '-게 되다' to express coming into a new situation due to external circumstances: '살게 되었어요' (I came to live here)!",
      "VI": "Dùng '-게 되다' khi diễn tả việc rơi vào hoàn cảnh mới do tác động khách quan: '살게 되었어요' (Đã chuyển đến sống ở...)!",
      "ZH": "表示由于外部环境或客观条件导致形成某种新状态时使用'-게 되다'，'살게 되었어요'表示'变成在这里生活了'！",
      "JA": "自らの意志というより外部の事情によって新しい状況になることを表す時は「-게 되다」を使い、「살게 되었어요（暮らすことになりました）」と言います！"
    }
  },
  # 576
  {
    "id": 576,
    "category": "교통·길찾기·택시",
    "type": "sentence",
    "level": 1,
    "visual": "⏰ 🚕",
    "speechBubble": "지하철이 끊겨서 택시를 탈 수밖에 없었어요.",
    "keyword": "탈 수밖에 없었어요",
    "situations": {
      "KO": "심야에 지하철 막차가 이미 지나가 버려 귀가할 다른 선택지가 없어 택시를 이용할 수밖에 없었던 불가피한 상황입니다.",
      "EN": "Explaining having no choice but to take a taxi because the last subway had already departed.",
      "VI": "Giải thích việc không còn lựa chọn nào khác ngoài đi taxi vì chuyến tàu điện ngầm cuối cùng đã chạy mất.",
      "ZH": "说明因深夜地铁末班车已过，别无他选只能搭乘出租车回家的情况。",
      "JA": "深夜に地下鉄の終電が終わってしまい、他に選択肢がなくタクシーに乗るしかなかった場面です。"
    },
    "questions": {
      "KO": "가: 어젯밤에 택시비가 꽤 많이 나왔을 텐데 왜 택시를 타셨어요?\n나: 회식이 너무 늦게 끝나서 대중교통이 다 끊기는 바람에 택시를 (   )."
    },
    "options": ["탈 수 있었어요", "탈 수밖에 없었어요", "타지 마세요", "타기 쉬웠어요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "다른 대안이나 선택지가 없어 오직 그 행동만을 할 수밖에 없음을 나타낼 때는 '-(으)ㄹ 수밖에 없다'를 써요!",
      "EN": "Use '-(으)ㄹ 수밖에 없다' to indicate having no other choice or alternative: '탈 수밖에 없었어요' (had no choice but to take it)!",
      "VI": "Dùng '-(으)ㄹ 수밖에 없다' để diễn tả việc không còn phương án thay thế nào khác: '탈 수밖에 없었어요' (Không còn cách nào khác ngoài đi...)!",
      "ZH": "表示别无选择或无可奈何只能采取某种行动时使用'-(으)ㄹ 수밖에 없다'，'탈 수밖에 없었어요'表示'只能坐（车）'！",
      "JA": "他の選択肢がなくその行動をするしかないことを表す時は「-(으)ㄹ 수밖에 없다」を使います！"
    }
  },
  # 577
  {
    "id": 577,
    "category": "시간·일정·문장완성",
    "type": "sentence",
    "level": 1,
    "visual": "⏳ 📖",
    "speechBubble": "친구를 기다리는 동안 카페에서 책을 읽었어요.",
    "keyword": "기다리는 동안",
    "situations": {
      "KO": "친구가 약속 장소에 도착하기까지 걸리는 시간 동안 카페에서 독서를 하며 기다린 시간 지속 상황을 묘사하는 상황입니다.",
      "EN": "Reading a book at a café during the time spent waiting for a friend to arrive.",
      "VI": "Đọc sách tại quán cà phê trong khoảng thời gian ngồi đợi bạn đến điểm hẹn.",
      "ZH": "在朋友到达约定地点的等待期间在咖啡馆看书打发时间。",
      "JA": "友達が約束の場所に到着するまでの間、カフェで本を読んで待っていた時間の持続を表す場面です。"
    },
    "questions": {
      "KO": "가: 약속 시간에 조금 늦어서 미안해요! 오래 기다렸어요?\n나: 아니에요, 친구를 (   ) 카페에서 재미있는 소설책을 읽고 있어서 괜찮았어요."
    },
    "options": ["기다리기 전에", "기다리는 동안", "기다린 후에", "기다리지 않고"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 행위가 지속되는 시간적 구간이나 기간을 나타낼 때는 동사 뒤에 '-는 동안'을 붙여 '기다리는 동안'이라고 표현해요!",
      "EN": "Use '-는 동안' to express a period of continuous time during which an action takes place: '기다리는 동안' (while waiting)!",
      "VI": "Gắn '-는 동안' sau động từ để chỉ khoảng thời gian một hành động đang tiếp diễn: '기다리는 동안' (Trong lúc chờ đợi)!",
      "ZH": "表示某种动作持续的时间段时在动词后接'-는 동안'，'기다리는 동안'表示'在等待期间/等候的当儿'！",
      "JA": "ある行動が持続する時間的区間を表す時は動詞に「-는 동안」をつけて「기다리는 동안（待っている間）」と言います！"
    }
  },
  # 578
  {
    "id": 578,
    "category": "음식·음료",
    "type": "sentence",
    "level": 1,
    "visual": "🌶️ 🍜",
    "speechBubble": "아주 매운 불닭라면은 먹어 본 적이 없어요.",
    "keyword": "먹어 본 적이 없어요",
    "situations": {
      "KO": "유명한 매운 라면을 지금까지 한 번도 시도하거나 맛본 적이 없다고 과거 경험의 부재를 이야기하는 상황입니다.",
      "EN": "Stating that you have never tried or experienced eating extremely spicy fire noodles in your past.",
      "VI": "Nói rằng trong quá khứ mình chưa từng một lần ăn thử món mì cay nồng nổi tiếng.",
      "ZH": "表示自己长这么大还从来没有尝试品尝过极辣的火鸡面。",
      "JA": "有名な激辛ラーメンをこれまでに一度も食べた経験がないことを話す場面です。"
    },
    "questions": {
      "KO": "가: 한국의 대표적인 매운 볶음면인 불닭라면 먹어봤어요?\n나: 너무 매워서 속이 쓰릴까 봐 저는 아직 한 번도 (   )."
    },
    "options": ["먹어 본 적이 있어요", "먹어 본 적이 없어요", "먹을 줄 알아요", "먹기 쉬워요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "과거에 어떤 행위를 직접 겪거나 경험해 본 사실이 전혀 없음을 나타낼 때는 '-(으)ㄴ 적이 없다'를 써서 '먹어 본 적이 없어요'라고 해요!",
      "EN": "Use '-(으)ㄴ 적이 없다' to indicate having no past experience of doing something: '먹어 본 적이 없어요' (I have never eaten it)!",
      "VI": "Dùng '-(으)ㄴ 적이 없다' để chỉ việc chưa từng có kinh nghiệm làm gì trong quá khứ: '먹어 본 적이 없어요' (Tôi chưa từng ăn thử bao giờ)!",
      "ZH": "表示过去从来没有过某种亲身体验或经历时使用'-(으)ㄴ 적이 없다'，'먹어 본 적이 없어요'表示'从来没吃过'！",
      "JA": "過去に何かを経験したことが全くないことを表す時は「-(으)ㄴ 적이 없다」を使い、「먹어 본 적이 없어요（食べたことがありません）」と言います！"
    }
  },
  # 579
  {
    "id": 579,
    "category": "카페·식당·외식문화",
    "type": "sentence",
    "level": 1,
    "visual": "🍵 🙇",
    "speechBubble": "따뜻한 보리차 한 잔 드시겠습니까?",
    "keyword": "드시겠습니까",
    "situations": {
      "KO": "격식 있는 식당이나 귀한 손님을 모신 자리에서 정중하고 공손한 어조로 마실 것을 권유하는 상황입니다.",
      "EN": "Politely offering a hot beverage to an honored guest in a formal setting.",
      "VI": "Mời vị khách quý dùng trà ấm với ngữ điệu vô cùng trang trọng và cung kính.",
      "ZH": "在正式的高级餐厅或款待贵宾的场合用极其客气尊敬的语气询问是否用茶。",
      "JA": "フォーマルな席や大切なお客様を迎えた場で、丁寧にお茶を勧める場面です。"
    },
    "questions": {
      "KO": "가: 손님, 식사 나오기 전에 몸을 녹일 수 있는 따뜻한 전통차 한 잔 (   )?\n나: 네, 배려해 주셔서 대단히 감사합니다."
    },
    "options": ["먹지 마세요", "드시겠습니까", "먹으면 안 돼요", "먹을 줄 몰라요"],
    "answerIndex": 1,
    "explanations": {
      "KO": "공식적인 자리나 손님에게 음식을 대접하며 의향을 높여 물어볼 때는 특수 높임 동사 '드시다'에 '-(으)시겠습니까?'를 붙여요!",
      "EN": "Use '드시겠습니까?' (the honorific form of '먹다') to politely offer food or drinks to guests: 'Would you like to drink/eat?'!",
      "VI": "Dùng dạng kính ngữ '드시겠습니까?' của động từ '먹다' khi mời đồ ăn thức uống cho khách: 'Quý khách có dùng... không ạ?'!",
      "ZH": "在正式场合招待客人时使用'먹다'的敬语动词'드시다'接'-(으)시겠습니까?'，'드시겠습니까?'表示'您要用点……吗？'！",
      "JA": "公式な席で客に飲食を勧める際は「먹다」の尊敬語「드시다」に「-(으)시겠습니까?」をつけて「드시겠습니까?（召し上がりますか？）」と聞きます！"
    }
  },
  # 580
  {
    "id": 580,
    "category": "신체·건강",
    "type": "sentence",
    "level": 1,
    "visual": "🏃‍♂️ 🥗",
    "speechBubble": "체중을 감량하려면 매일 꾸준히 운동해야 해요.",
    "keyword": "감량하려면",
    "situations": {
      "KO": "건강하게 체중을 줄이겠다는 전제 조건을 충족하기 위해 매일 규칙적인 유산소 운동이 필수적임을 설명하는 상황입니다.",
      "EN": "Explaining that daily regular exercise is essential if one intends to achieve weight loss.",
      "VI": "Giải thích rằng nếu muốn giảm cân hiệu quả thì điều kiện tiên quyết là phải tập thể dục đều đặn mỗi ngày.",
      "ZH": "说明如果想达到减肥目标，前提条件是必须每天坚持规律运动。",
      "JA": "体重を減らしたいなら毎日の規則的な運動が必須条件であると説明する場面です。"
    },
    "questions": {
      "KO": "가: 건강 검진에서 과체중이 나왔어요. 건강하게 살을 (   ) 어떻게 해야 하나요?\n나: 식단을 조절하고 매일 30분 이상 꾸준히 유산소 운동을 하셔야 해요."
    },
    "options": ["빼기 때문에", "빼려면", "뺀 후에", "빼지 않고"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 일을 성취하거나 실행하려는 의도나 목표를 조건으로 내세울 때는 '-(으)려면'을 써서 '빼려면'이라고 말해요!",
      "EN": "Use '-(으)려면' (contraction of -(으)려고 하면) to set an intention as a condition: '빼려면' (if you want to lose weight)!",
      "VI": "Dùng '-(으)려면' để đặt ra ý định hoặc mục tiêu làm điều kiện: '빼려면' (Nếu muốn giảm...)!",
      "ZH": "把打算实现某项意图或目标作为前提条件时使用'-(으)려면'，'빼려면'表示'如果要减（肥）的话'！",
      "JA": "何かを実行しようとする意図を条件として提示する時は「-(으)려면」を使い、「빼려면（落とそうとするなら）」と言います！"
    }
  },
  # 581. 약국: 소독약
  {
    "id": 581,
    "category": "병원·약국·응급",
    "type": "word",
    "level": 1,
    "visual": "🧴 🩹",
    "speechBubble": "상처에 세균이 없도록 소독약을 발라요.",
    "keyword": "소독약",
    "situations": {
      "KO": "넘어져서 무릎이 까졌을 때 덧나거나 세균에 감염되지 않도록 상처 부위에 바르는 살균 소독 액체를 약국에서 찾는 상황입니다.",
      "EN": "Buying liquid antiseptic disinfectant at a pharmacy to apply on a scraped knee to prevent infection.",
      "VI": "Mua thuốc sát trùng dạng lỏng tại hiệu thuốc để rửa vết trầy xước ở đầu gối tránh nhiễm trùng.",
      "ZH": "摔倒擦破膝盖后在药店购买涂抹在伤口处杀菌防感染的医用消毒药水。",
      "JA": "転んで膝をすりむいた時に化膿や細菌感染を防ぐため傷口に塗る消毒液を薬局で求める場面です。"
    },
    "questions": {
      "KO": "가: 넘어져서 무릎 피부가 까졌는데 물로 씻은 뒤 무엇을 발라야 하나요?\n나: 세균 감염을 막기 위해 솜에 빨간 (   )을/를 묻혀서 상처 부위를 닦아내세요."
    },
    "options": ["소독약", "비누", "로션", "샴푸"],
    "answerIndex": 0,
    "explanations": {
      "KO": "상처 부위의 세균을 죽여 덧나지 않게 해 주는 외용 살균 약품은 '소독약(Antiseptic / Disinfectant)'이에요!",
      "EN": "A topical medicinal antiseptic used to kill germs and prevent wound infection is '소독약' (Disinfectant)!",
      "VI": "Dung dịch sát trùng dùng ngoài da để diệt khuẩn giúp vết thương mau lành là '소독약' (Thuốc sát trùng)!",
      "ZH": "用于杀灭伤口病菌、防止化脓感染的外用消毒杀菌药剂是'소독약'（消毒药水）！",
      "JA": "傷口の細菌を殺菌して化膿を防ぐ外用殺菌薬品は「소독약（消毒薬）」です！"
    }
  },
  # 582. 약국: 종합감기약
  {
    "id": 582,
    "category": "병원·약국·응급",
    "type": "word",
    "level": 1,
    "visual": "💊 🤧",
    "speechBubble": "기침과 콧물에 종합감기약을 먹어요.",
    "keyword": "종합감기약",
    "situations": {
      "KO": "발열, 콧물, 기침, 두통 등 다양한 초기 감기 증상을 한꺼번에 완화해 주는 일반의약품을 약국에서 구매하는 상황입니다.",
      "EN": "Purchasing over-the-counter multi-symptom cold medicine at a pharmacy for a fever, runny nose, and cough.",
      "VI": "Mua thuốc cảm tổng hợp không kê đơn tại hiệu thuốc để điều trị các triệu chứng sốt, sổ mũi và ho.",
      "ZH": "在药店购买用于缓解发烧、流鼻涕、咳嗽等多种初期感冒症状的非处方综合感冒药。",
      "JA": "発熱、鼻水、咳、頭痛など初期の風邪の諸症状を和らげる総合感冒薬を薬局で購入する場面です。"
    },
    "questions": {
      "KO": "가: 약사님, 어제부터 열도 나고 콧물도 흐르고 기침도 살짝 나요.\n나: 초기 감기 증상을 복합적으로 가라앉혀 주는 캡슐형 (   )을/를 식후에 복용하세요."
    },
    "options": ["소화제", "종합감기약", "수면제", "영양제"],
    "answerIndex": 1,
    "explanations": {
      "KO": "두통, 열, 기침, 코막힘 등 감기의 여러 증상을 두루 치료하도록 만들어진 약은 '종합감기약(Multi-symptom cold medicine)'이에요!",
      "EN": "An over-the-counter medication formulated to relieve multiple cold symptoms is a '종합감기약' (Cold medicine)!",
      "VI": "Loại thuốc được bào chế để điều trị đồng thời nhiều triệu chứng cảm cúm là '종합감기약' (Thuốc cảm cúm tổng hợp)!",
      "ZH": "用于综合缓解头痛、发热、咳嗽、鼻塞等多种感冒症状的复方药物是'종합감기약'（综合感冒药）！",
      "JA": "頭痛、熱、咳、鼻づまりなど風邪の諸症状を総合的に和らげる薬は「종합감기약（総合風邪薬）」です！"
    }
  },
  # 583. 병원: 치과
  {
    "id": 583,
    "category": "병원·약국·응급",
    "type": "word",
    "level": 1,
    "visual": "🦷 🪥",
    "speechBubble": "이가 시리고 아플 때는 치과에 가요.",
    "keyword": "치과",
    "situations": {
      "KO": "찬물을 마실 때 이가 찌릿하게 시리고 충치가 의심되어 구강과 치아 전문 진료과를 찾는 상황입니다.",
      "EN": "Visiting a dental clinic when experiencing toothache or tooth sensitivity when drinking cold water.",
      "VI": "Đến phòng khám nha khoa khi thấy răng bị ê buốt buốt nhức hoặc nghi ngờ bị sâu răng.",
      "ZH": "喝冷水时牙齿酸痛敏感、怀疑有蛀牙而前往口腔牙科诊所就诊。",
      "JA": "冷たい水を飲んだ時に歯がしみて痛み、虫歯が疑われるため歯科医院を訪れる場面です。"
    },
    "questions": {
      "KO": "가: 밥을 씹을 때 어금니가 욱신거리고 찬물을 마시면 너무 시려요.\n나: 충치가 생긴 것 같네요. 얼른 (   )에 가서 엑스레이 찍고 치료받으세요."
    },
    "options": ["안과", "이비인후과", "치과", "피부과"],
    "answerIndex": 2,
    "explanations": {
      "KO": "치아와 잇몸 등 구강 내의 질환을 전문적으로 검진하고 치료하는 병원은 '치과(Dental clinic)'예요!",
      "EN": "The specialized medical clinic that diagnoses and treats teeth and gums is '치과' (Dental clinic)!",
      "VI": "Phòng khám chuyên khoa kiểm tra và điều trị các bệnh về răng và nướu là '치과' (Nha khoa / Phòng khám răng)!",
      "ZH": "专门检查和治疗牙齿、牙龈等口腔内疾病的医疗机构是'치과'（牙科/口腔诊所）！",
      "JA": "歯や歯茎など口腔内の疾患を専門的に診察・治療する病院は「치과（歯科）」です！"
    }
  },
  # 584. 병원: 정형외과
  {
    "id": 584,
    "category": "병원·약국·응급",
    "type": "word",
    "level": 1,
    "visual": "🦴 🦵",
    "speechBubble": "발목을 삐었을 때는 정형외과에 가요.",
    "keyword": "정형외과",
    "situations": {
      "KO": "농구를 하다가 발목을 접질려 뼈나 인대를 다쳤을 때 깁스와 엑스레이 검사를 받으러 가는 병원입니다.",
      "EN": "Visiting an orthopedic clinic for an X-ray and cast after spraining an ankle or injuring bones.",
      "VI": "Đến phòng khám chấn thương chỉnh hình để chụp X-quang và bó bột khi bị trật mắt cá chân hoặc chấn thương xương khớp.",
      "ZH": "打篮球扭伤脚踝、骨骼或韧带受损时前往骨科门诊拍片打石膏治疗。",
      "JA": "バスケットボール中に足首を捻挫して骨や靭帯を痛めた時にレントゲン撮影やギプス治療を受けに行く整形外科の場面です。"
    },
    "questions": {
      "KO": "가: 계단에서 발을 헛디뎌 발목이 심하게 붓고 딛기 힘들어요.\n나: 뼈에 금이 갔을 수도 있으니 (   )에 가서 엑스레이를 찍어보세요."
    },
    "options": ["안과", "치과", "내과", "정형외과"],
    "answerIndex": 3,
    "explanations": {
      "KO": "뼈, 관절, 인대, 근육 등 근골격계 손상과 질환을 전문적으로 다루는 병원은 '정형외과(Orthopedic clinic)'예요!",
      "EN": "The medical clinic specializing in bones, joints, ligaments, and musculoskeletal injuries is '정형외과' (Orthopedics)!",
      "VI": "Chuyên khoa y tế chuyên điều trị các tổn thương về xương, khớp, dây chằng là '정형외과' (Khoa Chấn thương Chỉnh hình)!",
      "ZH": "专门诊治骨骼、关节、韧带及肌肉等骨骼肌肉系统损伤的科室是'정형외과'（骨科/整形外科）！",
      "JA": "骨、関節、靭帯、筋肉などの筋骨格系の損傷や疾患を専門に診察する診療科は「정형외과（整形外科）」です！"
    }
  },
  # 585. 병원: 피부과
  {
    "id": 585,
    "category": "병원·약국·응급",
    "type": "word",
    "level": 1,
    "visual": "🧴 💆",
    "speechBubble": "피부 두드러기에는 피부과에 가요.",
    "keyword": "피부과",
    "situations": {
      "KO": "음식 알레르기로 얼굴에 붉은 두드러기가 나거나 여드름 치료를 위해 피부 전문 의원을 찾는 상황입니다.",
      "EN": "Visiting a dermatology clinic to treat facial hives from food allergies or acne.",
      "VI": "Đến phòng khám chuyên khoa da liễu để điều trị mề đay dị ứng thức ăn hoặc mụn trứng cá.",
      "ZH": "因食物过敏导致脸部长红疹荨麻疹或治疗痘痘时前往皮肤科就诊。",
      "JA": "食物アレルギーで顔に蕁麻疹が出たりニキビ治療のため皮膚科医院を訪れる場面です。"
    },
    "questions": {
      "KO": "가: 해산물을 먹은 뒤로 온몸이 간지럽고 빨간 발진이 돋아났어요.\n나: 알레르기 반응인 것 같아요. (   )에 가서 진정 주사를 맞고 연고를 처방받으세요."
    },
    "options": ["피부과", "안과", "치과", "이비인후과"],
    "answerIndex": 0,
    "explanations": {
      "KO": "피부 질환, 알레르기 발진, 여드름 등을 전문적으로 진료하고 관리해 주는 병원은 '피부과(Dermatology clinic)'예요!",
      "EN": "The specialized clinic that treats skin diseases, allergic rashes, and acne is '피부과' (Dermatology clinic)!",
      "VI": "Phòng khám chuyên khoa điều trị các bệnh ngoài da, phát ban dị ứng và mụn là '피부과' (Khoa Da liễu)!",
      "ZH": "专门诊治皮肤疾病、过敏红疹与痤疮的医疗科室是'피부과'（皮肤科）！",
      "JA": "皮膚の病気やアレルギー性の発疹、ニキビなどを専門的に診察・治療する科は「피부과（皮膚科）」です！"
    }
  },
  # 586. 교통: 시외버스
  {
    "id": 586,
    "category": "교통·길찾기·택시",
    "type": "word",
    "level": 1,
    "visual": "🚌 🛣️",
    "speechBubble": "터미널에서 지방으로 가는 시외버스를 타요.",
    "keyword": "시외버스",
    "situations": {
      "KO": "기차가 가지 않는 지방 중소 도시나 다른 시·도로 이동하기 위해 버스 터미널에서 고속·직행버스를 이용하는 상황입니다.",
      "EN": "Taking an intercity bus from a terminal to travel to other cities or provincial towns without train stations.",
      "VI": "Bắt xe buýt liên tỉnh tại bến xe để di chuyển đến các thành phố hoặc địa phương khác.",
      "ZH": "在客运站搭乘前往其他省市或未通铁路地区的长途城际客运大巴。",
      "JA": "列車が通っていない地方都市や他の自治体へ移動するためバスターミナルから長距離市外バスに乗る場面です。"
    },
    "questions": {
      "KO": "가: 강원도 속초 바다에 놀러 가고 싶은데 기차역이 없대요. 어떻게 가나요?\n나: 서울 고속버스터미널에서 속초로 직행하는 (   )을/를 타고 가시면 돼요."
    },
    "options": ["시내버스", "마을버스", "시외버스", "셔틀버스"],
    "answerIndex": 2,
    "explanations": {
      "KO": "한 도시의 경계를 넘어 다른 시, 군, 도의 도시들을 오가는 장거리 정기 버스는 '시외버스(고속버스 / Intercity bus)'예요!",
      "EN": "A long-distance coach bus operating between different cities and provincial regions is a '시외버스' (Intercity bus)!",
      "VI": "Tuyến xe buýt đường dài chạy giữa các thành phố và các tỉnh khác nhau là '시외버스' (Xe buýt liên tỉnh / Xe khách)!",
      "ZH": "跨越城市边界往返于不同市、郡之间的长途定期公路客运班车是'시외버스'（市外长途大巴）！",
      "JA": "都市の境界を越えて他の市や地方都市を結ぶ長距離定期バスは「시외버스（市外バス・高速バス）」です！"
    }
  },
  # 587. 교통: 휴게소
  {
    "id": 587,
    "category": "교통·길찾기·택시",
    "type": "word",
    "level": 1,
    "visual": "⛽ 🌭",
    "speechBubble": "고속도로 휴게소에서 호두과자와 소떡소떡을 먹어요.",
    "keyword": "휴게소",
    "situations": {
      "KO": "고속도로에서 장거리 운전을 하다가 화장실을 이용하고 맛있는 간식을 사 먹으며 쉬어가는 도로 편의 시설을 방문하는 상황입니다.",
      "EN": "Stopping at a highway rest area to use the restroom, refuel, and grab delicious Korean roadside snacks.",
      "VI": "Dừng chân tại trạm dừng nghỉ trên đường cao tốc để đi vệ sinh và thưởng thức các món ăn vặt đường dài.",
      "ZH": "在高速公路长途行车途中进入服务区上卫生间、给车辆加油并品尝美味特色小吃。",
      "JA": "高速道路の長距離運転中にトイレ休憩を挟み、名物のおやつを食べて休むサービスエリアに立ち寄る場面です。"
    },
    "questions": {
      "KO": "가: 고속도로 운전 중 졸리기도 하고 출출한데 어디 들렀다 갈까요?\n나: 저기 앞에 나오는 (   )에 들어가서 화장실도 가고 따뜻한 호두과자 사 먹어요."
    },
    "options": ["요금소", "주유소", "휴게소", "정비소"],
    "answerIndex": 2,
    "explanations": {
      "KO": "고속도로나 국도변에서 운전자들의 휴식과 식사, 주유를 위해 마련된 편의 쉼터는 '휴게소(Highway rest area / Service area)'예요!",
      "EN": "A roadside facility along highways providing restrooms, food, and fueling for drivers is a '휴게소' (Rest area)!",
      "VI": "Khu tiện ích ven đường cao tốc phục vụ tài xế nghỉ ngơi, ăn uống và đổ xăng là '휴게소' (Trạm dừng nghỉ)!",
      "ZH": "在高速公路沿线为过往司乘人员提供休息、就餐和加油等服务的综合便利设施是'휴게소'（服务区/休息站）！",
      "JA": "高速道路沿いに設けられ、運転手の休憩、食事、給油のために利用される施設は「휴게소（サービスエリア・休憩所）」です！"
    }
  },
  # 588. 교통: 승차홈
  {
    "id": 588,
    "category": "교통·길찾기·택시",
    "type": "word",
    "level": 1,
    "visual": "🚉 🎫",
    "speechBubble": "기차 승차권에 적힌 승차홈 번호로 가요.",
    "keyword": "승차홈",
    "situations": {
      "KO": "KTX 서울역이나 버스 터미널에서 표에 인쇄된 지정된 플랫폼 탑승 번호를 찾아가는 상황입니다.",
      "EN": "Checking the departure platform number printed on your train or bus ticket to board the vehicle.",
      "VI": "Tìm đúng số cửa khởi hành hoặc ke ga (sân ga) được in trên vé để lên tàu hoặc xe buýt.",
      "ZH": "在火车站或长途车站对照车票上注明的站台编号前往指定的上车乘车道。",
      "JA": "ソウル駅やバスターミナルで切符に印刷された指定の乗車プラットホーム番号を確認して向かう場面です。"
    },
    "questions": {
      "KO": "가: 기차표를 샀는데 어디로 가서 기차를 타야 하는지 어떻게 아나요?\n나: 승차권 아래쪽에 적힌 (   ) 번호(플랫폼)를 확인하고 그 번호 계단으로 내려가세요."
    },
    "options": ["승차홈", "좌석", "개찰구", "수납창구"],
    "answerIndex": 0,
    "explanations": {
      "KO": "승객이 열차나 버스를 타기 위해 대기하는 역의 플랫폼 승강장 구역을 '승차홈(Platform / Track)'이라고 불러요!",
      "EN": "The boarding platform area at a train or bus terminal is called the '승차홈' (Boarding platform)!",
      "VI": "Khu vực sân ga nơi hành khách đón và lên các chuyến tàu hay xe buýt gọi là '승차홈' (Ke ga / Sân ga)!",
      "ZH": "车站内供旅客上车的站台乘车区域在韩语中称为'승차홈'（站台/登车口）！",
      "JA": "乗客が列車やバスに乗るために待機する乗車用プラットホームを「승차홈（乗車ホーム）」と呼びます！"
    }
  },
  # 589. 교통: 급행
  {
    "id": 589,
    "category": "교통·길찾기·택시",
    "type": "word",
    "level": 1,
    "visual": "🚇 ⚡",
    "speechBubble": "주요 역에만 정차하는 급행열차가 빨라요.",
    "keyword": "급행",
    "situations": {
      "KO": "지하철 노선에서 모든 역에 서지 않고 환승역과 주요 거점 역만 건너뛰며 빠르게 운행하는 열차를 구별하는 상황입니다.",
      "EN": "Choosing an express train that stops only at major transfer stations to reach your destination faster.",
      "VI": "Lựa chọn đi chuyến tàu tốc hành chỉ dừng tại các ga chuyển tuyến lớn để tới đích nhanh chóng hơn.",
      "ZH": "在地铁线路中选择不逢站必停、仅在核心换乘大站停靠的快速列车以节省通勤时间。",
      "JA": "各駅停車ではなく主要な乗り換え駅にのみ停車して目的地まで素早く移動する急行列車を利用する場面です。"
    },
    "questions": {
      "KO": "가: 지하철 9호선을 탈 때 왜 어떤 열차는 목적지에 20분이나 일찍 도착하나요?\n나: 작은 역은 지나치고 주요 역에만 멈추는 빠른 (   ) 열차를 탔기 때문이에요."
    },
    "options": ["완행", "급행", "회차", "점검"],
    "answerIndex": 1,
    "explanations": {
      "KO": "중요한 주요 정차역만 선택적으로 정차하여 소요 시간을 대폭 단축해 주는 열차를 '급행(Express train)'이라고 해요!",
      "EN": "A transit train that bypasses smaller stops and halts only at major hubs is an '급행' (Express)!",
      "VI": "Chuyến tàu chỉ dừng ở các ga trung tâm trọng điểm nhằm rút ngắn thời gian di chuyển là '급행' (Tàu tốc hành)!",
      "ZH": "跳过部分小站仅在重要枢纽站停靠以缩短旅途耗时的快速列车是'급행'（急行/快车）！",
      "JA": "主要な拠点駅にのみ停車することで所要時間を短縮して運行する列車は「급행（急行）」です！"
    }
  },
  # 590. 식당: 셀프바
  {
    "id": 590,
    "category": "식당·외식·이동",
    "type": "word",
    "level": 1,
    "visual": "🥗 🍽️",
    "speechBubble": "부족한 반찬은 셀프바에서 직접 가져와요.",
    "keyword": "셀프바",
    "situations": {
      "KO": "식당에서 직원을 호출하지 않고 매장 중앙에 마련된 코너에서 반찬이나 소스를 손님이 원하는 만큼 직접 담는 상황입니다.",
      "EN": "Self-serving additional side dishes and sauces from a designated buffet station at a restaurant.",
      "VI": "Tự phục vụ lấy thêm đồ ăn kèm và nước sốt tại quầy đồ ăn tự chọn giữa nhà hàng.",
      "ZH": "在餐馆无需呼叫服务员，由顾客自己在餐厅中央的自助配菜台按需添加小菜和调料。",
      "JA": "食堂で店員を呼ばず、店舗中央に設けられたコーナーからおかずやタレを自分で自由に取る場面です。"
    },
    "questions": {
      "KO": "가: 쌈장과 상추가 더 필요한데 직원분께 말씀드려야 하나요?\n나: 저기 주방 앞 (   )에 가시면 드실 만큼 직접 그릇에 담아오실 수 있어요."
    },
    "options": ["카운터", "셀프바", "주차장", "흡연실"],
    "answerIndex": 1,
    "explanations": {
      "KO": "식당에서 손님이 필요한 반찬, 소스, 냅킨 등을 자유롭게 직접 덜어갈 수 있도록 꾸며진 코너는 '셀프바(Self-service bar)'예요!",
      "EN": "A designated self-service station where diners fetch additional side dishes or utensils is a '셀프바' (Self-bar)!",
      "VI": "Khu vực tự phục vụ nơi khách hàng có thể tự do lấy thêm đồ ăn kèm, nước sốt là '셀프바' (Quầy tự phục vụ)!",
      "ZH": "餐馆中供顾客自行按需盛取小菜、酱料的自助服务台称为'셀프바'（自助小菜台）！",
      "JA": "飲食店で客が必要なおかずや調味料を自由に自分で取り分けることができるコーナーは「셀프바（セルフバー）」です！"
    }
  },
  # 591. 식당: 호출벨
  {
    "id": 591,
    "category": "식당·외식·이동",
    "type": "word",
    "level": 1,
    "visual": "🔔 🛎️",
    "speechBubble": "테이블 위의 호출벨을 눌러 직원을 불러요.",
    "keyword": "호출벨",
    "situations": {
      "KO": "식당에서 큰 소리로 '저기요'라고 부르지 않고 테이블 모서리에 부착된 버튼을 눌러 직원을 부르는 상황입니다.",
      "EN": "Pressing the table service buzzer bell instead of shouting across the restaurant to call the server.",
      "VI": "Bấm chiếc chuông nhỏ gắn ở góc bàn để gọi nhân viên phục vụ thay vì phải gọi to trong quán ăn.",
      "ZH": "在餐馆不需要大声呼唤服务员，按下固定在餐桌角上的呼叫按钮等待服务员前来。",
      "JA": "飲食店で大声で店員を呼ぶ代わりに、テーブルの端に取り付けられた呼び出しボタンを押す場面です。"
    },
    "questions": {
      "KO": "가: 식당이 너무 넓고 시끄러워서 주문을 어떻게 해야 할지 모르겠어요.\n나: 테이블 모서리에 붙어 있는 둥근 (   )을/를 누르면 직원분이 자리로 찾아와요."
    },
    "options": ["비상벨", "호출벨", "진동벨", "자전거벨"],
    "answerIndex": 1,
    "explanations": {
      "KO": "식당 테이블에서 직원을 부르기 위해 누르는 무선 호출 버튼 장치는 '호출벨(Service call bell)'이에요!",
      "EN": "The wireless call button installed on restaurant tables to summon a server is a '호출벨' (Call button)!",
      "VI": "Nút bấm không dây gắn trên bàn ăn để gọi nhân viên phục vụ là '호출벨' (Chuông gọi phục vụ)!",
      "ZH": "固定在餐桌上用于呼叫餐厅服务员的无线按铃装置是'호출벨'（呼叫铃）！",
      "JA": "飲食店のテーブルで店員を呼ぶために押すワイヤレス呼び出しボタンは「호출벨（呼び出しベル）」です！"
    }
  },
  # 592. 식당: 병따개
  {
    "id": 592,
    "category": "식당·외식·이동",
    "type": "word",
    "level": 1,
    "visual": "🍾 🍺",
    "speechBubble": "유리병 콜라 뚜껑을 병따개로 열어요.",
    "keyword": "병따개",
    "situations": {
      "KO": "식당에서 유리병에 든 맥주나 음료수를 주문한 뒤 쇠로 된 뚜껑을 지렛대 원리로 따기 위해 도구를 찾는 상황입니다.",
      "EN": "Looking for a bottle opener to remove the metal crown cap from a glass bottled beverage.",
      "VI": "Tìm đồ khui nắp chai bằng kim loại để mở chai nước ngọt hoặc bia thủy tinh tại quán ăn.",
      "ZH": "在餐馆喝玻璃瓶装汽水或啤酒时，寻找撬开铁皮瓶盖的开瓶工具。",
      "JA": "食堂でガラス瓶入りのビールやサイダーの王冠フタを開けるために栓抜きを探す場面です。"
    },
    "questions": {
      "KO": "가: 유리병에 든 시원한 탄산음료를 받았는데 쇠 뚜껑이 손으로 안 열려요.\n나: 수저통 옆에 있는 쇠로 된 (   )을/를 사용해서 뚜껑을 지렛대처럼 위로 따세요."
    },
    "options": ["손톱깎이", "가위", "병따개", "칼"],
    "answerIndex": 2,
    "explanations": {
      "KO": "유리병의 금속 뚜껑을 걸어서 지렛대 힘으로 열 수 있게 만든 주방 도구는 '병따개(Bottle opener)'예요!",
      "EN": "A tool used to pry off metal crown caps from glass bottles is a '병따개' (Bottle opener)!",
      "VI": "Dụng cụ dùng để cạy mở nắp kim loại của các chai thủy tinh là '병따개' (Dụng cụ mở nắp chai / Đồ khui bia)!",
      "ZH": "利用杠杆原理开启玻璃瓶金属皇冠盖的工具是'병따개'（开瓶器/起子）！",
      "JA": "ガラス瓶の金属製のフタを引っ掛けて開けるための道具は「병따개（栓抜き）」です！"
    }
  },
  # 593. 마트: 셀프 계산대
  {
    "id": 593,
    "category": "편의점·마트·쇼핑",
    "type": "word",
    "level": 1,
    "visual": "🛒 💳",
    "speechBubble": "셀프 계산대에서 직접 바코드를 스캔해요.",
    "keyword": "셀프 계산대",
    "situations": {
      "KO": "대형마트나 다이소에서 직원이 계산해 주기를 기다리지 않고 손님이 직접 무인 키오스크에서 바코드를 찍고 카드로 결제하는 상황입니다.",
      "EN": "Using a self-checkout kiosk at a mart to scan product barcodes and pay by card without cashier assistance.",
      "VI": "Tự quét mã vạch sản phẩm và thanh toán bằng thẻ tại quầy thu ngân tự động ở siêu thị.",
      "ZH": "在超市不排人工通道，由顾客自己在无人自助结账机上扫描条形码并完成刷卡付款。",
      "JA": "大型スーパーで店員のレジを待たず、客自身がバーコードをスキャンして決済するセルフレジを利用する場面です。"
    },
    "questions": {
      "KO": "가: 계산 줄이 너무 길어서 빨리 결제하고 나가고 싶어요.\n나: 저기 대기 줄이 없는 무인 (   )에 가셔서 직접 상품 바코드를 찍고 결제하세요."
    },
    "options": ["고객센터", "셀프 계산대", "물품보관소", "환전소"],
    "answerIndex": 1,
    "explanations": {
      "KO": "소비자가 직접 물건의 바코드를 스캔하고 신용카드로 결제하는 무인 계산 기기는 '셀프 계산대(Self-checkout)'예요!",
      "EN": "An automated checkout kiosk where shoppers scan and pay for their own items is a '셀프 계산대' (Self-checkout)!",
      "VI": "Quầy thanh toán tự động nơi người mua tự quét mã vạch và quẹt thẻ thanh toán là '셀프 계산대' (Quầy thanh toán tự động)!",
      "ZH": "由消费者自行扫描商品条形码并刷卡结账的无人收银设备是'셀프 계산대'（自助结账台）！",
      "JA": "購入者が自分で商品のバーコードを読み取らせてカード決済する無人レジは「셀프 계산대（セルフレジ）」です！"
    }
  },
  # 594. 마트: 포인트
  {
    "id": 594,
    "category": "편의점·마트·쇼핑",
    "type": "word",
    "level": 1,
    "visual": "💳 🎁",
    "speechBubble": "결제 금액의 일부를 멤버십 포인트로 적립해요.",
    "keyword": "포인트",
    "situations": {
      "KO": "편의점이나 올리브영에서 물건을 살 때 결제 금액의 일정 비율을 회원 혜택으로 차곡차곡 쌓아 나중에 현금처럼 쓰는 상황입니다.",
      "EN": "Accumulating membership reward points from purchases to use like cash on future shopping trips.",
      "VI": "Tích lũy điểm thưởng thành viên theo tỷ lệ giá trị thanh toán để sau này dùng giảm trừ như tiền mặt.",
      "ZH": "在便利店或美妆店消费时将消费金额按一定比例累积为会员积分，日后抵扣现金使用。",
      "JA": "コンビニやドラッグストアで買い物をする際、購入金額の一部をポイントとして貯め後で使う場面です。"
    },
    "questions": {
      "KO": "가: 물건을 사고 결제할 때 휴대폰 번호를 누르라고 하던데 왜 그런가요?\n나: 구매 금액의 일부를 적립해서 나중에 현금처럼 쓸 수 있는 멤버십 (   )을/를 쌓기 위해서예요."
    },
    "options": ["벌금", "수수료", "포인트", "세금"],
    "answerIndex": 2,
    "explanations": {
      "KO": "결제 금액의 일정 비율을 점수처럼 누적해 모았다가 상품 구매 시 할인에 사용하는 혜택 점수는 '포인트(Membership points)'예요!",
      "EN": "Reward credit points earned on purchases that can be redeemed for discounts are called '포인트' (Reward points)!",
      "VI": "Điểm thưởng tích lũy từ hóa đơn mua sắm để đổi thành tiền giảm giá sau này là '포인트' (Điểm tích lũy)!",
      "ZH": "按消费金额一定比例累加积分并在日后消费中抵扣现金的会员权益是'포인트'（积分）！",
      "JA": "購入金額の一定割合を貯めて後で値引きや買い物に充当できる特典は「포인트（ポイント）」です！"
    }
  },
  # 595. 마트: 묶음 상품
  {
    "id": 595,
    "category": "편의점·마트·쇼핑",
    "type": "word",
    "level": 1,
    "visual": "📦 🏷️",
    "speechBubble": "라면 5개가 든 묶음 상품을 사면 더 저렴해요.",
    "keyword": "묶음 상품",
    "situations": {
      "KO": "마트에서 낱개로 하나씩 사는 것보다 여러 개를 한 봉지로 묶어 놓은 패키지를 살 때 가격이 더 저렴함을 비교하는 상황입니다.",
      "EN": "Comparing prices and choosing a multi-pack bundle of instant ramen because it is cheaper than single packs.",
      "VI": "So sánh giá cả và chọn mua lốc đóng gói nhiều gói mì tôm để tiết kiệm chi phí hơn mua lẻ từng gói.",
      "ZH": "在超市选购商品时，发现购买多包装捆绑商品比单独购买单件更加经济实惠。",
      "JA": "スーパーで単品で一つずつ買うより、複数個がパックされたセット商品を買う方が割安である場面です。"
    },
    "questions": {
      "KO": "가: 라면 한 봉지에 1,000원인데 5개들이 한 패키지는 4,000원이네요?\n나: 네, 낱개보다 여러 개를 하나로 묶어서 파는 (   )을/를 사시면 훨씬 경제적이에요."
    },
    "options": ["중고 물품", "묶음 상품", "불량 식품", "전시 상품"],
    "answerIndex": 1,
    "explanations": {
      "KO": "동일하거나 유사한 상품 여러 개를 한 단위로 묶어서 할인된 가격에 판매하는 패키지는 '묶음 상품(Multi-pack bundle)'이에요!",
      "EN": "A bundled package of multiple identical or related items sold at a discounted rate is a '묶음 상품' (Bundle / Multi-pack)!",
      "VI": "Các sản phẩm cùng loại được đóng gói chung thành lốc với mức giá ưu đãi hơn gọi là '묶음 상품' (Hàng combo / Lốc đóng gói)!",
      "ZH": "将多件相同或相关商品捆绑在一起以优惠价格整包出售的包装形式是'묶음 상품'（捆绑套装/多件组合装）！",
      "JA": "複数の同一または関連商品を一つにまとめて割引価格で販売するパッケージは「묶음 상품（まとめ買いセット）」です！"
    }
  },
  # 596. 마트: 마감 세일
  {
    "id": 596,
    "category": "편의점·마트·쇼핑",
    "type": "word",
    "level": 1,
    "visual": "🌙 🏷️",
    "speechBubble": "저녁 8시 이후 대형마트 마감 세일을 노려요.",
    "keyword": "마감 세일",
    "situations": {
      "KO": "대형마트 폐점 직전 저녁 시간대에 당일 조리된 초밥, 치킨, 신선식품을 대폭 할인된 스티커 가격에 알뜰하게 구매하는 상황입니다.",
      "EN": "Hunting for discount sticker bargains on fresh sushi and chicken during evening clearance sales before mart closing.",
      "VI": "Mua sắm thông minh các món ăn tươi trong ngày như sushi, gà rán được giảm giá sâu vào khung giờ chuẩn bị đóng cửa siêu thị.",
      "ZH": "晚上大卖场打烊前选购贴有打折标签的当天熟食、寿司或生鲜食品的晚市清仓特价活动。",
      "JA": "スーパーの閉店前の夜間に、当日調理された寿司やチキンに貼られる値引きシール商品を賢く買う場面です。"
    },
    "questions": {
      "KO": "가: 대형마트에서 초밥이나 통닭을 정가보다 훨씬 저렴하게 사려면 언제 가야 하나요?\n나: 저녁 8시 이후에 방문하시면 당일 판매 식품을 할인해 주는 (   ) 스티커가 붙어요."
    },
    "options": ["오픈 기념", "마감 세일", "반품 행사", "예약 판매"],
    "answerIndex": 1,
    "explanations": {
      "KO": "매장 영업 종료를 앞두고 당일 소진해야 하는 신선식품을 대폭 할인하여 판매하는 행사는 '마감 세일(Evening clearance sale)'이에요!",
      "EN": "A store's evening discount sale to clear out fresh foods prepared on the same day is '마감 세일' (Clearance sale)!",
      "VI": "Chương trình hạ giá xả hàng các món ăn tươi sống trong ngày vào lúc chuẩn bị đóng cửa gọi là '마감 세일' (Xả hàng giờ chót)!",
      "ZH": "商场或超市在营业结束前将当天必须售完的生鲜熟食降价处理的促销活动是'마감 세일'（晚市清仓特价）！",
      "JA": "当日のうちに売り切るべき生鮮食品などを閉店間際に大幅に値下げして販売することは「마감 세일（見切りセール・閉店セール）」です！"
    }
  },
  # 597. 행정: 무인발급기
  {
    "id": 597,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "📠 🪪",
    "speechBubble": "지하철역 무인발급기에서 등본을 떼요.",
    "keyword": "무인발급기",
    "situations": {
      "KO": "주민센터 창구 대기 시간이 길거나 야간일 때 지하철역에 설치된 자동화 기기에서 지문 인식을 통해 공문서를 즉시 발급받는 상황입니다.",
      "EN": "Printing official civil documents using fingerprint recognition at an automated kiosk inside a subway station.",
      "VI": "Tự in các giấy tờ hành chính công dân qua nhận diện vân tay tại ki-ốt tự động đặt ở ga tàu điện ngầm.",
      "ZH": "在地铁站使用安装的便民自助政务机，通过指纹验证即时打印所需的官方证明文件。",
      "JA": "住民センターの窓口を待たずに、駅に設置された自動発券機で指紋認証により各種公的証明書を即座に発行する場面です。"
    },
    "questions": {
      "KO": "가: 주민센터 문이 닫힌 주말에 주민등록등본 서류가 급하게 필요한데 어디서 뽑나요?\n나: 가까운 지하철역 대합실에 가시면 24시간 운영되는 민원 (   )가 있어요."
    },
    "options": ["현금인출기", "자동판매기", "무인발급기", "공중전화"],
    "answerIndex": 2,
    "explanations": {
      "KO": "담당 공무원 없이 기계를 통해 주민등록, 가족관계 등의 증명 서류를 자동 출력하는 키오스크는 '무인발급기(무인민원발급기)'예요!",
      "EN": "An automated civil certificate kiosk that dispenses public registry documents is a '무인발급기' (Automated civil document kiosk)!",
      "VI": "Máy tự động in các loại giấy tờ hành chính như sổ hộ khẩu, chứng nhận quan hệ gia đình là '무인발급기' (Máy in hồ sơ tự động)!",
      "ZH": "通过触控屏幕与指纹识别无需人工窗口即可自助打印居民户籍官方证明文件的设备是'무인발급기'（无人政务自助打印机）！",
      "JA": "担当職員を介さず住民票などの公的証明書類を自動でプリントできる機械は「무인발급기（無人自動交付機）」です！"
    }
  },
  # 598. 행정: 수수료
  {
    "id": 598,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "🪙 📄",
    "speechBubble": "증명서 발급 수수료로 500원을 결제해요.",
    "keyword": "수수료",
    "situations": {
      "KO": "관공서에서 증명서를 출력하거나 타행 계좌로 송금할 때 서비스 제공 대가로 지불하는 소정의 처리 비용을 확인하는 상황입니다.",
      "EN": "Paying a small handling charge for service processing when issuing documents or making interbank transfers.",
      "VI": "Thanh toán một khoản tiền phí dịch vụ nhỏ khi in giấy tờ tại cơ quan công quyền hoặc chuyển tiền liên ngân hàng.",
      "ZH": "在政府办事处开具证明文件或跨行转账时支付的一笔小额业务办理服务费。",
      "JA": "役所で証明書を発行したり他行送金をする際にサービス対価として支払う所定の事務処理費用を確認する場面です。"
    },
    "questions": {
      "KO": "가: 동사무소 창구에서 서류를 발급받을 때 내는 1,000원은 무슨 돈인가요?\n나: 공공 서류 발급 행정 서비스를 처리하는 대가로 납부하는 행정 (   )예요."
    },
    "options": ["월세", "수수료", "보증금", "팁"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 행정 서비스나 금융 거래를 대행하고 이용하는 대가로 지불하는 정해진 요금은 '수수료(Commission / Handling fee)'예요!",
      "EN": "A charge or fee paid in exchange for an administrative or financial service is a '수수료' (Handling fee / Commission)!",
      "VI": "Khoản chi phí trả cho một dịch vụ hành chính hoặc giao dịch ngân hàng là '수수료' (Phí dịch vụ / Lệ phí)!",
      "ZH": "为获得行政服务或代办业务而支付的法定规费或手续费用是'수수료'（手续费/规费）！",
      "JA": "行政サービスや金融取引の対価として支払う所定の手数料は「수수료（手数料）」です！"
    }
  },
  # 599. 행정: 전입신고
  {
    "id": 599,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "🚚 🏛️",
    "speechBubble": "이사 후 14일 이내에 전입신고를 해요.",
    "keyword": "전입신고",
    "situations": {
      "KO": "새 거주지로 이사한 후 법적으로 거주지 변경 사실을 공인받기 위해 관할 주민센터에 신고서를 제출하는 법적 절차 상황입니다.",
      "EN": "Submitting a moving-in change of address report at the local community center within 14 days of moving.",
      "VI": "Nộp đơn đăng ký chuyển đến nơi ở mới tại ủy ban phường trong vòng 14 ngày sau khi chuyển nhà.",
      "ZH": "搬入新居后14天内前往所属社区中心提交法定地址变更申报书。",
      "JA": "新しい住居へ引っ越した後、法的住所変更の手続きのため管轄の住民センターに届出を提出する場面です。"
    },
    "questions": {
      "KO": "가: 다른 동네로 방을 구해 이사했는데 법적으로 꼭 해야 하는 의무 행정 절차가 있나요?\n나: 네, 이사한 날부터 14일 이내에 관할 행정복지센터에 가서 (   )을/를 반드시 마쳐야 해요."
    },
    "options": ["혼인신고", "전입신고", "출생신고", "사망신고"],
    "answerIndex": 1,
    "explanations": {
      "KO": "새로운 거주지에 거주하기 시작했음을 지자체 행정 관청에 공식 등록하는 행정 절차는 '전입신고(Moving-in report)'예요!",
      "EN": "The mandatory legal notification of registering your new residence address is a '전입신고' (Moving-in registration)!",
      "VI": "Thủ tục hành chính chính thức đăng ký địa chỉ cư trú mới tại cơ quan địa phương là '전입신고' (Khai báo chuyển đến / Đăng ký tạm trú)!",
      "ZH": "迁入新住所后向当地行政主管机关依法登记现居住地址的申报制度是'전입신고'（迁入申报/落户申报）！",
      "JA": "新しい住所に住み始めたことを行政機関に公式に登録する手続きは「전입신고（転入届）」です！"
    }
  },
  # 600. 행정: 정부24
  {
    "id": 600,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "💻 🏛️",
    "speechBubble": "인터넷 정부24 사이트에서 증명서를 출력해요.",
    "keyword": "정부24",
    "situations": {
      "KO": "주민센터에 직접 방문하지 않고 집이나 사무실 컴퓨터로 대한민국 공식 전자민원 포털 사이트에 접속해 서류를 무료 발급하는 상황입니다.",
      "EN": "Accessing Korea's official public civil service portal website 'Gov24' to issue civil certificates online for free.",
      "VI": "Truy cập cổng dịch vụ công trực tuyến chính thức 'Gov24' của Hàn Quốc để in giấy tờ miễn phí tại nhà.",
      "ZH": "无需前往办事窗口，在电脑上访问韩国官方综合便民政务网络服务门户'政府24'免费打印各种证件。",
      "JA": "窓口に行かずに自宅のパソコンから韓国の公式オンライン行政ポータル「政府24」にアクセスし書類を発行する場面です。"
    },
    "questions": {
      "KO": "가: 주민센터에 직접 가지 않고 인터넷으로 주민등록등본을 무료로 즉시 뽑으려면 어디 사이트에 들어가나요?\n나: 대한민국 공식 온라인 전자민원 포털 웹사이트인 (   )에 로그인해서 발급받으세요."
    },
    "options": ["유튜브", "정부24", "인스타그램", "당근마켓"],
    "answerIndex": 1,
    "explanations": {
      "KO": "대한민국 중앙정부에서 운영하는 공식 통합 전자민원 안내 및 서류 발급 온라인 포털 사이트는 '정부24(Gov24)'예요!",
      "EN": "The official online government portal website for civil applications in South Korea is '정부24' (Gov24)!",
      "VI": "Cổng thông tin dịch vụ hành chính công trực tuyến chính thức của chính phủ Hàn Quốc là '정부24' (Chính phủ 24 / Gov24)!",
      "ZH": "由韩国中央政府运营、提供一站式民事证件线上申领办理的官方国家政务网站是'정부24'（政府24）！",
      "JA": "韓国中央政府が運営する各種証明書発行やオンライン行政案内ポータルサイトは「정부24（政府24）」です！"
    }
  }
]

# Write to questions.json
with open('assets/data/questions.json', 'r', encoding='utf-8') as f:
    questions = json.load(f)

existing_ids = set(q['id'] for q in questions)
added = 0
for item in new_40:
    if item['id'] not in existing_ids:
        questions.append(item)
        added += 1

with open('assets/data/questions.json', 'w', encoding='utf-8') as f:
    json.dump(questions, f, ensure_ascii=False, indent=2)
    f.write('\n')

print(f"Added {added} questions. Total questions now: {len(questions)}")

