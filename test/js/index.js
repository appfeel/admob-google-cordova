var app = {
  // global vars
  autoShowInterstitial: false,
  
  // Application Constructor
  initialize: function () {
    if (( /(ipad|iphone|ipod|android)/i.test(navigator.userAgent) )) {
      document.addEventListener('deviceready', this.onDeviceReady, false);
    } else {
      app.onDeviceReady();
    }
  },
  // Must be called when deviceready is fired so AdMobAds plugin will be ready
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
        bannerAtTop: true, // set to true, to put banner at top
        overlap: false, // set to true, to allow banner overlap webview
        offsetStatusBar: true, // set to true to avoid ios7 status bar overlap
        isTesting: true, // receiving test ads (do not test with real ads as your account will be banned)
        autoShowBanner: true, // auto show banners ad when loaded
        autoShowInterstitial: false // auto show interstitials ad when loaded
      });

    } else {
      alert('AdMobAds plugin not ready');
    }
  },
  // Bind Event Listeners
  bindEvents: function () {
    document.addEventListener("orientationchange", this.onOrientationChange, false);
    document.addEventListener(admob.events.onAdLoaded, this.onAdLoaded, false);
    document.addEventListener(admob.events.onAdFailedToLoad, this.onAdFailedToLoad, false);
    document.addEventListener(admob.events.onAdOpened, function (e) {}, false);
    document.addEventListener(admob.events.onAdClosed, function (e) {}, false);
    document.addEventListener(admob.events.onAdLeftApplication, function (e) {}, false);
    document.addEventListener(admob.events.onInAppPurchaseRequested, function (e) {}, false);
  },
  
  // -----------------------------------
  // Events.
  // The scope of 'this' is the event.
  // -----------------------------------
  onOrientationChange: function () {
    app.onResize();
  },
  onDeviceReady: function () {
    document.removeEventListener('deviceready', app.onDeviceReady, false);
    app.bindEvents();
    app.initAds();
  },
  onAdLoaded: function (e) {
    if (e.adType === admob.AD_TYPE.INTERSTITIAL) {
      if (app.autoShowInterstitial) {
        admob.showInterstitialAd();
      } else {
        alert("Interstitial is available");
      }
    }
  },
  onAdFailedToLoad: function(e) {
    alert("Could not load ad: " + JSON.stringify(e));
  },
  onResize: function () {
    var msg = 'Web view size: ' + window.innerWidth + ' x ' + window.innerHeight;
    document.getElementById('sizeinfo').innerHTML = msg;
  },
  
  // -----------------------------------
  // App buttons functionality
  // -----------------------------------
  addBannerAds: function () {
    admob.createBannerView(function (){}, function (e) {
      alert(JSON.stringify(e));
    });
  },
  removeBannerAds: function () {
    admob.destroyBannerView();
  },
  showBannerAd: function () {
    admob.showBannerAd(true, function (){}, function (e) {
      alert(JSON.stringify(e));
    });
  },
  hideBannerAd: function () {
    admob.showBannerAd(false);
  },
  requestInterstitial: function (autoshow) {
    app.autoShowInterstitial = autoshow;
    admob.requestInterstitialAd(function (){}, function (e) {
      alert(JSON.stringify(e));
    });
  },
  showInterstitial: function() {
    admob.showInterstitialAd(function (){}, function (e) {
      alert(JSON.stringify(e));
    });
  }
};