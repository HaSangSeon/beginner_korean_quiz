import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;

  /// Real AdMob IDs
  static const String realAndroidAppId = 'ca-app-pub-3702899361747571~5271747122';
  static const String realAndroidBannerAdUnitId = 'ca-app-pub-3702899361747571/7963902802';

  /// Google Official Test Ad Unit ID (Prevents account suspension during testing)
  static const String testAndroidBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  /// 스토어 스크린샷 촬영용 임시 플래그 (true: 광고 배너 완전 숨김, false: 정상 표시)
  static const bool hideBannerForScreenshot = false;

  /// Returns the appropriate ad unit ID (Test ID in debug, Real ID in release)
  static String get bannerAdUnitId {
    if (kReleaseMode) {
      return realAndroidBannerAdUnitId;
    }
    return testAndroidBannerAdUnitId;
  }

  /// Initialize Google Mobile Ads SDK with UMP (User Messaging Platform) Consent
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () async {
          ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) async {
            if (error != null) {
              debugPrint('Consent form error: ${error.message}');
            }
            if (await ConsentInformation.instance.canRequestAds()) {
              await _initMobileAds();
            }
          });
        },
        (FormError error) async {
          debugPrint('Consent info update error: ${error.message}');
          await _initMobileAds();
        },
      );
      
      // Fallback: If consent takes too long or already determined
      if (await ConsentInformation.instance.canRequestAds()) {
        await _initMobileAds();
      }
    } catch (e) {
      debugPrint('AdMob initialization error: $e');
      await _initMobileAds();
    }
  }

  Future<void> _initMobileAds() async {
    if (_isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
    } catch (e) {
      debugPrint('MobileAds initialize error: $e');
    }
  }
}

/// A clean, self-contained bottom banner ad widget with 100% full width and 0 margins
class BottomBannerAdWidget extends StatefulWidget {
  final void Function(bool isLoaded)? onLoadedChanged;
  final bool fillSafeAreaWhenEmpty;

  const BottomBannerAdWidget({
    super.key,
    this.onLoadedChanged,
    this.fillSafeAreaWhenEmpty = false,
  });

  @override
  State<BottomBannerAdWidget> createState() => _BottomBannerAdWidgetState();
}

class _BottomBannerAdWidgetState extends State<BottomBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isAdLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AdService.hideBannerForScreenshot) return;
    if (!_isAdLoading && _bannerAd == null) {
      _loadBannerAd();
    }
  }

  @override
  void didUpdateWidget(covariant BottomBannerAdWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (AdService.hideBannerForScreenshot) return;
    if (oldWidget.onLoadedChanged != widget.onLoadedChanged) {
      widget.onLoadedChanged?.call(_isLoaded && _bannerAd != null);
    }
  }

  Future<void> _loadBannerAd() async {
    if (AdService.hideBannerForScreenshot) return;
    _isAdLoading = true;
    final deviceWidth = MediaQuery.sizeOf(context).width.truncate();

    // ignore: deprecated_member_use
    final adaptiveSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(deviceWidth);
    final adSize = adaptiveSize ?? AdSize(width: deviceWidth, height: 50);

    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
            widget.onLoadedChanged?.call(true);
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
              _isLoaded = false;
            });
            widget.onLoadedChanged?.call(false);
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 스토어 스크린샷 촬영 모드: 배너 광고 완전 제거
    if (AdService.hideBannerForScreenshot) {
      return const SizedBox.shrink();
    }

    // 3버튼 내비게이션 바(홈/뒤로가기/최근앱) 및 제스처 바 인셋 정밀 감지 (삼성 갤럭시 포함 모든 안드로이드 기기 완벽 대응)
    final bottomInset = math.max(
      MediaQuery.paddingOf(context).bottom,
      MediaQuery.viewPaddingOf(context).bottom,
    );

    if (!_isLoaded || _bannerAd == null) {
      if (widget.fillSafeAreaWhenEmpty && bottomInset > 0) {
        return SizedBox(height: bottomInset);
      }
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final adHeight = _bannerAd!.size.height.toDouble();

    return Container(
      width: double.infinity, // 가로 100% 꽉 채우기
      height: adHeight + bottomInset,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(bottom: bottomInset),
      alignment: Alignment.topCenter,
      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width, // 화면 가로 100% 밀착
        height: adHeight,
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
