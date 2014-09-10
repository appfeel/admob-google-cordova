var argscheck = require('cordova/argscheck'),
    exec = require('cordova/exec');

var admob = module.exports;

/**
 * This enum represents appfeel-cordova-admob plugin events
 */
admob.events = {
  onAdLoaded : "appfeel.cordova.admob.onAdLoaded",
  onAdFailedToLoad : "appfeel.cordova.admob.onAdFailedToLoad",
  onAdOpened : "appfeel.cordova.admob.onAdOpened",
  onAdLeftApplication : "appfeel.cordova.admob.onAdLeftApplication",
  onAdClosed : "appfeel.cordova.admob.onAdClosed",
  onInAppPurchaseRequested : "appfeel.cordova.admob.onInAppPurchaseRequested",
};

/**
 * This enum represents AdMob's supported ad sizes.  Use one of these
 * constants as the adSize when calling createBannerView.
 * @const
 */
admob.AD_SIZE = {
  BANNER: 'BANNER',
  IAB_MRECT: 'IAB_MRECT',
  IAB_BANNER: 'IAB_BANNER',
  IAB_LEADERBOARD: 'IAB_LEADERBOARD',
  SMART_BANNER: 'SMART_BANNER'
};

admob.AD_TYPE = {
  BANNER: 'banner',
  INTERSTITIAL: 'interstitial'
};

admob.PURCHASE_RESOLUTION = {
  RESOLUTION_CANCELED: 2,
  RESOLUTION_FAILURE: 0,
  RESOLUTION_INVALID_PRODUCT: 3,
  RESOLUTION_SUCCESS: 1
};

admob.options = {
  publisherId : "ca-app-pub-8440343014846849/3119840614",
  interstitialId : "ca-app-pub-8440343014846849/4596573817",
  adSize : admob.AD_SIZE.SMART_BANNER,
  bannerAtTop : false,
  overlap : false,
  offsetStatusBar : false,
  isTesting : false,
  adExtras : {},
  autoShowBanner : true,
  autoShowInterstitial: true
};

/**
 * Initialize appfeel-cordova-admob plugin with options:
 * @param {!Object}    options         AdMob options (use admob.options as template)
 * @param {function()} successCallback Callback on success
 * @param {function()} failureCallback Callback on fail
 */
admob.setOptions = function (options, successCallback, failureCallback) {
  if (typeof options === 'function') {
    failureCallback = successCallback;
    successCallback = options;
    options = undefined;
  }
  
  options = options || admob.DEFAULT_OPTIONS;
  
  if (typeof options === 'object' && typeof options.publisherId === 'string' && options.publisherId.length > 0) {
    cordova.exec(successCallback, failureCallback, 'AdMobAds', 'setOptions', [options]);
    
  } else {
    if (typeof failureCallback === 'function') {
      failureCallback('options.publisherId should be specified.')
    }
  }
};

/**
 * Creates a new AdMob banner view.
 *
 * @param {!Object}    options         The options used to create a banner. (use admob.options as template)
 * @param {function()} successCallback The function to call if the banner was created successfully.
 * @param {function()} failureCallback The function to call if create banner  was unsuccessful.
 */
admob.createBannerView = function (options, successCallback, failureCallback) {
  if (typeof options === 'function') {
    failureCallback = successCallback;
    successCallback = options;
    options = undefined;
  }
  options = options || {};
  cordova.exec(successCallback, failureCallback, 'AdMobAds', 'createBannerView', [ options ]);
};

/*
 * Show or hide Ad.
 * 
 * @param {boolean} show true to show, false to hide.  
 * @param {function()} successCallback The function to call if the ad was shown successfully.
 * @param {function()} failureCallback The function to call if the ad failed to be shown.
 */
admob.showBannerAd = function (show, successCallback, failureCallback) {
  if (show === undefined) {
    show = true;
    
  } else if (typeof show === 'function') {
    failureCallback = successCallback;
    successCallback = show;
    show = true;
  }
  cordova.exec(successCallback, failureCallback, 'AdMobAds', 'showBannerAd', [ show ]);
};

/**
 * Hides and destroys the banner view. CreateBanner should be called if new ads were to be shown.
 * @param {function()} successCallback The function to call if the view was destroyed successfully.
 * @param {function()} failureCallback The function to call if failed to destroy view.
 */
admob.destroyBannerView = function (successCallback, failureCallback) {
  cordova.exec(successCallback, failureCallback, 'AdMobAds', 'destroyBannerView', []);
};

/**
 * Request an AdMob interstitial ad.
 *
 * @param {!Object}    options         The options used to request an ad. (use admob.options as template)
 * @param {function()} successCallback The function to call if an ad was requested successfully.
 * @param {function()} failureCallback The function to call if an ad failed to be requested.
 */
admob.requestInterstitialAd = function (options, successCallback, failureCallback) {
  if (typeof options === 'function') {
    failureCallback = successCallback;
    successCallback = options;
    options = undefined;
  }
  options = options || {};
  cordova.exec(successCallback, failureCallback, 'AdMobAds', 'requestInterstitialAd', [ options ]);
};

/**
 * Shows an interstitial ad. This function should be called when onAdLoaded occurred.
 *
 * @param {function()} successCallback The function to call if the ad was shown successfully.
 * @param {function()} failureCallback The function to call if the ad failed to be shown.
 */
admob.showInterstitialAd = function (successCallback, failureCallback) {
  cordova.exec(successCallback, failureCallback, 'AdMobAds', 'showInterstitialAd', []);
};

/**
 * Records a resolution after an inAppPurchase.
 *
 * @param {Integer}    purchaseId      The id of the purchase.
 * @param {Integer}    resolution      The resolution code.
 * @param {function()} successCallback The function to call if the ad was shown successfully.
 * @param {function()} successCallback The function to call if the ad was shown successfully.
 * @param {function()} failureCallback The function to call if the ad failed to be shown.
 */
admob.recordResolution = function (purchaseId, resolution, successCallback, failureCallback) {
  if (purchaseId === undefined || resolution === undefined) {
    if (typeof failureCallback === 'function') {
      failureCallback('purchaseId and resolution should be specified.')
    }
  }
  cordova.exec(successCallback, failureCallback, 'AdMobAds', 'recordResolution', [ purchaseId, resolution ]);
};

/**
 * Records a resolution after an inAppPurchase.
 *
 * @param {Integer}    purchaseId           The id of the purchase.
 * @param {Integer}    billingResponseCode  The resolution code.
 * @param {function()} successCallback      The function to call if the ad was shown successfully.
 * @param {function()} successCallback      The function to call if the ad was shown successfully.
 * @param {function()} failureCallback      The function to call if the ad failed to be shown.
 */
admob.recordPlayBillingResolution = function (purchaseId, billingResponseCode, successCallback, failureCallback) {
  if (purchaseId === undefined || billingResponseCode === undefined) {
    if (typeof failureCallback === 'function') {
      failureCallback('purchaseId and billingResponseCode should be specified.')
    }
  }
  cordova.exec(successCallback, failureCallback, 'AdMobAds', 'recordResolution', [ purchaseId, billingResponseCode ]);
};
