var onDeviceReady = function() {
  //hide splash screen
  alert("cordova ready");
  testAdMob_main();
  
  var weinreIp = 'http://192.168.1.13';
  var weinrePort = '9199';
  var weinreTargetApp = "c3Sf1RzCWE8SZKnGTs8w2gTxVYJBGbAEgIsJBNoji0g";
  //loadWeinre(weinreIp, weinrePort, weinreTargetApp);
};
document.addEventListener("deviceready", onDeviceReady, false);

var onXDKReady = function () {
  alert("intel.xdk ready");
  intel.xdk.device.hideSplashScreen();
};
document.addEventListener("intel.xdk.device.ready", onXDKReady, false);

/**
 * Loads Weinre to weinreIp, weinrePort and weinreTargetApp
 * @param {String} weinreIp        ip to connect to weire server
 * @param {Number} weinrePort      port where weinre is running
 * @param {String} weinreTargetApp app id
 */
function loadWeinre(weinreIp, weinrePort, weinreTargetApp) {
  var weinre = document.createElement('script');
  var weinreUrl = weinreIp + ":" + weinrePort;
  weinreUrl += "/target/target-script-min.js#";
  weinreUrl += weinreTargetApp;

  weinre.setAttribute('src', weinreUrl);
  document.head.appendChild(weinre);
}

var admobid = {
  banner: 'ca-app-pub-8440343014846849/3119840614',
  interstitial: 'ca-app-pub-8440343014846849/4596573817'
};

function testAdMob_main() {
  if (!admob) {
    alert('admob plugin not ready');
    return;
  }
  
  initAd();
  admob.createBanner(function () {
  }, function (data) {
    alert(JSON.stringify(data));
  });
}

function initAd() {
  var defaultOptions = admob.options;
  
  defaultOptions.publisherId = admobid.banner;
  defaultOptions.interstitialId = admobid.interstitial;
  defaultOptions.isTesting = true;
  
  admob.setOptions(defaultOptions);
  registerAdEvents();
}

// optional, in case respond to events or handle error
function registerAdEvents() {
  document.addEventListener(admob.events.onAdFailedToLoad, function (data) {
    alert(data.adType + ' failed. Error: ' + data.error + ', reason: ' + data.reason);
  });
  document.addEventListener(admob.events.onAdLoaded, function () {
    if (e.adType = admob.AD_TYPE.INTERSTITIA) {
      var autoshow = document.getElementById('autoshow').checked;
      if (!autoshow) {
        alert("Interstital available, click show to view it");
      }
    }
  });
  document.addEventListener(admob.events.onAdOpened, function (e) {});
  document.addEventListener(admob.events.onAdLeftApplication, function (e) {});
  document.addEventListener(admob.events.onAdClosed, function (e) {});
  document.addEventListener(admob.events.onInAppPurchaseRequested, function (e) {});
}

// click button to call following functions
function getSelectedAdSize() {
  var i = document.getElementById("adSize").selectedIndex;
  var items = document.getElementById("adSize").options;
  return items[i].value;
}

function createSelectedBanner() {
  var overlap = document.getElementById('overlap').checked;
  var bannerAtTop = document.getElementById("bannerAtTop").checked;
  admob.createBannerView({
    adId:admobid.banner,
    bannerAtTop: bannerAtTop,
    overlap:overlap,
    adSize: getSelectedAdSize()
  }, function () {
  }, function (e) {
    alert(JSON.stringify(e));
  });
}

function prepareInterstitial() {
  var autoshow = document.getElementById('autoshow').checked;
  admob.requestInterstitialAd({
    adId:admobid.interstitial,
    autoShow:autoshow
  }, function () {
  }, function (e) {
    alert(JSON.stringify(e));
  });
}
