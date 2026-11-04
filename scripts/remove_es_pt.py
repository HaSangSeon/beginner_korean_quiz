"""Remove unused Spanish (ES) / Portuguese (PT) data. App supports KO, EN, VI, ZH, JA only."""
import json
import re

# 1. questions.json
p = 'assets/data/questions.json'
data = json.load(open(p, encoding='utf-8'))
for q in data:
    for f in ('situations', 'explanations'):
        q[f].pop('ES', None)
        q[f].pop('PT', None)
with open(p, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
    f.write('\n')

# 2. Single-line map entries in data files
for p in ('lib/data/hangul_data.dart', 'lib/data/survival_phrases_data.dart', 'lib/data/dialogue_data.dart'):
    src = open(p, encoding='utf-8').read()
    src = re.sub(r"^[ \t]*'(ES|PT)': .*,[ \t]*\r?\n", '', src, flags=re.M)
    open(p, 'w', encoding='utf-8').write(src)

# 3. switch cases: `case 'ES':` followed by a single return statement (may span lines until ';')
for p in ('lib/screens/quiz_screen.dart', 'lib/screens/result_screen.dart'):
    src = open(p, encoding='utf-8').read()
    src = re.sub(r"^[ \t]*case '(ES|PT)':[ \t]*\r?\n[ \t]*return [^;]*;[ \t]*\r?\n", '', src, flags=re.M)
    open(p, 'w', encoding='utf-8').write(src)

# 4. app_localization.dart: drop ES and PT blocks
p = 'lib/data/app_localization.dart'
src = open(p, encoding='utf-8').read()
src = re.sub(r"\r?\n[ \t]*// 6\. Spanish.*?(?=\r?\n  \};)", '', src, flags=re.S)
open(p, 'w', encoding='utf-8').write(src)

print('ES/PT removed.')

