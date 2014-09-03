admob-google-cordova
====================

AdMob ads for Cordova Android with google-play-services.jar

## Platform SDK supported ##

* iOS, using AdMob SDK for iOS, v6.10.0
* Android, using Google Play Service for Android, v4.4
* Windows Phone, using AdMob SDK for Windows Phone 8, v6.5.11

## How to use? ##
To install this plugin, follow the [Command-line Interface Guide](http://cordova.apache.org/docs/en/edge/guide_cli_index.md.html#The%20Command-line%20Interface).

    cordova plugin add https://github.com/appfeel/admob-google-cordova.git
    
Or,

    cordova plugin add com.admob.google

Note: ensure you have a proper AdMob account and create an Id for your app.

## Quick example with cordova CLI ##
```c
    cordova create <project_folder> com.<company_name>.<app_name> <AppName>
    cd <project_folder>
    cordova platform add android
    cordova platform add ios

    // cordova will handle dependency automatically
    cordova plugin add com.admob.google

    // now remove the default www content, copy the demo html file to www
    rm -r www/*;
    cp plugins/com.admob.google/test/index.html www/

    cordova prepare; cordova run android; cordova run ios;
    // or import into Xcode / eclipse
```

## Javascript API ##

APIs:
```javascript
setOptions(options, success, fail);

createBannerView(options, success, fail);
showAd(true/false, success, fail); 
destroyBannerView();

requestInterstitialAd(options, success, fail);
showInterstitialAd();
```

## Example code ##
Call the following code inside onDeviceReady(), because only after device ready you will have the plugin working.
```javascript
    function onDeviceReady() {
      initAd();

      // display a banner at startup
      window.plugins.admob.createBannerView();
        
      // request an interstitial
      window.plugins.admob.requestInterstitialAd();
        
      // somewhere else, show the interstital (after onAdLoaded event), not needed if set autoShow = true
      window.plugins.admob.showInterstitialAd();
    }
    
    function initAd() {
      if ( window.plugins && window.plugins.admob ) {
    	  var ad_units = {
				  ios : {
					  banner: 'ca-app-pub-xxx/4806197152',
					  interstitial: 'ca-app-pub-xxx/7563979554'
				  },
				  android : {
					  banner: 'ca-app-pub-xxx/9375997553',
					  interstitial: 'ca-app-pub-xxx/1657046752'
				  }
    	  };
    	  
        var admobid = ( /(android)/i.test(navigator.userAgent) ) ? ad_units.android : ad_units.ios;
            
        window.plugins.admob.setOptions({
          publisherId: admobid.banner,
          interstitialAdId: admobid.interstitial,
          bannerAtTop: false, // set to true, to put banner at top
          overlap: false, // set to true, to allow banner overlap webview
          offsetTopBar: false, // set to true to avoid ios7 status bar overlap
          isTesting: false, // receiving test ad
          autoShow: true // auto show interstitial ad when loaded
        });

        registerAdEvents();
            
      } else {
        alert('admob plugin not ready');
      }
    }
	  
	  // optional, in case respond to events
    function registerAdEvents() {
    	document.addEventListener(window.plugins.admob.onAdLoaded, function (e) {});
      document.addEventListener(window.plugins.admob.onAdFailedToLoad, function (e) {});
      document.addEventListener(window.plugins.admob.onAdOpened, function (e) {});
      document.addEventListener(window.plugins.admob.onAdClosed, function (e) {});
      document.addEventListener(window.plugins.admob.onAdLeftApplication, function (e) {});
      document.addEventListener(window.plugins.admob.onInAppPurchaseRequested, function (e) { });
    }
```

See the working example code in [demo under test folder](test/index.html)

## Donate ##
You can use this cordova plugin for free. To support this project, donation is welcome.  
Donation can be accepted in either of following ways:
* Share 2% Ad traffic. (It's not mandatory. If you are unwilling to share, please fork and remove the donation code.)
