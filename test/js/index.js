var app = {
  // global vars
  showNextInterstitialInterval: undefined,
  // Application Constructor
  initialize: function () {
    this.bindEvents();
  },
  // Bind Event Listeners
  bindEvents: function () {
    if (( /(ipad|iphone|ipod|android)/i.test(navigator.userAgent) )) {
      document.addEventListener('deviceready', this.onDeviceReady, false);
    } else {
      this.onDeviceReady();
    }
    document.addEventListener(admob.events.onAdLoaded, this.onAdLoaded, false);
    document.addEventListener(admob.events.onAdFailedToLoad, function (e) {}, false);
    document.addEventListener(admob.events.onAdOpened, function (e) {}, false);
    document.addEventListener(admob.events.onAdClosed, function (e) {}, false);
    document.addEventListener(admob.events.onAdLeftApplication, function (e) {}, false);
    document.addEventListener(admob.events.onInAppPurchaseRequested, function (e) {}, false);
  },
  // deviceready Event Handler
  //
  // The scope of 'this' is the event. In order to call the 'receivedEvent'
  // function, we must explicitly call 'app.receivedEvent(...);'
  onDeviceReady: function () {
    document.removeEventListener('deviceready', app.onDeviceReady, false);
    app.initAds();
  },
  onAdLoaded: function (e) {
    if (e.adType === admob.AD_TYPE.INTERSTITIAL) {
      admob.showInterstitialAd();
      if (app.showNextInterstitialInterval === undefined) {
        app.showNextInterstitialInterval = setInterval(function() {
          admob.requestInterstitialAd();
        }, 2 * 60 * 1000); // 2 minutes
      }
    }
  },
  initAds: function () {
    if (admob) {
      var isAndroid = (/(android)/i.test(navigator.userAgent));
      var adPublisherIds = {
        ios : {
          banner: 'ca-app-pub-8440343014846849/7078073011',
          interstitial: 'ca-app-pub-8440343014846849/8554806210'
        },
        android : {
          banner: 'ca-app-pub-8440343014846849/6338199818',
          interstitial: 'ca-app-pub-8440343014846849/9791193812'
        }
      };

      var admobid;
      if (isAndroid) {
        admobid = adPublisherIds.android;
      } else {
        admobid = adPublisherIds.ios;
      }

      admob.setOptions({
        publisherId: admobid.banner,
        interstitialAdId: admobid.interstitial,
        bannerAtTop: false, // set to true, to put banner at top
        overlap: false, // set to true, to allow banner overlap webview
        offsetTopBar: false, // set to true to avoid ios7 status bar overlap
        isTesting: false, // receiving test ads (do not test with real ads as your account will be banned)
        autoShowBanner: true, // auto show banners ad when loaded
        autoShowInterstitial: true // auto show interstitials ad when loaded
      });

      registerAdEvents();

    } else {
      alert('AdMobAds plugin not ready');
    }
  },
  onResize: function () {
    var msg = 'Web view size: ' + window.innerWidth + ' x ' + window.innerHeight;
    document.getElementById('sizeinfo').innerHTML = msg;
  }
};