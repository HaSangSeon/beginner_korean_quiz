import json

new_60 = [
  # 541. 은행: 통장
  {
    "id": 541,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "🏦 💳",
    "speechBubble": "은행에서 입출금 통장을 개설해요.",
    "keyword": "통장",
    "situations": {
      "KO": "은행 창구에서 금융 거래와 월급 입금을 위해 종이 또는 전자 거래 장부를 새로 개설하는 상황입니다.",
      "EN": "Opening a new bankbook/account at a bank counter for transactions and salary deposits.",
      "VI": "Mở sổ tài khoản ngân hàng mới tại quầy để giao dịch tài chính và nhận lương.",
      "ZH": "在银行柜台新开立用于金融交易和接收工资的存折账户。",
      "JA": "銀行の窓口で給与の受取や金融取引のために新しい口座通帳を開設する場面です。"
    },
    "questions": {
      "KO": "가: 아르바이트 월급을 받으려면 은행에서 무엇을 만들어야 하나요?\n나: 신분증을 가지고 은행에 가서 입출금용 (   )을/를 개설하세요."
    },
    "options": ["상품권", "통장", "영수증", "입장권"],
    "answerIndex": 1,
    "explanations": {
      "KO": "은행에서 예금과 출금 내역을 기록하고 계좌를 증명하는 금융 장부는 '통장(Bankbook)'이에요!",
      "EN": "A financial account ledger issued by a bank to record deposits and withdrawals is a '통장' (Bankbook)!",
      "VI": "Sổ ghi chép giao dịch gửi và rút tiền do ngân hàng cấp là '통장' (Sổ tài khoản ngân hàng)!",
      "ZH": "由银行核发、记录存取款明细并证明账户的金融凭证是'통장'（存折/银行账户）！",
      "JA": "銀行で預金や引き出しの明細を記録し口座を証明するものは「통장（通帳）」です！"
    }
  },
  # 542. 은행: 송금
  {
    "id": 542,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "📱 💸",
    "speechBubble": "모바일 뱅킹으로 돈을 송금해요.",
    "keyword": "송금",
    "situations": {
      "KO": "스마트폰 은행 앱을 이용하여 상대방의 계좌 번호로 돈을 보내는 금융 이체 상황입니다.",
      "EN": "Transferring money to another person's bank account using a smartphone banking app.",
      "VI": "Chuyển tiền vào số tài khoản của người khác thông qua ứng dụng ngân hàng trên điện thoại.",
      "ZH": "使用智能手机银行应用程序向对方的银行账号转账汇款。",
      "JA": "スマートフォン銀行アプリを利用して相手の口座番号にお金を送金する場面です。"
    },
    "questions": {
      "KO": "가: 친구에게 빌린 돈 2만 원을 은행 계좌로 어떻게 보내요?\n나: 모바일 뱅킹 앱에서 친구의 계좌번호를 입력하고 (   ) 버튼을 누르세요."
    },
    "options": ["조회", "송금", "삭제", "취소"],
    "answerIndex": 1,
    "explanations": {
      "KO": "다른 사람의 금융 계좌로 돈을 부쳐 보내는 거래 행위를 '송금(Remittance / Money transfer)'이라고 해요!",
      "EN": "The financial action of transferring money to another person's account is '송금' (Money transfer)!",
      "VI": "Hành động chuyển tiền vào tài khoản ngân hàng của người khác gọi là '송금' (Chuyển khoản / Gửi tiền)!",
      "ZH": "向他人的金融账户转汇款项的操作称为'송금'（汇款/转账）！",
      "JA": "他人の金融口座にお金を送る取引行為を「송금（送金）」と言います！"
    }
  },
  # 543. 은행: 비밀번호
  {
    "id": 543,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "🔒 🔢",
    "speechBubble": "체크카드 비밀번호 4자리를 눌러요.",
    "keyword": "비밀번호",
    "situations": {
      "KO": "ATM 기기에서 현금을 인출할 때 본인 확인을 위해 4자리 보안 번호를 누르는 상황입니다.",
      "EN": "Entering a 4-digit PIN for identity verification when withdrawing cash at an ATM.",
      "VI": "Nhập mã số bảo mật 4 chữ số để xác minh danh tính khi rút tiền mặt tại cây ATM.",
      "ZH": "在ATM自动取款机取款时输入用于身份验证的4位数字安全密码。",
      "JA": "ATM機で現金を引き出す際に本人確認のため4桁の暗証番号を押す場面です。"
    },
    "questions": {
      "KO": "가: ATM 기기에서 현금을 찾으려는데 카드를 넣은 후 무엇을 입력해야 하나요?\n나: 화면에 키패드가 뜨면 카드 (   ) 4자리를 정확히 누르세요."
    },
    "options": ["전화번호", "우편번호", "비밀번호", "좌석번호"],
    "answerIndex": 2,
    "explanations": {
      "KO": "본인 인증과 금융 보안을 위해 정해 둔 비공개 숫자를 '비밀번호(PIN / Password)'라고 해요!",
      "EN": "A confidential code used for personal authentication and financial security is a '비밀번호' (PIN / Password)!",
      "VI": "Mã số bí mật được thiết lập để bảo mật giao dịch là '비밀번호' (Mật khẩu / Mã PIN)!",
      "ZH": "为了身份认证与金融安全而设定的非公开数字组合是'비밀번호'（密码/PIN码）！",
      "JA": "本人認証と金融セキュリティのために設定した非公開の暗証コードは「비밀번호（暗証番号）」です！"
    }
  },
  # 544. 우체국: 택배
  {
    "id": 544,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "📦 🚚",
    "speechBubble": "우체국에서 고향으로 택배를 보내요.",
    "keyword": "택배",
    "situations": {
      "KO": "우체국이나 편의점에서 상자에 든 무거운 물품을 수령인의 주소지로 부치는 배송 상황입니다.",
      "EN": "Sending a boxed package to a recipient's address at a post office or convenience store.",
      "VI": "Gửi bưu kiện đóng thùng đến địa chỉ người nhận tại bưu điện hoặc cửa hàng tiện lợi.",
      "ZH": "在邮局或便利店将装在纸箱里的包裹寄往收件人地址。",
      "JA": "郵便局やコンビニで箱詰めした荷物を受取人の住所へ送る宅配便の場面です。"
    },
    "questions": {
      "KO": "가: 고향에 계신 부모님께 한국 화장품과 김을 상자에 담아 보내고 싶어요.\n나: 가까운 우체국에 방문해서 상자에 주소를 적고 (   )을/를 접수하세요."
    },
    "options": ["편지", "전단지", "택배", "전보"],
    "answerIndex": 2,
    "explanations": {
      "KO": "물건이나 짐을 포장하여 원하는 목적지까지 운송해 주는 배송 서비스는 '택배(Parcel / Courier service)'예요!",
      "EN": "A delivery service that transports packaged goods and parcels directly to a destination is '택배' (Parcel / Courier)!",
      "VI": "Dịch vụ vận chuyển bưu kiện đóng gói đến tận địa chỉ người nhận là '택배' (Chuyển phát bưu kiện)!",
      "ZH": "将打包好的物品寄送至指定目的地的门到门包裹配送服务是'택배'（快递）！",
      "JA": "荷物を包装して希望の目的地まで配送してくれるサービスは「택배（宅配便・小包）」です！"
    }
  },
  # 545. 우체국: 등기
  {
    "id": 545,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "✉️ ✍️",
    "speechBubble": "중요한 서류는 등기 우편으로 보내요.",
    "keyword": "등기",
    "situations": {
      "KO": "분실되면 안 되는 중요한 공문서나 자격증을 배달원이 직접 서명을 받고 배달하는 안전 우편을 이용하는 상황입니다.",
      "EN": "Using registered mail where the courier collects a signature upon delivery for important documents.",
      "VI": "Sử dụng dịch vụ thư chuyển phát bảo đảm có ký nhận khi giao các giấy tờ quan trọng.",
      "ZH": "邮寄重要证件或文件时使用投递员当面签收的挂号信安全服务。",
      "JA": "紛失してはならない重要書類を配達員が受取人の署名をもらって手渡す書留郵便を利用する場面です。"
    },
    "questions": {
      "KO": "가: 비자 연장 심사에 필요한 중요한 원본 서류를 대사관에 보내야 해요.\n나: 분실 위험이 없도록 수취인 서명을 받는 안전한 (   ) 우편으로 부치세요."
    },
    "options": ["일반", "등기", "광고", "낙서"],
    "answerIndex": 1,
    "explanations": {
      "KO": "우편물의 접수부터 배달까지 전 과정을 기록하고 본인 서명을 받는 안전 우편 서비스는 '등기(Registered mail)'예요!",
      "EN": "A secure postal service that tracks the entire process and requires a recipient signature is '등기' (Registered mail)!",
      "VI": "Dịch vụ bưu chính an toàn có theo dõi lộ trình và yêu cầu người nhận ký tên là '등기' (Thư bảo đảm)!",
      "ZH": "从寄件到送达全程追踪并需收件人亲笔签收的安全邮政服务是'등기'（挂号信）！",
      "JA": "郵便物の引き受けから配達までを記録し受取人の受領印をもらう郵便サービスは「등기（書留）」です！"
    }
  },
  # 546. 주거/부동산: 월세
  {
    "id": 546,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "🏠 📅",
    "speechBubble": "매달 정해진 날짜에 월세를 내요.",
    "keyword": "월세",
    "situations": {
      "KO": "원룸이나 아파트에서 거주하면서 매달 집주인 계좌로 방 임대료를 지불하는 주거 임대차 상황입니다.",
      "EN": "Paying monthly rent to a landlord's bank account while living in a one-room studio or apartment.",
      "VI": "Trả tiền thuê nhà hàng tháng vào tài khoản của chủ nhà khi sống tại phòng trọ hoặc căn hộ.",
      "ZH": "租住在单间公寓或住宅时，每月定期向房东账户支付房屋租金。",
      "JA": "ワンルームやアパートに住みながら毎月決まった日に大家さんの口座へ家賃を支払う場面です。"
    },
    "questions": {
      "KO": "가: 학교 근처 원룸 계약 조건을 보니 보증금 500만 원이라고 적혀 있네요.\n나: 네, 그리고 매달 방 이용료로 45만 원씩 집주인에게 내는 (   )가 있어요."
    },
    "options": ["전세", "월세", "벌금", "세금"],
    "answerIndex": 1,
    "explanations": {
      "KO": "집이나 방을 빌려 쓰고 그 대가로 매달 일정 금액의 방세를 지불하는 임대 형태를 '월세(Monthly rent)'라고 해요!",
      "EN": "A rental system where a fixed rent amount is paid to the landlord every month is '월세' (Monthly rent)!",
      "VI": "Hình thức thuê nhà trả tiền thuê cố định theo từng tháng gọi là '월세' (Tiền thuê nhà theo tháng)!",
      "ZH": "租用房屋并按月向房东支付固定租金的租房方式是'월세'（月租/房租）！",
      "JA": "部屋を借りてその対価として毎月一定の金額を支払う賃貸方式を「월세（月払い家賃）」と言います！"
    }
  },
  # 547. 주거/부동산: 보증금
  {
    "id": 547,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "🏢 💰",
    "speechBubble": "원룸 계약할 때 보증금을 맡겨요.",
    "keyword": "보증금",
    "situations": {
      "KO": "부동산에서 방을 임대차 계약할 때 채무 담보를 위해 집주인에게 먼저 맡겼다가 이사 나갈 때 돌려받는 목돈을 확인하는 상황입니다.",
      "EN": "Paying a deposit to the landlord when signing a housing contract, which is refunded when moving out.",
      "VI": "Đặt cọc một khoản tiền lớn cho chủ nhà khi ký hợp đồng thuê phòng và sẽ được nhận lại khi chuyển đi.",
      "ZH": "签订房屋租赁合同时向房东预先交纳的担保金，退租搬家时全额退还。",
      "JA": "賃貸契約を結ぶ際に担保として大家さんに預け、退去時に返還されるまとまった敷金を指す場面です。"
    },
    "questions": {
      "KO": "가: 원룸을 계약할 때 계약서에 적힌 큰돈 1,000만 원은 무슨 돈인가요?\n나: 계약 기간 동안 집주인에게 맡겨두고 계약 만료 후 이사 갈 때 돌려받는 (   )이에요."
    },
    "options": ["관리비", "보증금", "교통비", "식비"],
    "answerIndex": 1,
    "explanations": {
      "KO": "임대차 계약 시 집주인에게 예치했다가 계약이 끝나 이사할 때 전액 돌려받는 담보금은 '보증금(Security deposit)'이에요!",
      "EN": "A refundable security deposit entrusted to the landlord during the lease period is a '보증금' (Deposit)!",
      "VI": "Khoản tiền cọc ký gửi cho chủ nhà trong suốt thời gian thuê và được hoàn lại khi kết thúc hợp đồng là '보증금' (Tiền đặt cọc)!",
      "ZH": "租赁合同期间质押给房东、租约期满搬家时如数返还的保证金是'보증금'（房屋押金）！",
      "JA": "賃貸契約中に大家さんに預け、退去時に全額返還される担保金は「보증금（保証金・敷金）」です！"
    }
  },
  # 548. 주거/부동산: 관리비
  {
    "id": 548,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "💡 🧾",
    "speechBubble": "건물 청소와 엘리베이터 관리비를 내요.",
    "keyword": "관리비",
    "situations": {
      "KO": "원룸이나 아파트 건물의 공용 전기, 수도, 계단 청소 및 엘리베이터 유지 보수를 위해 매달 납부하는 비용을 확인하는 상황입니다.",
      "EN": "Paying monthly building maintenance fees for common electricity, water, cleaning, and elevator upkeep.",
      "VI": "Chi trả tiền phí quản lý hàng tháng cho việc vệ sinh hành lang, thang máy và điện nước chung của tòa nhà.",
      "ZH": "每月缴纳用于公寓公用电费、楼道保洁、电梯维护等日常运维的物业费用。",
      "JA": "アパートの共有部分の電気・水道、清掃やエレベーター維持のために毎月納める費用を確認する場面です。"
    },
    "questions": {
      "KO": "가: 방세 말고 매달 5만 원씩 추가로 내는 영수증 항목은 뭐예요?\n나: 복도 전등, 엘리베이터 유지, 건물 청소 비용에 쓰이는 (   )예요."
    },
    "options": ["입장료", "관리비", "수수료", "위약금"],
    "answerIndex": 1,
    "explanations": {
      "KO": "건물이나 공동주택의 유지와 관리를 위해 입주민들이 분담하여 지불하는 공용 비용은 '관리비(Maintenance fee)'예요!",
      "EN": "The shared fee paid by residents for the maintenance and cleaning of a building is '관리비' (Maintenance fee)!",
      "VI": "Khoản tiền các cư dân cùng đóng góp để duy trì và vệ sinh tòa nhà chung là '관리비' (Phí quản lý)!",
      "ZH": "住户分摊用于公用设施维护保养与保洁的物业管理费用是'관리비'（物业费/管理费）！",
      "JA": "建物の維持・清掃・管理のために居住者が分担して支払う共益費用は「관리비（管理費）」です！"
    }
  },
  # 549. 병원: 안과
  {
    "id": 549,
    "category": "병원·약국·응급",
    "type": "word",
    "level": 1,
    "visual": "👁️ 🏥",
    "speechBubble": "눈이 충혈되고 아플 때는 안과에 가요.",
    "keyword": "안과",
    "situations": {
      "KO": "눈이 가렵거나 빨갛게 충혈되어 시력 검사와 눈 질환 진료를 전문 병원에 받으러 가는 상황입니다.",
      "EN": "Visiting an ophthalmology/eye clinic when your eyes are itchy, bloodshot, or in pain.",
      "VI": "Đi đến phòng khám chuyên khoa mắt khi mắt bị ngứa, đỏ hoặc đau nhức.",
      "ZH": "当眼睛发痒、发红充血或视力不适时前往眼科诊所就诊。",
      "JA": "目が充血して痛んだり痒みがある時に専門の眼科医院へ治療を受けに行く場面です。"
    },
    "questions": {
      "KO": "가: 눈에 모래가 들어간 것처럼 뻑뻑하고 충혈이 심해요. 어디 병원으로 가야 해요?\n나: 눈 질환과 시력을 전문적으로 진료해 주는 (   )에 가보세요."
    },
    "options": ["치과", "피부과", "안과", "정형외과"],
    "answerIndex": 2,
    "explanations": {
      "KO": "눈의 질병과 시력 이상을 전문적으로 검사하고 치료하는 전문 병원 진료과는 '안과(Eye clinic / Ophthalmology)'예요!",
      "EN": "The specialized medical department that treats eye diseases and vision problems is '안과' (Ophthalmology clinic)!",
      "VI": "Chuyên khoa y tế chuyên khám và điều trị các bệnh về mắt là '안과' (Khoa mắt / Phòng khám mắt)!",
      "ZH": "专门诊治眼睛疾病与视力问题的医疗专科是'안과'（眼科）！",
      "JA": "目の病気や視力異常を専門的に診察・治療する診療科は「안과（眼科）」です！"
    }
  },
  # 550. 병원: 이비인후과
  {
    "id": 550,
    "category": "병원·약국·응급",
    "type": "word",
    "level": 1,
    "visual": "👂 👃",
    "speechBubble": "목이 붓고 코가 막힐 때는 이비인후과에 가요.",
    "keyword": "이비인후과",
    "situations": {
      "KO": "목이 따끔거리고 코막힘이나 귀 통증이 심해 귀·코·목 전문 진료과를 찾는 상황입니다.",
      "EN": "Visiting an ENT (Ear, Nose, Throat) clinic when suffering from a sore throat, runny nose, or ear pain.",
      "VI": "Đến phòng khám chuyên khoa Tai - Mũi - Họng khi bị nghẹt mũi, viêm họng hoặc đau tai.",
      "ZH": "喉咙痛、鼻塞流涕或耳朵不适时前往耳鼻喉科就诊。",
      "JA": "喉の腫れ、鼻づまり、耳の痛みの治療のために耳鼻咽喉科を訪れる場面です。"
    },
    "questions": {
      "KO": "가: 침을 삼킬 때 목이 너무 아프고 코가 꽉 막혀서 숨쉬기 힘들어요.\n나: 귀, 코, 목을 집중적으로 진료해 주는 (   )에 얼른 가서 진찰받으세요."
    },
    "options": ["안과", "이비인후과", "치과", "소아과"],
    "answerIndex": 1,
    "explanations": {
      "KO": "귀(耳), 코(鼻), 목(咽喉)의 질환을 전문적으로 치료하는 의료 진료과는 '이비인후과(ENT clinic)'예요!",
      "EN": "The specialized clinic treating ear, nose, and throat ailments is '이비인후과' (ENT clinic)!",
      "VI": "Phòng khám chuyên khoa điều trị các bệnh về tai, mũi và họng là '이비인후과' (Khoa Tai - Mũi - Họng)!",
      "ZH": "专门治疗耳、鼻、咽喉相关疾病的专业医疗机构是'이비인후과'（耳鼻喉科）！",
      "JA": "耳、鼻、喉の疾患を専門的に診察・治療する科は「이비인후과（耳鼻咽喉科）」です！"
    }
  },
  # 551. 약국: 파스
  {
    "id": 551,
    "category": "병원·약국·응급",
    "type": "word",
    "level": 1,
    "visual": "🩹 💪",
    "speechBubble": "어깨가 결릴 때 시원한 파스를 붙여요.",
    "keyword": "파스",
    "situations": {
      "KO": "무리한 운동이나 무거운 짐을 들다가 근육통이 생겼을 때 피부에 붙이는 진통 소염 패치를 약국에서 구매하는 상황입니다.",
      "EN": "Buying pain-relief medicated adhesive patches at a pharmacy for sore muscles.",
      "VI": "Mua cao dán giảm đau tại hiệu thuốc để dán vào vùng cơ bị đau mỏi sau khi vận động.",
      "ZH": "因剧烈运动或劳累导致肌肉酸痛时，在药店购买贴在患处的消炎镇痛膏药贴。",
      "JA": "筋肉痛や肩こりがある時に皮膚に貼って痛みを和らげる消炎鎮痛湿布を薬局で買う場面です。"
    },
    "questions": {
      "KO": "가: 무거운 박스를 들다가 허리와 어깨 근육이 뻐근하게 뭉쳤어요.\n나: 약국에 가서 시원하게 통증을 풀어주는 붙이는 (   )을/를 사서 붙이세요."
    },
    "options": ["소독약", "파스", "안약", "물약"],
    "answerIndex": 1,
    "explanations": {
      "KO": "근육통, 관절통 부위 피부에 직접 붙여서 진통과 소염 효과를 내는 외용 패치는 '파스(Medicated plaster / Patch)'예요!",
      "EN": "A pain-relief medicated adhesive patch applied to muscles or joints is a '파스' (Pain relief patch)!",
      "VI": "Miếng dán ngoài da giúp giảm đau mỏi cơ bắp và khớp xương là '파스' (Cao dán giảm đau / Miếng dán nóng-lạnh)!",
      "ZH": "直接贴在肌肉或关节酸痛部位起到镇痛消炎作用的医用膏药贴是'파스'（膏药/止痛贴）！",
      "JA": "筋肉痛や関節の痛む部位に直接貼って痛みを鎮める外用貼付剤は「파스（湿布）」です！"
    }
  },
  # 552. 약국: 밴드
  {
    "id": 552,
    "category": "병원·약국·응급",
    "type": "word",
    "level": 1,
    "visual": "🩹 🩸",
    "speechBubble": "상처 난 손가락에 일회용 밴드를 감아요.",
    "keyword": "밴드",
    "situations": {
      "KO": "종이나 칼에 손가락을 살짝 베여 피가 날 때 세균 감염을 막기 위해 작은 반창고를 붙이는 상황입니다.",
      "EN": "Applying an adhesive bandage to a small cut on your finger to prevent infection.",
      "VI": "Dán miếng băng dán cá nhân vào ngón tay bị đứt chảy máu nhẹ để ngăn nhiễm trùng.",
      "ZH": "被纸张或刀片划破手指轻微出血时贴上创口贴防止感染。",
      "JA": "紙や包丁で指先を切って血が出た時に感染を防ぐため絆創膏を貼る場面です。"
    },
    "questions": {
      "KO": "가: 종이에 손가락을 살짝 베여서 피가 조금 나요.\n나: 연고를 살짝 바르고 상처 부위에 먼지가 닿지 않게 일회용 (   )을/를 붙이세요."
    },
    "options": ["밴드", "마스크", "장갑", "안경"],
    "answerIndex": 0,
    "explanations": {
      "KO": "작은 상처 부위를 보호하고 오염을 방지하기 위해 붙이는 접착식 반창고를 일상에서 '밴드(Band-Aid / Adhesive bandage)'라고 불러요!",
      "EN": "An adhesive bandage used to protect small wounds from dirt and bacteria is commonly called a '밴드' (Bandage)!",
      "VI": "Miếng băng dán có keo dùng để bảo vệ vết thương nhỏ ngoài da gọi là '밴드' (Băng cá nhân)!",
      "ZH": "用于保护小伤口免受灰尘感染的黏贴式创口贴在日常中常称为'밴드'（创口贴）！",
      "JA": "小さな傷口を保護し細菌や汚れの侵入を防ぐ粘着テープ付きガーゼは「밴드（絆創膏）」と呼ばれます！"
    }
  },
  # 553. 식당: 앞치마
  {
    "id": 553,
    "category": "식당·외식·이동",
    "type": "word",
    "level": 1,
    "visual": "👗 🍲",
    "speechBubble": "국물이 튀지 않게 앞치마를 둘러요.",
    "keyword": "앞치마",
    "situations": {
      "KO": "식당에서 찌개나 떡볶이를 먹을 때 밝은 옷에 붉은 양념 국물이 튀지 않도록 착용하는 보호 천을 요청하는 상황입니다.",
      "EN": "Asking for an apron at a restaurant to prevent spicy soup from staining your clothes.",
      "VI": "Hỏi xin tạp dề tại quán ăn để tránh nước lẩu hay sốt ớt bắn vào quần áo sáng màu.",
      "ZH": "在餐馆吃火锅或年糕时为了防止红汤溅脏衣服而向店家索要围裙。",
      "JA": "飲食店でチゲなどを食べる際、服に赤いスープが飛び散らないようエプロンを求める場面です。"
    },
    "questions": {
      "KO": "가: 오늘 흰색 셔츠를 입었는데 매콤한 김치찌개 국물이 튈까 봐 걱정돼요.\n나: 식당 벽에 걸려 있는 일회용 (   )을/를 가져다가 목에 두르고 드세요."
    },
    "options": ["앞치마", "목도리", "넥타이", "손수건"],
    "answerIndex": 0,
    "explanations": {
      "KO": "음식을 먹거나 조리할 때 옷이 더러워지지 않도록 가슴과 배 앞부분에 두르는 천은 '앞치마(Apron)'예요!",
      "EN": "A garment worn over the front of your body to keep clothes clean while eating or cooking is an '앞치마' (Apron)!",
      "VI": "Mảnh vải hoặc nilon đeo trước ngực để giữ quần áo không bị dơ khi ăn uống hay nấu nướng là '앞치마' (Tạp dề)!",
      "ZH": "在烹饪或用餐时围在胸前防止弄脏衣物的遮挡物是'앞치마'（围裙）！",
      "JA": "料理や食事の際に衣服が汚れないように胸や腹の前にかける布は「앞치마（エプロン・前掛け）」です！"
    }
  },
  # 554. 식당: 물티슈
  {
    "id": 554,
    "category": "식당·외식·이동",
    "type": "word",
    "level": 1,
    "visual": "🧻 💧",
    "speechBubble": "식사 전 손을 닦는 물티슈를 부탁해요.",
    "keyword": "물티슈",
    "situations": {
      "KO": "식당 테이블에 앉아 음식을 먹기 전 손을 위생적으로 닦기 위해 수분이 든 일회용 티슈를 요청하는 상황입니다.",
      "EN": "Asking for wet wipes to clean your hands hygienically before dining at a restaurant.",
      "VI": "Yêu cầu khăn giấy ướt để lau sạch tay trước khi bắt đầu dùng bữa tại nhà hàng.",
      "ZH": "在餐馆就餐前向服务员索要用于擦手消毒的湿纸巾。",
      "JA": "飲食店で食事を始める前に衛生的に手を拭くためのおしぼり（ウェットティッシュ）をお願いする場面です。"
    },
    "questions": {
      "KO": "가: 저기요, 쌈을 싸 먹으려고 하는데 손 닦을 것 좀 주시겠어요?\n나: 네, 테이블 위에 개별 포장된 시원한 (   ) 가져다드릴게요."
    },
    "options": ["물티슈", "신문지", "메모지", "복사지"],
    "answerIndex": 0,
    "explanations": {
      "KO": "수분과 소독 성분이 함유되어 손이나 얼굴을 간편하게 닦아내는 위생 티슈를 '물티슈(Wet wipe)'라고 해요!",
      "EN": "Moistened disposable tissues used for cleaning hands or surfaces are called '물티슈' (Wet wipes)!",
      "VI": "Loại khăn giấy ướt dùng một lần để lau tay vệ sinh được gọi là '물티슈' (Khăn ướt)!",
      "ZH": "含有水分可便捷擦手清洁的一次性湿纸巾称为'물티슈'（湿巾/湿纸巾）！",
      "JA": "水分が含まれていて手や口元を清潔に拭き取れるシートは「물티슈（ウェットティッシュ・おしぼり）」です！"
    }
  },
  # 555. 식당: 리필
  {
    "id": 555,
    "category": "식당·외식·이동",
    "type": "word",
    "level": 1,
    "visual": "🥗 🔄",
    "speechBubble": "김치와 밑반찬을 추가로 리필해요.",
    "keyword": "리필",
    "situations": {
      "KO": "한국 식당에서 기본 제공되는 김치나 나물 등 밑반찬이 떨어졌을 때 무료로 더 채워달라고 요청하는 상황입니다.",
      "EN": "Asking for a free refill of side dishes like kimchi and seasoned veggies at a Korean restaurant.",
      "VI": "Yêu cầu thêm kim chi hoặc các món ăn kèm miễn phí khi đã ăn hết tại quán ăn Hàn Quốc.",
      "ZH": "在韩国餐馆就餐时，免费要求续加吃完的泡菜或小菜。",
      "JA": "韓国の食堂でキムチやおかずを食べ終えた後、無料で追加のおかわりをお願いする場面です。"
    },
    "questions": {
      "KO": "가: 사장님, 테이블에 있는 배추김치를 다 먹었는데 더 주실 수 있나요?\n나: 네, 한국 식당에서는 기본 반찬은 셀프바에서 자유롭게 (   )해서 드시면 돼요."
    },
    "options": ["폐기", "리필", "포장", "반품"],
    "answerIndex": 1,
    "explanations": {
      "KO": "식당이나 카페에서 다 먹은 반찬이나 음료를 다시 무료로 채워 넣는 것을 '리필(Refill / おかわり)'이라고 불러요!",
      "EN": "Getting an empty side dish or beverage replenished is called a '리필' (Refill)!",
      "VI": "Hành động lấy thêm đồ ăn kèm hoặc nước uống vào phần đã hết gọi là '리필' (Lấy thêm / Refill)!",
      "ZH": "在餐馆将已经吃完的小菜或饮料再次添加斟满的行为在韩语中称为'리필'（续加/免费添盘）！",
      "JA": "食堂などで空になったおかずや飲み物を再び満たすことを「리필（おかわり・リフィル）」と言います！"
    }
  },
  # 556. 마트: 바코드
  {
    "id": 556,
    "category": "편의점·마트·쇼핑",
    "type": "word",
    "level": 1,
    "visual": "🏷️ 📱",
    "speechBubble": "계산대 스캐너에 검은 바코드를 찍어요.",
    "keyword": "바코드",
    "situations": {
      "KO": "셀프 계산대나 편의점 카운터에서 상품의 가격을 인식시키기 위해 굵고 얇은 검은 줄무늬 코드를 스캔하는 상황입니다.",
      "EN": "Scanning the striped black lines on a product packaging at a self-checkout counter.",
      "VI": "Quét mã vạch sọc đen in trên bao bì sản phẩm để thanh toán tại quầy thu ngân tự động.",
      "ZH": "在自助结账机或便利店用扫描枪扫描商品包装上的黑白条形码以识别价格。",
      "JA": "セルフレジで商品の価格を読み取るために白黒の縞模様コードをスキャナーにかざす場面です。"
    },
    "questions": {
      "KO": "가: 무인 셀프 계산대에서 상품 가격을 인식시키려면 기계에 무엇을 대야 하나요?\n나: 과자 봉지 뒤에 인쇄된 검은 줄무늬 (   )을/를 빨간 불빛 스캐너에 가까이 대세요."
    },
    "options": ["우편번호", "바코드", "비밀번호", "계좌번호"],
    "answerIndex": 1,
    "explanations": {
      "KO": "굵기가 서로 다른 검은 막대 선을 조합하여 가격 및 상품 정보를 광학 리더기로 판독하는 표시는 '바코드(Barcode)'예요!",
      "EN": "A machine-readable pattern of parallel black lines printed on commodities is a '바코드' (Barcode)!",
      "VI": "Ký hiệu các vạch đen trắng song song chứa thông tin sản phẩm và giá tiền là '바코드' (Mã vạch)!",
      "ZH": "由不同宽度的黑白平行线条组成、用扫描仪读取商品信息的标识是'바코드'（条形码）！",
      "JA": "太さの異なる黒い縞模様で価格や商品情報を読み取らせる標識は「바코드（バーコード）」です！"
    }
  },
  # 557. 쇼핑: 교환
  {
    "id": 557,
    "category": "편의점·마트·쇼핑",
    "type": "word",
    "level": 1,
    "visual": "👕 🔁",
    "speechBubble": "사이즈가 작아서 다른 옷으로 교환해요.",
    "keyword": "교환",
    "situations": {
      "KO": "구매한 셔츠의 치수가 맞지 않아 영수증을 제시하고 더 큰 사이즈의 동일 제품으로 맞바꾸는 상황입니다.",
      "EN": "Exchanging a purchased shirt for a larger size at a clothing store using the receipt.",
      "VI": "Đổi chiếc áo đã mua lấy một kích cỡ lớn hơn vừa vặn hơn tại cửa hàng quần áo bằng hóa đơn.",
      "ZH": "在服装店因买到的尺码不合身而凭小票换成更合适尺码的同一款衣服。",
      "JA": "購入した服のサイズが合わなかったため、レシートを提示してサイズ違いの同じ服と取り替える場面です。"
    },
    "questions": {
      "KO": "가: 어제 산 바지가 허리가 너무 꽉 끼는데 더 큰 사이즈로 바꿀 수 있나요?\n나: 네, 태그를 떼지 않고 영수증을 지참하시면 동일 상품의 큰 치수로 (   )해 드립니다."
    },
    "options": ["폐기", "교환", "적립", "기부"],
    "answerIndex": 1,
    "explanations": {
      "KO": "이미 산 물건을 다른 치수나 색상, 또는 다른 상품으로 맞바꾸는 것은 '교환(Exchange)'이에요!",
      "EN": "Swapping a purchased commodity for another size, color, or item is called '교환' (Exchange)!",
      "VI": "Việc đổi món đồ đã mua sang một kích cỡ, màu sắc hoặc sản phẩm khác gọi là '교환' (Đổi hàng)!",
      "ZH": "将已经购买的商品换成其他尺码、颜色或款式的行为称为'교환'（换货）！",
      "JA": "購入した品物を別のサイズや色、または別の品物と取り替えることは「교환（交換）」です！"
    }
  },
  # 558. 교통: 티머니
  {
    "id": 558,
    "category": "교통·길찾기·택시",
    "type": "word",
    "level": 1,
    "visual": "💳 🚌",
    "speechBubble": "전국 어디서나 티머니 카드로 대중교통을 타요.",
    "keyword": "티머니",
    "situations": {
      "KO": "한국의 지하철, 시내버스, 택시 요금을 단말기에 터치하여 결제하는 대표적인 충전식 교통카드 브랜드를 확인하는 상황입니다.",
      "EN": "Identifying Korea's popular rechargeable public transportation card brand used for subways, buses, and taxis.",
      "VI": "Nhận biết thương hiệu thẻ giao thông nạp tiền phổ biến tại Hàn Quốc dùng đi tàu điện ngầm, xe buýt và taxi.",
      "ZH": "确认在韩国搭乘地铁、市内公交和出租车时刷卡支付的主流充值型交通卡品牌。",
      "JA": "韓国の地下鉄、市内バス、タクシーに乗る際にタッチ決済する代表的な交通系ICカードを確認する場面です。"
    },
    "questions": {
      "KO": "가: 한국에서 지하철과 버스를 갈아탈 때 가장 편리하게 쓰는 대표적인 교통카드 이름이 뭐예요?\n나: 편의점이나 지하철역 자판기에서 쉽게 사서 충전해 쓰는 (   ) 카드예요."
    },
    "options": ["티머니", "하이패스", "신용장", "도서상품권"],
    "answerIndex": 0,
    "explanations": {
      "KO": "한국 전역의 대중교통 탑승과 편의점 결제에 널리 쓰이는 표준 선불 교통카드는 '티머니(T-money)'예요!",
      "EN": "The standard rechargeable transit card widely used across South Korea for buses and subways is '티머니' (T-money)!",
      "VI": "Thẻ giao thông trả trước tiêu chuẩn được sử dụng rộng rãi khắp Hàn Quốc là '티머니' (T-money)!",
      "ZH": "在韩国全境广泛用于搭乘公共交通和便利店小额支付的预付交通卡品牌是'티머니'（T-money卡）！",
      "JA": "韓国内の公共交通機関やコンビニ決済で広く使われている代表的なプリペイド交通カードは「티머니（T-money）」です！"
    }
  },
  # 559. 교통: 환승
  {
    "id": 559,
    "category": "교통·길찾기·택시",
    "type": "word",
    "level": 1,
    "visual": "🚏 🔄",
    "speechBubble": "지하철에서 버스로 환승 할인을 받아요.",
    "keyword": "환승",
    "situations": {
      "KO": "지하철에서 내린 뒤 30분 이내에 시내버스로 갈아타며 운임 할인 혜택을 받는 대중교통 환승 시스템을 이용하는 상황입니다.",
      "EN": "Transferring from the subway to a bus within 30 minutes to receive transit transfer discounts.",
      "VI": "Chuyển từ tàu điện ngầm sang xe buýt trong vòng 30 phút để được hưởng ưu đãi giảm giá chuyển tuyến.",
      "ZH": "从地铁出站后30分钟内换乘市内公交车，享受公共交通换乘优惠政策。",
      "JA": "地下鉄を降りて30分以内に市内バスに乗り換え、乗り換え割引の適用を受ける場面です。"
    },
    "questions": {
      "KO": "가: 지하철역에서 나와서 버스로 갈아타는데 추가 요금이 거의 안 나왔어요!\n나: 교통카드를 태그하고 30분 이내에 다른 노선으로 (   )하면 요금 할인 혜택이 적용돼요."
    },
    "options": ["출국", "환승", "주차", "견인"],
    "answerIndex": 1,
    "explanations": {
      "KO": "어떤 교통수단에서 내려 다른 교통수단이나 다른 노선으로 갈아타는 것을 '환승(Transfer)'이라고 해요!",
      "EN": "Transferring from one line or transit mode to another is called '환승' (Transfer)!",
      "VI": "Việc đổi từ tuyến xe này sang tuyến xe khác hoặc phương tiện khác gọi là '환승' (Chuyển tuyến / Đổi xe)!",
      "ZH": "从一种交通工具换乘到另一线路或工具的行为称为'환승'（换乘）！",
      "JA": "ある交通機関から降りて別の路線や乗り物に乗り換えることを「환승（乗り換え・乗換）」と言います！"
    }
  },
  # 560. 행정: 주민센터
  {
    "id": 560,
    "category": "배달·생활편의",
    "type": "word",
    "level": 1,
    "visual": "🏛️ 📋",
    "speechBubble": "동네 주민센터에서 서류를 발급받아요.",
    "keyword": "주민센터",
    "situations": {
      "KO": "이사 후 전입신고를 하거나 대형 폐기물 스티커를 발급받기 위해 가까운 동네 공공 행정복지센터를 찾는 상황입니다.",
      "EN": "Visiting the local community service center (Dong resident center) to file a move-in report or buy waste stickers.",
      "VI": "Đến trung tâm dịch vụ cộng đồng phường gần nhà để khai báo chuyển chỗ ở hoặc mua tem rác cồng kềnh.",
      "ZH": "搬家后前往附近的社区居民中心办理迁入申报或申领大型垃圾贴纸。",
      "JA": "引っ越し後に転入届を出したり粗大ゴミシールを購入するため地域の住民センターを訪れる場面です。"
    },
    "questions": {
      "KO": "가: 새집으로 이사했는데 주소 이전 신고(전입신고)는 어디에서 하나요?\n나: 새로 이사 간 동네를 관할하는 행정복지센터인 (   )에 신분증을 들고 가시면 돼요."
    },
    "options": ["경찰서", "주민센터", "소방서", "세무서"],
    "answerIndex": 1,
    "explanations": {
      "KO": "동네 주민들의 행정 민원, 전입신고, 복지 업무를 총괄 처리하는 기초 행정기관은 '주민센터(행정복지센터/Community center)'예요!",
      "EN": "The local administrative public office handling resident civil petitions and registrations is the '주민센터' (Community center)!",
      "VI": "Cơ quan hành chính địa phương xử lý các thủ tục cư trú và phúc lợi dân sự là '주민센터' (Ủy ban phường / Trung tâm dịch vụ dân cư)!",
      "ZH": "统筹处理辖区居民日常户籍、迁入申报等民事政务的基层机构是'주민센터'（社区居民中心/行政福利中心）！",
      "JA": "地域の住民の転入届や各種行政書類の発行を担う公的機関は「주민센터（住民センター・洞住民センター）」です！"
    }
  }
]

# Write to questions.json
with open('assets/data/questions.json', 'r', encoding='utf-8') as f:
    questions = json.load(f)

existing_ids = set(q['id'] for q in questions)
added = 0
for item in new_60:
    if item['id'] not in existing_ids:
        questions.append(item)
        added += 1

with open('assets/data/questions.json', 'w', encoding='utf-8') as f:
    json.dump(questions, f, ensure_ascii=False, indent=2)
    f.write('\n')

print(f"Added {added} questions. Total questions now: {len(questions)}")

