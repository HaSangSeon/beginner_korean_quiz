import json
import urllib.request
import urllib.parse
import time
from concurrent.futures import ThreadPoolExecutor

PATH = 'assets/data/questions.json'

def fetch_translation(text, target_lang):
    if not text.strip():
        return ""
    url = f'https://translate.googleapis.com/translate_a/single?client=gtx&sl=ko&tl={target_lang}&dt=t&q=' + urllib.parse.quote(text)
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=12) as res:
                data = json.loads(res.read().decode('utf-8'))
                return ''.join([part[0] for part in data[0] if part[0]])
        except Exception as e:
            time.sleep(1)
            if attempt == 2:
                print(f"Failed to translate to {target_lang}: {text[:30]} ({e})")
                return text

def process_question(q):
    qid = q['id']
    ans = q['options'][q['answerIndex']]
    sit_ko = q['situations']['KO']
    expl_ko = q['explanations']['KO']

    lang_map = {
        'EN': 'en',
        'VI': 'vi',
        'ZH': 'zh-CN',
        'JA': 'ja'
    }

    results = {'id': qid, 'situations': {}, 'explanations': {}}

    for code, tl in lang_map.items():
        sit_trans = fetch_translation(sit_ko, tl)
        expl_trans = fetch_translation(expl_ko, tl)

        # Ensure the Korean answer is clearly linked in the explanation if not already present
        if ans not in expl_trans:
            if code in ['ZH', 'JA']:
                expl_trans = f"{expl_trans}（'{ans}'）"
            else:
                expl_trans = f"{expl_trans} ('{ans}')"

        results['situations'][code] = sit_trans
        results['explanations'][code] = expl_trans

    return results

def main():
    with open(PATH, 'r', encoding='utf-8') as f:
        questions = json.load(f)

    target_qs = [q for q in questions if 321 <= q['id'] <= 500]
    print(f"Starting translation for {len(target_qs)} questions (IDs 321-500)...")

    t0 = time.time()
    with ThreadPoolExecutor(max_workers=15) as executor:
        results = list(executor.map(process_question, target_qs))

    res_by_id = {r['id']: r for r in results}

    for q in questions:
        if q['id'] in res_by_id:
            r = res_by_id[q['id']]
            for code in ['EN', 'VI', 'ZH', 'JA']:
                q['situations'][code] = r['situations'][code]
                q['explanations'][code] = r['explanations'][code]

    with open(PATH, 'w', encoding='utf-8') as f:
        json.dump(questions, f, ensure_ascii=False, indent=2)
        f.write('\n')

    print(f"Successfully localized 180 questions in {time.time()-t0:.2f}s!")

if __name__ == '__main__':
    main()

