import json

new_40 = [
  {
    "id": 501,
    "category": "핵심표현·의사소통",
    "type": "sentence",
    "level": 1,
    "visual": "🚲 🌿",
    "speechBubble": "두 바퀴 자전거를 탈 줄 알아요.",
    "keyword": "탈 줄 알아요",
    "situations": {
      "KO": "자전거를 타는 방법을 알고 있어서 실제로 탈 수 있는 능력이 있음을 말하는 상황입니다.",
      "EN": "Expressing that you know how to ride a bicycle and have the ability to do so.",
      "VI": "Tình huống nói rằng mình biết cách đi xe đạp và có khả năng đi được xe đạp.",
      "ZH": "表示自己知道怎么骑自行车并具备骑车能力的日常场景。",
      "JA": "自転車の乗り方を知っていて実際に乗る能力があることを話す場面です。"
    },
    "questions": {
      "KO": "가: 날씨도 좋은데 한강에서 자전거 빌려서 탈까요? 자전거 탈 수 있어요?\n나: 네, 어렸을 때 배워서 두 바퀴 자전거를 (   )."
    },
    "options": [
      "탈 줄 몰라요",
      "탈 줄 알아요",
      "타기 싫어요",
      "타지 못해요"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 일을 하는 방법이나 능력이 있음을 나타낼 때는 '-(으)ㄹ 줄 알다'를 사용해요. 할 수 있으므로 '탈 줄 알아요'가 정답이에요!",
      "EN": "Use '-(으)ㄹ 줄 알다' to express knowing how to do something or having the ability. '탈 줄 알아요' means 'I know how to ride'!",
      "VI": "Dùng '-(으)ㄹ 줄 알다' khi biểu thị biết cách làm hoặc có năng lực làm việc gì. '탈 줄 알아요' nghĩa là 'Tôi biết lái/đi'!",
      "ZH": "表示知道做某事的方法或具备某种能力时使用'-(으)ㄹ 줄 알다'，'탈 줄 알아요'表示'会骑'！",
      "JA": "何かをする方法や能力があることを表す時は「-(으)ㄹ 줄 알다」を使います。「탈 줄 알아요」で「乗ることができます」という意味です！"
    }
  },
  {
    "id": 502,
    "category": "K-컬처·소통·신조어",
    "type": "sentence",
    "level": 1,
    "visual": "👘 📸",
    "speechBubble": "전통 한복을 입어 본 적이 있어요.",
    "keyword": "입어 본 적이 있어요",
    "situations": {
      "KO": "경복궁에 놀러 가서 한국의 전통 한복을 직접 착용해 본 과거 경험을 이야기하는 상황입니다.",
      "EN": "Sharing the past experience of wearing traditional Hanbok at Gyeongbokgung Palace.",
      "VI": "Kể về trải nghiệm trong quá khứ khi mặc thử trang phục truyền thống Hanbok tại cung điện Gyeongbokgung.",
      "ZH": "讲述去景福宫游玩时亲自试穿过韩国传统韩服的过往经历。",
      "JA": "景福宮へ行って韓国の伝統衣装である韓服（ハンボク）を着てみた過去の経験を話す場面です。"
    },
    "questions": {
      "KO": "가: 한국에 여행 와서 특별한 전통 문화 체험을 해 본 적이 있어요?\n나: 네, 지난달에 경복궁에서 알록달록한 한복을 (   )."
    },
    "options": [
      "입어 본 적이 있어요",
      "입어 보지 않아요",
      "입고 싶지 않아요",
      "입으려고 해요"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "과거에 어떤 일을 직접 경험해 본 사실이 있음을 나타낼 때는 '-(으)ㄴ 적이 있다'를 써서 '입어 본 적이 있어요'라고 표현해요!",
      "EN": "Use '-(으)ㄴ 적이 있다' to express having had a past experience. '입어 본 적이 있어요' means 'I have worn it before'!",
      "VI": "Dùng '-(으)ㄴ 적이 있다' khi nói về trải nghiệm đã từng có trong quá khứ. '입어 본 적이 있어요' nghĩa là 'Tôi đã từng mặc qua'!",
      "ZH": "表示过去曾有某种亲身经历时使用'-(으)ㄴ 적이 있다'，'입어 본 적이 있어요'表示'曾穿过'！",
      "JA": "過去に何かを経験したことがある事実を表す時は「-(으)ㄴ 적이 있다」を使い、「입어 본 적이 있어요（着たことがあります）」と言います！"
    }
  },
  {
    "id": 503,
    "category": "시간·일정·문장완성",
    "type": "sentence",
    "level": 1,
    "visual": "🎬 🍿",
    "speechBubble": "영화관에 영화를 보려고 해요.",
    "keyword": "보려고 해요",
    "situations": {
      "KO": "주말 여가 시간에 친구와 함께 극장에서 영화를 관람할 계획과 의도를 밝히는 상황입니다.",
      "EN": "Explaining your intention and plan to watch a movie at the cinema with a friend this weekend.",
      "VI": "Nói về dự định và kế hoạch đi xem phim tại rạp cùng bạn vào dịp cuối tuần.",
      "ZH": "说明周末打算和朋友一起去电影院看电影的计划与意图。",
      "JA": "週末の余暇に友達と一緒に映画館で映画を観る予定や意図を伝える場面です。"
    },
    "questions": {
      "KO": "가: 이번 주말에 특별한 계획이 있어요?\n나: 네, 토요일 오후에 친구와 영화관에서 최신 인기 영화를 (   )."
    },
    "options": [
      "보지 않겠어요",
      "보려고 해요",
      "본 적이 없어요",
      "보기 힘들어요"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "앞으로 어떤 행동을 하려는 계획이나 의도를 나타낼 때는 동사 어간 뒤에 '-(으)려고 하다'를 써요. '보다' 뒤에 붙어 '보려고 해요'가 돼요!",
      "EN": "Use '-(으)려고 하다' to express an intention or plan to do something. Attached to '보다', it forms '보려고 해요' (I plan to watch)!",
      "VI": "Sử dụng '-(으)려고 하다' để thể hiện dự định hoặc kế hoạch làm việc gì. Gắn sau '보다' trở thành '보려고 해요' (Tôi định xem)!",
      "ZH": "表示今后打算做某事的计划或意图时使用'-(으)려고 하다'。接在'보다'后变为'보려고 해요'（打算看）！",
      "JA": "これから何かをする計画や意図を表す時は「-(으)려고 하다」を使います。「보다」の後ろについて「보려고 해요（観るつもりです）」になります！"
    }
  },
  {
    "id": 504,
    "category": "일상생활·장소",
    "type": "sentence",
    "level": 1,
    "visual": "🤫 📵",
    "speechBubble": "도서관 열람실에서는 통화하면 안 돼요.",
    "keyword": "통화하면 안 돼요",
    "situations": {
      "KO": "조용히 공부하는 도서관 열람실에서 소음을 유발하는 전화 통화가 금지되어 있음을 안내하는 상황입니다.",
      "EN": "Informing someone that phone calls are prohibited in the quiet library study room.",
      "VI": "Nhắc nhở rằng hành vi gọi điện thoại bị cấm trong phòng đọc thư viện để giữ yên tĩnh.",
      "ZH": "告知在需要保持安静的图书馆自习室里禁止打电话的规矩。",
      "JA": "静かに勉強する図書館の閲覧室で、電話通話が禁止されていることを案内する場面です。"
    },
    "questions": {
      "KO": "가: 도서관 열람실에서 갑자기 전화가 왔는데 여기서 바로 받아도 돼요?\n나: 안 돼요! 다른 사람들이 집중해서 공부하고 있으니 실내에서 (   )."
    },
    "options": [
      "통화해도 돼요",
      "통화하면 안 돼요",
      "통화하기 쉬워요",
      "통화할 수 있어요"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "규칙상 어떤 행동을 하지 못하도록 금지할 때는 '-(으)면 안 되다'를 써서 '통화하면 안 돼요'라고 단호하고 정중하게 안내해요!",
      "EN": "Use '-(으)면 안 되다' to express prohibition. '통화하면 안 돼요' means 'You must not talk on the phone'!",
      "VI": "Dùng '-(으)면 안 되다' khi cấm đoán một hành vi nào đó theo quy định: '통화하면 안 돼요' (Không được nghe điện thoại)!",
      "ZH": "根据规定禁止做出某种行为时使用'-(으)면 안 되다'，'통화하면 안 돼요'表示'不能/不可以通话'！",
      "JA": "規則上ある行動を禁止する時は「-(으)면 안 되다」を使い、「통화하면 안 돼요（通話してはいけません）」と言います！"
    }
  },
  {
    "id": 505,
    "category": "핵심표현·의사소통",
    "type": "sentence",
    "level": 1,
    "visual": "🪑 🙋",
    "speechBubble": "여기 빈자리에 잠깐 앉아도 돼요?",
    "keyword": "앉아도 돼요",
    "situations": {
      "KO": "카페나 대기실에서 빈 의자를 발견하고 다른 사람에게 착석 가능 여부를 공손하게 허락 구하는 상황입니다.",
      "EN": "Politely asking for permission to sit in an empty chair at a café or waiting area.",
      "VI": "Hỏi xin phép một cách lịch sự xem có thể ngồi vào chiếc ghế trống ở quán cà phê hay phòng chờ không.",
      "ZH": "在咖啡厅或候车室看到空位，礼貌询问他人是否可以就坐的场景。",
      "JA": "カフェや待合室で空いている席を見つけ、座ってもよいか丁寧に許可を求める場面です。"
    },
    "questions": {
      "KO": "가: 실례지만 옆자리에 일행이 없으시면 여기 (   )?\n나: 네, 빈자리니까 편하게 앉으세요."
    },
    "options": [
      "앉으면 안 돼요",
      "앉아도 돼요",
      "앉지 마세요",
      "앉을 수 없어요"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 행동에 대해 허락을 구하거나 동의를 물어볼 때는 '-아/어도 되다'를 사용하여 '앉아도 돼요?'라고 물어봅니다.",
      "EN": "Use '-아/어도 되다' to ask for permission. '앉아도 돼요?' means 'May I sit here?'!",
      "VI": "Dùng '-아/어도 되다' khi xin phép hoặc hỏi ý kiến: '앉아도 돼요?' (Tôi ngồi đây có được không ạ?)!",
      "ZH": "向对方请求许可或询问是否允许做某事时使用'-아/어도 되다'，'앉아도 돼요?'表示'可以坐在这里吗？'！",
      "JA": "許可を求めたり同意を尋ねる時は「-아/어도 되다」を使い、「앉아도 돼요?（座ってもいいですか？）」と聞きます。"
    }
  },
  {
    "id": 506,
    "category": "신체·건강",
    "type": "sentence",
    "level": 1,
    "visual": "🧼 🍽️",
    "speechBubble": "식사하기 전에 손을 깨끗이 씻어요.",
    "keyword": "먹기 전에",
    "situations": {
      "KO": "음식을 먹기 앞서 위생을 위해 비누로 손을 먼저 씻는 시간적 선후 관계를 표현하는 상황입니다.",
      "EN": "Describing the temporal sequence of washing hands with soap before eating a meal.",
      "VI": "Mô tả trình tự thời gian rửa sạch tay bằng xà phòng trước khi bắt đầu dùng bữa.",
      "ZH": "说明就餐前为了卫生先用肥皂洗手的先后时间顺序。",
      "JA": "食事をする前に衛生のため石鹸でまず手を洗う時間的前後関係を表す場面です。"
    },
    "questions": {
      "KO": "가: 손에 먼지가 묻어 있네요. 음식을 (   ) 비누로 깨끗하게 손을 씻으세요.\n나: 네, 위생을 위해서 먼저 손을 씻고 올게요."
    },
    "options": [
      "먹은 후에",
      "먹기 전에",
      "먹으면서",
      "먹지 않고"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 행위를 하기 앞서 일어나는 선행 행동을 나타낼 때는 동사 어간에 '-기 전에'를 붙여 '먹기 전에'라고 표현해요!",
      "EN": "Use '-기 전에' to express doing something before another action. '먹기 전에' means 'before eating'!",
      "VI": "Gắn '-기 전에' vào sau động từ để biểu thị hành động xảy ra trước: '먹기 전에' (Trước khi ăn)!",
      "ZH": "表示在做某事之前发生先行行为时在动词后加上'-기 전에'，'먹기 전에'表示'吃饭前'！",
      "JA": "ある行動をする前に起きる先行動作を表す時は動詞の語幹に「-기 전에」をつけて「먹기 전에（食べる前に）」と言います！"
    }
  },
  {
    "id": 507,
    "category": "병원·약국·응급",
    "type": "sentence",
    "level": 1,
    "visual": "💊 🍚",
    "speechBubble": "약은 식사를 한 후에 드세요.",
    "keyword": "한 후에",
    "situations": {
      "KO": "약국에서 위장 보호를 위해 반드시 밥을 다 먹고 난 뒤에 복용하라는 지침을 듣는 상황입니다.",
      "EN": "Listening to the pharmacist's instruction to take medication after finishing a meal to protect the stomach.",
      "VI": "Lắng nghe dược sĩ dặn dò phải uống thuốc sau khi đã ăn cơm xong để bảo vệ dạ dày.",
      "ZH": "在药店听取药剂师叮嘱为了保护肠胃必须在吃完饭后再服药的场景。",
      "JA": "薬局で胃を保護するために必ず食事を済ませた後に薬を飲むよう指示を聞く場面です。"
    },
    "questions": {
      "KO": "가: 약사님, 이 처방약은 빈속에 먹어도 괜찮나요?\n나: 아니요, 위에 부담이 될 수 있으니 밥을 든든하게 (   ) 30분 뒤에 드세요."
    },
    "options": [
      "하기 전에",
      "한 후에",
      "하면서",
      "하지 않고"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 행동이 완료된 이후에 뒤의 행동이 이어짐을 나타낼 때는 '-(으)ㄴ 후에'를 써요. '식사를 한 후에'가 올바릅니다.",
      "EN": "Use '-(으)ㄴ 후에' to express doing something after completing an action. '식사를 한 후에' means 'after having a meal'.",
      "VI": "Dùng '-(으)ㄴ 후에' để biểu thị hành động tiếp theo xảy ra sau khi hành động trước kết thúc: '식사를 한 후에' (Sau khi ăn cơm).",
      "ZH": "表示某行动完成之后接着进行后续行动时使用'-(으)ㄴ 후에'，'식사를 한 후에'表示'吃完饭后'。",
      "JA": "ある行動が終わった後に次の行動が続くことを表す時は「-(으)ㄴ 후에」を使います。「식사를 한 후에（食事をした後に）」が正解です。"
    }
  },
  {
    "id": 508,
    "category": "자연·날씨",
    "type": "sentence",
    "level": 1,
    "visual": "☔ 🌧️",
    "speechBubble": "비가 올 때 우산을 챙겨요.",
    "keyword": "올 때",
    "situations": {
      "KO": "하늘에서 비가 쏟아지는 특정한 날씨 시점에 우산을 잊지 않고 펼쳐야 함을 설명하는 상황입니다.",
      "EN": "Explaining that one should remember to bring and use an umbrella when it rains.",
      "VI": "Giải thích rằng cần mang theo và che ô vào thời điểm trời đổ mưa.",
      "ZH": "说明在天下雨的特定天气时刻不要忘记带伞撑伞的情况。",
      "JA": "雨が降る特定の天気のタイミングに傘を忘れずに差すべきであることを説明する場面です。"
    },
    "questions": {
      "KO": "가: 오늘 일기예보 봤어요? 오후에 하늘에서 비가 (   ) 가방에 든 접이식 우산을 꺼내세요.\n나: 네, 잊지 않고 꼭 챙겨서 나갈게요."
    },
    "options": [
      "온 후에",
      "올 때",
      "오기 전에",
      "오지 않아"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 일이나 상태가 진행되는 시간적 시점을 가리킬 때는 동사 뒤에 '-(으)ㄹ 때'를 붙여 '비가 올 때'라고 표현해요!",
      "EN": "Use '-(으)ㄹ 때' to specify the time or occasion when an action takes place: '비가 올 때' (when it rains)!",
      "VI": "Gắn '-(으)ㄹ 때' sau động từ để chỉ thời điểm diễn ra sự việc: '비가 올 때' (Khi trời mưa)!",
      "ZH": "表示某种事情或状态发生的特定时间节点时在动词后加上'-(으)ㄹ 때'，'비가 올 때'表示'下雨时'！",
      "JA": "ある出来事や状態が進行する時間的時点を指す時は動詞に「-(으)ㄹ 때」をつけて「비가 올 때（雨が降る時）」と言います！"
    }
  },
  {
    "id": 509,
    "category": "자연·날씨",
    "type": "sentence",
    "level": 1,
    "visual": "🧥 ❄️",
    "speechBubble": "바람이 차니까 따뜻하게 입으세요.",
    "keyword": "추우니까",
    "situations": {
      "KO": "바깥 기온이 영하로 떨어져 춥다는 객관적 이유와 근거를 들어 상대방에게 두꺼운 겉옷을 권하는 상황입니다.",
      "EN": "Advising someone to bundle up with warm outerwear because the outside temperature has dropped below freezing.",
      "VI": "Khuyên đối phương mặc áo khoác dày vì nhiệt độ ngoài trời đã giảm xuống dưới 0 độ rất lạnh.",
      "ZH": "以室外气温降至零下很冷为理由根据，建议对方穿厚外套的场景。",
      "JA": "外の気温が氷点下に下がり寒いという理由を挙げて、相手に暖かい上着を着るよう勧める場面です。"
    },
    "questions": {
      "KO": "가: 오늘 아침 기온이 영하 5도래요.\n나: 바깥 날씨가 아주 (   ) 목도리를 두르고 두꺼운 패딩을 입으세요."
    },
    "options": [
      "더우니까",
      "추우니까",
      "따뜻하니까",
      "맑으니까"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 행동을 권유하거나 명령하는 이유나 근거를 제시할 때는 '-(으)니까'를 써요. 춥기 때문에 '추우니까'가 알맞습니다.",
      "EN": "Use '-(으)니까' to give a reason or premise when giving advice or suggestions: '추우니까' (Because it's cold).",
      "VI": "Dùng '-(으)니까' khi đưa ra nguyên nhân hoặc căn cứ để khuyên nhủ: '추우니까' (Vì trời lạnh).",
      "ZH": "提出劝诱或建议的理由与根据时使用'-(으)니까'。因为天气冷，所以用'추우니까'（因为冷）。",
      "JA": "提案や勧めの理由・根拠を提示する時は「-(으)니까」を使います。寒いので「추우니까（寒いから）」が適しています。"
    }
  },
  {
    "id": 510,
    "category": "교통·길찾기·택시",
    "type": "sentence",
    "level": 1,
    "visual": "🚗 ⏰",
    "speechBubble": "퇴근길에 차가 막혀서 늦었어요.",
    "keyword": "막혀서",
    "situations": {
      "KO": "퇴근 시간 도로에 자동차가 몰려 정체가 심해 약속 시간에 지각하게 된 이유를 설명하는 상황입니다.",
      "EN": "Explaining the cause of being late to an appointment due to severe rush-hour traffic congestion.",
      "VI": "Giải thích nguyên nhân đến trễ hẹn do đường sá bị ùn tắc giao thông nghiêm trọng vào giờ tan tầm.",
      "ZH": "解释下班高峰期道路堵车严重导致赴约迟到的原因。",
      "JA": "退勤時間の道路に車が集中して渋滞がひどく、約束の時間に遅刻した理由を説明する場面です。"
    },
    "questions": {
      "KO": "가: 지훈 씨, 왜 약속 시간보다 20분이나 늦었어요?\n나: 정말 죄송해요! 퇴근 시간이라 도로에 차가 너무 (   ) 늦었어요."
    },
    "options": [
      "안 막혀서",
      "막혀서",
      "빨라서",
      "없어서"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "자연스러운 원인이나 인과관계를 나타낼 때는 '-아/어서'를 써요. 도로가 막힌 것이 늦은 원인이므로 '막혀서'가 정답이에요!",
      "EN": "Use '-아/어서' to express a natural cause-and-effect relationship. '막혀서' means 'because it was congested/blocked'!",
      "VI": "Sử dụng '-아/어서' để chỉ mối quan hệ nhân quả tự nhiên: '막혀서' (Vì bị tắc đường)!",
      "ZH": "表示自然的因果关系时使用'-아/어서'。堵车是迟到的原因，因此'막혀서'（因为堵车）是正确答案！",
      "JA": "自然な原因や因果関係を表す時は「-아/어서」を使います。道が混んでいたのが遅れた原因なので「막혀서（混んでいて）」が正解です！"
    }
  },
  {
    "id": 511,
    "category": "일상생활·장소",
    "type": "sentence",
    "level": 1,
    "visual": "🎵 🧹",
    "speechBubble": "신나는 음악을 들으면서 방 청소를 해요.",
    "keyword": "들으면서",
    "situations": {
      "KO": "한 사람이 방을 쓸고 닦으면서 동시에 스마트폰으로 음악을 함께 감상하는 동시 행동을 묘사하는 상황입니다.",
      "EN": "Describing two simultaneous actions of listening to music on a smartphone while cleaning the room.",
      "VI": "Miêu tả hai hành động diễn ra đồng thời: vừa dọn dẹp phòng vừa nghe nhạc trên điện thoại.",
      "ZH": "描述一边打扫房间一边用手机听音乐这两种同时进行的动作。",
      "JA": "部屋の掃除をしながら同時にスマートフォンで音楽を聴く同時行動を表す場面です。"
    },
    "questions": {
      "KO": "가: 주말 아침마다 집에서 무엇을 해요?\n나: 저는 기분 전환을 하려고 신나는 K-POP 음악을 (   ) 방 청소를 해요."
    },
    "options": [
      "듣기 전에",
      "들으면서",
      "들은 후에",
      "듣지 않고"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "한 주체가 두 가지 행동을 동시에 수행함을 나타낼 때는 '-(으)면서'를 써요. '듣다'는 'ㄷ' 불규칙으로 '들으면서'가 됩니다.",
      "EN": "Use '-(으)면서' to indicate two actions occurring simultaneously by the same subject. '듣다' becomes '들으면서' (while listening)!",
      "VI": "Dùng '-(으)면서' khi một chủ thể thực hiện đồng thời hai hành động. '듣다' biến đổi bất quy tắc thành '들으면서' (vừa nghe vừa)!",
      "ZH": "同一主体同时进行两项动作时使用'-(으)면서'。'듣다'为'ㄷ'不规则动词，变为'들으면서'（一边听一边）！",
      "JA": "1つの主語が2つの行動を同時に行うことを表す時は「-(으)면서」を使います。「듣다」は変則活用で「들으면서（聴きながら）」になります。"
    }
  },
  {
    "id": 512,
    "category": "핵심표현·의사소통",
    "type": "sentence",
    "level": 1,
    "visual": "🍽️ 🧼",
    "speechBubble": "식사 후 설거지는 제가 할게요.",
    "keyword": "할게요",
    "situations": {
      "KO": "식사를 마친 후 상대방에게 싱크대 그릇 정리를 자신이 책임지고 하겠다고 약속하고 의지를 밝히는 상황입니다.",
      "EN": "Promising and volunteering to take responsibility for washing the dishes after a meal.",
      "VI": "Hứa và chủ động nhận việc rửa chén bát sau bữa ăn để giúp đối phương.",
      "ZH": "吃完饭后向对方承诺并主动表示由自己来负责清洗碗筷。",
      "JA": "食事が終わった後、相手に自分が責任を持って皿洗いをするという意志を伝える場面です。"
    },
    "questions": {
      "KO": "가: 오늘 맛있는 저녁 요리 만들어 주셔서 정말 감사해요!\n나: 맛있게 드셔서 기뻐요. 뒷정리 싱크대 설거지는 제가 (   )."
    },
    "options": [
      "하지 않아요",
      "할게요",
      "하고 싶어요",
      "한 적이 있어요"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "화자가 상대방에게 어떤 행동을 하겠다고 약속하거나 자발적 의지를 나타낼 때는 '-(으)ㄹ게요'를 써서 '할게요'라고 말해요!",
      "EN": "Use '-(으)ㄹ게요' to express the speaker's promise or willingness to do something: '할게요' (I will do it)!",
      "VI": "Dùng '-(으)ㄹ게요' khi người nói hứa hẹn hoặc thể hiện ý chí tự nguyện làm việc gì: '할게요' (Tôi sẽ làm)!",
      "ZH": "说话者向对方承诺做某事或表达自发意愿时使用'-(으)ㄹ게요'，'할게요'表示'我来做'！",
      "JA": "話し手が相手に何かをすると約束したり自発的な意志を表す時は「-(으)ㄹ게요」を使い、「할게요（私がやります）」と言います！"
    }
  },
  {
    "id": 513,
    "category": "식당·외식·이동",
    "type": "sentence",
    "level": 1,
    "visual": "🍜 🧊",
    "speechBubble": "점심에 시원한 냉면 먹을까요?",
    "keyword": "먹을까요",
    "situations": {
      "KO": "더운 여름 점심시간에 동료에게 시원한 얼음 육수가 든 냉면을 함께 먹자고 의사를 묻고 제안하는 상황입니다.",
      "EN": "Suggesting having cold noodles with chilled broth for lunch to a colleague on a hot summer day.",
      "VI": "Gợi ý rủ đồng nghiệp cùng đi ăn mì lạnh có nước dùng mát lạnh vào buổi trưa hè oi bức.",
      "ZH": "在炎热的夏天中午向同事提议一起去吃带冰镇汤汁的冷面并征求意见。",
      "JA": "暑い夏の昼休みに同僚へ冷たい冷麺を一緒に食べようと意見を尋ねて提案する場面です。"
    },
    "questions": {
      "KO": "가: 오늘 날씨가 너무 무덥네요. 점심 메뉴로 시원한 물냉면 (   )?\n나: 좋은 생각이에요! 당장 근처 냉면 전문점으로 가요."
    },
    "options": [
      "먹지 마세요",
      "먹을까요",
      "먹은 후에",
      "먹기 싫어요"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "상대방의 의견을 묻거나 함께 어떤 일을 하자고 조심스럽게 제안할 때는 '-(으)ㄹ까요?'를 써서 '먹을까요?'라고 물어요!",
      "EN": "Use '-(으)ㄹ까요?' to suggest an action or ask for the listener's opinion: '먹을까요?' (Shall we eat?)!",
      "VI": "Dùng '-(으)ㄹ까요?' khi rủ rê hoặc hỏi ý kiến đối phương cùng làm gì: '먹을까요?' (Chúng mình ăn nhé?)!",
      "ZH": "征求对方意见或委婉提议一起做某事时使用'-(으)ㄹ까요?'，'먹을까요?'表示'我们要吃……吗？'！",
      "JA": "相手の意見を尋ねたり一緒に行動することを提案する時は「-(으)ㄹ까요?」を使い、「먹을까요?（食べましょうか？）」と聞きます！"
    }
  },
  {
    "id": 514,
    "category": "카페·식당·외식문화",
    "type": "sentence",
    "level": 1,
    "visual": "☕ 📋",
    "speechBubble": "어떤 음료로 주문하시겠어요?",
    "keyword": "주문하시겠어요",
    "situations": {
      "KO": "카페 직원이 카운터에 선 손님에게 어떤 메뉴를 마실 것인지 공손하고 정중하게 주문을 묻는 상황입니다.",
      "EN": "A café barista politely asking a customer at the counter what drink they would like to order.",
      "VI": "Nhân viên quán cà phê lịch sự hỏi khách hàng tại quầy xem muốn gọi món đồ uống nào.",
      "ZH": "咖啡店店员在吧台前礼貌客气地询问顾客想点什么饮品。",
      "JA": "カフェの店員がカウンターに立った客にどの飲み物を注文するか丁寧に尋ねる場面です。"
    },
    "questions": {
      "KO": "가: 어서 오세요! 고객님, 오늘 어떤 음료로 (   )?\n나: 따뜻한 카페라떼 한 잔 테이크아웃으로 부탁드려요."
    },
    "options": [
      "주문하지 마세요",
      "주문하시겠어요",
      "주문하면 안 돼요",
      "주문한 적이 있어요"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "손님이나 웃어른의 의향을 높여서 정중하게 물어볼 때는 존칭 '-(으)시겠어요?'를 써서 '주문하시겠어요?'라고 질문합니다.",
      "EN": "Use '-(으)시겠어요?' to politely ask for a customer's or elder's choice or intention: '주문하시겠어요?' (Would you like to order?)!",
      "VI": "Dùng '-(으)시겠어요?' để hỏi ý định của khách hàng hoặc người lớn tuổi một cách trang trọng: '주문하시겠어요?' (Quý khách muốn gọi món gì ạ?)!",
      "ZH": "向顾客或长辈礼貌询问其意向时使用尊称'-(으)시겠어요?'，'주문하시겠어요?'表示'请问您要点什么？'！",
      "JA": "客や目上の人の意向を高めて丁寧に尋ねる時は敬語「-(으)시겠어요?」を使い、「주문하시겠어요?（ご注文なさいますか？）」と聞きます。"
    }
  },
  {
    "id": 515,
    "category": "핵심표현·의사소통",
    "type": "sentence",
    "level": 1,
    "visual": "🤝 📖",
    "speechBubble": "다 함께 힘내서 열심히 공부합시다.",
    "keyword": "공부합시다",
    "situations": {
      "KO": "수업이나 모임에서 다 같이 힘을 내어 다 함께 참여하자고 공적인 어조로 청유하는 상황입니다.",
      "EN": "Formally suggesting that everyone work hard and study together in a classroom or group setting.",
      "VI": "Đưa ra lời đề nghị trang trọng kêu gọi mọi người cùng nhau cố gắng học tập chăm chỉ.",
      "ZH": "在课堂或集会中以较正式的语调提议大家一起鼓劲努力学习。",
      "JA": "授業や集まりでみんな一緒に力を合わせて熱心に勉強しようと公的に呼びかける場面です。"
    },
    "questions": {
      "KO": "가: 다음 주에 한국어능력시험이 있으니까 다 같이 힘내서 (   ).\n나: 네, 모두 좋은 점수 받을 수 있게 끝까지 파이팅해요!"
    },
    "options": [
      "공부하지 맙시다",
      "공부합시다",
      "공부하기 싫어요",
      "공부하면 안 돼요"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "격식 있는 자리에서 청자에게 함께 행동할 것을 권유할 때는 '-(으)ㅂ시다'를 써서 '공부합시다'라고 말해요!",
      "EN": "Use '-(으)ㅂ시다' in formal contexts to propose doing an action together: '공부합시다' (Let's study)!",
      "VI": "Dùng '-(으)ㅂ시다' trong bối cảnh trang trọng để rủ cùng thực hiện hành động: '공부합시다' (Chúng ta hãy cùng học nào)!",
      "ZH": "在正式场合建议听者一起采取某种行动时使用'-(으)ㅂ시다'，'공부합시다'表示'让我们一起学习吧'！",
      "JA": "フォーマルな場面で聞き手と一緒に行動することを勧める時は「-(으)ㅂ시다」を使い、「공부합시다（勉強しましょう）」と言います！"
    }
  },
  {
    "id": 516,
    "category": "음식·음료",
    "type": "sentence",
    "level": 1,
    "visual": "🥩 😋",
    "speechBubble": "제주도 흑돼지 구이를 먹어 보세요.",
    "keyword": "먹어 보세요",
    "situations": {
      "KO": "제주도에 처음 방문한 친구에게 유명한 향토 명물 음식을 직접 체험해 보라고 적극 권유하는 상황입니다.",
      "EN": "Recommending that a friend visiting Jeju Island for the first time try the famous local black pork.",
      "VI": "Nhiệt tình khuyên người bạn lần đầu đến đảo Jeju hãy thưởng thức món thịt lợn đen nướng đặc sản trứ danh.",
      "ZH": "向第一次去济州岛的朋友热情推荐亲自品尝当地著名的黑猪肉美食。",
      "JA": "済州島を初めて訪れた友達に有名な郷土名物料理をぜひ味わってみてと勧める場面です。"
    },
    "questions": {
      "KO": "가: 다음 주에 제주도로 여행 가는데 꼭 맛봐야 할 음식이 있나요?\n나: 육즙이 풍부한 제주도 명물 흑돼지 삼겹살을 꼭 (   )!"
    },
    "options": [
      "먹지 마세요",
      "먹어 보세요",
      "먹기 전에",
      "먹으면 안 돼요"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "상대방에게 어떤 일을 시도하거나 체험해 보라고 권유할 때는 '-아/어 보다'를 써서 '먹어 보세요'라고 권해요!",
      "EN": "Use '-아/어 보다' to recommend trying out or experiencing something: '먹어 보세요' (Please try eating it)!",
      "VI": "Dùng '-아/어 보다' khi khuyên đối phương thử trải nghiệm điều gì: '먹어 보세요' (Hãy ăn thử xem nhé)!",
      "ZH": "建议对方尝试体验某种事物时使用'-아/어 보다'，'먹어 보세요'表示'尝尝看吧'！",
      "JA": "相手に何かを試したり体験してみるよう勧める時は「-아/어 보다」を使い、「먹어 보세요（食べてみてください）」と言います！"
    }
  },
  {
    "id": 517,
    "category": "자연·날씨",
    "type": "sentence",
    "level": 1,
    "visual": "☁️ 🌧️",
    "speechBubble": "먹구름이 몰려와 곧 비가 올 것 같아요.",
    "keyword": "올 것 같아요",
    "situations": {
      "KO": "하늘이 어두워지고 찬 바람이 부는 외부 단서를 바탕으로 곧 비가 쏟아질 것이라고 추측하는 상황입니다.",
      "EN": "Guessing that it will rain soon based on visual cues such as dark clouds and chilly wind.",
      "VI": "Dự đoán trời sắp đổ mưa dựa trên dấu hiệu mây đen kéo đến và gió lạnh thổi mạnh.",
      "ZH": "根据天空阴沉乌云密布、凉风阵阵的外界线索推测马上就要下雨。",
      "JA": "空が暗くなり冷たい風が吹く手がかりをもとに、もうすぐ雨が降りそうだと推測する場面です。"
    },
    "questions": {
      "KO": "가: 하늘에 먹구름이 가득 끼고 바람도 심상치 않네요.\n나: 그러게요, 금방이라도 하늘에서 소나기가 (   ). 서둘러요!"
    },
    "options": [
      "오지 않아요",
      "올 것 같아요",
      "온 적이 있어요",
      "오기 전에"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "주변 상황이나 느낌을 토대로 미래의 일이나 가능성을 불확실하게 추측할 때는 '-(으)ㄹ 것 같다'를 써서 '올 것 같아요'라고 말해요!",
      "EN": "Use '-(으)ㄹ 것 같다' to express a supposition or guess about future events: '올 것 같아요' (It looks like it will come/rain)!",
      "VI": "Dùng '-(으)ㄹ 것 같다' khi phỏng đoán về sự việc có khả năng xảy ra: '올 것 같아요' (Có vẻ như trời sắp mưa)!",
      "ZH": "根据周围情况推测未来的事情或可能性时使用'-(으)ㄹ 것 같다'，'올 것 같아요'表示'好像要下（雨）了'！",
      "JA": "周りの状況をもとに未来の出来事を推測する時は「-(으)ㄹ 것 같다」を使い、「올 것 같아요（降りそうです）」と言います！"
    }
  },
  {
    "id": 518,
    "category": "일상생활·장소",
    "type": "sentence",
    "level": 1,
    "visual": "🌧️ ❌",
    "speechBubble": "폭우가 쏟아지기 때문에 경기가 취소됐어요.",
    "keyword": "오기 때문에",
    "situations": {
      "KO": "야외 축구 경기가 취소된 명확하고 객관적인 원인이 폭우 때문임을 설명하는 상황입니다.",
      "EN": "Explaining the clear objective reason why an outdoor soccer match was cancelled due to heavy rain.",
      "VI": "Giải thích nguyên nhân rõ ràng khiến trận bóng đá ngoài trời bị hủy là do trời mưa như trút nước.",
      "ZH": "说明户外足球比赛被取消的明确客观原因是因为下暴雨。",
      "JA": "野外サッカーの試合がキャンセルされた明確で客観的な原因が大雨のためであることを説明する場面です。"
    },
    "questions": {
      "KO": "가: 오늘 저녁 야외 축구 경기가 왜 갑자기 취소되었나요?\n나: 오후부터 폭우가 세차게 (   ) 안전을 위해 취소되었습니다."
    },
    "options": [
      "오지 않아서",
      "오기 때문에",
      "오려고 해서",
      "오면서"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "앞 절의 내용이 뒤 절의 명백하고 객관적인 원인이나 이유가 됨을 격식 있게 나타낼 때는 '-기 때문에'를 사용해요!",
      "EN": "Use '-기 때문에' to give a formal, definitive reason or cause: '오기 때문에' (Because it is raining)!",
      "VI": "Dùng '-기 때문에' khi đưa ra lý do hoặc nguyên nhân khách quan, rõ ràng: '오기 때문에' (Bởi vì trời mưa)!",
      "ZH": "正式说明前项是后项明确的客观原因或理由时使用'-기 때문에'，'오기 때문에'表示'因为下（雨）'！",
      "JA": "前の内容が後ろの内容の明確で客観的な原因・理由になることを表す時は「-기 때문에」を使います！"
    }
  },
  {
    "id": 519,
    "category": "핵심표현·의사소통",
    "type": "sentence",
    "level": 1,
    "visual": "📚 😄",
    "speechBubble": "배우기는 어렵지만 정말 재미있어요.",
    "keyword": "어렵지만",
    "situations": {
      "KO": "새로운 언어를 배우는 과정이 까다롭고 힘들지만 동시에 큰 보람과 재미가 있다는 대조적 사실을 연결하는 상황입니다.",
      "EN": "Connecting contrasting facts: while learning a new language is difficult, it is also very rewarding and fun.",
      "VI": "Liên kết hai vế đối lập: việc học một ngôn ngữ mới tuy khó nhưng đồng thời lại vô cùng thú vị và ý nghĩa.",
      "ZH": "连接对比事实：学习新语言的过程虽然有难度，但同时也非常有趣且有收获。",
      "JA": "新しい言語を学ぶ過程は難しいものの、同時にとてもやりがいがあって面白いという対照的な事実を繋ぐ場面です。"
    },
    "questions": {
      "KO": "가: 한국어 공부를 시작해 보니까 어때요?\n나: 문법과 발음이 조금 (   ) 매일 새로운 표현을 배우는 게 정말 재미있어요!"
    },
    "options": [
      "쉬워서",
      "어렵지만",
      "어려우니까",
      "어려우면서"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "서로 상반되거나 대조적인 두 가지 사실을 이어줄 때는 연결 어미 '-지만'을 써요. '어렵다'에 붙어 '어렵지만'이 됩니다.",
      "EN": "Use '-지만' to link two contrasting or opposing clauses: '어렵지만' (Although it is difficult / It is difficult, but)!",
      "VI": "Dùng '-지만' để nối hai vế mang ý nghĩa đối lập: '어렵지만' (Mặc dù khó nhưng)!",
      "ZH": "连接两个相互对立或对比的事实时使用连接词尾'-지만'。接在'어렵다'后变为'어렵지만'（虽然难，但是）！",
      "JA": "互いに対照的な2つの事実を繋ぐ時は「-지만」を使います。「어렵다」について「어렵지만（難しいですが）」になります。"
    }
  },
  {
    "id": 520,
    "category": "편의점·마트·쇼핑",
    "type": "sentence",
    "level": 1,
    "visual": "🛍️ 🚶",
    "speechBubble": "지금 마트에 가는데 같이 갈래요?",
    "keyword": "가는데",
    "situations": {
      "KO": "자신이 마트로 출발하는 현재 배경 상황을 먼저 제시하며 상대방에게 동행 여부를 묻는 상황입니다.",
      "EN": "Presenting your current background context of heading to the supermarket before asking the listener to come along.",
      "VI": "Đưa ra bối cảnh trước rằng mình chuẩn bị đi siêu thị rồi rủ đối phương cùng đi chung.",
      "ZH": "先说明自己正要去超市的背景情况，然后询问对方要不要一起去。",
      "JA": "自分がスーパーへ行くという現在の背景状況を提示しながら、相手に一緒に行かないか誘う場面です。"
    },
    "questions": {
      "KO": "가: 민수 씨, 지금 어디 가세요?\n나: 저 지금 생필품 사러 대형마트에 (   ) 혹시 필요한 거 있으면 같이 갈래요?"
    },
    "options": [
      "가기 전에",
      "가는데",
      "가려고 해서",
      "가지 않아서"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "뒤에 오는 제안이나 질문에 대한 배경 상황을 자연스럽게 도입할 때는 '-는데'를 써서 '가는데'라고 말해요!",
      "EN": "Use '-는데' to provide background context for a subsequent question or invitation: '가는데' (I'm going there, and...)!",
      "VI": "Dùng '-는데' để mở ra bối cảnh cho câu hỏi hoặc lời đề nghị phía sau: '가는데' (Tôi đang đi đây, bạn có... không)!",
      "ZH": "为后面的提议或提问自然引出背景情况时使用'-는데'，'가는데'表示'我正要去……，你要……'！",
      "JA": "後ろに続く提案や質問の背景状況を自然に導入する時は「-는데」を使い、「가는데（行くんですが）」と言います！"
    }
  },
  {
    "id": 521,
    "category": "일상생활·장소",
    "type": "sentence",
    "level": 1,
    "visual": "🛋️ 📺",
    "speechBubble": "주말에는 음악을 듣거나 영화를 봐요.",
    "keyword": "듣거나",
    "situations": {
      "KO": "주말 여가 시간에 두 가지 이상의 취미 활동 중 하나를 선택해서 즐긴다고 말하는 상황입니다.",
      "EN": "Explaining that you choose between multiple leisure activities like listening to music or watching movies on weekends.",
      "VI": "Nói về việc lựa chọn làm một trong các hoạt động giải trí vào cuối tuần như nghe nhạc hoặc xem phim.",
      "ZH": "表示周末空闲时间会在听音乐或看电影等多种爱好活动中选择其一进行。",
      "JA": "週末の余暇に音楽を聴いたり映画を観たり、複数の活動から選択して楽しむと話す場面です。"
    },
    "questions": {
      "KO": "가: 휴일에는 보통 집에서 어떤 취미 활동을 하면서 시간을 보내요?\n나: 편안하게 소파에 누워서 좋아하는 노래를 (   ) 넷플릭스로 영화를 감상해요."
    },
    "options": [
      "듣기 때문에",
      "듣거나",
      "들으려고",
      "듣지 않고"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "두 가지 이상의 행동이나 상태 중에서 하나를 선택함을 나타낼 때는 동사/형용사 어간에 '-거나'를 붙여요. '듣거나'가 정답입니다.",
      "EN": "Use '-거나' to express choosing between two or more actions: '듣거나' (listen or...)!",
      "VI": "Gắn '-거나' vào sau động từ/tính từ để diễn tả sự lựa chọn giữa hai hay nhiều hành động: '듣거나' (nghe hoặc...)!",
      "ZH": "表示在两项以上的行动或状态中选择其一时在动词后加上'-거나'，'듣거나'表示'听或者……'！",
      "JA": "2つ以上の行動や状態から1つを選択することを表す時は動詞・形容詞の語幹に「-거나」をつけて「듣거나（聴いたり）」と表現します。"
    }
  },
  {
    "id": 522,
    "category": "카페·식당·외식문화",
    "type": "sentence",
    "level": 1,
    "visual": "🥤 🧃",
    "speechBubble": "시원한 생수나 오렌지 주스 한 잔 주세요.",
    "keyword": "생수나",
    "situations": {
      "KO": "목이 마를 때 물 또는 주스 중 아무거나 하나를 마시겠다고 명사를 나열하며 선택하는 상황입니다.",
      "EN": "Listing nouns to choose either water or juice to quench your thirst.",
      "VI": "Liệt kê danh từ để chọn uống nước lọc hoặc nước ép khi thấy khát.",
      "ZH": "口渴时列举名词表示在矿泉水或果汁中任选其一来喝。",
      "JA": "喉が渇いた時にミネラルウォーターかジュースのどちらかを選んで飲む場面です。"
    },
    "questions": {
      "KO": "가: 많이 걸어서 목이 마른데 마실 것 좀 드릴까요?\n나: 네, 냉장고에 시원한 (   ) 과일 주스 있으면 한 잔 부탁드려요."
    },
    "options": [
      "생수나",
      "생수도",
      "생수만",
      "생수밖에"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "둘 이상의 명사 중 하나를 선택할 때는 조사 '(이)나'를 써요. '생수'에 받침이 없으므로 '생수나'를 붙입니다.",
      "EN": "Use particle '(이)나' to choose between nouns. Since '생수' ends in a vowel, attach '나' to form '생수나' (water or...)!",
      "VI": "Dùng trợ từ '(이)나' để chọn giữa các danh từ. Vì '생수' không có phụ âm cuối nên dùng '생수나' (nước khoáng hoặc...)!",
      "ZH": "在两个以上的名词中选择其一时使用助词'(이)나'。'생수'无收音，故用'생수나'（矿泉水或……）！",
      "JA": "2つ以上の名詞から1つを選択する時は助詞「(이)나」を使います。「생수」にはパッチムがないため「생수나」になります。"
    }
  },
  {
    "id": 523,
    "category": "교통·길찾기·택시",
    "type": "sentence",
    "level": 1,
    "visual": "✈️ 🚄",
    "speechBubble": "비행기가 기차보다 훨씬 빨라요.",
    "keyword": "기차보다",
    "situations": {
      "KO": "서울에서 부산까지 이동할 때 비행기와 기차의 이동 속도를 비교하여 우열을 설명하는 상황입니다.",
      "EN": "Comparing the travel speed between an airplane and a train when traveling from Seoul to Busan.",
      "VI": "So sánh tốc độ di chuyển giữa máy bay và tàu hỏa khi đi từ Seoul tới Busan.",
      "ZH": "比较从首尔到釜山时飞机与火车的运行速度。",
      "JA": "ソウルから釜山まで移動する際、飛行機と列車の移動速度を比較して説明する場面です。"
    },
    "questions": {
      "KO": "가: 서울에서 제주도나 부산 갈 때 비행기랑 KTX 기차 중에 뭐가 더 빨라요?\n나: 아무래도 하늘을 나는 비행기가 (   ) 훨씬 더 빨라요."
    },
    "options": [
      "기차처럼",
      "기차마다",
      "기차보다",
      "기차밖에"
    ],
    "answerIndex": 2,
    "explanations": {
      "KO": "비교의 기준이 되는 대상 뒤에는 비교 조사 '보다'를 붙여요. 기차가 비교 기준이므로 '기차보다'가 올바릅니다.",
      "EN": "Attach the comparative particle '보다' to the standard of comparison: '기차보다' (than a train)!",
      "VI": "Gắn trợ từ so sánh '보다' vào sau đối tượng làm chuẩn so sánh: '기차보다' (hơn tàu hỏa)!",
      "ZH": "在作为比较基准的对象后加上比较助词'보다'。'기차보다'表示'比火车'！",
      "JA": "比較の基準となる対象の後ろには比較助詞「보다」をつけます。「기차보다（列車より）」が正解です。"
    }
  },
  {
    "id": 524,
    "category": "일상생활·장소",
    "type": "sentence",
    "level": 1,
    "visual": "🏃 🌳",
    "speechBubble": "주말마다 한강 공원에서 조깅해요.",
    "keyword": "주말마다",
    "situations": {
      "KO": "특정한 요일이나 시간 간격마다 빠짐없이 반복해서 운동을 실천하는 습관을 나타내는 상황입니다.",
      "EN": "Expressing a routine habit of exercising without fail every recurring weekend at Hangang Park.",
      "VI": "Nói về thói quen đều đặn tập thể dục không sót tuần nào tại công viên sông Hàn vào mỗi dịp cuối tuần.",
      "ZH": "表示每个周末都无一例外坚持在汉江公园跑步锻炼的生活习惯。",
      "JA": "週末ごとに欠かさず漢江公園でジョギングをする習慣を表す場面です。"
    },
    "questions": {
      "KO": "가: 지우 씨는 체력 관리를 어떻게 하세요?\n나: 저는 토요일과 일요일이 되면 (   ) 한강 공원에 나가서 가볍게 조깅을 해요."
    },
    "options": [
      "주말밖에",
      "주말처럼",
      "주말마다",
      "주말보다"
    ],
    "answerIndex": 2,
    "explanations": {
      "KO": "어떤 시간이나 대상이 하나도 빠짐없이 모두 해당함을 나타낼 때는 조사 '마다'를 써서 '주말마다'라고 표현해요!",
      "EN": "Use the particle '마다' to indicate that something happens every time without exception: '주말마다' (every weekend)!",
      "VI": "Dùng trợ từ '마다' để chỉ việc lặp lại đều đặn không sót lần nào: '주말마다' (Mỗi dịp cuối tuần)!",
      "ZH": "表示某个时间或对象毫无例外全部包含时使用助词'마다'，'주말마다'表示'每个周末'！",
      "JA": "ある時間や対象が漏れなく全て該当することを表す時は助詞「마다」を使い、「주말마다（週末ごとに）」と言います！"
    }
  },
  {
    "id": 525,
    "category": "편의점·마트·쇼핑",
    "type": "sentence",
    "level": 1,
    "visual": "👛 🪙",
    "speechBubble": "지갑에 현금이 천 원밖에 없어요.",
    "keyword": "천 원밖에",
    "situations": {
      "KO": "지갑 속에 가진 현금이 천 원뿐이어서 더 이상의 돈이 없음을 한정하고 아쉬워하는 상황입니다.",
      "EN": "Expressing that you have only 1,000 won in your wallet and no additional cash.",
      "VI": "Nói rằng trong ví chỉ vỏn vẹn có 1.000 won tiền mặt ngoài ra không còn đồng nào khác.",
      "ZH": "表示钱包里只有一千韩元现金，没有多余的钱。",
      "JA": "財布の中に現金が千ウォンしかなく、それ以上の所持金がないことを限定して話す場面です。"
    },
    "questions": {
      "KO": "가: 붕어빵 사 먹으려는데 혹시 현금 가진 거 있어요?\n나: 지갑을 열어봤는데 지금 현금이 (   ) 없어서 카드로 결제해야겠어요."
    },
    "options": [
      "천 원마다",
      "천 원보다",
      "천 원밖에",
      "천 원처럼"
    ],
    "answerIndex": 2,
    "explanations": {
      "KO": "'그것뿐이고 다른 것은 없음'을 나타낼 때는 조사 '밖에'를 쓰고 뒤에 부정어(없다, 안 되다 등)가 와요. '천 원밖에 없어요'가 맞습니다.",
      "EN": "Use '밖에' followed by a negative verb to mean 'only' or 'nothing other than': '천 원밖에 없어요' (I only have 1,000 won).",
      "VI": "Dùng '밖에' đi kèm từ phủ định phía sau để mang nghĩa 'chỉ có ngoài ra không còn': '천 원밖에 없어요' (Chỉ có mỗi 1.000 won).",
      "ZH": "表示'仅有这个而无其他'时使用助词'밖에'，后面接否定词，'천 원밖에 없어요'表示'只有一千韩元'。",
      "JA": "「それだけで他にはない」という限定を表す時は助詞「밖에」に否定語を続け、「천 원밖에 없어요（千ウォンしかありません）」と言います。"
    }
  },
  {
    "id": 526,
    "category": "교통·길찾기·택시",
    "type": "sentence",
    "level": 1,
    "visual": "🚇 🏢",
    "speechBubble": "매일 아침 지하철로 출근해요.",
    "keyword": "지하철로",
    "situations": {
      "KO": "출퇴근이나 통학 시 이용하는 교통수단이나 도구를 나타내는 상황입니다.",
      "EN": "Stating the mode of transportation used to commute to work every morning.",
      "VI": "Nói về phương tiện giao thông được sử dụng để đi làm mỗi buổi sáng.",
      "ZH": "说明每天早晨上班时所搭乘的交通工具。",
      "JA": "毎朝通勤する際に利用する交通手段を表す場面です。"
    },
    "questions": {
      "KO": "가: 회사까지 거리가 제법 먼데 매일 아침 어떻게 출퇴근하세요?\n나: 아침 출근 시간에는 도로가 막혀서 보통 (   ) 빠르게 이동해요."
    },
    "options": [
      "지하철로",
      "지하철에",
      "지하철을",
      "지하철이"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "이동 수단이나 도구를 나타낼 때는 조사 '-(으)로'를 써요. '지하철' 뒤에 받침 'ㄹ'이 있으므로 '로'를 붙여 '지하철로'가 됩니다.",
      "EN": "Use particle '-(으)로' to indicate a means or tool. Since '지하철' ends in 'ㄹ', attach '로' to make '지하철로' (by subway)!",
      "VI": "Dùng trợ từ '-(으)로' để chỉ phương tiện hoặc công cụ. '지하철' kết thúc bằng 'ㄹ' nên kết hợp với '로' thành '지하철로' (bằng tàu điện ngầm)!",
      "ZH": "表示交通工具或手段时使用助词'-(으)로'。'지하철'以'ㄹ'结尾，接'로'变为'지하철로'（乘地铁）！",
      "JA": "移動手段や道具を表す時は助詞「-(으)로」を使います。「지하철」のパッチム「ㄹ」には「로」がつき「지하철로（地下鉄で）」になります。"
    }
  },
  {
    "id": 527,
    "category": "핵심표현·의사소통",
    "type": "sentence",
    "level": 1,
    "visual": "🎁 😊",
    "speechBubble": "친구한테 생일 선물을 받았어요.",
    "keyword": "친구한테",
    "situations": {
      "KO": "생일에 소중한 친구로부터 축하 선물이나 물건을 건네받은 대상 출처를 나타내는 상황입니다.",
      "EN": "Indicating the person from whom you received a birthday present.",
      "VI": "Chỉ ra đối tượng mà từ người đó mình đã nhận được món quà sinh nhật ý nghĩa.",
      "ZH": "表示生日时从朋友那里收到了生日礼物的对象来源。",
      "JA": "誕生日に大切な友達からプレゼントを受け取った対象を表す場面です。"
    },
    "questions": {
      "KO": "가: 와, 그 가방 정말 귀엽고 예쁘네요! 어디서 샀어요?\n나: 제가 직접 산 게 아니라 어제 생일에 친한 (   ) 선물로 받았어요."
    },
    "options": [
      "친구보다",
      "친구한테",
      "친구처럼",
      "친구마다"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "사람이나 동물 등 어떤 행동의 대상이나 출처를 구어체로 친근하게 나타낼 때는 '한테'를 써서 '친구한테'라고 말해요!",
      "EN": "Use '한테' in colloquial Korean to indicate the person from or to whom an action is directed: '친구한테' (from a friend)!",
      "VI": "Dùng '한테' trong văn nói thân mật để chỉ đối tượng hướng tới hoặc nguồn gốc nhận: '친구한테' (từ bạn / cho bạn)!",
      "ZH": "在口语中亲切表示动作的对象或来源时使用'한테'，'친구한테'表示'从朋友那里/向朋友'！",
      "JA": "口語で人や動物など行動の対象や出所を表す時は「한테」を使い、「친구한테（友達から/に）」と言います！"
    }
  },
  {
    "id": 528,
    "category": "자기소개·직업",
    "type": "survival",
    "level": 1,
    "visual": "🙇‍♂️ 💼",
    "speechBubble": "처음 뵙겠습니다. 잘 부탁드립니다.",
    "keyword": "처음 뵙겠습니다",
    "situations": {
      "KO": "새로운 직장이나 모임에서 상사나 동료를 난생처음 마주하여 격식을 차려 첫인사를 나누는 상황입니다.",
      "EN": "Exchanging formal first greetings when meeting colleagues or a supervisor for the very first time at a new workplace.",
      "VI": "Chào hỏi một cách trang trọng khi lần đầu tiên gặp mặt cấp trên hoặc đồng nghiệp tại nơi làm việc mới.",
      "ZH": "在新的职场或聚会中第一次与上级或同事见面时进行正式的初次问候。",
      "JA": "新しい職場や集まりで上司や同僚と初めて対面し、格式高く初対面の挨拶を交わす場面です。"
    },
    "questions": {
      "KO": "가: 오늘 마케팅팀에 새로 입사한 신입사원 김민수라고 합니다. (   ).\n나: 환영합니다, 민수 씨! 앞으로 우리 팀에서 잘 지내봐요."
    },
    "options": [
      "오랜만입니다",
      "안녕히 계세요",
      "처음 뵙겠습니다",
      "수고하셨습니다"
    ],
    "answerIndex": 2,
    "explanations": {
      "KO": "상대방을 생전 처음 만났을 때 공손하고 정중하게 첫인사를 건네는 표준 격식 표현은 '처음 뵙겠습니다'예요!",
      "EN": "The standard formal greeting used when meeting someone for the very first time is '처음 뵙겠습니다' (Nice to meet you / How do you do)!",
      "VI": "Lời chào trang trọng chuẩn mực khi lần đầu tiên gặp mặt một người nào đó là '처음 뵙겠습니다' (Hân hạnh lần đầu gặp quý vị)!",
      "ZH": "初次与对方见面时最标准且郑重的正式问候语是'처음 뵙겠습니다'（初次见面，幸会）！",
      "JA": "相手と初めて会った時に礼儀正しく交わす標準的な初対面の挨拶表現は「처음 뵙겠습니다（初めまして）」です！"
    }
  },
  {
    "id": 529,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "🏦 🎟️",
    "speechBubble": "창구 앞에서 대기 번호표를 뽑으세요.",
    "keyword": "번호표",
    "situations": {
      "KO": "은행이나 공공기관에서 자신의 차례를 기다리기 위해 기계에서 순번 종이를 발권하는 상황입니다.",
      "EN": "Taking a paper waiting number ticket from a machine to wait for your turn at a bank or public office.",
      "VI": "Lấy phiếu số thứ tự từ máy tự động để chờ đến lượt giao dịch tại ngân hàng hoặc cơ quan công quyền.",
      "ZH": "在银行或公共机构为了等待叫号办理业务而在排队机上抽取号码凭条。",
      "JA": "銀行や公的機関で自分の順番を待つために機械から受付番号札を発行する場面です。"
    },
    "questions": {
      "KO": "가: 오늘 은행에 대기하는 손님이 정말 많네요. 상담을 받으려면 어떻게 해야 해요?\n나: 입구에 있는 순번 발급기 기계 화면을 누르고 (   )을/를 먼저 뽑아서 기다리세요."
    },
    "options": [
      "영수증",
      "번호표",
      "입장권",
      "복권"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "은행, 병원, 관공서 등에서 대기 순서를 지키기 위해 기계에서 출력하는 종이 표는 '번호표(Waiting ticket)'예요!",
      "EN": "The printed slip with a queue number taken from a kiosk at banks or offices is a '번호표' (Waiting ticket)!",
      "VI": "Mảnh giấy in số thứ tự xếp hàng tại ngân hàng, bệnh viện hay cơ quan là '번호표' (Phiếu số thứ tự)!",
      "ZH": "在银行、医院或公共办事处等场所排队等候叫号时抽取的纸质排队凭证是'번호표'（号码牌/排队小票）！",
      "JA": "銀行や病院、役所などで順番を待つために機械から発券する紙の札は「번호표（番号札）」です！"
    }
  },
  {
    "id": 530,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "🪪 🏛️",
    "speechBubble": "출입국에 외국인등록증을 신청해요.",
    "keyword": "외국인등록증",
    "situations": {
      "KO": "한국에 장기 체류하는 외국인이 출입국관리사무소에서 법적 신분을 증명하는 공식 신분증을 신청하는 상황입니다.",
      "EN": "Applying for the official Residence Card (Alien Registration Card) at the immigration office for long-term stay in Korea.",
      "VI": "Làm thủ tục xin cấp Thẻ đăng ký người nước ngoài chính thức tại Cục xuất nhập cảnh để cư trú dài hạn tại Hàn Quốc.",
      "ZH": "长期居留韩国的外国人在出入境管理局申领证明合法法定身份的'外国人登录证'。",
      "JA": "韓国に長期滞在する外国人が出入国管理事務所で法的身分を証明する公式身分証明書を申請する場面です。"
    },
    "questions": {
      "KO": "가: 한국 대학교에서 1년 동안 유학하려면 어떤 공식 신분증을 만들어야 하나요?\n나: 입국 후 출입국·외국인청에 방문해서 대한민국 체류 신분증인 (   )을/를 반드시 발급받아야 해요."
    },
    "options": [
      "학생증",
      "외국인등록증",
      "교통카드",
      "도서관 대출증"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "한국에 90일 이상 장기 체류하는 외국인에게 법무부 출입국에서 발급해 주는 법적 신분증은 '외국인등록증(Residence Card)'이에요!",
      "EN": "The official legal identification issued by Korean immigration to foreigners staying over 90 days is the '외국인등록증' (Residence Card)!",
      "VI": "Giấy tờ tùy thân hợp pháp được Cục xuất nhập cảnh cấp cho người nước ngoài cư trú trên 90 ngày là '외국인등록증' (Thẻ đăng ký người nước ngoài)!",
      "ZH": "韩国法务部出入境管理机构向在韩逗留90天以上的外国人颁发的官方法定身份证件是'외국인등록증'（外国人登录证）！",
      "JA": "韓国に90日以上長期滞在する外国人に法務部出入国から発給される法的身分証明書は「외국인등록증（外国人登録証）」です！"
    }
  },
  {
    "id": 531,
    "category": "병원·약국·응급",
    "type": "word",
    "level": 1,
    "visual": "🩺 📄",
    "speechBubble": "의사 선생님의 처방전을 약국에 내요.",
    "keyword": "처방전",
    "situations": {
      "KO": "병원 진료 후 의사가 약을 조제할 수 있도록 작성해 준 서류를 가지고 약국을 방문하는 상황입니다.",
      "EN": "Visiting a pharmacy with the official prescription written by a doctor after a medical consultation.",
      "VI": "Mang theo đơn thuốc do bác sĩ kê sau khi khám bệnh đến hiệu thuốc để mua thuốc theo chỉ định.",
      "ZH": "拿着就诊后医生开具的处方单前往药店配药的场景。",
      "JA": "病院で診察を受けた後、医師が作成した処方箋を持って薬局を訪れる場面です。"
    },
    "questions": {
      "KO": "가: 병원 진료를 다 마쳤는데 이제 약은 어디서 어떻게 사나요?\n나: 수납 창구에서 수납 후 받은 의사의 (   )을/를 가지고 근처 약국에 가시면 조제해 줘요."
    },
    "options": [
      "입원 서류",
      "처방전",
      "설문지",
      "영수증"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "의사가 환자를 진찰한 후 약사에게 약을 조제하도록 지시하는 공식 서류는 '처방전(Prescription)'이에요!",
      "EN": "The official document issued by a doctor instructing a pharmacist to prepare medicine is a '처방전' (Prescription)!",
      "VI": "Tài liệu chính thức do bác sĩ chỉ định cho dược sĩ bốc thuốc là '처방전' (Đơn thuốc / Toa thuốc)!",
      "ZH": "医生为患者诊断后指示药剂师配药的正式书面凭单是'처방전'（处方单）！",
      "JA": "医師が患者を診察した後、薬剤師に調剤を指示する公式な書類は「처방전（処方箋）」です！"
    }
  },
  {
    "id": 532,
    "category": "신체·건강",
    "type": "word",
    "level": 1,
    "visual": "🌡️ 🤒",
    "speechBubble": "체온계로 이마의 체온을 측정해요.",
    "keyword": "체온",
    "situations": {
      "KO": "몸에 오한이 들고 열감이 있을 때 체온계로 신체 온도를 재어 발열 여부를 확인하는 상황입니다.",
      "EN": "Checking whether you have a fever by measuring your body temperature with a thermometer.",
      "VI": "Dùng nhiệt kế đo nhiệt độ cơ thể để kiểm tra xem có bị sốt không khi cảm thấy ớn lạnh và nóng trán.",
      "ZH": "感觉身体发冷发热时用体温计测量身体温度以确认是否发烧。",
      "JA": "寒気がして熱っぽさを感じる時に体温計で体の温度を測り発熱を確認する場面です。"
    },
    "questions": {
      "KO": "가: 머리가 지끈거리고 몸이 으슬으슬 떨려요.\n나: 열이 나는 것 같네요. 체온계를 귀에 대고 (   )을/를 먼저 측정해 볼게요."
    },
    "options": [
      "혈압",
      "체중",
      "체온",
      "시력"
    ],
    "answerIndex": 2,
    "explanations": {
      "KO": "우리 몸의 온도를 가리키는 의학 단어는 '체온(Body temperature)'이에요. 정상 체온은 보통 36.5도 안팎입니다.",
      "EN": "The medical term referring to the temperature of the human body is '체온' (Body temperature)!",
      "VI": "Thuật ngữ y học chỉ nhiệt độ của cơ thể con người là '체온' (Thân nhiệt)!",
      "ZH": "表示人体内部温度的医学词汇是'체온'（体温）！正常体温一般在36.5度左右。",
      "JA": "人間の体の温度を指す医学単語は「체온（体温）」です。正常体温は一般的に36.5度前後です。"
    }
  },
  {
    "id": 533,
    "category": "교통·길찾기·택시",
    "type": "word",
    "level": 1,
    "visual": "🚶‍♂️ 🦓",
    "speechBubble": "초록불이 켜지면 횡단보도를 건너요.",
    "keyword": "횡단보도",
    "situations": {
      "KO": "보행자가 차도를 안전하게 건널 수 있도록 하얀 줄무늬가 그려진 보행 구역을 확인하는 상황입니다.",
      "EN": "Identifying the designated white striped road crossing zone where pedestrians safely cross the street.",
      "VI": "Nhận biết phần đường kẻ sọc trắng dành cho người đi bộ qua đường một cách an toàn.",
      "ZH": "识别路面上画有白色条纹、供行人安全穿越车行道的斑马线行人穿越区。",
      "JA": "歩行者が車道を安全に渡れるように白い縞模様が引かれた歩行区域を確認する場面です。"
    },
    "questions": {
      "KO": "가: 길 건너편 편의점으로 가고 싶은데 어디로 건너가야 하나요?\n나: 저기 흰색 줄무늬가 그려진 (   )에서 신호등 초록불을 확인하고 건너세요."
    },
    "options": [
      "고속도로",
      "횡단보도",
      "육교",
      "지하차도"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "보행자가 도로를 가로질러 안전하게 건널 수 있도록 표시한 도로 시설물은 '횡단보도(Crosswalk)'예요!",
      "EN": "The painted pedestrian crossing on a street is a '횡단보도' (Crosswalk)!",
      "VI": "Phần đường kẻ vạch sơn trắng dành cho người đi bộ băng qua đường an toàn là '횡단보도' (Lối qua đường / Vạch sang đường)!",
      "ZH": "供行人在道路上安全横穿马路设立的道路设施是'횡단보도'（人行横道/斑马线）！",
      "JA": "歩行者が道路を安全に横断できるように標示された施設は「횡단보도（横断歩道）」です！"
    }
  },
  {
    "id": 534,
    "category": "교통·길찾기·택시",
    "type": "word",
    "level": 1,
    "visual": "🚦 🔴",
    "speechBubble": "빨간불 신호등에서는 멈춰 서야 해요.",
    "keyword": "신호등",
    "situations": {
      "KO": "교차로나 도로에서 자동차와 보행자의 안전을 위해 빛으로 통행 신호를 알려주는 신호 체계를 확인하는 상황입니다.",
      "EN": "Observing the traffic lights that regulate vehicular and pedestrian flow with colored signals.",
      "VI": "Quan sát hệ thống đèn tín hiệu giao thông điều tiết xe cộ và người đi bộ qua các màu đèn.",
      "ZH": "确认在十字路口用红黄绿灯光指示通行与停止的交通控制设施。",
      "JA": "交差点や道路で車や歩行者の安全のために光で合図を送る交通信号機を確認する場面です。"
    },
    "questions": {
      "KO": "가: 사거리에서 차를 운전하거나 길을 건널 때 무엇을 보고 판단하나요?\n나: 빨간색, 노란색, 초록색 불빛으로 통행 순서를 알려주는 (   )을/를 봐야 해요."
    },
    "options": [
      "가로등",
      "신호등",
      "간판",
      "표지판"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "빨간불, 초록불 등의 빛으로 자동차와 보행자의 통행을 통제하는 기둥형 장치는 '신호등(Traffic light)'이에요!",
      "EN": "The illuminated signalling device at intersections is a '신호등' (Traffic light)!",
      "VI": "Thiết bị dùng ánh sáng đỏ, vàng, xanh để điều khiển luồng giao thông là '신호등' (Đèn giao thông)!",
      "ZH": "用红绿黄灯光管制车辆和行人通行的立柱式交通控制装置是'신호등'（红绿灯/交通信号灯）！",
      "JA": "赤や青の光で自動車や歩行者の通行を整理・規制する柱状の装置は「신호등（信号機）」です！"
    }
  },
  {
    "id": 535,
    "category": "교통·길찾기·택시",
    "type": "word",
    "level": 1,
    "visual": "🚇 🌙",
    "speechBubble": "오늘 밤 지하철 막차 시간을 확인해요.",
    "keyword": "막차",
    "situations": {
      "KO": "늦은 밤 모임 후 대중교통이 끊기지 않도록 당일 운행되는 마지막 지하철이나 버스 시간을 조회하는 상황입니다.",
      "EN": "Checking the departure schedule of the last subway or bus of the day to avoid being stranded late at night.",
      "VI": "Tra cứu giờ khởi hành của chuyến tàu điện ngầm hoặc xe buýt cuối cùng trong ngày để tránh lỡ chuyến về muộn.",
      "ZH": "深夜聚会结束后为避免错过公共交通而查询当晚最后一班地铁或公交车的发车时间。",
      "JA": "夜遅い集まりの後に公共交通が途切れないよう、その日の運行最終の地下鉄やバスの時刻を確認する場面です。"
    },
    "questions": {
      "KO": "가: 지금 밤 11시 40분인데 집으로 가는 지하철이 아직 남아 있을까요?\n나: 서둘러야겠어요! 오늘 운행하는 마지막 열차인 (   ) 시간이 곧 지나가요."
    },
    "options": [
      "첫차",
      "급행",
      "막차",
      "환승"
    ],
    "answerIndex": 2,
    "explanations": {
      "KO": "그날의 운행 일정 중 가장 마지막으로 떠나는 대중교통 열차나 버스를 '막차(Last train/bus)'라고 불러요!",
      "EN": "The final operating train or bus of the day is called the '막차' (Last train/bus)!",
      "VI": "Chuyến tàu hay xe buýt khởi hành cuối cùng trong lịch trình của ngày được gọi là '막차' (Chuyến cuối)!",
      "ZH": "当天运营时刻表中最后发车的一班公共汽车或地铁列车称为'막차'（末班车）！",
      "JA": "その日の運行スケジュールの中で一番最後に発車する公共交通機関を「막차（終電・終バス）」と呼びます！"
    }
  },
  {
    "id": 536,
    "category": "편의점·마트·쇼핑",
    "type": "word",
    "level": 1,
    "visual": "🥛 📅",
    "speechBubble": "안전하게 먹을 수 있는 유통기한을 봐요.",
    "keyword": "유통기한",
    "situations": {
      "KO": "마트나 편의점에서 유제품이나 가공식품을 구매할 때 안전하게 섭취 가능한 판매 마감 날짜를 확인하는 상황입니다.",
      "EN": "Checking the expiration or sell-by date printed on dairy or processed foods at a supermarket.",
      "VI": "Kiểm tra hạn sử dụng được in trên bao bì sữa hoặc thực phẩm đóng gói tại siêu thị trước khi mua.",
      "ZH": "在超市或便利店购买乳制品时确认包装上标注的安全销售食用截止日期。",
      "JA": "スーパーやコンビニで乳製品などを購入する際、安全に消費できる販売期限の日付を確認する場面です。"
    },
    "questions": {
      "KO": "가: 냉장고에 든 우유를 마시려는데 상하지 않았는지 어떻게 알 수 있나요?\n나: 우유 팩 상단에 인쇄된 날짜인 (   )을/를 보고 날짜가 지나지 않았는지 꼭 확인하세요."
    },
    "options": [
      "제조국",
      "유통기한",
      "영양성분",
      "판매가격"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "식품 등이 제조일로부터 소비자에게 판매 및 섭취가 허용되는 기한 날짜를 '유통기한(Expiration date)'이라고 해요!",
      "EN": "The date mark indicating the period within which food can be sold and consumed is the '유통기한' (Expiration date)!",
      "VI": "Thời hạn được in trên bao bì thực phẩm cho biết ngày hết hạn tiêu thụ an toàn là '유통기한' (Hạn sử dụng)!",
      "ZH": "食品从生产之日起允许向消费者销售和安全食用的有效截止日期是'유통기한'（保质期/流通期限）！",
      "JA": "食品が製造されてから消費者に販売・消費が許可される期限の日付を「유통기한（賞味期限・消費期限）」と言います！"
    }
  },
  {
    "id": 537,
    "category": "편의점·마트·쇼핑",
    "type": "word",
    "level": 1,
    "visual": "🛒 🥬",
    "speechBubble": "환경 보호를 위해 다회용 장바구니를 써요.",
    "keyword": "장바구니",
    "situations": {
      "KO": "마트에서 물건을 살 때 일회용 비닐봉투 대신 환경을 지키기 위해 천으로 된 다회용 쇼핑백을 지참하는 상황입니다.",
      "EN": "Bringing a reusable eco-shopping bag to the grocery store instead of buying disposable plastic bags.",
      "VI": "Mang theo túi mua hàng tái sử dụng bằng vải khi đi siêu thị thay vì mua túi nilon dùng một lần để bảo vệ môi trường.",
      "ZH": "在超市购物时为了环保自带布质环保购物袋代替一次性塑料袋。",
      "JA": "スーパーで買い物をする際、使い捨てレジ袋の代わりに環境保護のため布製エコバッグを持参する場面です。"
    },
    "questions": {
      "KO": "가: 대형마트에 장보러 갈 때 환경을 보호하기 위해 챙겨가면 좋은 물건은 뭐예요?\n나: 비닐봉투 값을 아끼고 지구도 지킬 수 있는 다회용 (   )을/를 가져가면 좋아요."
    },
    "options": [
      "서류 가방",
      "장바구니",
      "캐리어",
      "지갑"
    ],
    "answerIndex": 1,
    "explanations": {
      "KO": "물건이나 식료품을 담아서 들고 올 수 있는 다회용 친환경 쇼핑 가방을 '장바구니(Shopping bag/Eco-bag)'라고 해요!",
      "EN": "A reusable eco-friendly bag used to carry groceries is called a '장바구니' (Shopping bag/Tote)!",
      "VI": "Chiếc túi vải đựng đồ dùng nhiều lần thân thiện với môi trường khi đi chợ là '장바구니' (Túi đi chợ / Giỏ đi chợ)!",
      "ZH": "用于盛放采购的食品杂货、可多次重复使用的环保购物包称为'장바구니'（环保菜篮/购物袋）！",
      "JA": "食料品や日用品を入れて持ち運べる再利用可能なエコバッグを「장바구니（買い物かご・エコバッグ）」と呼びます！"
    }
  },
  {
    "id": 538,
    "category": "편의점·마트·쇼핑",
    "type": "word",
    "level": 1,
    "visual": "💵 ↩️",
    "speechBubble": "영수증을 가져오시면 전액 환불돼요.",
    "keyword": "환불",
    "situations": {
      "KO": "구매한 물건에 하자가 있거나 마음에 들지 않아 영수증을 제시하고 지불했던 결제 금액을 되돌려받는 상황입니다.",
      "EN": "Returning an item with a receipt to get your money returned at a store.",
      "VI": "Xuất trình hóa đơn để trả lại món hàng đã mua và nhận lại toàn bộ số tiền đã thanh toán.",
      "ZH": "因商品存在瑕疵或不合适而凭收据退回商品并取回全部货款的售后场景。",
      "JA": "購入した品物に欠陥があったり合わなかったため、レシートを提示して支払った代金を返してもらう場面です。"
    },
    "questions": {
      "KO": "가: 옷 가게에서 산 티셔츠 사이즈가 맞지 않는데 돈으로 돌려받을 수 있나요?\n나: 네, 결제 영수증과 결제 카드를 챙겨오시면 일주일 내로 (   )이/가 가능합니다."
    },
    "options": [
      "환불",
      "기부",
      "적립",
      "할부"
    ],
    "answerIndex": 0,
    "explanations": {
      "KO": "구매한 상품을 반품하고 지불한 돈을 소비자에게 그대로 돌려주는 제도는 '환불(Refund)'이에요!",
      "EN": "Returning a purchased product and getting the money returned back is a '환불' (Refund)!",
      "VI": "Việc trả lại món hàng và nhận lại số tiền đã thanh toán được gọi là '환불' (Hoàn tiền / Trả lại tiền)!",
      "ZH": "退还购买的商品并将所付钱款如数退还给消费者的售后退款制度是'환불'（退款）！",
      "JA": "購入した商品を返品して支払った代金をそのまま返金してもらうことを「환불（払い戻し・返金）」と言います！"
    }
  },
  {
    "id": 539,
    "category": "자연·날씨",
    "type": "word",
    "level": 1,
    "visual": "🍂 🌡️",
    "speechBubble": "환절기에는 일교차가 매우 커요.",
    "keyword": "일교차",
    "situations": {
      "KO": "봄이나 가을 환절기에 낮과 밤의 기온 차이가 심해 감기에 걸리기 쉬운 날씨 특성을 설명하는 상황입니다.",
      "EN": "Explaining the daily temperature fluctuation where the gap between day and night temperatures is large in spring or autumn.",
      "VI": "Giải thích về đặc trưng thời tiết chuyển mùa khi chênh lệch nhiệt độ giữa ngày và đêm rất lớn dễ gây cảm lạnh.",
      "ZH": "说明春秋换季期白天与夜晚温差较大、容易着凉感冒的气候特征。",
      "JA": "春や秋の季節の変わり目に昼と夜の気温差が激しく風邪を引きやすい気候特性を説明する場面です。"
    },
    "questions": {
      "KO": "가: 가을 환절기에는 낮엔 따뜻한데 밤이 되면 왜 이렇게 갑자기 쌀쌀해지나요?\n나: 하루 동안 낮의 최고기온과 밤의 최저기온 차이를 뜻하는 (   )이/가 크기 때문이에요."
    },
    "options": [
      "습도",
      "풍속",
      "일교차",
      "강수량"
    ],
    "answerIndex": 2,
    "explanations": {
      "KO": "하루 동안 가장 높은 기온과 가장 낮은 기온 사이의 기온 차이를 가리키는 기상 용어는 '일교차(Daily temperature range)'예요!",
      "EN": "The meteorological term for the difference between the day's highest and lowest temperature is '일교차' (Daily temperature range)!",
      "VI": "Thuật ngữ khí tượng chỉ mức chênh lệch giữa nhiệt độ cao nhất và thấp nhất trong một ngày là '일교차' (Biên độ nhiệt ngày đêm)!",
      "ZH": "指一天内最高气温与最低气温之差的气象学专业名词是'일교차'（日温差/昼夜温差）！",
      "JA": "一日のうちで最も高い気温と最も低い気温の差を指す気象用語は「일교차（日較差・昼夜の気温差）」です！"
    }
  },
  {
    "id": 540,
    "category": "신체·건강",
    "type": "word",
    "level": 1,
    "visual": "😷 🌫️",
    "speechBubble": "미세먼지가 심하니 마스크를 써요.",
    "keyword": "미세먼지",
    "situations": {
      "KO": "대기 중에 눈에 보이지 않는 아주 작은 유해 먼지 농도가 높아 호흡기 건강을 위해 보건용 마스크를 착용하는 상황입니다.",
      "EN": "Wearing a protective face mask for respiratory health due to high concentrations of fine dust in the air.",
      "VI": "Đeo khẩu trang bảo vệ đường hô hấp khi nồng độ bụi mịn độc hại trong không khí tăng cao.",
      "ZH": "因空气中看不见的细颗粒有害粉尘浓度较高，为了呼吸道健康而佩戴防护口罩。",
      "JA": "大気中に目に見えない微小な有害ダストの濃度が高く、呼吸器の健康のためマスクを着用する場面です。"
    },
    "questions": {
      "KO": "가: 오늘 하늘이 뿌옇게 흐리고 목이 칼칼하게 아픈데 왜 그런가요?\n나: 공기 중에 호흡기에 해로운 (   ) 농도가 '매우 나쁨'이라서 꼭 보건용 마스크를 써야 해요."
    },
    "options": [
      "눈송이",
      "빗방울",
      "미세먼지",
      "꽃가루"
    ],
    "answerIndex": 2,
    "explanations": {
      "KO": "대기 중에 떠다니는 눈에 보이지 않을 만큼 미세한 유해 먼지 입자를 가리키는 환경 용어는 '미세먼지(Fine dust)'예요!",
      "EN": "The environmental term for tiny, harmful airborne particulate matter is '미세먼지' (Fine dust / PM2.5/PM10)!",
      "VI": "Thuật ngữ môi trường chỉ những hạt bụi độc hại li ti trôi nổi trong không khí là '미세먼지' (Bụi mịn)!",
      "ZH": "指漂浮在空气中肉眼难以察觉的微细有害颗粒物的环境术语是'미세먼지'（细颗粒物/微尘/雾霾）！",
      "JA": "大気中に漂う目に見えないほど微細な有害ダスト粒子を指す環境用語は「미세먼지（微小粒子状物質・PM2.5/微小粉塵）」です！"
    }
  }
]

PATH = 'assets/data/questions.json'

with open(PATH, 'r', encoding='utf-8') as f:
    questions = json.load(f)

# Ensure no ID collision and append
existing_ids = set(q['id'] for q in questions)
for item in new_40:
    if item['id'] not in existing_ids:
        questions.append(item)
    else:
        print(f"Warning: ID {item['id']} already exists!")

with open(PATH, 'w', encoding='utf-8') as f:
    json.dump(questions, f, ensure_ascii=False, indent=2)
    f.write('\n')

print(f"Added {len(new_40)} questions successfully. Total now: {len(questions)}")

