var argscheck = require('cordova/argscheck'),
    exec = require('cordova/exec');

var admobExport = {};

/**
 * This enum represents appfeel-cordova-admob plugin events
 */
admobExport.events = {
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
admobExport.AD_SIZE = {
  BANNER: 'BANNER',
  IAB_MRECT: 'IAB_MRECT',
  IAB_BANNER: 'IAB_BANNER',
  IAB_LEADERBOARD: 'IAB_LEADERBOARD',
  SMART_BANNER: 'SMART_BANNER'
};

admobExport.options = {
  publisherId : "ca-app-pub-8440343014846849/6338199818",
  interstitialId : "ca-app-pub-8440343014846849/9791193812",
  adSize : admobExport.AD_SIZE.SMART_BANNER,
  bannerAtTop : false,
  overlap : false,
  offsetStatusBar : false,
  isTesting : false,
  adExtras : {},
  autoShow : true,
};

/**
 * Initialize appfeel-cordova-admob plugin with options:
 * @param {!Object}    options         AdMob options (use admob.options as template)
 * @param {function()} successCallback Callback on success
 * @param {function()} failureCallback Callback on fail
 */
admobExport.setOptions = function (options, successCallback, failureCallback) {
  if (typeof options === 'function') {
    failureCallback = successCallback;
    successCallback = options;
    options = undefined;
  }
  
  options = options || admobExport.DEFAULT_OPTIONS;
  
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
admobExport.createBannerView = function (options, successCallback, failureCallback) {
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
admobExport.showBannerAd = function (show, successCallback, failureCallback) {
  if (show === undefined) {
    show = true;
  }
  cordova.exec(successCallback, failureCallback, 'AdMobAds', 'showBannerAd', [ show ]);
};

/**
 * Hides and destroys the banner view. CreateBanner should be called if new ads were to be shown.
 * @param {function()} successCallback The function to call if the view was destroyed successfully.
 * @param {function()} failureCallback The function to call if failed to destroy view.
 */
admobExport.destroyBannerView = function (successCallback, failureCallback) {
  cordova.exec(successCallback, failureCallback, 'AdMobAds', 'destroyBannerView', []);
};

/**
 * Request an AdMob interstitial ad.
 *
 * @param {!Object}    options         The options used to request an ad. (use admob.options as template)
 * @param {function()} successCallback The function to call if an ad was requested successfully.
 * @param {function()} failureCallback The function to call if an ad failed to be requested.
 */
admobExport.requestInterstitialAd = function (options, successCallback, failureCallback) {
  options = options || {};
  cordova.exec(successCallback, failureCallback, 'AdMobAds', 'requestInterstitialAd', [ options ]);
};

/**
 * Shows an interstitial ad. This function should be called when onAdLoaded occurred.
 *
 * @param {function()} successCallback The function to call if the ad was shown successfully.
 * @param {function()} failureCallback The function to call if the ad failed to be shown.
 */
admobExport.showInterstitialAd = function (successCallback, failureCallback) {
  cordova.exec(successCallback, failureCallback, 'AdMobAds', 'showInterstitialAd', []);
};

module.exports = admobExport;
