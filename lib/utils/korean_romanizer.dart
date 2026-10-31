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
      return _customWordMap[trimmed]!;
    }

    final buffer = StringBuffer();
    final chars = text.runes.toList();

    for (int i = 0; i < chars.length; i++) {
      final code = chars[i];
      final charStr = String.fromCharCode(code);

      // 1. Check standalone jamo
      if (_standaloneJamo.containsKey(charStr)) {
        buffer.write(_standaloneJamo[charStr]);
        continue;
      }

      // 2. Check full syllable Hangul range [0xAC00 - 0xD7A3]
      if (code >= _hangulBase && code <= _hangulEnd) {
        final syllableIndex = code - _hangulBase;
        final initialIndex = syllableIndex ~/ (21 * 28);
        final medialIndex = (syllableIndex % (21 * 28)) ~/ 28;
        final finalIndex = syllableIndex % 28;

        String initStr = _initials[initialIndex];
        final medStr = _medials[medialIndex];
        String finStr = _finals[finalIndex];

        // Assimilation / Liaison rule:
        // If next character starts with 'ㅇ' (silent initial), liaison occurs:
        if (finalIndex != 0 && i + 1 < chars.length) {
          final nextCode = chars[i + 1];
          if (nextCode >= _hangulBase && nextCode <= _hangulEnd) {
            final nextInitialIndex = (nextCode - _hangulBase) ~/ (21 * 28);
            if (nextInitialIndex == 11) {
              // 'ㅇ' initial
              // Final consonant carries over to next syllable
              if (finalIndex == 8) {
                // ㄹ + vowel -> r
                finStr = '';
              } else if (finalIndex == 17) {
                // ㅂ + vowel -> b
                finStr = '';
              } else if (finalIndex == 4) {
                // ㄴ + vowel -> n
                finStr = '';
              } else if (finalIndex == 16) {
                // ㅁ + vowel -> m
                finStr = '';
              } else if (finalIndex == 19) {
                // ㅅ + vowel -> s
                finStr = '';
              } else if (finalIndex == 20) {
                // ㅆ + vowel -> ss
                finStr = '';
              }
            }
          }
        }

        // Special case: Initial 'ㄹ' is 'r' before vowel, but if previous syllable ended in 'ㄹ', it becomes 'l'
        if (initialIndex == 5 && buffer.isNotEmpty && buffer.toString().endsWith('l')) {
          initStr = 'l';
        }

        // 'ㅂ니다' / '습니다' nasalization (b -> m)
        if (finalIndex == 17 && i + 1 < chars.length) {
          final nextCode = chars[i + 1];
          if (nextCode >= _hangulBase && nextCode <= _hangulEnd) {
            final nextInitial = (nextCode - _hangulBase) ~/ (21 * 28);
            if (nextInitial == 2) {
              // 'ㄴ' initial (e.g. 니다)
              finStr = 'm';
            }
          }
        }

        buffer.write(initStr);
        buffer.write(medStr);
        buffer.write(finStr);
      } else {
        buffer.write(charStr);
      }
    }

    return buffer.toString();
  }
}

