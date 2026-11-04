import json
import re

PATH = 'assets/data/questions.json'

with open(PATH, 'r', encoding='utf-8') as f:
    questions = json.load(f)

# 1. Issue 1: Q#408 blank addition
for q in questions:
    if q['id'] == 408:
        q['questions']['KO'] = "가: 버스를 탈 때 카드를 찍었는데 '잔액이 부족합니다'라고 나와요. 지금 (   ).\n나: 카드에 충전된 돈이 다 떨어진 거예요. 편의점에서 충전하세요."
        print("Updated Q#408 with blank.")

# 2. Issue 2: Q#169~184 trailing period removal
for q in questions:
    if 169 <= q['id'] <= 184:
        # Strip trailing period from options
        q['options'] = [opt.rstrip('.') for opt in q['options']]
        # Strip trailing period from chips if present
        if q.get('chips'):
            q['chips'] = [chip.rstrip('.') for chip in q['chips']]
        print(f"Cleaned periods in Q#{q['id']}")

# 3. Issue 3: Q#213~216, Q#237~250 dialogue improvement
new_dialogues = {
    213: "가: 베이커리 조각 케이크 위에 예쁘게 올려진 빨갛고 달콤한 과일은 뭐예요?\n나: 상큼하고 맛있는 (   )입니다.",
    214: "가: 하늘을 날아서 멀리 해외 여행을 갈 때 타는 교통수단은 뭐예요?\n나: 날개가 크고 빠른 (   )입니다.",
    215: "가: 하루 일과를 마치고 포근한 이불 속에서 잠을 자는 가구는 뭐예요?\n나: 안방에 있는 편안한 (   )입니다.",
    216: "가: 바깥에 갑자기 비가 많이 쏟아져요. 젖지 않으려면 뭘 써야 해요?\n나: 가방에 챙겨둔 접이식 (   )입니다.",
    237: "가: 가을에 수확하는 붉고 아삭아삭해서 아침에 먹으면 좋은 과일은 뭐예요?\n나: 비타민이 풍부한 (   )입니다.",
    238: "가: 젖소에서 얻은 하얗고 고소해서 시리얼에 부어 먹는 건강 음료는 뭐예요?\n나: 냉장고에 있는 신선한 (   )입니다.",
    239: "가: 아름다운 풍경을 바라보고 책을 읽을 수 있게 해 주는 얼굴 부위는 어디예요?\n나: 세상을 맑게 보는 (   )입니다.",
    240: "가: 다섯 개 손가락으로 연필을 잡고 글씨를 쓸 때 사용하는 신체 부위는 어디예요?\n나: 장갑을 끼는 따뜻한 (   )입니다.",
    241: "가: 외출할 때 발을 다치지 않게 양말 위에 신는 것은 뭐예요?\n나: 현관에 가지런히 놓인 (   )입니다.",
    242: "가: 뜨거운 햇빛을 막아주고 머리에 가볍게 얹어 쓰는 패션 소품은 뭐예요?\n나: 챙이 달려 있는 예쁜 (   )입니다.",
    243: "가: 봄이 오면 가지마다 알록달록 피어나 달콤한 향기를 풍기는 것은 뭐예요?\n나: 정원에 화사하게 핀 (   )입니다.",
    244: "가: 숲과 공원에서 푸른 잎으로 시원한 그늘을 만들어 주는 키 큰 식물은 뭐예요?\n나: 튼튼한 기둥을 가진 (   )입니다.",
    245: "가: 매일 주머니에 넣고 다니며 전화, 메시지, 인터넷 검색을 하는 기기는 뭐예요?\n나: 손안의 작은 컴퓨터인 (   )입니다.",
    246: "가: 정류장에서 많은 사람이 차례대로 줄을 서서 교통카드를 찍고 타는 대중교통은 뭐예요?\n나: 도로 위를 달리는 (   )입니다.",
    247: "가: 다리를 굽히거나 펼 때 접히는 허벅지와 종아리 사이 관절은 어디예요?\n나: 걷거나 앉을 때 꼭 필요한 (   )입니다.",
    248: "가: 목과 팔 사이에 위치해서 무거운 배낭을 멜 때 끈을 걸치는 부위는 어디예요?\n나: 반듯하고 듬직한 (   )입니다.",
    249: "가: 상체와 하체의 중심을 잡아주고 바지가 흘러내리지 않게 벨트를 매는 부위는 어디예요?\n나: 몸을 곧게 세워 주는 (   )입니다.",
    250: "가: 이어폰을 꽂고 신나는 K-POP 음악이나 친구 목소리를 듣는 기관은 어디예요?\n나: 머리 양옆에 있는 (   )입니다.",
}

for q in questions:
    if q['id'] in new_dialogues:
        q['questions']['KO'] = new_dialogues[q['id']]
        print(f"Updated natural dialogue in Q#{q['id']}")

with open(PATH, 'w', encoding='utf-8') as f:
    json.dump(questions, f, ensure_ascii=False, indent=2)
    f.write('\n')

print("Issues 1, 2, 3 applied successfully!")

