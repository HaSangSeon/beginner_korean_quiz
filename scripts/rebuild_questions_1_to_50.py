# -*- coding: utf-8 -*-
"""
rebuild_questions_1_to_50.py
Completely rewrites questions 1 to 50 with 100% original, modern real-life scenarios.
Zero relation to any printed workbook.
Maintains exact answer choices, options, and answerIndex so that quiz integrity remains 100% intact.
"""

import json

NEW_QUESTIONS_1_TO_50 = {
    1: {
        "situations": {
            "KO": "노래방에서 친구에게 한국어 노래를 부를 수 있는지 묻고 답하는 상황입니다.",
            "EN": "Asking and answering if a friend can sing Korean songs at karaoke.",
            "VI": "Tình huống hỏi đáp tại phòng hát xem bạn có thể hát được bài hát tiếng Hàn không.",
            "ZH": "在KTV询问朋友是否会唱韩语歌曲并回答的日常情景。",
            "JA": "カラオケで友達に韓国語の歌が歌えるか尋ねて答える場面です。"
        },
        "questions": {
            "KO": "가: 지민 씨는 K-POP을 자주 듣네요! 혹시 한국어 노래도 (   )?\n나: 네, 발음 연습을 많이 해서 능숙하게 (   )."
        },
        "explanations": {
            "KO": "어떤 행동을 할 수 있는 능력이 있음을 나타낼 때 동사 뒤에 '-(으)ㄹ 수 있어요'를 써서 '할 수 있어요'라고 해요!",
            "EN": "When expressing the ability to do something, attach '-(으)ㄹ 수 있어요' to the verb: '할 수 있어요' (I can do it)!",
            "VI": "Khi biểu thị khả năng có thể làm gì đó, gắn '-(으)ㄹ 수 있어요' vào sau động từ: '할 수 있어요' (Tôi có thể làm được)!",
            "ZH": "表示具备做某事的能力时，在动词后加上'-(으)ㄹ 수 있어요'，表达为'할 수 있어요'（会/能够做）！",
            "JA": "何かをする能力があることを表す時は、動詞の後ろに「-(으)ㄹ 수 있어요」をつけて「할 수 있어요（できます）」と言います！"
        }
    },
    2: {
        "situations": {
            "KO": "제주도 렌터카 여행을 앞두고 운전 능력을 묻고 답하는 상황입니다.",
            "EN": "Asking and answering about driving ability before a Jeju rental car road trip.",
            "VI": "Tình huống hỏi đáp về khả năng lái xe trước chuyến du lịch thuê xe tự lái ở đảo Jeju.",
            "ZH": "在济州岛自驾租车旅行前询问开车能力并回答的情景。",
            "JA": "済州島のレンタカー旅行を前に、運転ができるか尋ねて答える場面です。"
        },
        "questions": {
            "KO": "가: 이번 주말에 제주도로 드라이브 여행 가는데, 민수 씨 혹시 운전할 줄 알아요?\n나: 네, 1종 보통 면허가 있어서 (   )."
        },
        "explanations": {
            "KO": "운전할 수 있는 면허와 능력이 있음을 긍정적으로 표현할 때 '운전할 수 있어요'라고 답해요!",
            "EN": "Use '운전할 수 있어요' (I can drive) to confirm that you have the ability and license to drive!",
            "VI": "Dùng '운전할 수 있어요' (Tôi có thể lái xe) để khẳng định bản thân có bằng lái và biết lái xe!",
            "ZH": "肯定地表达自己有驾照并具备开车能力时，回答'운전할 수 있어요'（我会开车）！",
            "JA": "運転免許と運転する能力があることを肯定的に伝える時は「운전할 수 있어요（運転できます）」と答えます！"
        }
    },
    3: {
        "situations": {
            "KO": "친구 생일 파티를 위해 케이크를 직접 만들 수 있는지 묻는 상황입니다.",
            "EN": "Asking whether someone can bake a birthday cake themselves for a party.",
            "VI": "Tình huống hỏi xem có thể tự tay làm bánh kem cho bữa tiệc sinh nhật của bạn không.",
            "ZH": "为了朋友的生日聚会询问是否能亲手制作蛋糕的日常情景。",
            "JA": "友達の誕生日パーティーのために、自分でケーキを作れるか尋ねる場面です。"
        },
        "questions": {
            "KO": "가: 다가오는 주말에 친구 생일 파티를 열려고 해요. 유진 씨는 케이크를 직접 (   )?\n나: 네, 홈베이킹을 배워서 집에서 달콤하게 (   )."
        },
        "explanations": {
            "KO": "케이크를 제작할 수 있는 능력이 있음을 나타내어 '만들 수 있어요'를 사용해요!",
            "EN": "Use '만들 수 있어요' (I can make it) to express the ability to bake or create a cake!",
            "VI": "Dùng '만들 수 있어요' (Tôi có thể làm được) để thể hiện khả năng tự làm bánh kem!",
            "ZH": "表达具备烘焙或制作蛋糕的能力时，使用'만들 수 있어요'（会做/能做）！",
            "JA": "ケーキを作ることができる能力があることを表して「만들 수 있어요（作れます）」を使います！"
        }
    },
    4: {
        "situations": {
            "KO": "매운 음식을 잘 먹지 못하는 식성을 솔직하게 설명하는 상황입니다.",
            "EN": "Honestly explaining that you cannot eat spicy food well due to taste tolerance.",
            "VI": "Tình huống thành thật giải thích rằng bản thân không ăn được đồ cay.",
            "ZH": "坦诚说明自己不太能吃辣的饮食偏好的日常场景。",
            "JA": "辛いものが苦手で上手に食べられない好みを正直に説明する場面です。"
        },
        "questions": {
            "KO": "가: 이 식당 닭볶음탕은 청양고추가 들어가서 아주 매워요. 수현 씨 매운 거 잘 먹어요?\n나: 아니요, 저는 매운맛에 약해서 매운 음식은 (   ). 덜 맵게 해 달라고 해요."
        },
        "explanations": {
            "KO": "능력이나 여건상 어떤 행위를 하지 못함을 나타낼 때 '못 + 동사'를 써서 '못 먹어요'라고 해요!",
            "EN": "Use '못 먹어요' (I cannot eat it) with '못 + verb' when you are unable to eat something due to low tolerance!",
            "VI": "Dùng '못 먹어요' (Không thể ăn được) với cấu trúc '못 + động từ' khi không thể ăn món gì đó!",
            "ZH": "表示因能力或体质无法做某事时，用'못 + 动词'，表达为'못 먹어요'（吃不了/不能吃）！",
            "JA": "能力や体質上、何かを食べることができない時は「못 ＋ 動詞」を使って「못 먹어요（食べられません）」と言います！"
        }
    },
    5: {
        "situations": {
            "KO": "겨울 스키장 여행에서 스키를 탈 줄 모른다고 사양하는 상황입니다.",
            "EN": "Politely declining skiing because you do not know how to ski on a winter trip.",
            "VI": "Tình huống từ chối trượt tuyết vì chưa biết trượt trong chuyến đi khu trượt tuyết mùa đông.",
            "ZH": "在冬季滑雪场旅行中说明自己不会滑雪并委婉拒绝的日常情景。",
            "JA": "冬のスキー場旅行でスキーが滑れないと丁寧に断る場面です。"
        },
        "questions": {
            "KO": "가: 이번 주말에 다 같이 강원도 스키장 가는데, 지우 씨도 스키 탈래요?\n나: 아니요, 저는 겁이 많아서 스키는 아직 (   ). 그냥 눈썰매 탈게요."
        },
        "explanations": {
            "KO": "기술이나 능력이 부족하여 탈 수 없음을 나타낼 때 '못'을 붙여 '못 타요'라고 해요!",
            "EN": "Use '못 타요' (I cannot ride/ski) when you lack the skill or ability to ride skis!",
            "VI": "Dùng '못 타요' (Không biết trượt/đi) khi chưa có kỹ năng hoặc không thể trượt được!",
            "ZH": "表示因缺乏技巧或不会做而无法滑雪时，加上'못'表达为'못 타요'（不会滑/滑不了）！",
            "JA": "技術や能力がなくて乗ることができない時は「못」をつけて「못 타요（滑れません/乗れません）」と言います！"
        }
    },
    6: {
        "situations": {
            "KO": "화창한 날씨에 강아지와 산책하러 공원에 간다고 외출 목적을 밝히는 상황입니다.",
            "EN": "Sharing that you are going to the park to walk your puppy on a sunny day.",
            "VI": "Nói rằng mình đang đến công viên để dắt cún đi dạo vào một ngày đẹp trời.",
            "ZH": "在天气晴朗的日子说明去公园遛狗散步的目的的日常情景。",
            "JA": "天気の良い日に子犬の散歩をしに公園へ行くと外出の目的を伝える場面です。"
        },
        "questions": {
            "KO": "가: 오늘 햇살도 따뜻하고 바람도 상쾌하네요! 어디 가세요?\n나: 날씨가 너무 좋아서 강아지와 함께 (   )."
        },
        "explanations": {
            "KO": "어떤 목적을 위해 장소로 이동함을 나타낼 때 '-(으)러 가다'를 써서 '산책하러 공원에 가요'가 맞아요!",
            "EN": "When going to a place for a purpose, use '-(으)러 가다': '산책하러 공원에 가요' (I'm going to the park to take a walk)!",
            "VI": "Khi di chuyển đến đâu để thực hiện mục đích, dùng '-(으)러 가다': '산책하러 공원에 가요' (Đi đến công viên để đi dạo)!",
            "ZH": "表示为了某种目的前往某地时，使用'-(으)러 가다'，即'산책하러 공원에 가요'（去公园散步）！",
            "JA": "目的のために場所へ移動することを表す時は「-(으)러 가다」を使って「산책하러 공원에 가요（散歩しに公園へ行きます）」が正解です！"
        }
    },
    7: {
        "situations": {
            "KO": "대학 과제 리포트 작성을 위해 책을 대출하러 도서관에 가는 상황입니다.",
            "EN": "Going to the library to borrow books for a university assignment report.",
            "VI": "Đi đến thư viện mượn sách để làm bài tập báo cáo đại học.",
            "ZH": "为了撰写大学课题报告去图书馆借书的校园生活情景。",
            "JA": "大学のレポート作成のために本を借りに図書館へ行く場面です。"
        },
        "questions": {
            "KO": "가: 지우 씨, 손에 전공 서적이 가득하네요. 지금 어디에 가요?\n나: 다음 주 과제 발표를 준비하려고 (   )."
        },
        "explanations": {
            "KO": "도서관에 가는 목적(책 대출)을 나타내는 연결 어미 '-(으)러'를 사용한 '책을 빌리러 도서관에 가요'가 가장 자연스러워요!",
            "EN": "Use '책을 빌리러 도서관에 가요' (I'm going to the library to borrow books) to express the purpose of going to the library!",
            "VI": "Dùng '책을 빌리러 도서관에 가요' (Đến thư viện để mượn sách) với đuôi chỉ mục đích '-(으)러'!",
            "ZH": "表示去图书馆的目的（借书）时，使用目的连接词尾'-(으)러'，即'책을 빌리러 도서관에 가요'（去图书馆借书）！",
            "JA": "図書館へ行く目的（本の貸出）を表す連結語尾「-(으)러」を使った「책을 빌리러 도서관에 가요（本を借りに図書館へ行きます）」が最も自然です！"
        }
    },
    8: {
        "situations": {
            "KO": "운동 후 갈증이 나서 시원한 생수를 사러 편의점에 들르는 상황입니다.",
            "EN": "Stopping by a convenience store to buy cold water after working out.",
            "VI": "Ghé vào cửa hàng tiện lợi mua nước suối mát lạnh sau khi tập thể dục vì khát nước.",
            "ZH": "运动后口渴去便利店买一瓶清凉矿泉水的日常情景。",
            "JA": "運動後に喉が渇いて冷たい水を買うためにコンビニに立ち寄る場面です。"
        },
        "questions": {
            "KO": "가: 헬스장에서 땀을 많이 흘리셨네요. 어디로 가세요?\n나: 목이 너무 말라서 시원한 (   )."
        },
        "explanations": {
            "KO": "물을 사기 위한 목적을 가지고 편의점으로 이동하므로 '물을 사러 편의점에 가요'가 올바른 표현이에요!",
            "EN": "Moving toward the convenience store to buy water is expressed as '물을 사러 편의점에 가요' (I'm going to the convenience store to buy water)!",
            "VI": "Di chuyển đến cửa hàng tiện lợi với mục đích mua nước, do đó dùng '물을 사러 편의점에 가요' (Đến cửa hàng tiện lợi để mua nước)!",
            "ZH": "带着买水的目的前往便利店，因此'물을 사러 편의점에 가요'（去便利店买水）是正确表达！",
            "JA": "水を買う目的を持ってコンビニへ向かうため、「물을 사러 편의점에 가요（水を買いにコンビニへ行きます）」が正しい表現です！"
        }
    },
    9: {
        "situations": {
            "KO": "주말 KTX를 타고 오랜 친구를 만나러 부산으로 떠나는 상황입니다.",
            "EN": "Taking the KTX train on the weekend to visit an old friend in Busan.",
            "VI": "Đi tàu cao tốc KTX vào cuối tuần để đến Busan gặp lại người bạn thân lâu năm.",
            "ZH": "周末乘坐KTX高速列车去釜山见老朋友的旅行情景。",
            "JA": "週末にKTXに乗って旧友に会いに釜山へ向かう場面です。"
        },
        "questions": {
            "KO": "가: 주말 아침부터 서울역 KTX 승강장에는 무슨 일로 오셨어요?\n나: 오랜만에 휴가를 받아서 (   )."
        },
        "explanations": {
            "KO": "목적지(부산)와 이동 목적(친구 만남)을 문법 '-(으)러'로 결합한 '친구를 만나러 부산에 가요'가 정답이에요!",
            "EN": "Combining the destination (Busan) and the purpose (meeting a friend) with '-(으)러' yields '친구를 만나러 부산에 가요'!",
            "VI": "Kết hợp điểm đến (Busan) và mục đích (gặp bạn bè) với ngữ pháp '-(으)러' tạo thành '친구를 만나러 부산에 가요'!",
            "ZH": "结合目的地（釜山）和出行目的（见朋友），用'-(으)러'组合成'친구를 만나러 부산에 가요'（去釜山见朋友）！",
            "JA": "目的地（釜山）と移動の目的（友達に会う）を文法「-(으)러」で結んだ「친구를 만나러 부산에 가요（友達に会いに釜山へ行きます）」が正解です！"
        }
    },
    10: {
        "situations": {
            "KO": "외국인 교환학생이 한국 대학교에 유학 온 목적을 설명하는 상황입니다.",
            "EN": "An international exchange student explaining their purpose of studying in Korea.",
            "VI": "Sinh viên trao đổi quốc tế giải thích mục đích đến du học tại trường đại học Hàn Quốc.",
            "ZH": "国际交换生说明自己来到韩国大学留学的目的的场景。",
            "JA": "外国人交換留学生が韓国の大学に留学に来た目的を説明する場面です。"
        },
        "questions": {
            "KO": "가: 올리버 씨는 처음에 어떤 계기로 멀리서 한국까지 유학을 오게 되셨어요?\n나: K-드라마를 보면서 관심이 생겨서 대학교 어학당에 (   )."
        },
        "explanations": {
            "KO": "이미 한국에 도착한 상태에서 과거의 입국 목적을 회상하며 말하므로 '한국어를 배우러 왔어요'가 알맞아요!",
            "EN": "Since you have already arrived in Korea, expressing your initial purpose of coming uses '왔어요': '한국어를 배우러 왔어요' (I came to learn Korean)!",
            "VI": "Vì đã có mặt tại Hàn Quốc, diễn tả mục đích ban đầu khi đến dùng '왔어요': '한국어를 배우러 왔어요' (Tôi đến để học tiếng Hàn)!",
            "ZH": "既然人已经在韩国，回顾最初前来的目的时用'왔어요'，即'한국어를 배우러 왔어요'（来学习韩语）！",
            "JA": "すでに韓国に到着した状態で、以前韓国に来た目的を話すので「한국어를 배우러 왔어요（韓国語を学びに来ました）」が適切です！"
        }
    },

    # 11-28: 사물 어휘 일상 회화
    11: {
        "situations": {
            "KO": "기념일을 맞아 선물 받은 향기로운 장미꽃을 보며 감탄하는 상황입니다.",
            "EN": "Admiring fragrant anniversary roses received as a thoughtful gift.",
            "VI": "Trầm trồ khen ngợi bó hoa hồng thơm ngát được tặng nhân ngày kỷ niệm.",
            "ZH": "纪念日收到充满香气的玫瑰花礼物时赞叹喜悦的日常场景。",
            "JA": "記念日にもらった香りの良いバラの花を見ながら感嘆する場面です。"
        },
        "questions": {
            "KO": "가: 책상 위에 꽂아 둔 붉은 식물이 방 안을 화사하게 만들어 주네요!\n나: 오늘 1주년 기념일이라서 친구한테 향기로운 (   )을/를 선물 받았어요."
        },
        "explanations": {
            "KO": "붉은 꽃잎과 아름다운 향기를 지닌 식물은 '꽃(Flower)'이에요!",
            "EN": "A plant with beautiful colorful petals and lovely fragrance is '꽃' (Flower)!",
            "VI": "Thực vật có cánh rực rỡ và hương thơm ngát chính là '꽃' (Hoa)!",
            "ZH": "有着鲜艳花瓣和芬芳香气的植物是'꽃'（花）！",
            "JA": "赤い花びらと美しい香りを持つ植物は「꽃（花）」です！"
        }
    },
    12: {
        "situations": {
            "KO": "야외 페스티벌에서 강한 자외선을 가리기 위해 착용할 소품을 권하는 상황입니다.",
            "EN": "Recommending headwear to block strong sunlight during an outdoor festival.",
            "VI": "Gợi ý phụ kiện đội đầu để che bớt tia cực tím gay gắt khi tham gia lễ hội ngoài trời.",
            "ZH": "在户外音乐节推荐佩戴遮挡强烈紫外线的头部用品的场景。",
            "JA": "野外フェスで強い紫外線を遮るために身につける小物を勧める場面です。"
        },
        "questions": {
            "KO": "가: 야외 록 페스티벌에 가는데 한낮 햇빛이 너무 뜨거워요.\n나: 자외선 차단하려면 가방에서 이 챙 넓은 (   )을/를 꺼내서 머리에 쓰세요."
        },
        "explanations": {
            "KO": "머리에 써서 햇빛을 가리거나 멋을 내는 패션 소품은 '모자(Cap/Hat)'예요!",
            "EN": "An accessory worn on the head to block the sun or add style is '모자' (Hat/Cap)!",
            "VI": "Phụ kiện đội trên đầu để che nắng hoặc làm đẹp là '모자' (Mũ/Nón)!",
            "ZH": "戴在头上遮挡阳光或搭配造型的时尚配饰是'모자'（帽子）！",
            "JA": "頭にかぶって日差しを遮ったりおしゃれを楽しむアイテムは「모자（帽子）」です！"
        }
    },
    13: {
        "situations": {
            "KO": "바깥에서 찬 바람과 소음이 들어와 닫아달라고 정중히 부탁하는 상황입니다.",
            "EN": "Politely asking to close the door/window because cold wind and noise are coming in.",
            "VI": "Lịch sự nhờ đóng lại vì có gió lạnh và tiếng ồn từ bên ngoài lọt vào.",
            "ZH": "因外面吹进冷风和噪音而礼貌请对方随手关门的日常场景。",
            "JA": "外から冷たい風や騒音が入ってくるため、閉めてもらうよう頼む場面です。"
        },
        "questions": {
            "KO": "가: 바깥에 공사 소음도 시끄럽고 찬 바람이 쌩쌩 불어서 춥네요.\n나: 실내 온도를 지키려면 저기 열려 있는 (   ) 좀 꼭 닫아 주세요."
        },
        "explanations": {
            "KO": "열고 닫으며 방 안팎을 드나들거나 바람을 막는 출입구 구조물은 '문(Door)'이에요!",
            "EN": "The barrier that opens and closes to enter a room or block drafts is '문' (Door)!",
            "VI": "Cánh cửa đóng mở để ra vào phòng hoặc ngăn gió lùa là '문' (Cửa)!",
            "ZH": "用来开关出入房间或阻挡冷风的隔断设施是'문'（门）！",
            "JA": "開け閉めして出入りしたり風を防いだりする出入り口の構造物は「문（ドア/扉）」です！"
        }
    },
    14: {
        "situations": {
            "KO": "아침마다 최신 시사 뉴스를 확인하기 위해 읽는 종이 인쇄물을 묻는 상황입니다.",
            "EN": "Asking about the printed daily paper read every morning for current news.",
            "VI": "Hỏi về tờ báo giấy được đọc mỗi sáng để cập nhật các tin tức thời sự mới nhất.",
            "ZH": "询问每天清晨为了阅读最新时事资讯而订阅的纸质报纸的场景。",
            "JA": "毎朝最新の時事ニュースを確認するために読む新聞について尋ねる場面です。"
        },
        "questions": {
            "KO": "가: 할아버지께서는 매일 아침 식사 전에 활자가 가득한 인쇄물을 꼼꼼히 읽으세요.\n나: 세상 돌아가는 소식을 확인하시려고 매일 현관으로 배달되는 (   )을/를 보시는군요."
        },
        "explanations": {
            "KO": "사회, 정치, 경제 소식을 종이에 인쇄하여 매일 아침 전해주는 매체는 '신문(Newspaper)'이에요!",
            "EN": "A daily printed publication reporting social, political, and economic news is '신문' (Newspaper)!",
            "VI": "Ấn phẩm báo chí in trên giấy truyền tải tin tức xã hội mỗi ngày là '신문' (Báo)!",
            "ZH": "将社会、政治、经济等即时新闻印在纸上发行的刊物是'신문'（报纸）！",
            "JA": "社会や政治、経済のニュースを紙に印刷して毎朝届ける刊行物は「신문（新聞）」です！"
        }
    },
    15: {
        "situations": {
            "KO": "공원 산책과 만 보 걷기를 위해 발이 편안한 워킹화를 챙겨 신는 상황입니다.",
            "EN": "Putting on comfortable footwear before heading out for a 10,000-step park walk.",
            "VI": "Xỏ đôi giày êm ái trước khi ra ngoài công viên đi bộ tập thể dục.",
            "ZH": "去公园散步健走前挑选穿戴轻便舒适鞋子的日常场景。",
            "JA": "公園の散歩やウォーキングのために足が楽な靴を履く場面です。"
        },
        "questions": {
            "KO": "가: 오늘 만 보 걷기 운동하러 올림픽공원에 나갈 건데 뭐가 필요해요?\n나: 오래 걸어도 발이 아프지 않게 푹신하고 편안한 (   )을/를 꼭 챙겨 신고 나가세요."
        },
        "explanations": {
            "KO": "발에 신어서 땅을 딛고 걷거나 뛰도록 보호해 주는 물건은 '신발(Shoes)'이에요!",
            "EN": "The protective footwear worn on the feet to walk or run is '신발' (Shoes)!",
            "VI": "Vật mang vào chân để bảo vệ khi đi lại hoặc chạy nhảy là '신발' (Giày dép)!",
            "ZH": "穿在脚上用于保护双脚行走奔跑的物品是'신발'（鞋子）！",
            "JA": "足に履いて地面を踏みしめ歩いたり走ったりするものを「신발（靴）」と言います！"
        }
    },
    16: {
        "situations": {
            "KO": "영화관에서 자막이 흐릿하게 보일 때 시력 교정용 도구를 추천하는 상황입니다.",
            "EN": "Recommending corrective glasses when movie subtitles appear blurry.",
            "VI": "Gợi ý đeo kính cận khi phụ đề phim trong rạp chiếu bị mờ do giảm thị lực.",
            "ZH": "在电影院看字幕模糊不清时建议佩戴近视眼镜的场景。",
            "JA": "映画館で字幕がぼやけて見える時に視力矯正用のメガネを勧める場面です。"
        },
        "questions": {
            "KO": "가: 영화관 맨 뒷자리에 앉았더니 스크린 자막 글씨가 흐릿하게 보여요.\n나: 시력이 떨어져서 멀리 있는 게 안 보이면 가방에 넣어 둔 (   )을/를 쓰세요."
        },
        "explanations": {
            "KO": "시력이 안 좋을 때 눈앞에 착용하여 사물을 또렷하게 보게 해주는 물건은 '안경(Glasses)'이에요!",
            "EN": "An optical device worn in front of the eyes to see clearly is '안경' (Glasses)!",
            "VI": "Dụng cụ đeo trước mắt giúp nhìn rõ mọi vật khi thị lực kém là '안경' (Kính mắt)!",
            "ZH": "在视力不好时佩戴在眼前让人看清事物的用具是'안경'（眼镜）！",
            "JA": "視力が悪い時に目の前に着用して物をはっきり見せる器具は「안경（メガネ）」です！"
        }
    },
    17: {
        "situations": {
            "KO": "휴대폰 배터리가 방전되어 벽걸이 계측기로 현재 시각을 확인하는 상황입니다.",
            "EN": "Checking the time on a wall clock because your smartphone battery died.",
            "VI": "Xem giờ trên chiếc đồng hồ treo tường vì điện thoại đã cạn sạch pin.",
            "ZH": "手机电量耗尽关机时，看墙上的时钟确认准确时间的日常情景。",
            "JA": "スマホの充電が切れてしまい、壁掛けの時計で現在時刻を確認する場面です。"
        },
        "questions": {
            "KO": "가: 휴대폰 배터리가 꺼져서 그런데 지금 정확히 몇 시 몇 분이에요?\n나: 저기 거실 벽에 걸려 있는 둥근 (   )을/를 한번 보세요."
        },
        "explanations": {
            "KO": "시침과 분침으로 현재 시각을 알려주는 기기는 '시계(Clock/Watch)'예요!",
            "EN": "The device that shows the current time with hands or digital numbers is '시계' (Clock/Watch)!",
            "VI": "Thiết bị hiển thị thời gian chính xác qua kim giờ và phút là '시계' (Đồng hồ)!",
            "ZH": "用时针和分针指示当前具体时间的仪器是'시계'（时钟/手表）！",
            "JA": "時針と分針で現在の時刻を教えてくれる機器は「시계（時計）」です！"
        }
    },
    18: {
        "situations": {
            "KO": "대기업 신입사원 최종 면접에 입고 갈 단정한 복장을 조언하는 상황입니다.",
            "EN": "Advising on neat, professional clothing to wear to a job interview.",
            "VI": "Tư vấn trang phục lịch sự và chỉn chu để đi phỏng vấn xin việc.",
            "ZH": "为求职面试提供穿着端庄得体职业装建议的日常场景。",
            "JA": "就職面接に着ていくきちんとした服装についてアドバイスする場面です。"
        },
        "questions": {
            "KO": "가: 내일 대기업 신입사원 최종 면접시험에 가야 하는데 어떻게 입죠?\n나: 첫인상이 중요하니까 아주 깔끔하고 단정한 (   )을/를 입고 가세요."
        },
        "explanations": {
            "KO": "사람의 몸을 감싸서 가리고 체온을 유지해 주는 의복류를 통틀어 '옷(Clothes)'이라고 해요!",
            "EN": "The general term for garments worn on the human body is '옷' (Clothes)!",
            "VI": "Từ chung chỉ các loại trang phục mặc trên người là '옷' (Quần áo)!",
            "ZH": "穿在身上遮蔽身体、保暖打扮的服饰总称为'옷'（衣服）！",
            "JA": "人の体に身につけて保護し体温を保つ衣類の総称を「옷（服）」と言います！"
        }
    },
    19: {
        "situations": {
            "KO": "운동화를 신기 전 발을 따뜻하게 보호하기 위해 착용할 소품을 챙기는 상황입니다.",
            "EN": "Putting on socks to protect feet and stay warm before wearing sneakers.",
            "VI": "Xỏ tất để bảo vệ đôi chân êm ấm trước khi đi giày thể thao.",
            "ZH": "穿运动鞋之前先穿好棉袜以保护双脚保暖防磨的日常场景。",
            "JA": "スニーカーを履く前に、足を温かく保護する靴下を履く場面です。"
        },
        "questions": {
            "KO": "가: 겨울철에 새 운동화를 맨발로 신었더니 발이 시렵고 뒤꿈치도 쓸려요.\n나: 발을 보호하고 따뜻하게 하려면 신발 안에 도톰한 (   )을/를 먼저 신어야죠."
        },
        "explanations": {
            "KO": "신발을 신기 전에 발에 신어서 땀을 흡수하고 보온해 주는 소품은 '양말(Socks)'이에요!",
            "EN": "The fabric item worn on the feet inside shoes to absorb sweat and stay warm is '양말' (Socks)!",
            "VI": "Phụ kiện vải mang vào chân trước khi xỏ giày để hút mồ hôi và giữ ấm là '양말' (Tất/Vớ)!",
            "ZH": "穿鞋前套在脚上用于保暖吸汗的棉质服饰是'양말'（袜子）！",
            "JA": "靴を履く前に足に履いて汗を吸い保温するアイテムは「양말（靴下）」です！"
        }
    },
    20: {
        "situations": {
            "KO": "관공서 신청 서류에 손글씨로 이름과 연락처를 작성하기 위해 도구를 찾는 상황입니다.",
            "EN": "Looking for a pencil or pen to handwrite your name on government forms.",
            "VI": "Tìm bút viết để điền họ tên và số điện thoại vào giấy tờ tại cơ quan nhà nước.",
            "ZH": "在办事大厅表格上手写姓名与联系方式寻找书写工具的场景。",
            "JA": "申請書類に手書きで名前や連絡先を記入するため筆記用具を探す場面です。"
        },
        "questions": {
            "KO": "가: 민원실 신청 서류 양식에 이름과 전화번호를 직접 손글씨로 적어야 해요.\n나: 여기 필통에 흑연심이 들어 있는 뾰족한 (   )이/가 있으니 이걸로 쓰세요."
        },
        "explanations": {
            "KO": "흑연으로 심을 만들어 종이에 글씨를 쓰거나 그림을 그릴 때 사용하는 필기구는 '연필(Pencil)'이에요!",
            "EN": "A wooden writing utensil with a graphite core used for writing and drawing is '연필' (Pencil)!",
            "VI": "Dụng cụ học tập bằng than chì dùng để viết hoặc vẽ trên giấy là '연필' (Bút chì)!",
            "ZH": "用石墨做芯、在纸上书写绘图的书写工具是'연필'（铅笔）！",
            "JA": "黒鉛の芯を使って紙に文字を書いたり絵を描いたりする筆記具は「연필（鉛筆）」です！"
        }
    },
    21: {
        "situations": {
            "KO": "단풍이 물든 주말에 맑은 공기를 마시며 힐링 등산을 떠나는 상황입니다.",
            "EN": "Heading out for an autumn hike to enjoy fresh air and colorful foliage.",
            "VI": "Đi leo núi ngắm lá đỏ mùa thu và tận hưởng không khí trong lành vào cuối tuần.",
            "ZH": "在秋高气爽的周末去大自然爬山呼吸新鲜空气的登山休闲场景。",
            "JA": "紅葉が色づく週末に澄んだ空気を吸いながら山登りに出かける場面です。"
        },
        "questions": {
            "KO": "가: 가을이 깊어져서 나무들이 울긋불긋 단풍으로 곱게 물들었어요.\n나: 맑은 공기도 마시고 힐링할 겸 이번 주말에 설악(   )으로 등산 갈까요?"
        },
        "explanations": {
            "KO": "주위의 평지보다 훨씬 높이 솟아올라 나무와 바위가 우거진 자연 지형은 '산(Mountain)'이에요!",
            "EN": "A high, elevated natural landform rising above surrounding land is '산' (Mountain)!",
            "VI": "Địa hình tự nhiên nhô cao hùng vĩ với cây cối và vách đá là '산' (Núi)!",
            "ZH": "比周围地面高耸拔起、林木葱郁的自然地貌是'산'（山）！",
            "JA": "平地よりも高くそびえ立ち木々や岩が茂る自然地形は「산（山）」です！"
        }
    },
    22: {
        "situations": {
            "KO": "지하철역 앞 베이커리에서 갓 구운 고소한 크루아상을 사 먹는 상황입니다.",
            "EN": "Buying a freshly baked, warm croissant from a bakery near the subway.",
            "VI": "Mua một chiếc bánh mì nóng giòn thơm phức tại tiệm bánh trước ga tàu điện ngầm.",
            "ZH": "在地铁站前的面包店购买刚出炉热气腾腾牛角面包的早餐情景。",
            "JA": "駅前のベーカリーで焼きたての香ばしいクロワッサンを買う場面です。"
        },
        "questions": {
            "KO": "가: 출근길 지하철역 앞 베이커리에서 갓 구운 고소한 버터 냄새가 솔솔 나요.\n나: 아침 거르지 말고 들어가서 따뜻한 크루아상 (   ) 하나랑 커피 사서 가요."
        },
        "explanations": {
            "KO": "밀가루 반죽을 오븐에 부풀려 구워낸 고소한 주식 간편식은 '빵(Bread)'이에요!",
            "EN": "The staple baked food made by mixing flour, water, and yeast is '빵' (Bread)!",
            "VI": "Món ăn nướng làm từ bột mì nở xốp thơm lừng là '빵' (Bánh mì)!",
            "ZH": "用面粉和黄油发酵在烤箱中烘烤而成的香醇食品是'빵'（面包）！",
            "JA": "小麦粉の生地をオーブンでふっくらと焼き上げた香ばしい食品は「빵（パン）」です！"
        }
    },
    23: {
        "situations": {
            "KO": "마트 과일 코너에서 아침에 먹기 좋은 아삭아삭한 꿀사과를 고르는 상황입니다.",
            "EN": "Picking crisp, sweet red apples at the supermarket fruit section.",
            "VI": "Chọn những quả táo mật đỏ tươi giòn ngọt tại quầy hoa quả siêu thị.",
            "ZH": "在超市水果区挑选适合早晨食用的爽脆红苹果的场景。",
            "JA": "スーパーの果物コーナーで朝食にぴったりのシャキシャキしたリンゴを選ぶ場面です。"
        },
        "questions": {
            "KO": "가: 마트 과일 코너에서 아침 공복에 먹으면 건강에 좋은 빨간 과일을 고르고 있어요.\n나: 껍질째 씻어 먹을 수 있는 아삭아삭하고 상큼한 꿀(   ) 한 봉지 사요."
        },
        "explanations": {
            "KO": "빨갛게 익고 과즙이 풍부하며 아삭아삭 씹히는 과일은 '사과(Apple)'예요!",
            "EN": "A sweet, crisp, round red fruit popular for breakfast is '사과' (Apple)!",
            "VI": "Loại trái cây màu đỏ giòn ngọt nhiều nước rất tốt cho sức khỏe là '사과' (Táo)!",
            "ZH": "外皮鲜红、香甜爽脆的多汁温带水果是'사과'（苹果）！",
            "JA": "赤く実り果汁たっぷりでシャキシャキとした食感の果物は「사과（リンゴ）」です！"
        }
    },
    24: {
        "situations": {
            "KO": "봄꽃 축제에서 스마트폰 카메라로 담은 기념 촬영물을 함께 보는 상황입니다.",
            "EN": "Looking at memory photos taken with a smartphone camera at a spring festival.",
            "VI": "Cùng xem lại những tấm hình kỷ niệm đẹp được chụp bằng điện thoại tại lễ hội hoa xuân.",
            "ZH": "在春季花卉节用智能手机相机拍照留念并一起欣赏照片的情景。",
            "JA": "春の花祭りでスマホカメラを使って撮った記念写真を一緒に見る場面です。"
        },
        "questions": {
            "KO": "가: 가족들과 벚꽃 축제에 놀러 가서 스마트폰 카메라로 추억을 많이 남겼어요.\n나: 활짝 웃는 모습이 너무 보기 좋아요! 저한테도 그 (   ) 몇 장 전송해 주세요."
        },
        "explanations": {
            "KO": "카메라 렌즈를 통해 인물이나 풍경의 빛을 기록한 시각 영상물은 '사진(Photo)'이에요!",
            "EN": "An image produced by capturing light on a camera sensor or film is '사진' (Photo)!",
            "VI": "Tác phẩm hình ảnh ghi lại cảnh vật và con người bằng máy ảnh là '사진' (Ảnh/Hình)!",
            "ZH": "通过照相机镜头定格记录人物与风景的图像画面是'사진'（照片）！",
            "JA": "カメラのレンズを通して人物や風景を写した視覚的記録は「사진（写真）」です！"
        }
    },
    25: {
        "situations": {
            "KO": "매운 음식을 먹고 나서 입안을 달래기 위해 고소한 흰색 음료를 마시는 상황입니다.",
            "EN": "Drinking cold, creamy white milk to soothe your tongue after spicy food.",
            "VI": "Uống một cốc sữa tươi mát để làm dịu vị cay trong miệng sau khi ăn đồ cay.",
            "ZH": "吃完辛辣食物后喝冰凉香浓的白牛奶来解辣舒缓口腔的场景。",
            "JA": "辛い料理を食べた後、口の中を落ち着かせるために白い牛乳を飲む場面です。"
        },
        "questions": {
            "KO": "가: 매운 떡볶이를 먹었더니 입안에 불이 난 것처럼 혀가 너무 얼얼해요!\n나: 매운맛을 달래려면 냉장고에 있는 차갑고 고소한 흰 (   )을/를 얼른 마셔요."
        },
        "explanations": {
            "KO": "젖소에서 짜내어 칼슘과 영양이 풍부한 하얀 음료는 '우유(Milk)'예요!",
            "EN": "The white, nutrient-rich liquid produced by dairy cows is '우유' (Milk)!",
            "VI": "Thức uống màu trắng bổ dưỡng giàu canxi từ bò sữa là '우유' (Sữa)!",
            "ZH": "从奶牛身上采集提取、富含钙质与营养的白色饮品是'우유'（牛奶）！",
            "JA": "牛から絞ったカルシウムと栄養が豊富な白い飲み物は「우유（牛乳）」です！"
        }
    },
    26: {
        "situations": {
            "KO": "오래 걸어 다리가 아파 휴게 공간의 빈 좌석에 앉아 쉬려는 상황입니다.",
            "EN": "Looking for an empty seat to sit down and rest tired legs after walking.",
            "VI": "Tìm chiếc ghế trống ở khu nghỉ chân để ngồi nghỉ vì đi bộ mỏi chân.",
            "ZH": "长时间逛街步行双腿酸痛，找一张空椅子坐下休息的日常场景。",
            "JA": "長く歩いて足が痛いため、休憩スペースの空いた椅子に座って休む場面です。"
        },
        "questions": {
            "KO": "가: 백화점에서 세 시간 동안 걸어 다녔더니 다리가 너무 뻐근하고 아파요.\n나: 저기 카페 휴게 공간에 빈 (   )이/가 있으니까 잠시 앉아서 쉬었다 가요."
        },
        "explanations": {
            "KO": "사람이 엉덩이를 대고 편안하게 앉을 수 있도록 만든 가구는 '의자(Chair)'예요!",
            "EN": "A piece of furniture designed for one person to sit on is '의자' (Chair)!",
            "VI": "Món đồ nội thất có chân dùng để ngồi nghỉ ngơi là '의자' (Ghế)!",
            "ZH": "供人坐下来休息放松的单人家具是'의자'（椅子）！",
            "JA": "人が腰掛けて快適に座れるように作られた家具は「의자（椅子）」です！"
        }
    },
    27: {
        "situations": {
            "KO": "예고 없는 소나기가 쏟아져 비를 피하기 위한 물건을 편의점에서 구매하는 상황입니다.",
            "EN": "Buying an umbrella at a convenience store during an unexpected sudden downpour.",
            "VI": "Mua một chiếc ô ở cửa hàng tiện lợi khi gặp cơn mưa rào bất chợt.",
            "ZH": "遭遇突如其来的倾盆雷阵雨，去便利店买雨伞避雨的日常场景。",
            "JA": "突然の夕立に見舞われ、雨をしのぐためにコンビニで傘を買う場面です。"
        },
        "questions": {
            "KO": "가: 일기예보도 못 봤는데 갑자기 하늘에서 장대비가 쏟아지기 시작했어요!\n나: 비 맞으면 감기 걸리니까 편의점에 가서 비를 막아줄 튼튼한 (   ) 하나 사요."
        },
        "explanations": {
            "KO": "비가 올 때 머리 위로 펼쳐서 빗방울을 막아주는 비가림 도구는 '우산(Umbrella)'이에요!",
            "EN": "A portable canopy that opens overhead to shield you from rain is '우산' (Umbrella)!",
            "VI": "Vật dụng xòe ra che trên đầu để không bị ướt khi trời mưa là '우산' (Cái ô/dù)!",
            "ZH": "下雨天撑开在头顶阻挡雨水淋湿身体的随身工具是'우산'（雨伞）！",
            "JA": "雨が降る時に頭上に広げて雨粒を防ぐ雨具は「우산（傘）」です！"
        }
    },
    28: {
        "situations": {
            "KO": "버스 요금을 내기 위해 가방 속에 둔 카드 보관용 소품을 찾는 상황입니다.",
            "EN": "Searching for your wallet inside your bag to pay for the bus fare.",
            "VI": "Tìm chiếc ví cất trong túi xách để lấy thẻ thanh toán tiền vé xe buýt.",
            "ZH": "为了刷卡乘坐公交车，在背包内侧寻找存放卡片钱包的日常情景。",
            "JA": "バス料金を支払うためにバッグの中にある財布を探す場面です。"
        },
        "questions": {
            "KO": "가: 버스 요금을 결제해야 하는데 신용카드와 교통카드가 어디 갔지?\n나: 아까 가방 안쪽 주머니에 넣어 둔 가죽 (   ) 안에 잘 들어있을 거예요."
        },
        "explanations": {
            "KO": "현금, 동전, 신용카드, 신분증을 넣어 휴대하는 소형 주머니 소품은 '지갑(Wallet)'이에요!",
            "EN": "A pocket-sized case used for carrying paper money, cards, and coins is '지갑' (Wallet)!",
            "VI": "Vật dụng nhỏ gọn bằng da để đựng tiền mặt, thẻ ngân hàng và giấy tờ là '지갑' (Ví tiền)!",
            "ZH": "随身携带用来存放现金纸币、银行卡与证件的小包是'지갑'（钱包）！",
            "JA": "紙幣や硬貨、クレジットカードを入れて持ち歩くケースは「지갑（財布）」です！"
        }
    },

    # 29-45: 국적 및 직업 회화
    29: {
        "situations": {
            "KO": "도쿄 타워가 있는 일본에서 태어난 친구의 출신 국적을 확인하는 상황입니다.",
            "EN": "Confirming Japanese nationality for a friend born in Tokyo, Japan.",
            "VI": "Xác nhận quốc tịch Nhật Bản của một người bạn sinh ra tại Tokyo.",
            "ZH": "向出生在拥有东京铁塔的日本东京的朋友确认国籍的情景。",
            "JA": "東京タワーがある日本出身の友達の国籍を確認する場面です。"
        },
        "questions": {
            "KO": "가: 켄지 씨는 후지산과 도쿄 타워가 있는 수도 도쿄에서 자라셨나요?\n나: 네, 제 고향은 도쿄이고 저는 (   ) 사람이에요."
        },
        "explanations": {
            "KO": "도쿄를 수도로 가진 이웃 나라는 '일본(Japan)'이에요!",
            "EN": "The neighboring Asian country whose capital is Tokyo is '일본' (Japan)!",
            "VI": "Đất nước láng giềng có thủ đô là Tokyo chính là '일본' (Nhật Bản)!",
            "ZH": "首都是东京的东亚邻国是'일본'（日本）！",
            "JA": "東京を首都に持つお隣の国は「일본（日本）」です！"
        }
    },
    30: {
        "situations": {
            "KO": "베를린 장벽과 맥주로 유명한 유럽 독일 출신임을 확인하는 상황입니다.",
            "EN": "Confirming German nationality for a friend from Berlin, Germany.",
            "VI": "Xác nhận người bạn đến từ nước Đức, nơi nổi tiếng với bia và thủ đô Berlin.",
            "ZH": "向来自以啤酒和柏林闻名的欧洲德国的朋友确认国籍的情景。",
            "JA": "ベルリンの壁やビールで有名なヨーロッパのドイツ出身であることを確認する場面です。"
        },
        "questions": {
            "KO": "가: 루카스 씨는 맥주 축제와 유서 깊은 베를린이 있는 나라에서 오셨나요?\n나: 네, 맞아요. 저는 유럽 대륙의 (   ) 사람이에요."
        },
        "explanations": {
            "KO": "베를린을 수도로 둔 유럽의 국가는 '독일(Germany)'이에요!",
            "EN": "The European country with Berlin as its capital is '독일' (Germany)!",
            "VI": "Đất nước châu Âu có thủ đô Berlin là '독일' (Nước Đức)!",
            "ZH": "首都是柏林的欧洲国家是'독일'（德国）！",
            "JA": "ベルリンを首都とするヨーロッパの国は「독일（ドイツ）」です！"
        }
    },
    31: {
        "situations": {
            "KO": "만리장성과 자금성이 위치한 베이징 출신 중국인임을 확인하는 상황입니다.",
            "EN": "Confirming Chinese nationality for a friend from Beijing, China.",
            "VI": "Xác nhận người bạn đến từ Bắc Kinh, Trung Quốc nơi có Vạn Lý Trường Thành.",
            "ZH": "向来自拥有故宫和长城的北京的朋友确认其为中国人的场景。",
            "JA": "万里の長城や紫禁城がある北京出身の中国人であることを確認する場面です。"
        },
        "questions": {
            "KO": "가: 웨이 씨는 만리장성과 웅장한 자금성이 있는 베이징 출신이신가요?\n나: 네, 제 고향은 베이징이고 저는 (   ) 사람이에요."
        },
        "explanations": {
            "KO": "베이징을 수도로 두고 만리장성이 있는 아시아 국가는 '중국(China)'이에요!",
            "EN": "The Asian country home to the Great Wall and capital Beijing is '중국' (China)!",
            "VI": "Quốc gia châu Á có Vạn Lý Trường Thành và thủ đô Bắc Kinh là '중국' (Trung Quốc)!",
            "ZH": "首都是北京、拥有万里长城的邻邦是'중국'（中国）！",
            "JA": "北京を首都とし万里の長城がある国は「중국（中国）」です！"
        }
    },
    32: {
        "situations": {
            "KO": "캥거루와 시드니 오페라 하우스로 유명한 호주 출신임을 밝히는 상황입니다.",
            "EN": "Explaining that someone is from Australia, famous for kangaroos and Sydney.",
            "VI": "Nói về việc mình đến từ nước Úc, nơi nổi tiếng với chuột túi kangaroo và Sydney.",
            "ZH": "介绍自己来自以袋鼠和悉尼歌剧院闻名的澳大利亚的场景。",
            "JA": "カンガルーやシドニーオペラハウスで有名なオーストラリア出身を明かす場面です。"
        },
        "questions": {
            "KO": "가: 캥거루가 뛰놀고 하얀 조개 모양의 오페라 하우스가 있는 남반구 나라에서 오셨어요?\n나: 네, 저는 시드니와 멜버른이 있는 아름다운 (   )에서 왔어요."
        },
        "explanations": {
            "KO": "시드니 오페라 하우스와 캥거루로 유명한 남반구의 영연방 국가는 '호주(Australia)'예요!",
            "EN": "The Southern Hemisphere nation famous for Sydney and kangaroos is '호주' (Australia)!",
            "VI": "Quốc gia ở Nam bán cầu nổi tiếng với nhà hát con sò và kangaroo là '호주' (Nước Úc)!",
            "ZH": "拥有悉尼歌剧院和可爱袋鼠的南半球大洋洲国家是'호주'（澳大利亚）！",
            "JA": "シドニーオペラハウスやカンガルーで有名な南半球の国は「호주（オーストラリア）」です！"
        }
    },
    33: {
        "situations": {
            "KO": "에펠탑과 낭만의 도시 파리로 유명한 프랑스에서 왔음을 소개하는 상황입니다.",
            "EN": "Introducing that someone came from France, world-famous for Paris and the Eiffel Tower.",
            "VI": "Giới thiệu mình đến từ nước Pháp, kinh đô ánh sáng nổi tiếng với tháp Eiffel và Paris.",
            "ZH": "介绍自己来自以埃菲尔铁塔和巴黎闻名的浪漫法国的场景。",
            "JA": "エッフェル塔や花の都パリで有名なフランスから来たことを紹介する場面です。"
        },
        "questions": {
            "KO": "가: 에펠탑 야경과 바게트 빵, 루브르 박물관으로 유명한 파리가 고향이신가요?\n나: 네, 낭만과 예술의 도시 파리가 있는 (   )에서 왔습니다."
        },
        "explanations": {
            "KO": "파리를 수도로 두고 에펠탑이 서 있는 서유럽 국가는 '프랑스(France)'예요!",
            "EN": "The Western European country with Paris as its capital and the Eiffel Tower is '프랑스' (France)!",
            "VI": "Quốc gia Tây Âu có thủ đô Paris và tháp Eiffel là '프랑스' (Nước Pháp)!",
            "ZH": "首都是巴黎、矗立着埃菲尔铁塔的西欧国家是'프랑스'（法国）！",
            "JA": "パリを首都としエッフェル塔がある西ヨーロッパの国は「프랑스（フランス）」です！"
        }
    },
    34: {
        "situations": {
            "KO": "어학당 교실에서 외국인 학생들에게 한국어를 가르치는 직업을 밝히는 상황입니다.",
            "EN": "Sharing that your profession is a Korean language teacher at a language institute.",
            "VI": "Giới thiệu nghề nghiệp là giáo viên dạy tiếng Hàn cho người nước ngoài tại trung tâm.",
            "ZH": "在语学院课堂上向大家介绍自己教授外国人韩语的教师职业的场景。",
            "JA": "語学堂で外国人学生に韓国語を教える先生という職業を伝える場面です。"
        },
        "questions": {
            "KO": "가: 다정 씨는 대학교 어학당 교실에서 외국인 유학생들에게 한국어 문법을 가르치시나요?\n나: 네, 교실에서 학생들을 사랑으로 가르치는 한국어 (   )이에요."
        },
        "explanations": {
            "KO": "학교나 학원에서 지식과 학문을 가르치는 직업은 '선생님(Teacher)'이에요!",
            "EN": "An educator who teaches knowledge and languages at school is '선생님' (Teacher)!",
            "VI": "Người làm nghề truyền thụ kiến thức cho học sinh tại trường lớp là '선생님' (Thầy/Cô giáo)!",
            "ZH": "在学校传授知识、培育学生的教育职业是'선생님'（老师）！",
            "JA": "学校や塾で知識や語学を教える職業は「선생님（先生）」です！"
        }
    },
    35: {
        "situations": {
            "KO": "테크노밸리 사옥으로 매일 출근해 사무 업무를 보는 직장인을 소개하는 상황입니다.",
            "EN": "Introducing an office worker commuting to an IT company headquarters daily.",
            "VI": "Giới thiệu một nhân viên văn phòng đi làm mỗi ngày tại tòa nhà công nghệ IT.",
            "ZH": "介绍每天前往科技园区大厦上班打卡做办公业务的上班族职业的场景。",
            "JA": "オフィスビルへ毎日出勤してデスクワークをする会社員の職業を紹介する場面です。"
        },
        "questions": {
            "KO": "가: 민호 씨는 판교 IT 테크노밸리 사옥으로 매일 아침 출근하시나요?\n나: 네, 사무실에서 컴퓨터로 마케팅 기획 업무를 담당하는 (   )이에요."
        },
        "explanations": {
            "KO": "기업체나 회사에 소속되어 월급을 받으며 일하는 사무직 근로자는 '회사원(Office worker)'이에요!",
            "EN": "An employee who works in an office or corporate business is '회사원' (Office worker)!",
            "VI": "Người làm việc tại các công ty, doanh nghiệp văn phòng là '회사원' (Nhân viên công ty)!",
            "ZH": "在企事业单位上班从事日常业务的工薪职场人是'회사원'（公司职员/上班族）！",
            "JA": "会社に所属してオフィスでデスクワークを行う職業は「회사원（会社員）」です！"
        }
    },
    36: {
        "situations": {
            "KO": "대학병원 진료실에서 아픈 환자의 질병을 진찰하고 치료하는 직업을 묻는 상황입니다.",
            "EN": "Asking about a medical doctor examining and treating sick patients at a hospital.",
            "VI": "Hỏi về bác sĩ khám và điều trị bệnh cho bệnh nhân tại phòng khám bệnh viện.",
            "ZH": "询问在大学医院诊室里用听诊器为病人问诊治疗的医生职业的日常场景。",
            "JA": "大学病院の診察室で病気の患者を診察し治療する医師について尋ねる場面です。"
        },
        "questions": {
            "KO": "가: 대학병원 진료실에서 청진기를 대고 아픈 환자를 진찰해 주시는 분은 누구예요?\n나: 흰 가운을 입고 병을 고쳐주는 전문 의료인 (   ) 선생님이세요."
        },
        "explanations": {
            "KO": "환자의 질병을 진단하고 약을 처방하거나 수술하는 의료인은 '의사(Doctor)'예요!",
            "EN": "A licensed medical professional who diagnoses and treats patients is '의사' (Doctor)!",
            "VI": "Chuyên gia y tế được cấp phép khám và chữa bệnh cho bệnh nhân là '의사' (Bác sĩ)!",
            "ZH": "在医院诊断病情、开具处方救治患者的白衣天使是'의사'（医生）！",
            "JA": "病気を診断して治療や投薬を行う医療の専門家は「의사（医師/お医者さん）」です！"
        }
    },
    37: {
        "situations": {
            "KO": "하롱베이와 쌀국수로 유명한 동남아시아 베트남 출신임을 확인하는 상황입니다.",
            "EN": "Confirming Vietnamese nationality for someone from Hanoi, Vietnam.",
            "VI": "Xác nhận quốc tích Việt Nam của một người bạn đến từ thủ đô Hà Nội tươi đẹp.",
            "ZH": "向来自拥有下龙湾美景和美味河粉的越南的朋友确认国籍的日常场景。",
            "JA": "ハロン湾やフォーで有名な東南アジアのベトナム出身であることを確認する場面です。"
        },
        "questions": {
            "KO": "가: 린 씨는 하롱베이 관광지와 따뜻하고 맛있는 쌀국수로 유명한 곳에서 오셨나요?\n나: 네, 맞아요! 수도가 하노이인 아름다운 나라 (   ) 사람이에요."
        },
        "explanations": {
            "KO": "하노이가 수도이고 쌀국수(포)로 유명한 동남아 국가는 '베트남(Vietnam)'이에요!",
            "EN": "The Southeast Asian nation with Hanoi as capital, famous for Pho, is '베트남' (Vietnam)!",
            "VI": "Quốc gia Đông Nam Á có thủ đô là Hà Nội và nổi tiếng với món phở là '베트남' (Việt Nam)!",
            "ZH": "首都是河内、以美味河粉闻名的东南亚国家是'베트남'（越南）！",
            "JA": "ハノイを首都としフォーが有名な東南アジアの国は「베트남（ベトナム）」です！"
        }
    },
    38: {
        "situations": {
            "KO": "서울 경복궁 근처에서 태어나고 자란 대한민국 토박이임을 밝히는 상황입니다.",
            "EN": "Explaining that someone was born in Seoul and is a local Korean citizen.",
            "VI": "Nói rằng mình sinh ra và lớn lên tại Seoul, là người bản xứ Hàn Quốc.",
            "ZH": "向外国朋友介绍自己土生土长在首尔是韩国本地人的日常场景。",
            "JA": "ソウルの景福宮の近くで生まれ育った生粋の韓国人であることを伝える場面です。"
        },
        "questions": {
            "KO": "가: 지훈 씨는 서울 경복궁 근처 종로에서 태어나고 자란 현지인이신가요?\n나: 네, 저는 대한민국 서울 토박이 (   ) 사람이에요."
        },
        "explanations": {
            "KO": "한글을 창제하고 서울을 수도로 둔 우리나라는 '한국(Korea)'이에요!",
            "EN": "The country home to the Korean language and capital Seoul is '한국' (Korea)!",
            "VI": "Đất nước của chữ Hangeul và thủ đô Seoul tươi đẹp chính là '한국' (Hàn Quốc)!",
            "ZH": "创造了韩文字母、首都是首尔的国家是'한국'（韩国）！",
            "JA": "ハングルを創製しソウルを首都とする国は「한국（韓国）」です！"
        }
    },
    39: {
        "situations": {
            "KO": "자유의 여신상과 뉴욕 타임스퀘어가 있는 미국 출신임을 소개하는 상황입니다.",
            "EN": "Introducing that someone came from the USA, home to New York and the Statue of Liberty.",
            "VI": "Giới thiệu mình đến từ nước Mỹ, nơi có tượng Nữ Thần Tự Do và New York sầm uất.",
            "ZH": "介绍自己来自拥有自由女神像与纽约时代广场的美国的日常场景。",
            "JA": "自由の女神やタイムズスクエアがあるアメリカ出身であることを紹介する場面です。"
        },
        "questions": {
            "KO": "가: 엠마 씨는 자유의 여신상과 타임스퀘어가 있는 뉴욕 맨해튼에서 오셨어요?\n나: 네, 저는 북미 대륙에 위치한 (   )에서 유학 온 교환학생이에요."
        },
        "explanations": {
            "KO": "워싱턴 D.C.가 수도이고 뉴욕이 위치한 북아메리카의 대국은 '미국(USA)'이에요!",
            "EN": "The North American nation home to New York and Washington D.C. is '미국' (USA)!",
            "VI": "Quốc gia Bắc Mỹ có thủ đô Washington D.C. và New York hoa lệ là '미국' (Nước Mỹ)!",
            "ZH": "首都是华盛顿特区、拥有纽约等大都市的北美大国是'미국'（美国）！",
            "JA": "ワシントンD.C.を首都としニューヨークがある北米の国は「미국（アメリカ）」です！"
        }
    },
    40: {
        "situations": {
            "KO": "대학교 강의실과 도서관에서 전공 공부에 열중하는 대학생 신분을 소개하는 상황입니다.",
            "EN": "Introducing someone's status as a university student studying hard in class.",
            "VI": "Giới thiệu thân phận là sinh viên đại học đang chăm chỉ học tập tại giảng đường.",
            "ZH": "在大学教室和图书馆里专心攻读专业的大学生日常自我介绍情景。",
            "JA": "大学の講義室や図書館で専門の勉強に励む学生であることを紹介する場面です。"
        },
        "questions": {
            "KO": "가: 수현 씨는 요즘 대학교 강의실과 도서관에서 주로 무엇을 하고 지내세요?\n나: 경영학 전공 수업을 열심히 수강하고 있는 대(   )이에요."
        },
        "explanations": {
            "KO": "학교에 다니며 스승에게 배움을 얻는 신분은 '학생(Student)'이에요!",
            "EN": "A person who is enrolled in school and learning from instructors is '학생' (Student)!",
            "VI": "Người đang theo học tại các trường lớp là '학생' (Học sinh/Sinh viên)!",
            "ZH": "在学校跟随老师读书求学的身份是'학생'（学生）！",
            "JA": "学校に通って先生から学びを得る立場の人を「학생（学生）」と言います！"
        }
    },
    41: {
        "situations": {
            "KO": "병원 병동에서 환자들의 혈압과 건강 상태를 따뜻하게 보살피는 직업을 묻는 상황입니다.",
            "EN": "Asking about a nurse who measures blood pressure and cares for hospital patients.",
            "VI": "Hỏi về nghề y tá ân cần đo huyết áp và chăm sóc bệnh nhân trong phòng bệnh.",
            "ZH": "询问在医院病房里测量血压、悉心照料病患健康的护士职业的日常场景。",
            "JA": "病棟で患者の血圧や健康状態を温かくケアする看護師について尋ねる場面です。"
        },
        "questions": {
            "KO": "가: 병동을 돌며 입원 환자들의 체온과 혈압을 꼼꼼하게 측정하고 돌봐주시는 분은 누구예요?\n나: 환자 곁을 24시간 지키며 정성을 다해 치료를 돕는 백의의 천사 (   ) 선생님이세요."
        },
        "explanations": {
            "KO": "의사의 진료를 보조하고 환자를 직접 보살피는 의료 전문직은 '간호사(Nurse)'예요!",
            "EN": "A licensed healthcare professional who assists doctors and cares for patients is '간호사' (Nurse)!",
            "VI": "Người làm công tác điều dưỡng chăm sóc bệnh nhân tại cơ sở y tế là '간호사' (Y tá/Điều dưỡng)!",
            "ZH": "协助医生诊疗、在病床前悉心护理照料病患的专业医护工作者是'간호사'（护士）！",
            "JA": "医師の診療を補助し患者を直接ケアする医療専門職は「간호사（看護師）」です！"
        }
    },
    42: {
        "situations": {
            "KO": "고급 레스토랑 주방에서 최고의 풍미를 내는 메인 코스 요리를 만드는 전문가를 묻는 상황입니다.",
            "EN": "Asking about a professional chef who prepares exquisite fine dining dishes in the kitchen.",
            "VI": "Hỏi về người đầu bếp tài hoa đứng bếp nấu các món ăn cao cấp tại nhà hàng sang trọng.",
            "ZH": "询问在高级餐厅后厨精心烹制顶级美味料理的专业厨师的日常场景。",
            "JA": "高級レストランの厨房で最高の一皿を作る専門家について尋ねる場面です。"
        },
        "questions": {
            "KO": "가: 이 레스토랑의 메인 스테이크 코스 요리는 누가 직접 정성껏 만드나요?\n나: 주방에서 하얀 모자를 쓰고 최고의 맛을 조리해 내는 전문 셰프 (   )예요."
        },
        "explanations": {
            "KO": "다양한 식재료를 손질하여 맛있는 음식을 전문적으로 만드는 사람은 '요리사(Chef/Cook)'예요!",
            "EN": "A professional who prepares delicious meals in restaurant kitchens is '요리사' (Chef/Cook)!",
            "VI": "Người chế biến nguyên liệu thành các món ăn thơm ngon trong nhà bếp là '요리사' (Đầu bếp)!",
            "ZH": "在厨房挥勺掌勺、专业制作各种美味珍馐的人是'요리사'（厨师）！",
            "JA": "食材を調理して美味しい料理を専門的に作る人は「요리사（料理人/シェフ）」です！"
        }
    },
    43: {
        "situations": {
            "KO": "어두운 밤길을 순찰하며 시민들의 안전을 든든하게 지켜주는 수호자를 묻는 상황입니다.",
            "EN": "Asking about a police officer patrolling dark night streets to keep citizens safe.",
            "VI": "Hỏi về chú công an tuần tra đường phố ban đêm để bảo vệ bình yên cho nhân dân.",
            "ZH": "询问在深夜巡逻街巷、坚守岗位保卫市民人身财产安全的警察的日常场景。",
            "JA": "夜道をパトロールしながら市民の安全を守る警察官について尋ねる場面です。"
        },
        "questions": {
            "KO": "가: 늦은 밤 골목길을 순찰차로 돌며 시민들의 밤길 안전을 든든하게 지켜주시는 분은 누구예요?\n나: 멋진 제복을 입고 범죄를 예방하는 우리 동네 (   ) 아저씨예요."
        },
        "explanations": {
            "KO": "사회의 법률과 질서를 유지하고 국민의 생명과 재산을 보호하는 공무원은 '경찰관(Police officer)'이에요!",
            "EN": "A public officer who upholds law and order and protects citizens is '경찰관' (Police officer)!",
            "VI": "Cán bộ thực thi pháp luật giữ gìn trật tự và an toàn xã hội là '경찰관' (Cảnh sát/Công an)!",
            "ZH": "维护社会治安秩序、惩治违法犯罪守护人民安全的国家公职人员是'경찰관'（警察）！",
            "JA": "社会の法と秩序を維持し、国民の安全と財産を守る公務員は「경찰관（警察官）」です！"
        }
    },
    44: {
        "situations": {
            "KO": "콘서트 무대 위에서 마이크를 잡고 감미로운 목소리로 노래하는 직업을 묻는 상황입니다.",
            "EN": "Asking about a musical artist singing with a microphone on a concert stage.",
            "VI": "Hỏi về người ca sĩ cầm mic cất giọng hát truyền cảm trên sân khấu buổi hòa nhạc.",
            "ZH": "询问在演唱会聚光灯下拿起麦克风倾情放歌的歌手职业的场景。",
            "JA": "コンサートのステージでマイクを握り美しい声で歌う歌手について尋ねる場面です。"
        },
        "questions": {
            "KO": "가: 화려한 콘서트 무대 조명 아래에서 감미로운 목소리로 노래를 들려주는 저분은 누구예요?\n나: 이번에 최신 음원 차트 1위에 오른 인기 만점 대중(   )예요."
        },
        "explanations": {
            "KO": "대중 앞에서 음악에 맞춰 아름다운 목소리로 노래를 부르는 예술가는 '가수(Singer)'예요!",
            "EN": "A musical artist who performs vocal songs for audiences is '가수' (Singer)!",
            "VI": "Nghệ sĩ biểu diễn giọng hát truyền cảm cho công chúng thưởng thức là '가수' (Ca sĩ)!",
            "ZH": "用歌声传递情感、在舞台上为大家献唱的音乐人是'가수'（歌手）！",
            "JA": "大勢の聴衆の前で音楽に合わせて歌を歌うアーティストは「가수（歌手）」です！"
        }
    },
    45: {
        "situations": {
            "KO": "인천국제공항 출국 심사대에서 해외 신분 확인을 위해 제시하는 공문서를 묻는 상황입니다.",
            "EN": "Asking about the official passport document presented for international boarding checks.",
            "VI": "Hỏi về cuốn hộ chiếu xuất trình tại quầy kiểm soát xuất cảnh sân bay quốc tế.",
            "ZH": "询问在仁川国际机场出境边防检查大厅出示以证明国籍身份的护照证件的场景。",
            "JA": "空港の出国審査場で身分証明のために提示する公的書類のパスポートを尋ねる場面です。"
        },
        "questions": {
            "KO": "가: 인천국제공항에서 비행기 탑승권을 발권하고 출국 심사할 때 반드시 제시해야 하는 해외 신분증은 뭐예요?\n나: 정부 외교부에서 발급한 녹색/남색 표지의 공식 (   )이에요."
        },
        "explanations": {
            "KO": "외국을 여행할 때 자신의 국적과 신분을 국제적으로 증명해 주는 정부 발행 수첩은 '여권(Passport)'이에요!",
            "EN": "The official government booklet verifying your identity and nationality abroad is '여권' (Passport)!",
            "VI": "Cuốn sổ thông hành chính thức chứng minh quốc tịch khi ra nước ngoài là '여권' (Hộ chiếu)!",
            "ZH": "前往外国旅行时用来在国际上证明国籍与身份的政府签发证件是'여권'（护照）！",
            "JA": "海外旅行の際に自分の国籍と身分を証明する公的な手帳は「여권（パスポート/旅券）」です！"
        }
    },

    # 46-50: 장소 및 대표 음식
    46: {
        "situations": {
            "KO": "고열과 심한 기침 증상으로 의사의 전문 진료를 받기 위해 찾아갈 시설을 권하는 상황입니다.",
            "EN": "Recommending visiting a hospital to get professional doctor treatment for high fever.",
            "VI": "Khuyên nên đến bệnh viện gặp bác sĩ thăm khám khi bị sốt cao và ho dữ dội.",
            "ZH": "因持续高烧剧烈咳嗽而建议前往就医找专业医生诊治的场所场景。",
            "JA": "高熱と激しい咳のため、医師の診察を受けるべく病院を勧める場面です。"
        },
        "questions": {
            "KO": "가: 기침이 멈추지 않고 열이 38.5도까지 치솟아서 온몸이 너무 아파요.\n나: 더 악화되기 전에 얼른 의사 선생님이 계신 종합(   )에 가서 전문 진료를 받으세요."
        },
        "explanations": {
            "KO": "의사와 간호사가 환자를 검사하고 치료해 주는 전문 의료 기관은 '병원(Hospital)'이에요!",
            "EN": "A medical institution where doctors and nurses provide healthcare treatment is '병원' (Hospital)!",
            "VI": "Cơ sở y tế chuyên khám chữa bệnh cho người đau ốm là '병원' (Bệnh viện)!",
            "ZH": "由医生和护士为病人检查诊断、施行治疗的专业医疗机构是'병원'（医院）！",
            "JA": "医師や看護師が患者を診察し治療を行う医療機関は「병원（病院）」です！"
        }
    },
    47: {
        "situations": {
            "KO": "조용한 분위기에서 집중해서 공부하고 전공 서적을 빌릴 수 있는 공공시설을 묻는 상황입니다.",
            "EN": "Asking about a public library where you can focus on studying and borrow books.",
            "VI": "Hỏi về thư viện công cộng, nơi yên tĩnh để tập trung học tập và mượn sách chuyên ngành.",
            "ZH": "询问在安静氛围下专心学习自习并借阅各类图书的公共设施图书馆的场景。",
            "JA": "静かな環境で集中して勉強し、本を借りることができる図書館について尋ねる場面です。"
        },
        "questions": {
            "KO": "가: 소음 없이 조용한 열람실에서 집중해서 시험공부도 하고 전공 책도 빌릴 수 있는 곳은 어디예요?\n나: 수만 권의 장서와 쾌적한 학습 좌석이 마련되어 있는 시립(   )이에요."
        },
        "explanations": {
            "KO": "온갖 서적과 자료를 모아 두고 대출해 주거나 공부할 수 있는 공공시설은 '도서관(Library)'이에요!",
            "EN": "A public institution providing books, study areas, and learning resources is '도서관' (Library)!",
            "VI": "Nơi lưu trữ sách báo để mọi người đến mượn đọc và học tập là '도서관' (Thư viện)!",
            "ZH": "收藏各种图书报刊供公众借阅自修的文化学习设施是'도서관'（图书馆）！",
            "JA": "多くの書籍を集めて貸し出したり勉強できる公共施設は「도서관（図書館）」です！"
        }
    },
    48: {
        "situations": {
            "KO": "점심시간에 따뜻하고 푸짐한 한식 백반을 사 먹기 위해 들어갈 외식 장소를 찾는 상황입니다.",
            "EN": "Finding a traditional Korean restaurant to eat a hearty home-style lunch.",
            "VI": "Tìm một quán ăn ngon để thưởng thức bữa trưa cơm phần kiểu Hàn ấm cúng.",
            "ZH": "在午餐时间寻找品尝热气腾腾地道家常定食的餐厅就餐场景。",
            "JA": "お昼休みに温かい韓食の定食を食べるために食堂を探す場面です。"
        },
        "questions": {
            "KO": "가: 배가 너무 고픈데 근처에 점심으로 따뜻한 찌개 백반을 푸짐하게 잘하는 곳이 있어요?\n나: 네, 골목 안쪽에 가면 맛있는 정식을 파는 유명한 한식 (   )이/가 있어요."
        },
        "explanations": {
            "KO": "돈을 내고 음식을 주문하여 사 먹을 수 있는 외식 전문 업소는 '식당(Restaurant)'이에요!",
            "EN": "A commercial place where meals are prepared, served, and eaten is '식당' (Restaurant)!",
            "VI": "Nơi nấu nướng phục vụ các món ăn ngon cho thực khách là '식당' (Nhà hàng/Quán ăn)!",
            "ZH": "向公众提供烹饪好的菜肴饭食供人点餐食用的场所是'식당'（餐馆/餐厅）！",
            "JA": "料理を注文して食事をすることができる飲食店を「식당（食堂/レストラン）」と言います！"
        }
    },
    49: {
        "situations": {
            "KO": "소풍 갈 때 은박지에 싸서 간편하게 먹기 좋은 한국인의 대표 도시락 메뉴를 묻는 상황입니다.",
            "EN": "Asking about gimbap, the iconic Korean picnic lunchbox wrapped in foil.",
            "VI": "Hỏi về món gimbap cơm cuộn rong biển quen thuộc cho các chuyến dã ngoại ngoài trời.",
            "ZH": "询问在春游郊游时用锡纸包装携带的韩国代表性便当美食紫菜包饭的情景。",
            "JA": "遠足やピクニックのお弁当としてアルミホイルに包んで持っていく海苔巻きキンパを尋ねる場面です。"
        },
        "questions": {
            "KO": "가: 주말 소풍 갈 때 간편하게 은박지에 싸서 야외에서 먹기 가장 좋은 한국 도시락 메뉴는 뭐예요?\n나: 참기름을 바른 밥에 단무지, 당근, 햄을 넣고 김으로 돌돌 말아 썬 (   )이에요."
        },
        "explanations": {
            "KO": "밥에 다양한 채소와 햄 등을 넣고 김으로 말아서 썰어 먹는 소풍 대표 음식은 '김밥(Gimbap)'이에요!",
            "EN": "The iconic Korean rolled rice dish wrapped in toasted seaweed with fillings is '김밥' (Gimbap)!",
            "VI": "Món cơm cuộn rong biển trứ danh kết hợp cùng các loại nhân rau củ là '김밥' (Gimbap)!",
            "ZH": "在米饭中卷入火腿、黄萝卜丝等配料用紫菜包裹切段的标志性美食是'김밥'（紫菜包饭）！",
            "JA": "ご飯に具材をのせて海苔で巻いて輪切りにする代表的な遠足料理は「김밥（キンパ）」です！"
        }
    },
    50: {
        "situations": {
            "KO": "전주 한옥마을에서 다양한 신선 나물과 고추장을 밥에 쓱쓱 비벼 먹는 명물 음식을 묻는 상황입니다.",
            "EN": "Asking about Jeonju's specialty bibimbap mixed with vegetables and red chili paste.",
            "VI": "Hỏi về món cơm trộn bibimbap trứ danh của làng cổ Jeonju kết hợp nhiều loại rau tươi và tương ớt.",
            "ZH": "询问在全州韩屋村品尝的将各种新鲜野菜与辣酱拌饭食用的招牌美食拌饭的场景。",
            "JA": "全州の伝統的な名物で、ご飯にナムルとコチュジャンを混ぜて食べるビビンバを尋ねる場面です。"
        },
        "questions": {
            "KO": "가: 전주 한옥마을에 놀러 가면 놋그릇에 담아 나오는 꼭 먹어야 할 전통 한식 명물 메뉴는 뭐예요?\n나: 고슬고슬한 밥 위에 형형색색의 나물과 고추장을 듬뿍 넣어 쓱쓱 섞어 먹는 (   )이에요."
        },
        "explanations": {
            "KO": "밥에 여러 가지 나물, 고기, 양념 고추장을 골고루 비벼서 먹는 대표적인 전통 요리는 '비빔밥(Bibimbap)'이에요!",
            "EN": "The famous Korean dish of warm rice topped with seasoned vegetables, chili paste, and meat is '비빔밥' (Bibimbap)!",
            "VI": "Món ăn truyền thống gồm cơm nóng trộn đều với các loại rau thịt và sốt tương ớt là '비빔밥' (Cơm trộn)!",
            "ZH": "在米饭上码放各种凉拌菜、肉丝与甜辣酱拌匀享用的韩国经典名菜是'비빔밥'（拌饭）！",
            "JA": "温かいご飯に様々なナムルや牛肉、コチュジャンを入れて混ぜて食べる代表的な料理は「비빔밥（ビビンバ）」です！"
        }
    }
}

def main():
    json_path = 'assets/data/questions.json'
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    updated_count = 0
    for q in data:
        qid = q['id']
        if qid in NEW_QUESTIONS_1_TO_50:
            override = NEW_QUESTIONS_1_TO_50[qid]
            q['situations'] = override['situations']
            q['questions'] = override['questions']
            q['explanations'] = override['explanations']
            updated_count += 1

    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"Successfully overhauled {updated_count} questions (IDs 1-50) with 100% original scenarios.")

if __name__ == '__main__':
    main()

