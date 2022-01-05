import 'dart:io';
import 'package:e_wallet/app/data/utils/usable_strings.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  int maxFailedLoadAttempts = 3;
  int _numRewardedLoadAttempts = 0;

  static String get bannerHomeAdUnitId => Platform.isAndroid
      ? UsableStrings.bannerHomeAdUnitID
      : UsableStrings.bannerHomeAdUnitID;

  static String get bannerMoreAdUnitId => Platform.isAndroid
      ? UsableStrings.bannerMoreAdUnitID
      : UsableStrings.bannerMoreAdUnitID;

  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;

  int numOfAttempLoad = 0;

  static initialize() {
    MobileAds.instance.initialize();
  }

  static void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }

  static BannerAd createHomeBannerAd() {
    BannerAd ad = BannerAd(
        size: AdSize.largeBanner,
        adUnitId: bannerHomeAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) => {},
          // print('Ad loaded'),
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
          onAdOpened: (Ad ad) => {},
          // print('Ad opened'),
          onAdClosed: (Ad ad) => {},
          // print('On Ad closed')
        ),
        request: const AdRequest());

    return ad;
  }

  static BannerAd createMoreBannerAd() {
    BannerAd ad = BannerAd(
        size: AdSize.largeBanner,
        adUnitId: bannerHomeAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) => {},
          // print('Ad loaded'),
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
          onAdOpened: (Ad ad) => {},
          // print('Ad opened'),
          onAdClosed: (Ad ad) => {},
          // print('On Ad closed')
        ),
        request: const AdRequest());

    return ad;
  }

// 2 mthods, one is to create the ad and the next is to show the ad
  void createInterAd() {
    InterstitialAd.load(
      adUnitId: UsableStrings.interstitialAdUnitID,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          print('intertitial ad loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('intertitial ad load error - $error');
        },
      ),
    );
  }

  void showInterad() {
    if (_interstitialAd == null) {
      print('intertitial ad error');
      return;
    } else {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          print("ad onAdshowedFullscreen");
        },
        onAdWillDismissFullScreenContent: (InterstitialAd ad) {
          print("ad Disposed");
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent:
            (InterstitialAd ad, AdError aderror) {
          print("$ad OnAdFailed $aderror");
          ad.dispose();
          createInterAd();
        },
      );
      _interstitialAd?.show();
    }
  }

  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: UsableStrings.rewardedAdUnitID,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            // print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              createRewardedAd();
            }
          },
        ));
  }

  void showRewardedAd() {
    if (_rewardedAd == null) {
      // print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => {},
      // print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        // print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        // print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      // print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    _rewardedAd = null;
  }
}
