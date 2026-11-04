/// Utility to convert Korean Hangul text into standard Revised Romanization (국어의 로마자 표기법).
/// This provides complete beginners with phonetic reading aids while keeping the quiz 100% Korean.
class KoreanRomanizer {
  // Hangul Unicode Constants
  static const int _hangulBase = 0xAC00;
  static const int _hangulEnd = 0xD7A3;

  // 19 Initials (초성)
  static const List<String> _initials = [
    'g', 'kk', 'n', 'd', 'tt', 'r', 'm', 'b', 'pp', 's',
    'ss', '', 'j', 'jj', 'ch', 'k', 't', 'p', 'h'
  ];

  // 21 Medials (중성)
  static const List<String> _medials = [
    'a', 'ae', 'ya', 'yae', 'eo', 'e', 'yeo', 'ye', 'o', 'wa',
    'wae', 'oe', 'yo', 'u', 'wo', 'we', 'wi', 'yu', 'eu', 'ui', 'i'
  ];

  // 28 Finals (종성) - index 0 is no final consonant
  static const List<String> _finals = [
    '', 'k', 'k', 'k', 'n', 'n', 'n', 't', 'l', 'k',
    'm', 'p', 't', 't', 'p', 'l', 'm', 'p', 'p', 't',
    't', 'ng', 't', 't', 'k', 't', 'p', 't'
  ];

  /// Special standalone Jamo mapping (ㄱ, ㅏ, etc.)
  static const Map<String, String> _standaloneJamo = {
    'ㄱ': 'g', 'ㄲ': 'kk', 'ㄴ': 'n', 'ㄷ': 'd', 'ㄸ': 'tt',
    'ㄹ': 'r', 'ㅁ': 'm', 'ㅂ': 'b', 'ㅃ': 'pp', 'ㅅ': 's',
    'ㅆ': 'ss', 'ㅇ': 'ng', 'ㅈ': 'j', 'ㅉ': 'jj', 'ㅊ': 'ch',
    'ㅋ': 'k', 'ㅌ': 't', 'ㅍ': 'p', 'ㅎ': 'h',
    'ㅏ': 'a', 'ㅐ': 'ae', 'ㅑ': 'ya', 'ㅒ': 'yae', 'ㅓ': 'eo',
    'ㅔ': 'e', 'ㅕ': 'yeo', 'ㅖ': 'ye', 'ㅗ': 'o', 'ㅘ': 'wa',
    'ㅙ': 'wae', 'ㅚ': 'oe', 'ㅛ': 'yo', 'ㅜ': 'u', 'ㅝ': 'wo',
    'ㅞ': 'we', 'ㅟ': 'wi', 'ㅠ': 'yu', 'ㅡ': 'eu', 'ㅢ': 'ui', 'ㅣ': 'i',
  };

  /// Common frequent Korean expressions dictionary for 100% natural colloquial reading
  static const Map<String, String> _customWordMap = {
    '안녕하세요': 'annyeonghaseyo',
    '감사합니다': 'gamsahamnida',
    '고맙습니다': 'gomapseumnida',
    '죄송합니다': 'joesonghamnida',
    '미안합니다': 'mianhamnida',
    '실례합니다': 'sillyehamnida',
    '괜찮습니다': 'gwaenchanseumnida',
    '괜찮아요': 'gwaenchanayo',
    '얼마예요': 'eolmayeyo',
    '반갑습니다': 'bangapseumnida',
    '네': 'ne',
    '아니요': 'aniyo',
    '어디예요': 'eodiyeyo',
    '있어요': 'isseoyo',
    '없어요': 'eopseoyo',
    '주세요': 'juseyo',
    '어떻게': 'eotteoke',
    '맞아요': 'majayo',
    '좋아요': 'joayo',
    '싫어요': 'sireoyo',
  };

  /// Converts a Korean text string into Revised Romanization.
  /// Non-Hangul characters (punctuation, numbers, English, emojis) are preserved.
  static String romanize(String text) {
    if (text.isEmpty) return text;

    // Check whole string dictionary match first
    final trimmed = text.trim();
    if (_customWordMap.containsKey(trimmed)) {
      return text.replaceFirst(trimmed, _customWordMap[trimmed]!);
    }

    // Process contiguous Hangul syllable blocks at the word/token level
    // so punctuation (e.g. "있어요?") or surrounding text never breaks word-level rules.
    final buffer = StringBuffer();
    final chars = text.runes.toList();
    int i = 0;

    while (i < chars.length) {
      final code = chars[i];
      final charStr = String.fromCharCode(code);

      if (_standaloneJamo.containsKey(charStr)) {
        buffer.write(_standaloneJamo[charStr]);
        i++;
        continue;
      }

      if (code >= _hangulBase && code <= _hangulEnd) {
        int end = i + 1;
        while (end < chars.length &&
            chars[end] >= _hangulBase &&
            chars[end] <= _hangulEnd) {
          end++;
        }
        final wordRunes = chars.sublist(i, end);
        final wordStr = String.fromCharCodes(wordRunes);
        if (_customWordMap.containsKey(wordStr)) {
          buffer.write(_customWordMap[wordStr]);
        } else {
          buffer.write(_romanizeHangulWord(wordRunes));
        }
        i = end;
      } else {
        buffer.write(charStr);
        i++;
      }
    }

    return buffer.toString();
  }

  /// Romanizes a contiguous sequence of Hangul syllables [0xAC00..0xD7A3]
  /// with full Korean phonological rules (liaison/연음, nasalization/비음화,
  /// palatalization/구개음화, aspiration/격음화, liquidization/유음화, ㅎ-deletion).
  static String _romanizeHangulWord(List<int> runes) {
    final n = runes.length;
    final inits = List<int>.filled(n, 0);
    final meds = List<int>.filled(n, 0);
    final fins = List<int>.filled(n, 0);

    final initStrs = List<String>.filled(n, '');
    final medStrs = List<String>.filled(n, '');
    final finStrs = List<String>.filled(n, '');

    for (int i = 0; i < n; i++) {
      final syllableIndex = runes[i] - _hangulBase;
      inits[i] = syllableIndex ~/ (21 * 28);
      meds[i] = (syllableIndex % (21 * 28)) ~/ 28;
      fins[i] = syllableIndex % 28;

      initStrs[i] = _initials[inits[i]];
      medStrs[i] = _medials[meds[i]];
      finStrs[i] = _finals[fins[i]];
    }

    for (int i = 0; i < n - 1; i++) {
      final f = fins[i];
      final nextI = inits[i + 1];
      final nextM = meds[i + 1];

      if (f == 0) continue;

      // 1. Next syllable starts with 'ㅇ' (silent initial, index 11) -> Liaison (연음)
      if (nextI == 11) {
        switch (f) {
          case 1: // ㄱ -> g
            finStrs[i] = '';
            initStrs[i + 1] = 'g';
            break;
          case 2: // ㄲ -> kk
            finStrs[i] = '';
            initStrs[i + 1] = 'kk';
            break;
          case 3: // ㄳ -> k + s
            finStrs[i] = 'k';
            initStrs[i + 1] = 's';
            break;
          case 4: // ㄴ -> n
            finStrs[i] = '';
            initStrs[i + 1] = 'n';
            break;
          case 5: // ㄵ -> n + j
            finStrs[i] = 'n';
            initStrs[i + 1] = 'j';
            break;
          case 6: // ㄶ -> n (ㅎ silent before vowel)
            finStrs[i] = '';
            initStrs[i + 1] = 'n';
            break;
          case 7: // ㄷ -> j (before 이/여: 구개음화) or d
            finStrs[i] = '';
            initStrs[i + 1] = (nextM == 20 || nextM == 6) ? 'j' : 'd';
            break;
          case 8: // ㄹ -> r (e.g. 물이 -> muri)
            finStrs[i] = '';
            initStrs[i + 1] = 'r';
            break;
          case 9: // ㄺ -> l + g (e.g. 읽어요 -> ilgeoyo)
            finStrs[i] = 'l';
            initStrs[i + 1] = 'g';
            break;
          case 10: // ㄻ -> l + m (e.g. 삶이 -> salmi)
            finStrs[i] = 'l';
            initStrs[i + 1] = 'm';
            break;
          case 11: // ㄼ -> l + b (e.g. 넓은 -> neolbeun)
            finStrs[i] = 'l';
            initStrs[i + 1] = 'b';
            break;
          case 12: // ㄽ -> l + s
            finStrs[i] = 'l';
            initStrs[i + 1] = 's';
            break;
          case 13: // ㄾ -> l + ch (before 이) or l + t
            finStrs[i] = 'l';
            initStrs[i + 1] = (nextM == 20) ? 'ch' : 't';
            break;
          case 14: // ㄿ -> l + p
            finStrs[i] = 'l';
            initStrs[i + 1] = 'p';
            break;
          case 15: // ㅀ -> r (ㅎ silent before vowel: 싫어요 -> sireoyo)
            finStrs[i] = '';
            initStrs[i + 1] = 'r';
            break;
          case 16: // ㅁ -> m
            finStrs[i] = '';
            initStrs[i + 1] = 'm';
            break;
          case 17: // ㅂ -> b (e.g. 밥을 -> babeul)
            finStrs[i] = '';
            initStrs[i + 1] = 'b';
            break;
          case 18: // ㅄ -> p + s (e.g. 없어요 -> eopseoyo)
            finStrs[i] = 'p';
            initStrs[i + 1] = 's';
            break;
          case 19: // ㅅ -> s (e.g. 옷이 -> osi)
            finStrs[i] = '';
            initStrs[i + 1] = 's';
            break;
          case 20: // ㅆ -> ss (e.g. 있어요 -> isseoyo)
            finStrs[i] = '';
            initStrs[i + 1] = 'ss';
            break;
          case 21: // ㅇ -> stays ng
            finStrs[i] = 'ng';
            initStrs[i + 1] = '';
            break;
          case 22: // ㅈ -> j (e.g. 맞아요 -> majayo)
            finStrs[i] = '';
            initStrs[i + 1] = 'j';
            break;
          case 23: // ㅊ -> ch (e.g. 꽃이 -> kkochi)
            finStrs[i] = '';
            initStrs[i + 1] = 'ch';
            break;
          case 24: // ㅋ -> k
            finStrs[i] = '';
            initStrs[i + 1] = 'k';
            break;
          case 25: // ㅌ -> ch (before 이/여: 같이 -> gachi) or t
            finStrs[i] = '';
            initStrs[i + 1] = (nextM == 20 || nextM == 6) ? 'ch' : 't';
            break;
          case 26: // ㅍ -> p (e.g. 앞에 -> ape)
            finStrs[i] = '';
            initStrs[i + 1] = 'p';
            break;
          case 27: // ㅎ -> silent before vowel (e.g. 좋아요 -> joayo)
            finStrs[i] = '';
            initStrs[i + 1] = '';
            break;
        }
        continue;
      }

      // 2. Aspiration (격음화) when final has ㅎ (ㄶ:6, ㅀ:15, ㅎ:27) + next initial is ㄱ(0)/ㄷ(3)/ㅂ(7)/ㅈ(12)
      if ((f == 6 || f == 15 || f == 27) &&
          (nextI == 0 || nextI == 3 || nextI == 7 || nextI == 12)) {
        finStrs[i] = f == 6 ? 'n' : (f == 15 ? 'l' : '');
        if (nextI == 0) initStrs[i + 1] = 'k';
        if (nextI == 3) initStrs[i + 1] = 't';
        if (nextI == 7) initStrs[i + 1] = 'p';
        if (nextI == 12) initStrs[i + 1] = 'ch';
        continue;
      }

      // 3. Aspiration (격음화) when next initial is ㅎ(18)
      if (nextI == 18) {
        if (f == 1 || f == 2 || f == 24) {
          finStrs[i] = '';
          initStrs[i + 1] = 'k';
          continue;
        } else if (f == 9) {
          finStrs[i] = 'l';
          initStrs[i + 1] = 'k';
          continue;
        } else if (f == 7 || f == 19 || f == 20 || f == 22 || f == 23 || f == 25) {
          finStrs[i] = '';
          initStrs[i + 1] = (nextM == 20 || nextM == 6) ? 'ch' : 't';
          continue;
        } else if (f == 5) {
          finStrs[i] = 'n';
          initStrs[i + 1] = 'ch';
          continue;
        } else if (f == 17 || f == 26) {
          finStrs[i] = '';
          initStrs[i + 1] = 'p';
          continue;
        } else if (f == 11) {
          finStrs[i] = 'l';
          initStrs[i + 1] = 'p';
          continue;
        }
      }

      // 4. Liquidization (유음화): ㄴ+ㄹ -> ll, ㄹ+ㄴ -> ll
      if ((f == 4 && nextI == 5) || ((f == 8 || f == 15) && nextI == 2)) {
        finStrs[i] = 'l';
        initStrs[i + 1] = 'l';
        continue;
      }
      if (f == 8 && nextI == 5) {
        finStrs[i] = 'l';
        initStrs[i + 1] = 'l';
        continue;
      }

      // 5. Nasalization (비음화) before ㄴ(2) or ㅁ(6)
      if (nextI == 2 || nextI == 6) {
        if (f == 1 || f == 2 || f == 3 || f == 9 || f == 24) {
          finStrs[i] = 'ng';
        } else if (f == 7 || f == 19 || f == 20 || f == 22 || f == 23 || f == 25 || f == 27) {
          finStrs[i] = 'n';
        } else if (f == 11 || f == 14 || f == 17 || f == 18 || f == 26) {
          finStrs[i] = 'm';
        }
        continue;
      }

      // 6. Nasalization of ㄹ(5) after non-ㄹ finals (ㅁ/ㅇ/ㄱ/ㅂ + ㄹ -> n)
      if (nextI == 5) {
        if (f == 16 || f == 21) {
          initStrs[i + 1] = 'n';
        } else if (f == 1 || f == 2 || f == 24) {
          finStrs[i] = 'ng';
          initStrs[i + 1] = 'n';
        } else if (f == 17 || f == 26) {
          finStrs[i] = 'm';
          initStrs[i + 1] = 'n';
        }
      }
    }

    final out = StringBuffer();
    for (int i = 0; i < n; i++) {
      out.write(initStrs[i]);
      out.write(medStrs[i]);
      out.write(finStrs[i]);
    }
    return out.toString();
  }
}

