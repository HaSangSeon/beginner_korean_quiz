import 'package:flutter_test/flutter_test.dart';
import 'package:beginner_korean_quiz/utils/korean_romanizer.dart';

void main() {
  test('Korean Romanizer converts text accurately', () {
    expect(KoreanRomanizer.romanize('안녕하세요'), 'annyeonghaseyo');
    expect(KoreanRomanizer.romanize('감사합니다'), 'gamsahamnida');
    expect(KoreanRomanizer.romanize('커피 주세요'), 'keopi juseyo');
    expect(KoreanRomanizer.romanize('얼마예요?'), 'eolmayeyo?');
    expect(KoreanRomanizer.romanize('한글'), 'hangeul');
    expect(KoreanRomanizer.romanize('물'), 'mul');
    expect(KoreanRomanizer.romanize('가방'), 'gabang');
  });
}

