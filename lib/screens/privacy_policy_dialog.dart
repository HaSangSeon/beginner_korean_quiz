import 'package:flutter/material.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  const PrivacyPolicyDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PrivacyPolicyDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shield_outlined, color: Color(0xFF3B82F6), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '개인정보처리방침 / Privacy Policy',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const Divider(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    '''[개인정보처리방침 (Privacy Policy)]

초급 한국어 퀴즈 (Beginner Korean Quiz)는 사용자의 개인정보를 매우 소중하게 생각하며, 이용자의 개인정보를 보호하기 위해 최선을 다하고 있습니다.

1. 수집하는 정보
본 앱은 별도의 회원가입 없이 이용할 수 있으며, 사용자의 성명, 전화번호, 이메일 등 개인을 식별할 수 있는 정보를 직접 수집하거나 서버에 저장하지 않습니다.
- 로컬 저장소: 학습 진행도, 오타 복습 목록, 즐겨찾기, 테마/언어 설정값은 전적으로 기기 내부(SharedPreferences)에만 저장됩니다.
- 광고 제공: Google AdMob SDK를 통해 개인 맞춤형 또는 비맞춤형 광고가 노출될 수 있으며, 광고 식별자(AD_ID) 및 쿠키 등이 사용될 수 있습니다.

2. 광고 식별자 및 타사 서비스
본 앱은 구글 애드몹(Google AdMob)을 사용합니다. Google의 개인정보 처리에 관한 자세한 사항은 Google 개인정보처리방침(https://policies.google.com/technologies/ads)을 참고하시기 바랍니다.

3. 데이터 삭제 및 관리
앱을 삭제(제거)할 경우 기기에 저장된 모든 로컬 학습 데이터는 즉시 영구 삭제됩니다.

4. 문의처 (Contact)
개인정보 보호와 관련된 문의사항이 있으시면 아래 연락처로 문의해 주시기 바랍니다.
- 이메일: hasangseon@gmail.com

---

[Privacy Policy (English)]

Beginner Korean Quiz ("the App") respects your privacy.
- No Personal Data Collected: The App does not require registration and does not collect or store any personally identifiable information (PII) on external servers.
- Local Storage: Your quiz progress, review items, bookmarks, and language/theme preferences are stored locally on your device only.
- Advertising: The App displays ads powered by Google AdMob. Google may use advertising IDs and related cookies to serve ads according to Google's Privacy & Terms.
- Contact: hasangseon@gmail.com
''',
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.55,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인 (Close)', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

