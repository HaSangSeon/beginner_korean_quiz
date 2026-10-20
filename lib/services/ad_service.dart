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

  /// Returns the appropriate ad unit ID (Test ID in debug, Real ID in release)
  static String get bannerAdUnitId {
    if (kReleaseMode) {
      return realAndroidBannerAdUnitId;
    }
    return testAndroidBannerAdUnitId;
  }

  /// Initialize Google Mobile Ads SDK
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
    } catch (e) {
      debugPrint('AdMob initialization error: $e');
    }
  }
}

/// A clean, self-contained bottom banner ad widget with 100% full width and 0 margins
class BottomBannerAdWidget extends StatefulWidget {
  const BottomBannerAdWidget({super.key});

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
    if (!_isAdLoading && _bannerAd == null) {
      _loadBannerAd();
    }
  }

  Future<void> _loadBannerAd() async {
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
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final adHeight = _bannerAd!.size.height.toDouble();
    // 3버튼 내비게이션 바(홈/뒤로가기) 및 제스처 바 인셋 자동 감지
    final bottomInset = MediaQuery.paddingOf(context).bottom;

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
