# -*- coding: utf-8 -*-
"""
rephrase_situations.py
Rewrites all textbook-like instructions ('그림을 보고...', '<보기>와 같이...')
into 100% original, rich, contextual real-life situations in KO, EN, VI, ZH, JA.
Also converts IDs 169-184 from '<보기>... [문제]...' to natural conversational dialogues.
"""

import json
import re

def main():
    with open('assets/data/questions.json', 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Dictionary of bespoke situation overrides: id -> {KO, EN, VI, ZH, JA}
    custom_situations = {
        # 1-5: 능력 표현
        1: {
            "KO": "친구가 나의 한국어 구사 능력을 물어보는 상황입니다.",
            "EN": "A friend is asking about your ability to speak Korean.",
            "VI": "Tình huống bạn bè hỏi về khả năng nói tiếng Hàn của bạn.",
            "ZH": "朋友询问你的韩语能力的日常情景。",
            "JA": "友達から韓国語を話す能力について尋ねられた場面です。"
        },
        2: {
            "KO": "친구가 운전을 할 줄 아는지 나의 능력을 물어보는 상황입니다.",
            "EN": "A friend is asking if you know how to drive.",
            "VI": "Tình huống bạn bè hỏi xem bạn có biết lái xe không.",
            "ZH": "朋友询问你是否会开车的日常情景。",
            "JA": "友達から運転ができるか能力について尋ねられた場面です。"
        },
        3: {
            "KO": "생일 파티를 앞두고 케이크를 직접 만들 수 있는지 묻는 상황입니다.",
            "EN": "Asking if you can bake a cake yourself for an upcoming birthday party.",
            "VI": "Hỏi xem bạn có thể tự làm bánh kem cho bữa tiệc sinh nhật không.",
            "ZH": "在生日聚会前询问你是否会自己做蛋糕的情景。",
            "JA": "誕生日パーティーを前に、自分でケーキを作れるか尋ねる場面です。"
        },
        4: {
            "KO": "한국 식당에서 매운 김치를 먹을 수 있는지 식성을 묻는 상황입니다.",
            "EN": "Asking if you can eat spicy kimchi at a Korean restaurant.",
            "VI": "Hỏi xem bạn có ăn được kim chi cay ở nhà hàng Hàn Quốc không.",
            "ZH": "在韩国餐厅询问你是否能吃辣泡菜的场景。",
            "JA": "韓国料理店で辛いキムチが食べられるか好みを尋ねる場面です。"
        },
        5: {
            "KO": "겨울 여행을 가서 스키를 탈 줄 아는지 스포츠 능력을 묻는 상황입니다.",
            "EN": "Asking if you know how to ski on a winter vacation trip.",
            "VI": "Hỏi xem bạn có biết trượt tuyết không trong chuyến du lịch mùa đông.",
            "ZH": "去冬季旅行时询问你是否会滑雪的场景。",
            "JA": "冬の旅行でスキーができるかスポーツの能力について尋ねる場面です。"
        },

        # 6-10: 목적 및 이동 표현
        6: {
            "KO": "화창한 날씨에 산책하러 외출하는 목적지를 묻고 답하는 상황입니다.",
            "EN": "Asking and answering about the destination to go for a walk on a sunny day.",
            "VI": "Hỏi đáp về điểm đến để đi dạo trong một ngày đẹp trời.",
            "ZH": "在晴朗的日子里询问去散步的目的地并回答的情景。",
            "JA": "晴れた日に散歩に出かける目的地を尋ねて答える場面です。"
        },
        7: {
            "KO": "가방에 책을 챙겨 공부하러 가는 장소를 묻고 답하는 상황입니다.",
            "EN": "Asking and answering where you are going to study with books in your bag.",
            "VI": "Hỏi đáp về nơi bạn đang đến để học bài với cặp đầy sách.",
            "ZH": "拿着装满书的包询问去哪里学习并回答的情景。",
            "JA": "本が入ったカバンを持って勉強しに行く場所を尋ねて答える場面です。"
        },
        8: {
            "KO": "목이 말라 시원한 음료수를 사러 갈 장소를 말하는 상황입니다.",
            "EN": "Explaining that you are going to buy a cold drink because you are thirsty.",
            "VI": "Nói về nơi đi mua đồ uống mát vì đang khát nước.",
            "ZH": "口渴时说明要去买清凉饮料的地方的情景。",
            "JA": "喉が渇いて冷たい飲み物を買いに行く場所を伝える場面です。"
        },
        9: {
            "KO": "주말에 부산으로 여행을 떠나는 목적을 묻고 답하는 상황입니다.",
            "EN": "Asking and answering about the purpose of traveling to Busan on the weekend.",
            "VI": "Hỏi đáp về mục đích đi du lịch Busan vào cuối tuần.",
            "ZH": "询问并回答周末去釜山旅行的目的的情景。",
            "JA": "週末に釜山へ旅行に行く目的を尋ねて答える場面です。"
        },
        10: {
            "KO": "외국인 유학생에게 한국에 입국한 방문 목적을 묻는 상황입니다.",
            "EN": "Asking an international student about the purpose of visiting Korea.",
            "VI": "Hỏi du học sinh nước ngoài về mục đích đến Hàn Quốc.",
            "ZH": "询问外国留学生来韩国的目的的场景。",
            "JA": "外国人留学生に韓国に来た目的を尋ねる場面です。"
        },

        # 11-28: 사물 및 일상 어휘
        11: {
            "KO": "정원에 활짝 핀 아름다운 빨간 꽃을 보며 감탄하는 일상 대화입니다.",
            "EN": "An everyday conversation admiring beautiful red flowers blooming in the garden.",
            "VI": "Đoạn hội thoại khen ngợi những bông hoa đỏ tuyệt đẹp nở rộ trong vườn.",
            "ZH": "赞叹花园里盛开的鲜红花朵的日常对话场景。",
            "JA": "庭に満開の美しい赤い花を見ながら感嘆する日常会話です。"
        },
        12: {
            "KO": "햇빛이 강한 날 외출하기 전 필요한 필수 소품을 권하는 상황입니다.",
            "EN": "Recommending an essential accessory before going out on a sunny day.",
            "VI": "Gợi ý phụ kiện cần thiết trước khi ra ngoài vào ngày nắng gắt.",
            "ZH": "在阳光强烈的日子出门前推荐必备随身物品的场景。",
            "JA": "日差しが強い日に外出する前、必要なアイテムを勧める場面です。"
        },
        13: {
            "KO": "밖에서 찬 바람이 들어와 실내 온도를 위해 닫아달라고 부탁하는 상황입니다.",
            "EN": "Asking someone to close the window because cold wind is blowing in.",
            "VI": "Nhờ ai đó đóng lại vì có gió lạnh thổi từ bên ngoài vào.",
            "ZH": "外面冷风吹进来，请对方帮忙关好窗户的场景。",
            "JA": "外から冷たい風が入ってくるため、閉めてもらうよう頼む場面です。"
        },
        14: {
            "KO": "아침마다 시사 뉴스를 확인하기 위해 읽는 인쇄 매체를 묻는 상황입니다.",
            "EN": "Asking about the print news medium read every morning to check current events.",
            "VI": "Hỏi về ấn phẩm báo chí được đọc mỗi sáng để cập nhật tin tức.",
            "ZH": "询问每天早晨为了看新闻而阅读的印刷读物的场景。",
            "JA": "毎朝ニュースを確認するために読んでいる印刷物について尋ねる場面です。"
        },
        15: {
            "KO": "외출하기 전 발을 보호하고 걷기 위해 착용하는 물건을 묻는 상황입니다.",
            "EN": "Asking about the footwear worn to protect feet and walk outside.",
            "VI": "Hỏi về vật dụng mang dưới chân để đi ra ngoài.",
            "ZH": "询问出门前穿在脚上以保护双脚行走的物品的场景。",
            "JA": "外出する前、足を保護して歩くために履く物について尋ねる場面です。"
        },
        16: {
            "KO": "작은 글씨가 잘 안 보일 때 시력 보조를 위해 권하는 소품을 묻는 상황입니다.",
            "EN": "Recommending glasses when small print is hard to see.",
            "VI": "Gợi ý đeo kính khi không nhìn rõ chữ nhỏ.",
            "ZH": "字太小看不清时，建议佩戴以帮助视力的随身物品的场景。",
            "JA": "小さな文字が見えにくい時、視力補助のために勧めるアイテムの場面です。"
        },
        17: {
            "KO": "현재 몇 시 몇 분인지 정확한 시각을 확인하기 위해 벽을 보는 상황입니다.",
            "EN": "Looking at the wall to check the accurate time.",
            "VI": "Nhìn lên tường để kiểm tra xem bây giờ là mấy giờ mấy phút.",
            "ZH": "为了确认当前准确时间而看向墙壁的日常场景。",
            "JA": "今何時何分か正確な時刻を確認するために壁を見る場面です。"
        },
        18: {
            "KO": "지인의 결혼식에 참석하기 위해 단정하고 격식 있는 복장을 권하는 상황입니다.",
            "EN": "Recommending neat, formal attire to attend a friend's wedding.",
            "VI": "Gợi ý trang phục lịch sự, trang trọng để đi dự đám cưới bạn bè.",
            "ZH": "为参加朋友婚礼推荐端庄得体服装的场景。",
            "JA": "知人の結婚式に出席するため、きちんとした正装を勧める場面です。"
        },
        19: {
            "KO": "신발을 신기 전 발을 따뜻하고 편안하게 감싸주는 의류 소품을 묻는 상황입니다.",
            "EN": "Asking about the clothing item worn on the feet before putting on shoes.",
            "VI": "Hỏi về phụ kiện mang vào chân trước khi xỏ giày để giữ ấm.",
            "ZH": "询问穿鞋之前穿在脚上保暖舒适的衣物配饰的场景。",
            "JA": "靴を履く前に足を暖かく包む衣料品について尋ねる場面です。"
        },
        20: {
            "KO": "종이에 생각이나 메모를 적기 위해 필기구를 찾는 상황입니다.",
            "EN": "Looking for a writing tool to take notes or write on paper.",
            "VI": "Tìm đồ dùng học tập để viết ghi chú lên giấy.",
            "ZH": "为了在纸上写字或做笔记而寻找书写工具的日常场景。",
            "JA": "紙にメモや文字を書くために筆記用具を探す場面です。"
        },
        21: {
            "KO": "맑은 공기를 마시며 주말에 등산하러 갈 자연 명소를 이야기하는 상황입니다.",
            "EN": "Discussing a natural scenic mountain to go hiking on the weekend.",
            "VI": "Nói về địa điểm thiên nhiên đi leo núi vào cuối tuần để hít thở không khí trong lành.",
            "ZH": "谈论周末去呼吸新鲜空气爬山的自然景点的场景。",
            "JA": "澄んだ空気を吸いながら週末に登山へ行く自然スポットを話す場面です。"
        },
        22: {
            "KO": "베이커리에서 풍기는 고소한 냄새를 맡으며 아침 식사 메뉴를 고르는 상황입니다.",
            "EN": "Choosing a breakfast item while smelling the aroma of fresh bakery goods.",
            "VI": "Chọn bữa sáng khi ngửi thấy mùi thơm phức từ tiệm bánh mì.",
            "ZH": "闻着面包店里诱人的香气挑选早餐菜单的场景。",
            "JA": "ベーカリーの香ばしい匂いを嗅ぎながら朝食メニューを選ぶ場面です。"
        },
        23: {
            "KO": "과일가게에서 탐스럽게 익은 빨간 과일을 구입하는 일상 대화입니다.",
            "EN": "Buying ripe, delicious red fruits at a fruit shop.",
            "VI": "Mua trái cây màu đỏ chín mọng tại cửa hàng hoa quả.",
            "ZH": "在水果店购买熟透诱人的红苹果的日常场景。",
            "JA": "果物屋で赤く実った美味しい果物を買う日常会話です。"
        },
        24: {
            "KO": "즐거웠던 제주도 여행 추억을 나누기 위해 남겨둔 결과물을 보여주는 상황입니다.",
            "EN": "Showing pictures taken to share memories from a wonderful Jeju trip.",
            "VI": "Khoe những bức hình kỷ niệm đã chụp trong chuyến đi Jeju tuyệt vời.",
            "ZH": "展示在济州岛旅行时留下美好回忆的照片的场景。",
            "JA": "楽しかった済州島旅行の思い出を共有するため写真を見せる場面です。"
        },
        25: {
            "KO": "건강을 위해 마실 신선하고 고소한 흰색 음료를 고르는 상황입니다.",
            "EN": "Choosing a fresh, healthy white drink for wellness.",
            "VI": "Chọn một loại thức uống màu trắng bổ dưỡng cho sức khỏe.",
            "ZH": "为了健康而挑选新鲜浓郁的白色饮品的场景。",
            "JA": "健康のために飲む新鮮で白い飲み物を選ぶ場面です。"
        },
        26: {
            "KO": "다리가 아파 잠시 쉬어가기 위해 앉을 자리를 찾는 상황입니다.",
            "EN": "Looking for a chair or seat to sit down and rest tired legs.",
            "VI": "Tìm ghế trống để ngồi nghỉ vì chân đang mỏi.",
            "ZH": "腿酸想找空椅子坐下来休息一会儿的场景。",
            "JA": "足が痛くて少し休むために座る場所を探す場面です。"
        },
        27: {
            "KO": "갑작스럽게 쏟아지는 비를 맞지 않기 위해 비를 막아주는 물건을 찾는 상황입니다.",
            "EN": "Looking for an umbrella to avoid getting wet in sudden rain.",
            "VI": "Tìm chiếc ô để che khi trời bất chợt đổ mưa.",
            "ZH": "为了不被突如其来的阵雨淋湿而寻找雨伞的场景。",
            "JA": "急に降ってきた雨を避けるために傘を探す場面です。"
        },
        28: {
            "KO": "현금과 신용카드를 안전하게 보관하고 다니는 휴대용 소품을 묻는 상황입니다.",
            "EN": "Asking about a wallet used to carry cash and credit cards safely.",
            "VI": "Hỏi về chiếc ví cầm tay dùng để cất giữ tiền và thẻ ngân hàng an toàn.",
            "ZH": "询问安全随身存放现金与银行卡的皮夹钱包的场景。",
            "JA": "現金やクレジットカードを安全に保管して持ち歩く財布について尋ねる場面です。"
        },

        # 29-45: 국적 및 직업 어휘
        29: {
            "KO": "도쿄가 고향인 상대방에게 일본 국적임을 확인하는 상황입니다.",
            "EN": "Confirming Japanese nationality for someone from Tokyo.",
            "VI": "Xác nhận quốc tịch Nhật Bản cho người có quê quán ở Tokyo.",
            "ZH": "向家乡在东京的对方确认其为日本国籍的场景。",
            "JA": "東京出身の相手に日本国籍であることを確認する場面です。"
        },
        30: {
            "KO": "베를린에서 태어난 친구에게 독일 국적임을 확인하는 대화 상황입니다.",
            "EN": "Confirming German nationality for a friend born in Berlin.",
            "VI": "Xác nhận quốc tịch Đức cho người bạn sinh ra ở Berlin.",
            "ZH": "向出生在柏林的朋友确认其为德国国籍的日常对话。",
            "JA": "ベルリン生まれの友達にドイツ人であることを確認する会話の場面です。"
        },
        31: {
            "KO": "베이징에서 온 친구에게 중국 출신임을 묻고 확인하는 상황입니다.",
            "EN": "Asking and confirming Chinese nationality for a friend from Beijing.",
            "VI": "Hỏi và xác nhận người bạn đến từ Bắc Kinh là người Trung Quốc.",
            "ZH": "向来自北京的朋友确认其为中国人的情景。",
            "JA": "北京から来た友達に中国出身であることを確認する場面です。"
        },
        32: {
            "KO": "시드니 오페라 하우스가 상징인 호주 출신임을 이야기하는 상황입니다.",
            "EN": "Mentioning that someone is from Australia, famous for the Sydney Opera House.",
            "VI": "Nói về việc đến từ Úc, đất nước nổi tiếng với Nhà hát Opera Sydney.",
            "ZH": "提及自己来自以悉尼歌剧院闻名的澳大利亚的场景。",
            "JA": "シドニーオペラハウスが有名なオーストラリア出身であることを伝える場面です。"
        },
        33: {
            "KO": "에펠탑과 파리로 유명한 프랑스에서 왔음을 소개하는 상황입니다.",
            "EN": "Introducing that someone came from France, famous for the Eiffel Tower and Paris.",
            "VI": "Giới thiệu mình đến từ nước Pháp, nơi nổi tiếng với tháp Eiffel và thủ đô Paris.",
            "ZH": "介绍自己来自以埃菲尔铁塔和巴黎闻名的法国的场景。",
            "JA": "エッフェル塔とパリで有名なフランスから来たことを紹介する場面です。"
        },
        34: {
            "KO": "학교에서 학생들에게 한국어를 가르치는 교육 직업을 소개하는 상황입니다.",
            "EN": "Introducing the teaching profession of teaching Korean to students at school.",
            "VI": "Giới thiệu nghề giáo viên dạy tiếng Hàn cho học sinh tại trường học.",
            "ZH": "介绍在学校给学生教授韩语的老师职业的情景。",
            "JA": "学校で生徒たちに韓国語を教える先生という職業を紹介する場面です。"
        },
        35: {
            "KO": "매일 회사로 출근해 사무 업무를 보는 직장인을 소개하는 상황입니다.",
            "EN": "Introducing an office worker who commutes to the company every day.",
            "VI": "Giới thiệu nhân viên công ty đi làm và xử lý công việc văn phòng mỗi ngày.",
            "ZH": "介绍每天到公司上班做办公室工作的上班族职业的情景。",
            "JA": "毎日会社に出勤してデスクワークをする会社員の職業を紹介する場面です。"
        },
        36: {
            "KO": "병원에서 아픈 환자를 진료하고 치료하는 전문 의료인을 소개하는 상황입니다.",
            "EN": "Introducing a medical doctor who diagnoses and treats patients in a hospital.",
            "VI": "Giới thiệu bác sĩ khám và điều trị cho bệnh nhân tại bệnh viện.",
            "ZH": "介绍在医院给生病的患者诊断治疗的医生职业的情景。",
            "JA": "病院で患者を診察し治療する医師の職業を紹介する場面です。"
        },
        37: {
            "KO": "쌀국수와 하노이로 유명한 베트남 출신임을 밝히는 상황입니다.",
            "EN": "Explaining that someone is from Vietnam, famous for Pho and Hanoi.",
            "VI": "Nói về việc mình là người Việt Nam, nơi nổi tiếng với món phở và thủ đô Hà Nội.",
            "ZH": "说明自己来自以河粉和首都河内闻名的越南的场景。",
            "JA": "フォーとハノイで有名なベトナム出身であることを伝える場面です。"
        },
        38: {
            "KO": "서울에서 나고 자란 대한민국 국적임을 당당하게 밝히는 상황입니다.",
            "EN": "Explaining that someone was born and raised in Seoul and is a Korean national.",
            "VI": "Nói rằng mình sinh ra và lớn lên ở Seoul, là công dân Hàn Quốc.",
            "ZH": "说明自己在首尔土生土长是韩国人的日常场景。",
            "JA": "ソウル生まれ育ちの韓国人であることを伝える場面です。"
        },
        39: {
            "KO": "자유의 여신상과 뉴욕이 있는 미국 출신임을 소개하는 상황입니다.",
            "EN": "Introducing that someone is from the United States, home to New York and the Statue of Liberty.",
            "VI": "Giới thiệu mình đến từ Mỹ, nơi có tượng Nữ Thần Tự Do và thành phố New York.",
            "ZH": "介绍自己来自拥有自由女神像与纽约的美国的场景。",
            "JA": "自由の女神とニューヨークがあるアメリカ出身であることを紹介する場面です。"
        },
        40: {
            "KO": "대학교에서 학업에 열중하고 있는 신분을 소개하는 대화 상황입니다.",
            "EN": "Introducing someone's status as a student studying hard at university.",
            "VI": "Giới thiệu thân phận là sinh viên đang chăm chỉ học tập tại trường đại học.",
            "ZH": "介绍自己在大学里努力学习的大学生成分的情景。",
            "JA": "大学で熱心に勉強している学生であることを紹介する会話場面です。"
        },
        41: {
            "KO": "병원에서 환자들을 따뜻하게 돌봐주는 간호 직무를 소개하는 상황입니다.",
            "EN": "Introducing a nurse who warmly cares for patients in a hospital.",
            "VI": "Giới thiệu nghề y tá luôn ân cần chăm sóc các bệnh nhân tại bệnh viện.",
            "ZH": "介绍在医院里悉心照料病患的护士职业的情景。",
            "JA": "病院で患者さんを温かくケアする看護師の職業を紹介する場面です。"
        },
        42: {
            "KO": "식당 주방에서 정성껏 맛있는 음식을 만드는 조리 직업을 묻는 상황입니다.",
            "EN": "Asking about a chef who cooks delicious dishes in a restaurant kitchen.",
            "VI": "Hỏi về nghề đầu bếp nấu những món ăn ngon trong gian bếp nhà hàng.",
            "ZH": "询问在餐厅厨房里用心烹饪美味佳肴的厨师职业的场景。",
            "JA": "厨房で美味しい料理を作る料理人の職業について尋ねる場面です。"
        },
        43: {
            "KO": "시민들의 치안과 안전을 지켜주는 든든한 경찰관을 묻고 답하는 상황입니다.",
            "EN": "Asking and answering about a police officer who protects public safety.",
            "VI": "Hỏi đáp về người cảnh sát bảo vệ an ninh trật tự cho người dân.",
            "ZH": "询问并回答守护市民安全、维持治安的警察职业的场景。",
            "JA": "市民の安全を守り犯罪を防ぐ警察官について尋ねて答える場面です。"
        },
        44: {
            "KO": "무대 위에서 마이크를 잡고 노래를 들려주는 직업을 묻는 상황입니다.",
            "EN": "Asking about a singer who holds a microphone and sings on stage.",
            "VI": "Hỏi về nghề ca sĩ cầm mic biểu diễn ca hát trên sân khấu.",
            "ZH": "询问在舞台上手握麦克风唱歌的歌手职业的日常情景。",
            "JA": "ステージの上でマイクを握り歌を歌う歌手の職業について尋ねる場面です。"
        },
        45: {
            "KO": "해외로 출국할 때 공항 심사대에서 신분을 증명하는 공식 신분증을 묻는 상황입니다.",
            "EN": "Asking about the official passport used for identity verification at the airport.",
            "VI": "Hỏi về cuốn hộ chiếu dùng để làm thủ tục xuất cảnh tại sân bay.",
            "ZH": "询问出国旅行时在机场出入境大厅出示的官方护照证件的场景。",
            "JA": "海外へ出国する際、空港で提示する身分証明書のパスポートを尋ねる場面です。"
        },

        # 46-50: 대표 음식 및 공공장소 어휘
        46: {
            "KO": "다양한 신선한 나물과 고추장을 밥에 쓱쓱 비벼 먹는 한국 대표 음식을 묻는 상황입니다.",
            "EN": "Asking about bibimbap, a signature Korean dish mixed with vegetables and gochujang.",
            "VI": "Hỏi về món cơm trộn bibimbap nổi tiếng của Hàn Quốc kết hợp rau củ và tương ớt.",
            "ZH": "询问将各种蔬菜和辣酱拌饭食用的韩国代表性美食拌饭的情景。",
            "JA": "様々なナムルとコチュジャンをご飯に混ぜて食べる韓国の代表料理ビビンバを尋ねる場面です。"
        },
        47: {
            "KO": "달콤하고 짭조름한 간장 양념에 얇게 썬 소고기를 볶아낸 고기 요리를 묻는 상황입니다.",
            "EN": "Asking about bulgogi, thinly sliced beef marinated in savory-sweet sauce.",
            "VI": "Hỏi về món thịt bò xào bulgogi ướp gia vị đậm đà thơm ngon của Hàn Quốc.",
            "ZH": "询问用咸甜酱汁腌制薄切牛肉翻炒而成的烤牛肉料理的场景。",
            "JA": "甘辛いタレに漬け込んだ薄切り牛肉を炒めた料理プルコギを尋ねる場面です。"
        },
        48: {
            "KO": "잘 익은 김치와 돼지고기를 냄비에 보글보글 끓여낸 얼큰한 찌개 요리를 묻는 상황입니다.",
            "EN": "Asking about kimchi stew, a hearty Korean stew boiled with ripe kimchi and pork.",
            "VI": "Hỏi về món canh kim chi thịt heo hầm cay nóng hổi thơm ngon.",
            "ZH": "询问用熟泡菜和猪肉炖煮的热气腾腾的泡菜汤料理的场景。",
            "JA": "熟成キムチと豚肉を煮込んだピリ辛チゲ料理キムチチゲを尋ねる場面です。"
        },
        49: {
            "KO": "해외여행을 떠나기 위해 비행기를 탑승하는 대형 교통 관문을 묻는 상황입니다.",
            "EN": "Asking about the airport where airplanes take off and land for international travel.",
            "VI": "Hỏi về sân bay, nơi làm thủ tục lên máy bay để đi du lịch quốc tế.",
            "ZH": "询问乘坐飞机前往海外旅行的大型交通枢纽机场的场景。",
            "JA": "海外旅行へ向かうため飛行機に搭乗する空港について尋ねる場面です。"
        },
        50: {
            "KO": "예금 저축이나 외화 환전 등 금융 업무를 처리하는 기관을 묻는 상황입니다.",
            "EN": "Asking about a bank where people deposit money and exchange foreign currency.",
            "VI": "Hỏi về ngân hàng, nơi thực hiện các giao dịch gửi tiền và đổi ngoại tệ.",
            "ZH": "询问办理储蓄存钱与外币兑换等金融业务的银行的场景。",
            "JA": "貯金や外貨両替などの金融業務を行う銀行について尋ねる場面です。"
        },

        # 51-56: 생활 간편식 및 음료
        51: {
            "KO": "뜨거운 국물에 꼬들꼬들한 면을 끓여 먹는 한국인의 대표 간편식을 묻는 상황입니다.",
            "EN": "Asking about instant ramen noodles, Korea's most popular comfort food.",
            "VI": "Hỏi về món mì gói ramen quen thuộc thơm ngon với nước dùng nóng hổi.",
            "ZH": "询问韩国人最喜爱的带汤即食拉面美食的场景。",
            "JA": "熱いスープにコシのある麺を茹でて食べる代表的な即席麺ラーメンを尋ねる場面です。"
        },
        52: {
            "KO": "밥에 여러 가지 속재료를 넣고 김으로 돌돌 말아 썬 한국 소풍 음식을 묻는 상황입니다.",
            "EN": "Asking about gimbap, seaweed rice rolls packed with delicious ingredients.",
            "VI": "Hỏi về món cơm cuộn rong biển gimbap truyền thống của Hàn Quốc.",
            "ZH": "询问用米饭和各种配料裹在紫菜里卷制切段的紫菜包饭的场景。",
            "JA": "ご飯と具材を海苔で巻いて食べる韓国の海苔巻きキンパを尋ねる場面です。"
        },
        53: {
            "KO": "매콤달콤한 고추장 양념에 쫄깃한 떡을 볶아 만든 길거리 대표 간식을 묻는 상황입니다.",
            "EN": "Asking about tteokbokki, chewy rice cakes cooked in sweet and spicy sauce.",
            "VI": "Hỏi về món bánh gạo cay tteokbokki đường phố nổi tiếng của Hàn Quốc.",
            "ZH": "询问用甜辣酱炒制软糯年糕的代表性街头小吃辣炒年糕的场景。",
            "JA": "甘辛いタレでもちもちの餅を炒めた代表的なおやつトッポッキを尋ねる場面です。"
        },
        54: {
            "KO": "갈증이 날 때 목을 시원하게 축여주는 생명수를 묻는 일상 대화 상황입니다.",
            "EN": "Asking for pure, clean water to quench your thirst on a hot day.",
            "VI": "Hỏi xin ly nước lọc mát lạnh để làm dịu cơn khát.",
            "ZH": "口渴时喝一口清凉解渴的纯净水的日常场景。",
            "JA": "喉の渇きを潤す冷たい水について尋ねる日常会話の場面です。"
        },
        55: {
            "KO": "식후에 향긋한 원두를 내려 마시는 대중적인 기호 음료를 묻는 상황입니다.",
            "EN": "Asking about coffee, a beloved brewed beverage enjoyed after meals.",
            "VI": "Hỏi về món cà phê thơm ngon được nhiều người yêu thích sau bữa ăn.",
            "ZH": "询问餐后品尝的香醇提神饮品咖啡的场景。",
            "JA": "食後に豆から淹れて飲む人気の嗜好飲料コーヒーについて尋ねる場面です。"
        },
        56: {
            "KO": "찻잎을 우려내어 은은한 향과 따뜻한 온기를 즐기는 전통 음료를 묻는 상황입니다.",
            "EN": "Asking about brewed tea, a warm, aromatic traditional beverage.",
            "VI": "Hỏi về món trà ấm nóng thanh tao làm từ lá trà tự nhiên.",
            "ZH": "询问用茶叶冲泡的温热香醇传统茶饮的日常场景。",
            "JA": "茶葉を煎じて豊かな香りと温もりを楽しむお茶について尋ねる場面です。"
        },

        # 57-64: 신체 부위 어휘
        57: {
            "KO": "세상을 바라보고 아름다운 풍경을 담는 시각 감각 기관을 묻는 상황입니다.",
            "EN": "Asking about the eyes, the sensory organ used to see the world.",
            "VI": "Hỏi về đôi mắt, cơ quan thị giác dùng để ngắm nhìn thế giới xung quanh.",
            "ZH": "询问用来观察世界和美景的视觉感官眼睛的场景。",
            "JA": "世界を見て美しい景色を捉える視覚器官の目について尋ねる場面です。"
        },
        58: {
            "KO": "향기로운 냄새를 맡고 호흡을 돕는 얼굴 중앙의 감각 기관을 묻는 상황입니다.",
            "EN": "Asking about the nose, the organ in the center of the face for smelling and breathing.",
            "VI": "Hỏi về chiếc mũi nằm ở giữa khuôn mặt dùng để ngửi mùi và hít thở.",
            "ZH": "询问位于面部中央用于闻气味和呼吸的鼻子感官的场景。",
            "JA": "匂いを嗅いで呼吸をする顔の中心にある鼻について尋ねる場面です。"
        },
        59: {
            "KO": "맛있는 음식을 맛보고 소리를 내어 말을 하는 신체 부위를 묻는 상황입니다.",
            "EN": "Asking about the mouth, used for tasting food and speaking.",
            "VI": "Hỏi về chiếc miệng dùng để thưởng thức món ăn và trò chuyện.",
            "ZH": "询问用于品尝美食和发声说话的口腔部位的场景。",
            "JA": "料理を味わい言葉を発する体の部位である口について尋ねる場面です。"
        },
        60: {
            "KO": "감미로운 음악과 상대방의 목소리를 듣는 청각 감각 기관을 묻는 상황입니다.",
            "EN": "Asking about the ears, the organ for listening to voices and music.",
            "VI": "Hỏi về đôi tai, cơ quan thính giác dùng để lắng nghe âm thanh và âm nhạc.",
            "ZH": "询问用来倾听美妙音乐和对方说话声音的耳朵部位的场景。",
            "JA": "音楽や人の声を聞く聴覚器官の耳について尋ねる場面です。"
        },
        61: {
            "KO": "물건을 집거나 글씨를 쓸 때 섬세하게 사용하는 신체 부위를 묻는 상황입니다.",
            "EN": "Asking about the hands, used delicately to hold objects and write.",
            "VI": "Hỏi về bàn tay khéo léo dùng để cầm nắm đồ vật và viết chữ.",
            "ZH": "询问在拿取物品和写字时灵活使用的双手部位的场景。",
            "JA": "物を持ったり文字を書くときに器用に使う手について尋ねる場面です。"
        },
        62: {
            "KO": "대지를 딛고 서서 몸의 균형을 잡아주는 다리의 맨 아래 부위를 묻는 상황입니다.",
            "EN": "Asking about the feet, located at the bottom of legs to balance the body.",
            "VI": "Hỏi về bàn chân giúp nâng đỡ cơ thể và giữ thăng bằng khi đứng.",
            "ZH": "询问支撑身体站立保持平衡的下肢脚部部位的场景。",
            "JA": "地面を踏みしめて立ち体のバランスを取る足について尋ねる場面です。"
        },
        63: {
            "KO": "두 발로 힘차게 걷고 달리며 계단을 오를 수 있게 하는 하체 부위를 묻는 상황입니다.",
            "EN": "Asking about the legs, used for walking, running, and climbing stairs.",
            "VI": "Hỏi về đôi chân giúp con người có thể đi lại, chạy nhảy và leo cầu thang.",
            "ZH": "询问用于行走奔跑和攀登台阶的下肢腿部部位的场景。",
            "JA": "歩いたり走ったり階段を上るときに使う脚について尋ねる場面です。"
        },
        64: {
            "KO": "생각을 하고 기억을 담당하는 뇌가 위치한 신체 최상단 부위를 묻는 상황입니다.",
            "EN": "Asking about the head, located at the top of the body containing the brain.",
            "VI": "Hỏi về phần đầu, nơi chứa bộ não giúp con người suy nghĩ và ghi nhớ.",
            "ZH": "询问位于人体最上端负责思考和记忆的头部部位的场景。",
            "JA": "思考や記憶を司る脳がある体の一番上の頭について尋ねる場面입니다。"
        },

        # 65-70: 교통수단 어휘
        65: {
            "KO": "정류장에서 승객을 태우고 시내 곳곳을 운행하는 대중교통을 묻는 상황입니다.",
            "EN": "Asking about a public city bus that picks up passengers at stops.",
            "VI": "Hỏi về xe buýt công cộng đón trả khách tại các trạm dừng trong thành phố.",
            "ZH": "询问在公交站停靠接送乘客穿梭于市内的公共汽车的场景。",
            "JA": "バス停で乗客を乗せて市内を運行する市バスについて尋ねる場面です。"
        },
        66: {
            "KO": "교통 체증 없이 지하 선로를 따라 정시에 빠르게 달리는 도시 철도를 묻는 상황입니다.",
            "EN": "Asking about the subway metro that runs quickly underground without traffic.",
            "VI": "Hỏi về tàu điện ngầm chạy nhanh dưới lòng đất tránh ùn tắc giao thông.",
            "ZH": "询问避开地面堵车在地下铁轨上准点运行的地铁交通的场景。",
            "JA": "渋滞なく地下の線路を正確に素早く走る地下鉄について尋ねる場面です。"
        },
        67: {
            "KO": "원하는 목적지까지 신속하고 편안하게 요금을 내고 이동하는 승용차 교통을 묻는 상황입니다.",
            "EN": "Asking about a taxi that takes passengers directly to their destination for a fare.",
            "VI": "Hỏi về xe taxi chở khách đến tận nơi một cách tiện lợi và nhanh chóng.",
            "ZH": "询问按计价器收费将乘客快捷送达目的地的出租车的场景。",
            "JA": "目的地まで迅速かつ快適に料金を払って乗るタクシーについて尋ねる場面です。"
        },
        68: {
            "KO": "도시와 도시 사이의 철로를 시속 수백 킬로미터로 달리는 기차를 묻는 상황입니다.",
            "EN": "Asking about a passenger train connecting cities along long railway tracks.",
            "VI": "Hỏi về đoàn tàu hỏa chạy trên đường ray kết nối giữa các thành phố.",
            "ZH": "询问在城市之间铁轨上长途奔驰的高速列车火车的场景。",
            "JA": "都市と都市の間の鉄路を走る長距離列車・汽車について尋ねる場面입니다。"
        },
        69: {
            "KO": "하늘 높이 날아올라 대륙과 바다를 건너는 항공 교통수단을 묻는 상황입니다.",
            "EN": "Asking about an airplane that flies high across skies and oceans.",
            "VI": "Hỏi về chiếc máy bay bay lượn trên bầu trời qua các lục địa và đại dương.",
            "ZH": "询问飞翔在蓝天之中横跨海洋大陆的民航飞机的场景。",
            "JA": "大空高く飛び立ち海や大陸を渡る飛行機について尋ねる場面입니다。"
        },
        70: {
            "KO": "바다나 강 위를 떠다니며 섬과 육지를 연결해 주는 수상 교통수단을 묻는 상황입니다.",
            "EN": "Asking about a boat or ship that sails across waters connecting islands.",
            "VI": "Hỏi về con tàu thuyền di chuyển trên sông nước để kết nối đảo và đất liền.",
            "ZH": "询问在水面航行连接海岛与陆地的轮船船只的场景。",
            "JA": "海や川を航行して島と陸をつなぐ船・ボートについて尋ねる場面입니다。"
        },

        # 71-76: 날씨 및 계절
        71: {
            "KO": "구름 한 점 없이 하늘이 푸르고 햇빛이 밝게 비치는 기상 상태를 묻는 상황입니다.",
            "EN": "Asking about clear, sunny weather with bright sunshine and blue skies.",
            "VI": "Hỏi về thời tiết trong xanh có nắng ấm áp không một gợn mây.",
            "ZH": "询问晴空万里、阳光明媚的晴朗天气状态的日常场景。",
            "JA": "雲ひとつなく青空が広がり太陽が照らす晴れの天気について尋ねる場面です。"
        },
        72: {
            "KO": "먹구름이 끼고 하늘에서 빗방울이 촉촉하게 떨어지는 날씨를 묻는 상황입니다.",
            "EN": "Asking about rainy weather as raindrops fall from dark clouds.",
            "VI": "Hỏi về thời tiết mưa khi những hạt mưa rơi xuống từ bầu trời âm u.",
            "ZH": "询问天空乌云密布下起雨滴的下雨天气的日常场景。",
            "JA": "雨雲が広がり空から雨粒が降る雨の天気について尋ねる場面です。"
        },
        73: {
            "KO": "겨울철에 기온이 영하로 내려가 하늘에서 하얗게 내리는 결정체를 묻는 상황입니다.",
            "EN": "Asking about snow falling from the sky when temperatures drop below freezing.",
            "VI": "Hỏi về tuyết trắng rơi xuống vào mùa đông khi nhiệt độ xuống thấp.",
            "ZH": "询问冬季气温降至零度以下时空中飘落的雪花天气的场景。",
            "JA": "冬の冷え込みで空から白く舞い落ちる雪について尋ねる場面です。"
        },
        74: {
            "KO": "나뭇가지가 흔들리고 시원한 공기의 흐름이 피부에 느껴지는 현상을 묻는 상황입니다.",
            "EN": "Asking about the wind as leaves rustle and air moves past.",
            "VI": "Hỏi về hiện tượng gió thổi làm đung đưa cành cây và mát rượi.",
            "ZH": "询问树枝摇曳、能感受到空气流动的刮风气象现象的场景。",
            "JA": "木の枝が揺れて肌に涼しい空気の流れを感じる風について尋ねる場面です。"
        },
        75: {
            "KO": "추운 겨울이 지나고 따스한 햇살과 함께 꽃이 피어나는 화사한 계절을 묻는 상황입니다.",
            "EN": "Asking about spring, the blooming season that follows cold winter.",
            "VI": "Hỏi về mùa xuân ấm áp với muôn hoa đua nở sau mùa đông giá rét.",
            "ZH": "询问严冬过后春暖花开、生机勃勃的春天季节的场景。",
            "JA": "寒い冬が去り暖かな日差しと共に花が咲く春の季節について尋ねる場面です。"
        },
        76: {
            "KO": "기온이 높고 뜨거운 태양 아래 바다로 휴가를 떠나는 무더운 계절을 묻는 상황입니다.",
            "EN": "Asking about summer, the hot season for vacationing at the sea.",
            "VI": "Hỏi về mùa hè rực rỡ với cái nắng chói chang và những chuyến đi biển.",
            "ZH": "询问烈日当头、适合去海边度假旅行的炎热夏天季节的场景。",
            "JA": "気温が高く照りつける太陽の下で海へ遊びに行く夏の季節について尋ねる場面です。"
        },

        # 133: 교실 환경
        133: {
            "KO": "교실 안의 비품과 학습 시설에 대해 친구와 대화를 나누는 상황입니다.",
            "EN": "A conversation with a classmate about classroom desks and furniture.",
            "VI": "Cuộc trò chuyện với bạn học về bàn ghế và đồ dùng trong lớp học.",
            "ZH": "和同学交谈教室里的课桌与教学设施的日常情景。",
            "JA": "教室の中の机や学習設備について友達と会話する場面です。"
        },

        # 169-184: 일정 표현 대화형 문맥
        169: {
            "KO": "특정 날짜에 친구와 만날 약속 일정을 자연스럽게 말하는 상황입니다.",
            "EN": "Stating a scheduled plan to meet a friend on a specific date.",
            "VI": "Nói về kế hoạch gặp gỡ bạn bè vào một ngày cụ thể.",
            "ZH": "自然表达在特定日期与朋友有约会日程的场景。",
            "JA": "特定の日付に友達と会う予定を自然に伝える場面です。"
        },
        170: {
            "KO": "대학교 졸업식 날짜를 묻고 답변하는 대화 상황입니다.",
            "EN": "Asking and answering the graduation date from university.",
            "VI": "Hỏi đáp về ngày lễ tốt nghiệp đại học.",
            "ZH": "询问并回答大学毕业典礼日期的日常对话场景。",
            "JA": "大学の卒業式の日程を尋ねて答える会話の場面です。"
        },
        171: {
            "KO": "학교 방학이 시작되는 월을 묻고 답변하는 상황입니다.",
            "EN": "Asking and answering which month the school vacation begins.",
            "VI": "Hỏi đáp về tháng mà kỳ nghỉ của trường bắt đầu.",
            "ZH": "询问并回答学校放假的月份的日常情景。",
            "JA": "学校の休暇が始まる月について尋ねて答える場面です。"
        },
        172: {
            "KO": "주말 토요일에 영화를 관람할 여가 계획을 말하는 상황입니다.",
            "EN": "Sharing plans to watch a movie on Saturday weekend.",
            "VI": "Chia sẻ kế hoạch xem phim vào thứ Bảy cuối tuần.",
            "ZH": "说明周六去电影院看电影的周末休闲计划的场景。",
            "JA": "週末の土曜日に映画を見るレジャーの予定を話す場面です。"
        },
        173: {
            "KO": "주말에 백화점이나 상점에서 쇼핑할 계획을 이야기하는 상황입니다.",
            "EN": "Talking about shopping plans at a store over the weekend.",
            "VI": "Nói về kế hoạch đi mua sắm vào dịp cuối tuần.",
            "ZH": "谈论周末去商场或超市逛街购物的日程安排。",
            "JA": "週末にショッピングをする予定について話す場面です。"
        },
        174: {
            "KO": "생일 파티를 준비하며 달콤한 케이크를 살 일정을 말하는 상황입니다.",
            "EN": "Talking about the schedule to buy a birthday cake for a party.",
            "VI": "Nói về việc sẽ mua bánh kem để chuẩn bị cho bữa tiệc sinh nhật.",
            "ZH": "准备生日派对并说明去买生日蛋糕的日程情景。",
            "JA": "誕生日パーティーのためにケーキを買う予定を伝える場面です。"
        },
        175: {
            "KO": "수업이 끝난 후 오늘 한국어를 복습하고 공부할 일정을 밝히는 상황입니다.",
            "EN": "Sharing plans to study and review Korean after class today.",
            "VI": "Nói về kế hoạch học và ôn tập tiếng Hàn sau giờ học hôm nay.",
            "ZH": "说明今天放学后要复习自习韩语的日程安排。",
            "JA": "授業が終わった後、今日韓国語を勉強する予定を話す場面です。"
        },
        176: {
            "KO": "내일 휴일이지만 직장에 출근해 일해야 한다고 답하는 상황입니다.",
            "EN": "Explaining that you have to work tomorrow despite it being a holiday.",
            "VI": "Nói rằng ngày mai vẫn phải đi làm dù là ngày nghỉ.",
            "ZH": "说明明天虽是假期但仍需去上班工作的场景。",
            "JA": "明日休みだが仕事に行かなければならないと伝える場面です。"
        },
        177: {
            "KO": "어제 친구와 만나 즐거운 시간을 보낸 과거 행동을 설명하는 상황입니다.",
            "EN": "Describing past activities of meeting a friend yesterday.",
            "VI": "Kể lại việc đã gặp gỡ bạn bè vào ngày hôm qua trong quá khứ.",
            "ZH": "描述昨天和朋友见面度过美好时光的过去行为。",
            "JA": "昨日友達に会って楽しい時間を過ごした過去の出来事を話す場面です。"
        },
        178: {
            "KO": "방에서 좋아하는 음악을 감상하고 있는 현재 행동을 전하는 상황입니다.",
            "EN": "Sharing that you are currently listening to favorite music in your room.",
            "VI": "Nói rằng mình đang nghe bản nhạc yêu thích trong phòng.",
            "ZH": "说明当前正在房间里听喜欢的音乐的日常情景。",
            "JA": "部屋でお気に入りの音楽を聴いている現在の行動を伝える場面です。"
        },
        179: {
            "KO": "일요일에 친구와 함께 공원으로 산책 갈 일정을 약속하는 상황입니다.",
            "EN": "Agreeing on plans to go to the park together on Sunday.",
            "VI": "Hẹn cùng nhau đi dạo ở công viên vào Chủ Nhật.",
            "ZH": "约定周日一起去公园散步游玩的日程情景。",
            "JA": "日曜日に友達と一緒に公園へ行く約束をする場面です。"
        },
        180: {
            "KO": "바쁜 아침 시간에 식사로 간편하게 빵을 먹는 습관을 이야기하는 상황입니다.",
            "EN": "Talking about having bread for breakfast in the morning.",
            "VI": "Nói về thói quen ăn bánh mì cho bữa sáng nhanh gọn.",
            "ZH": "谈论早晨吃面包作为简便早餐的日常习惯。",
            "JA": "忙しい朝に手軽にパンを食べる習慣について話す場面です。"
        },
        181: {
            "KO": "일과를 마치고 저녁 시간에 건강을 위해 운동하는 계획을 밝히는 상황입니다.",
            "EN": "Stating plans to exercise in the evening after finishing work.",
            "VI": "Chia sẻ kế hoạch tập thể dục vào buổi tối sau khi xong việc.",
            "ZH": "说明下班后在傍晚锻炼身体的日常日程安排。",
            "JA": "仕事帰りの夕方に運動をする予定を伝える場面です。"
        },
        182: {
            "KO": "나른한 오후 2시에 동료와 카페에서 커피를 마시기로 약속하는 상황입니다.",
            "EN": "Scheduling a coffee break with a colleague at 2 PM.",
            "VI": "Hẹn uống cà phê cùng đồng nghiệp vào lúc 2 giờ chiều.",
            "ZH": "约定下午2点和同事一起喝咖啡休息的日常场景。",
            "JA": "午後2時に同僚とカフェでコーヒーを飲む約束をする場面です。"
        },
        183: {
            "KO": "한국어 실력을 키우기 위해 매일 꾸준히 연습하고 있다고 답하는 상황입니다.",
            "EN": "Explaining that you practice Korean every day to improve your skills.",
            "VI": "Nói rằng mình kiên trì luyện tập tiếng Hàn mỗi ngày để tiến bộ.",
            "ZH": "说明为了提高韩语水平而每天坚持练习的情景。",
            "JA": "韓国語の上達のために毎日練習していると答える場面です。"
        },
        184: {
            "KO": "다음 주 휴가 기간에 제주도로 여행을 떠날 설레는 계획을 전하는 상황입니다.",
            "EN": "Sharing exciting vacation plans to travel to Jeju Island next week.",
            "VI": "Chia sẻ kế hoạch hào hứng đi du lịch đảo Jeju vào tuần tới.",
            "ZH": "说明下周假期将前往济州岛旅行的心动计划。",
            "JA": "来週の休暇に済州島へ旅行に行く予定を話す場面です。"
        },

        # 213-216: 사물/교통 기초 확인
        213: {
            "KO": "새콤달콤하고 맛있는 붉은 딸기 과일의 이름을 묻고 답하는 상황입니다.",
            "EN": "Asking and answering the name of sweet red strawberries.",
            "VI": "Hỏi đáp về tên loại quả dâu tây đỏ tươi ngọt ngào.",
            "ZH": "询问并回答酸甜可口的草莓水果名称的场景。",
            "JA": "甘酸っぱくて美味しい赤いイチゴの名前を答える場面です。"
        },
        214: {
            "KO": "하늘을 날아 외국으로 여행 갈 때 타는 비행기 교통수단을 확인하는 상황입니다.",
            "EN": "Identifying an airplane used for traveling overseas through the sky.",
            "VI": "Nhận biết máy bay, phương tiện di chuyển trên không khi đi nước ngoài.",
            "ZH": "识别飞越天空前往外国旅行乘坐的飞机交通工具的场景。",
            "JA": "空を飛んで海外旅行へ行くときに乗る飛行機を確認する場面です。"
        },
        215: {
            "KO": "피곤할 때 편안하게 누워 잠을 자는 침실 가구의 이름을 확인하는 상황입니다.",
            "EN": "Identifying a bedroom bed where people sleep and rest comfortably.",
            "VI": "Nhận biết chiếc giường ngủ trong phòng để nằm nghỉ ngơi êm ái.",
            "ZH": "确认在疲惫时躺下安然入眠的卧室床铺家具名称的场景。",
            "JA": "疲れたときに横になって眠る寝室のベッドを確認する場面です。"
        },
        216: {
            "KO": "비가 올 때 옷이 젖지 않도록 머리 위로 펼쳐 쓰는 비가림 소품을 확인하는 상황입니다.",
            "EN": "Identifying an umbrella used overhead to stay dry in rainy weather.",
            "VI": "Nhận biết chiếc ô che mưa để không bị ướt khi trời mưa.",
            "ZH": "确认下雨天撑在头顶遮风挡雨的雨伞物品名称的场景。",
            "JA": "雨が降る時に濡れないよう差す傘の名前を確認する場面です。"
        },

        # 237-250: 필수 일상 어휘 확인
        237: {
            "KO": "나무에서 자란 아삭아삭하고 달콤한 사과 과일의 이름을 확인하는 상황입니다.",
            "EN": "Identifying a crisp, delicious red apple grown on trees.",
            "VI": "Nhận biết quả táo đỏ giòn ngọt thơm ngon.",
            "ZH": "确认树上结出的脆甜多汁的红苹果水果名称的场景。",
            "JA": "木に実るシャキシャキと甘いリンゴの名前を確認する場面です。"
        },
        238: {
            "KO": "아침마다 영양 보충을 위해 마시는 신선한 흰 우유의 이름을 확인하는 상황입니다.",
            "EN": "Identifying fresh white milk enjoyed for morning nutrition.",
            "VI": "Nhận biết ly sữa tươi trắng bổ dưỡng uống vào mỗi buổi sáng.",
            "ZH": "确认每天清晨为了补充营养而饮用的鲜牛奶的场景。",
            "JA": "毎朝の栄養補給のために飲む新鮮な牛乳の名前を確認する場面입니다。"
        },
        239: {
            "KO": "앞을 보고 빛과 색상을 감지하는 눈의 이름을 확인하는 상황입니다.",
            "EN": "Identifying the eyes that perceive light, color, and sight.",
            "VI": "Nhận biết đôi mắt dùng để nhìn thấy ánh sáng và màu sắc.",
            "ZH": "确认用来观察视线、感知色彩的眼睛部位名称的场景。",
            "JA": "前を見て光や色彩を感じ取る目の名前を確認する場面です。"
        },
        240: {
            "KO": "물건을 쥐고 따뜻한 온기를 전하는 손의 이름을 확인하는 상황입니다.",
            "EN": "Identifying the hand used to grasp objects and greet others.",
            "VI": "Nhận biết bàn tay dùng để cầm nắm và chào hỏi.",
            "ZH": "确认用来抓取物品、传递温暖的双手部位名称的场景。",
            "JA": "物を握り温もりを伝える手の名前を確認する場面です。"
        },
        241: {
            "KO": "야외에서 걸을 때 발을 안전하게 감싸주는 신발의 이름을 확인하는 상황입니다.",
            "EN": "Identifying footwear worn to walk safely outdoors.",
            "VI": "Nhận biết đôi giày dép bảo vệ đôi chân khi đi ra ngoài.",
            "ZH": "确认在户外行走时安全包裹双脚的鞋履物品名称的场景。",
            "JA": "外を歩くときに足を安全に守る靴の名前を確認する場面です。"
        },
        242: {
            "KO": "강한 햇빛을 가리고 패션을 더해주는 모자의 이름을 확인하는 상황입니다.",
            "EN": "Identifying a hat worn on the head for style and sun protection.",
            "VI": "Nhận biết chiếc mũ đội trên đầu để che nắng và làm đẹp.",
            "ZH": "确认戴在头上遮阳又增添时尚感的帽子名称的场景。",
            "JA": "強い日差しを遮りファッションを彩る帽子の名前を確認する場面입니다。"
        },
        243: {
            "KO": "향기롭고 화사하게 피어난 꽃 식물의 이름을 확인하는 상황입니다.",
            "EN": "Identifying beautiful, fragrant blossoms and flowers.",
            "VI": "Nhận biết những bông hoa xinh tươi ngát hương thơm.",
            "ZH": "确认花香四溢、美丽绽放的鲜花植物名称的场景。",
            "JA": "香り高く華やかに咲いた花の名前を確認する場面です。"
        },
        244: {
            "KO": "푸른 잎과 튼튼한 줄기로 자연 그늘을 만들어주는 나무의 이름을 확인하는 상황입니다.",
            "EN": "Identifying a green tree providing cool natural shade with leaves.",
            "VI": "Nhận biết cây xanh rợp bóng mát trong thiên nhiên.",
            "ZH": "确认有着绿叶和粗壮树干、带来阴凉的树木名称的场景。",
            "JA": "青々とした葉と丈夫な幹で日陰を作ってくれる木の名前を確認する場面です。"
        },
        245: {
            "KO": "연락과 인터넷 검색에 매일 사용하는 스마트폰 기기를 확인하는 상황입니다.",
            "EN": "Identifying a smartphone used daily for communication and internet browsing.",
            "VI": "Nhận biết chiếc điện thoại di động thông minh dùng hàng ngày.",
            "ZH": "确认每天用于联络与网络浏览的智能手机数码产品的场景。",
            "JA": "連絡やネット検索に毎日使うスマートフォン端末を確認する場面입니다。"
        },
        246: {
            "KO": "정해진 노선을 따라 도로를 달리며 많은 승객을 태우는 버스를 확인하는 상황입니다.",
            "EN": "Identifying a city bus that transports passengers along fixed routes.",
            "VI": "Nhận biết xe buýt công cộng chạy trên đường phố chở nhiều hành khách.",
            "ZH": "确认沿着固定路线行驶搭载广大乘客的公交车交通工具的场景。",
            "JA": "定められたルートに沿って道路を走り多くの乗客を乗せるバスを確認する場面입니다。"
        },
        247: {
            "KO": "다리를 부드럽게 굽히고 펴게 해주는 무릎 관절 부위를 확인하는 상황입니다.",
            "EN": "Identifying the knee joint that allows legs to bend and walk smoothly.",
            "VI": "Nhận biết khớp đầu gối giúp đôi chân gập duỗi linh hoạt.",
            "ZH": "确认使腿部能够顺畅弯曲行走的膝盖关节部位名称的场景。",
            "JA": "足を滑らかに曲げ伸ばしさせる膝（ひざ）の部位を確認する場面です。"
        },
        248: {
            "KO": "팔과 몸통을 이어주며 가방 끈을 메는 어깨 신체 부위를 확인하는 상황입니다.",
            "EN": "Identifying the shoulder where bag straps rest and arms connect.",
            "VI": "Nhận biết phần vai, nơi đeo quai túi xách và nối liền cánh tay.",
            "ZH": "确认连接双臂与躯干、背负背包肩带的双肩部位名称的场景。",
            "JA": "腕と胴体をつなぎカバンのストラップをかける肩の部位を確認する場面입니다。"
        },
        249: {
            "KO": "상체와 하체를 지탱하며 곧게 서게 돕는 중심축 허리를 확인하는 상황입니다.",
            "EN": "Identifying the waist and lower back that supports posture.",
            "VI": "Nhận biết phần eo và thắt lưng giúp nâng đỡ cơ thể đứng thẳng.",
            "ZH": "确认支撑上下身、保持身姿挺拔的腰部核心部位名称的场景。",
            "JA": "上半身と下半身を支え姿勢をまっすぐ保つ腰の部位を確認する場面です。"
        },
        250: {
            "KO": "음악과 사람들의 대화를 들을 수 있게 해주는 귀의 이름을 확인하는 상황입니다.",
            "EN": "Identifying the ears that hear music and human voices.",
            "VI": "Nhận biết đôi tai giúp lắng nghe giai điệu và lời nói của mọi người.",
            "ZH": "确认能让人聆听音乐与人声交流的耳朵器官名称的场景。",
            "JA": "音楽や人々の会話を聞くことができる耳の名前を確認する場面です。"
        },

        # 301-320: 자연/일상 심화 어휘 대화 맥락
        301: {
            "KO": "과일가게에서 싱싱하고 달콤한 보라색 포도 한 송이를 고르는 상황입니다.",
            "EN": "Choosing a bunch of fresh, sweet purple grapes at a fruit shop.",
            "VI": "Chọn một chùm nho tím tươi ngon ngọt lịm tại tiệm trái cây.",
            "ZH": "在水果店挑选一串新鲜多汁的紫葡萄的日常场景。",
            "JA": "果物屋で新鮮で甘い紫のブドウを一房選ぶ場面です。"
        },
        302: {
            "KO": "무더운 여름날 갈증을 해소하기 위해 시원한 수박을 권하는 상황입니다.",
            "EN": "Recommending chilled, sweet watermelon to beat the hot summer heat.",
            "VI": "Gợi ý ăn dưa hấu mát lạnh để giải nhiệt vào ngày hè oi bức.",
            "ZH": "在炎热夏日推荐品尝清凉西瓜消暑解渴的场景。",
            "JA": "暑い夏の日に喉の渇きを潤す冷たいスイカを勧める場面です。"
        },
        303: {
            "KO": "베이커리에서 갓 구워낸 고소하고 따뜻한 빵을 아침으로 먹는 상황입니다.",
            "EN": "Eating warm, freshly baked bread from a bakery for breakfast.",
            "VI": "Thưởng thức bánh mì mới nướng thơm lừng cho bữa sáng.",
            "ZH": "早晨品尝面包房刚出炉的热气腾腾香酥面包的场景。",
            "JA": "ベーカリーで焼きたての香ばしいパンを朝食に食べる場面です。"
        },
        304: {
            "KO": "라면에 넣어 국물 맛을 부드럽게 해주는 계란을 넣을지 묻는 상황입니다.",
            "EN": "Asking if you want an egg added to your ramen noodles.",
            "VI": "Hỏi xem có muốn đập thêm một quả trứng vào bát mì tôm không.",
            "ZH": "询问在煮拉面时是否要加入一个鸡蛋增添风味的日常场景。",
            "JA": "ラーメンに卵を入れてまろやかにするか尋ねる場面입니다。"
        },
        305: {
            "KO": "향수 냄새를 맡으려는데 감기 때문에 코가 막혀 답답한 상황입니다.",
            "EN": "Mentioning that your nose is congested from a cold and cannot smell perfume.",
            "VI": "Nói về việc bị nghẹt mũi do cảm cúm nên không ngửi được mùi nước hoa.",
            "ZH": "因感冒鼻塞而闻不到好闻香水味道的日常情景。",
            "JA": "香水の匂いを嗅ごうとしたが風邪で鼻が詰まって匂わない場面です。"
        },
        306: {
            "KO": "병원 진료 시 의사 선생님의 말씀에 따라 입을 벌려 목을 보여주는 상황입니다.",
            "EN": "Opening your mouth to let the doctor examine your throat during checkup.",
            "VI": "Há to miệng để bác sĩ khám họng khi đi khám bệnh.",
            "ZH": "就医检查时听从医生嘱咐张开嘴巴查看喉咙的场景。",
            "JA": "診察の際に医師の指示に従って口を開け喉を見せる場面です。"
        },
        307: {
            "KO": "등산을 오래 하여 다리 근육이 뻐근하고 피로해진 상태를 말하는 상황입니다.",
            "EN": "Mentioning that your legs are sore and tired after a long hike.",
            "VI": "Nói về việc đôi chân mỏi nhừ sau một chuyến leo núi dài.",
            "ZH": "因长时间爬山而导致双腿酸痛疲惫的日常对话场景。",
            "JA": "長時間の登山で脚が疲れて痛くなったと伝える場面입니다。"
        },
        308: {
            "KO": "새 구두를 처음 신고 걸어서 발뒤꿈치가 쓸려 아픈 상태를 말하는 상황입니다.",
            "EN": "Mentioning that your feet hurt from wearing brand-new shoes.",
            "VI": "Nói về việc bị đau chân do mang đôi giày mới mua.",
            "ZH": "说明刚穿新皮鞋走路导致脚后跟有点磨痛的情景。",
            "JA": "新しい靴を履いて歩いたら足のかかとが少し痛いと話す場面です。"
        },
        309: {
            "KO": "쌀쌀한 날씨에 활동하기 편하고 따뜻한 바지를 입기로 결정하는 상황입니다.",
            "EN": "Choosing to wear warm, comfortable pants in chilly weather.",
            "VI": "Quyết định mặc chiếc quần dài ấm áp khi thời tiết se lạnh.",
            "ZH": "在天气转凉时决定穿上温暖舒适长裤出门的场景。",
            "JA": "肌寒い天気に動きやすくて暖かいズボンを履くことにした場面です。"
        },
        310: {
            "KO": "결혼식이나 공식 모임에 어울리는 단정한 치마를 추천해달라고 하는 상황입니다.",
            "EN": "Asking for recommendations of a neat, elegant skirt for weddings.",
            "VI": "Nhờ gợi ý một chiếc chân váy thanh lịch để đi dự đám cưới.",
            "ZH": "请朋友推荐一条适合去婚礼穿着的端庄裙子的场景。",
            "JA": "結婚式に着ていくきちんとしたスカートを勧めてもらう場面です。"
        },
        311: {
            "KO": "운동화를 신기 전에 발을 보호하고 땀을 흡수하는 양말을 챙겨 신는 상황입니다.",
            "EN": "Putting on socks to protect feet before wearing sneakers.",
            "VI": "Mang tất trước khi đi giày thể thao để bảo vệ bàn chân.",
            "ZH": "在穿运动鞋前穿上保护双脚吸汗棉袜的日常场景。",
            "JA": "スニーカーを履く前に足を保護する靴下を履く場面です。"
        },
        312: {
            "KO": "칠판 글씨가 흐릿하게 보여 시력 보정을 위해 안경을 쓰기로 권하는 상황입니다.",
            "EN": "Recommending glasses because the board text looks blurry.",
            "VI": "Khuyên nên đeo kính vì nhìn chữ trên bảng bị mờ do giảm thị lực.",
            "ZH": "因看黑板字迹模糊不清而建议佩戴近视眼镜的场景。",
            "JA": "黒板の文字がぼやけて見えるためメガネをかけるよう勧める場面입니다。"
        },
        313: {
            "KO": "이른 아침 동쪽 하늘 위로 붉게 떠오르는 해를 바라보며 감탄하는 상황입니다.",
            "EN": "Admiring the bright red sun rising over the eastern sky at dawn.",
            "VI": "Ngắm nhìn vầng mặt trời đỏ rực đang nhô lên ở phía đông vào sáng sớm.",
            "ZH": "清晨欣赏东方天空冉冉升起的火红太阳的场景。",
            "JA": "早朝の東の空に赤く昇る太陽（日）を眺めて感嘆する場面です。"
        },
        314: {
            "KO": "구름 없는 맑은 밤하늘에 둥실 떠오른 밝은 보름달을 함께 바라보는 상황입니다.",
            "EN": "Gazing at the bright, round full moon in a clear night sky.",
            "VI": "Cùng ngắm nhìn vầng trăng tròn vành vạnh tỏa sáng trên bầu trời đêm trong vắt.",
            "ZH": "一起仰望晴朗夜空中高悬的皎洁满月的浪漫场景。",
            "JA": "雲ひとつない夜空に浮かぶ丸い満月を一緒に見上げる場面です。"
        },
        315: {
            "KO": "도심을 벗어나 시골 밤하늘에 보석처럼 수없이 반짝이는 별들을 바라보는 상황입니다.",
            "EN": "Looking at countless sparkling stars in the quiet countryside night sky.",
            "VI": "Ngắm nhìn vô số vì sao lấp lánh như ngọc trên bầu trời đêm ở vùng thôn quê.",
            "ZH": "远离喧嚣都市，在乡下夜空下欣赏繁星点点的浪漫场景。",
            "JA": "田舎の澄んだ夜空に無数にきらめく星々を見上げる場面です。"
        },
        316: {
            "KO": "푸른 하늘에 하얀 솜사탕처럼 둥둥 떠다니는 구름을 올려다보는 상황입니다.",
            "EN": "Looking up at white cotton-candy clouds floating across a blue sky.",
            "VI": "Ngước nhìn những đám mây trắng bồng bềnh như kẹo bông gòn trên nền trời xanh.",
            "ZH": "仰望蓝天中朵朵像棉花糖一样漂浮的白云的日常场景。",
            "JA": "青空に白い綿菓子のように浮かぶ雲を見上げる場面です。"
        },
        317: {
            "KO": "주말에 서점에 들러 마음의 양식을 쌓을 유익한 책을 고르는 대화 상황입니다.",
            "EN": "Discussing picking up a great book to read at a bookstore on the weekend.",
            "VI": "Rủ nhau ghé hiệu sách vào cuối tuần để chọn một cuốn sách hay để đọc.",
            "ZH": "周末去书店挑选一本好书阅读增进知识的日常对话情景。",
            "JA": "週末に書店へ行って読む本を一冊選ぶ日常会話の場面です。"
        },
        318: {
            "KO": "오래 걸어 다리가 아파 카페의 빈 의자에 앉아 휴식을 취하려는 상황입니다.",
            "EN": "Looking for an empty chair to sit down and rest after walking a lot.",
            "VI": "Tìm chiếc ghế trống ở quán để ngồi nghỉ ngơi vì đi bộ nhiều bị mỏi chân.",
            "ZH": "走累了找一张空椅子坐下来歇息放松的场景。",
            "JA": "たくさん歩いて足が痛いので空いた椅子に座って休む場面です。"
        },
        319: {
            "KO": "대학 과제나 리포트 작성을 위해 도서관 컴퓨터를 이용해야 하는 상황입니다.",
            "EN": "Needing a computer to write university assignments and reports.",
            "VI": "Cần sử dụng máy tính để hoàn thành báo cáo và bài tập đại học.",
            "ZH": "为了撰写大学论文报告需要使用电脑的校园学习情景。",
            "JA": "大学のレポート作成のためにパソコンが必要な場面です。"
        },
        320: {
            "KO": "주말에 한강 공원에서 시원한 바람을 가르며 자전거를 타는 여가 상황입니다.",
            "EN": "Riding a bicycle while enjoying the cool breeze at Hangang Park on the weekend.",
            "VI": "Đạp xe đạp đón gió mát thư giãn tại công viên sông Hàn vào cuối tuần.",
            "ZH": "周末在汉江公园迎着清凉微风骑自行车的休闲生活场景。",
            "JA": "週末に漢江公園で涼しい風を感じながら自転車に乗る場面です。"
        }
    }

    # Conversational question rewrites for IDs 169-184
    dialogue_questions = {
        169: "가: 11월 30일에 중요한 약속이 있어요?\n나: 네, (   ).",
        170: "가: 대학교를 언제 졸업해요?\n나: (   ).",
        171: "가: 학교 방학은 언제 시작해요?\n나: (   ).",
        172: "가: 이번 주 토요일에 무슨 계획이 있어요?\n나: (   ).",
        173: "가: 주말에 보통 무엇을 하면서 시간을 보내요?\n나: (   ).",
        174: "가: 친구 생일 파티 준비는 잘 되어 가요?\n나: 네, (   ).",
        175: "가: 오늘 수업이 끝난 후에 뭐 할 거예요?\n나: (   ).",
        176: "가: 내일 휴일인데 쉴 수 있어요?\n나: 아니요, (   ).",
        177: "가: 어제 하루 종일 무엇을 했어요?\n나: (   ).",
        178: "가: 지금 방에서 무엇을 하고 있어요?\n나: (   ).",
        179: "가: 일요일에 시간 있으면 같이 산책할래요?\n나: 좋아요, (   ).",
        180: "가: 아침 식사로 보통 무엇을 드세요?\n나: (   ).",
        181: "가: 퇴근하고 저녁 시간에 보통 뭐 해요?\n나: (   ).",
        182: "가: 점심 먹고 나른한데 몇 시에 차 한잔할까요?\n나: (   ).",
        183: "가: 한국어 실력이 정말 많이 늘었네요!\n나: 고마워요, (   ).",
        184: "가: 이번 휴가 때 어디로 떠나실 계획이에요?\n나: (   )."
    }

    # Questions 1-10: replace '철수:' and '영희:' with natural '가:' and '나:'
    dialogue_1_10 = {
        1: "가: 한국어를 할 수 있어요?\n나: 네, (   ).",
        2: "가: 운전할 수 있어요?\n나: 네, (   ).",
        3: "가: 케이크를 만들 수 있어요?\n나: 네, (   ).",
        4: "가: 김치를 먹을 수 있어요?\n나: 아니요, (   ).",
        5: "가: 스키를 탈 수 있어요?\n나: 아니요, (   ).",
        6: "가: 날씨가 정말 화창하네요. 지금 어디에 가요?\n나: (   ).",
        7: "가: 가방에 책이 가득하네요. 어디에 가요?\n나: (   ).",
        8: "가: 어디에 가요?\n나: 목이 말라서 (   ).",
        9: "가: 부산에 왜 가요?\n나: (   ).",
        10: "가: 한국에 왜 왔어요?\n나: (   )."
    }

    # Apply updates
    modified_count = 0
    for q in data:
        qid = q['id']
        
        # 1. Update situation if mapped
        if qid in custom_situations:
            q['situations'] = custom_situations[qid]
            modified_count += 1
            
        # 2. Update question for 169-184
        if qid in dialogue_questions:
            q['questions']['KO'] = dialogue_questions[qid]
            
        # 3. Update question for 1-10
        if qid in dialogue_1_10:
            q['questions']['KO'] = dialogue_1_10[qid]

    print(f'Successfully updated {modified_count} questions with bespoke situations and dialogues.')

    # Save to questions.json
    with open('assets/data/questions.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print('Saved updated assets/data/questions.json.')

if __name__ == '__main__':
    main()

