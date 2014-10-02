admob-google-cordova
====================

Monetize your apps with AdMob ads for Cordova Android/iOS.
With this Cordova AdMob plugin you can show AdMob ads as easy as:

    admob.createBannerView({publisherId: "ca-app-pub-8440343014846849/3119840614"});

Or

    admob.requestInterstitialAd({interstitialAdId: "ca-app-pub-8440343014846849/4596573817", autoShowInterstitial: true});


---
## Platform SDK supported ##

* iOS, using AdMob SDK for iOS, v6.11.1
* Android, using Google Play Service for Android, v4.4

---
## How to use ##
To install this plugin, follow the [Command-line Interface Guide](http://cordova.apache.org/docs/en/edge/guide_cli_index.md.html#The%20Command-line%20Interface). You can use one of the following command lines:

* `cordova plugin add com.admob.google`
* `cordova plugin add https://github.com/appfeel/admob-google-cordova.git`

To start showing ads, place the following code in your onDeviceReady callback. In order to attach an event listener, use `document.addEventListener("deviceready", onDeviceReady, false)`.
```javascript
    
    function onDeviceReady() {
      document.removeEventListener('deviceready', onDeviceReady, false);
      
      // Set AdMobAds options:
      admob.setOptions({
        publisherId:          "ca-app-pub-8440343014846849/3119840614",
        interstitialAdId:     "ca-app-pub-8440343014846849/4596573817"
      });
      
      // Start showing banners (atomatic when autoShowBanner is set to true)
      admob.createBannerView();
      
      // Request interstitial (will present automatically when autoShowInterstitial is set to true)
      admob.requestIntertitial();
    }
```
Note: ensure you have a proper [AdMob](https://apps.admob.com/admob/signup) account and create an Id for your app.

---
## Javascript API ##

*Note:* All success callbacks are in the form `` 'function () {}' ``, and all failure callbacks are in the form `` 'function (err) {}' `` where `err` is a String explaining the error reason.

#### setOptions(options, success, fail);
Set the options to start displaying ads:

* options: setup options (see [options](#options)).
* success: success callback.
* failure: failure callback.

#### Options
A JSON object whith the following fields:

* **publisherId**: (Required) Your publisher id code from your AdMob account.
* interstitialAdId: (Optional) Your interstitial id code from your AdMob account. Defaults to `publisherId`.
* bannerAtTop: (Optional) Indicates whether to put banner ads at top when set to true or at bottom when set to false. Default `false`.
* adSize: (Optional) Indicates the size of banner ads.  
Available values are (see [Google Docs](https://developers.google.com/mobile-ads-sdk/docs/admob/android/banner#size) for more info):
  * admob.AD_SIZE.BANNER: 320x50. Standard Banner (Phones and Tablets).
  * admob.AD_SIZE.IAB_MRECT: 300x250. IAB Medium Rectangle (Phones and Tablets).
  * admob.AD_SIZE.IAB_BANNER: 468x60. IAB Full-Size Banner (Tablets).
  * admob.AD_SIZE.IAB_LEADERBOARD: 728x90. IAB Leaderboard (Tablets).
  * admob.AD_SIZE.SMART_BANNER: ([See table](https://developers.google.com/mobile-ads-sdk/docs/admob/android/banner#smart)) Smart Banner (Phones and Tablets).
* overlap: (Optional) Allow banner overlap webview. Default `false`.
* offsetStatusBar: (Optional) Set to true to avoid ios7 status bar overlap. Default `false`.
* isTesting: (Optional) Set to true for receiving test ads (do not test with real ads as your account will be banned). Default `false`.
* adExtras: (Options) A JSON object with additional {key: value} pairs (see [Google Docs](https://developers.google.com/mobile-ads-sdk/docs/admob/android/banner#color) for more info).
* autoShowBanner: (Optional) Auto show banners ad when available (`admob.events.onAdLoaded` event is called). Default `true`.
* autoShowInterstitial: (Optional) Auto show interstitials ad when available (`admob.events.onAdLoaded` event is called). Default `false`.

*Example (those are also the default options):*
```javascript
{
  publisherId:          "ca-app-pub-8440343014846849/3119840614",
  interstitialAdId:     "ca-app-pub-8440343014846849/4596573817",
  adSize:               admob.AD_SIZE.SMART_BANNER,
  bannerAtTop:          false,
  overlap:              false,
  offsetStatusBar:      false,
  isTesting:            false,
  adExtras :            {},
  autoShowBanner:       true,
  autoShowInterstitial: true
}
```

### Banners
#### createBannerView(options, success, fail);
Create a new banner view.

* options: setup options (see [options](#options)).
* success: success callback.
* failure: failure callback.

#### showAd(show, success, fail); 
Show banner ads.

* show[boolean]: Indicates whether to show or hide banner ads.
* success: success callback.
* failure: failure callback.

#### destroyBannerView();
Hide and destroy banner view.

### Interstitials
#### requestInterstitialAd(options, success, fail);
Request an interstitial ad.  
If `options.autoShowInterstitial` is set to true, the ad will automatically be displayed. Otherwise you should call `showInterstitialAd()` when `admob.events.onAdLoaded` event is called.  
If you already called `requestInterstitialAd()` but the interstitial was never shown, the following calls to `requestInterstitialAd()` will result in the ad being inmediately available (the same ad as the one in the first call).

* options: setup options (see [options](#options)).
* success: success callback.
* failure: failure callback.

#### showInterstitialAd(success, fail);
Show an interstitial ad.  
This method must be called after `admob.events.onAdLoaded` event is called. If there is no ad available it calls fail callback.

* success: success callback.
* failure: failure callback.

### In App Purchase
#### recordResolution(purchaseId, resolution, success, fail);
Records the purchase status and conversion events.

* purchaseId: The id of the purchase (you will get it when `admob.events.onInAppPurchase` event is called).
* resolution: The result of a purchase. The value can be:
  * admob.PURCHASE_RESOLUTION.RESOLUTION_CANCELED: A resolution indicating the purchase was canceled.
  * admob.PURCHASE_RESOLUTION.RESOLUTION_FAILURE: A resolution indicating the purchase failed.
  * admob.PURCHASE_RESOLUTION.RESOLUTION_INVALID_PRODUCT: A resolution indicating the product is invalid.
  * admob.PURCHASE_RESOLUTION.RESOLUTION_SUCCESS: A resolution indicating the purchase was successful.
* success: success callback.
* failure: failure callback.

#### recordPlayBillingResolution(purchaseId, billingResponseCode, success, fail);
Records the purchase status and conversion events for a play billing purchase.

* purchaseId: The id of the purchase (you will get it when `admob.events.onInAppPurchase` event is called).
* billingResponseCode: The result of a play billing purchase. The value can be any billing response code from:
  * admob.PURCHASE_RESOLUTION.RESOLUTION_CANCELED: A resolution indicating the purchase was canceled.
  * admob.PURCHASE_RESOLUTION.RESOLUTION_FAILURE: A resolution indicating the purchase failed.
  * admob.PURCHASE_RESOLUTION.RESOLUTION_INVALID_PRODUCT: A resolution indicating the product is invalid.
  * admob.PURCHASE_RESOLUTION.RESOLUTION_SUCCESS: A resolution indicating the purchase was successful.
* success: success callback.
* failure: failure callback.
    
### Events
AdMobAds Cordova library will use the same events for Android as for iOS (the iOS ones are mapped to the Android ones). See [Google Docs](https://developers.google.com/mobile-ads-sdk/docs/admob/android/banner#adlistener) for more info.  
To listen to any of those events you can use:

    document.addEventListener(admob.events.onAdLoaded, function (e) { });
    
#### admob.events.onAdLoaded
Called when an ad is received.

* e: JSON object.  
*Example:* `{ adType : "banner" }`  
  * adType can be `admob.AD_TYPE.BANNER` or `admob.AD_TYPE.INTERSTITIAL`

#### admob.events.onAdFailedToLoad
Called when an ad request failed.

* e: JSON object.  
*Example:* `{ adType : "[string]", error : [integer], reason : "[string]" }`
  * adType can be admob.AD_TYPE.BANNER or admob.AD_TYPE.INTERSTITIAL
  * error is the error code and is usually one of the following:
    * AdRequest.ERROR_CODE_INTERNAL_ERROR
    * AdRequest.ERROR_CODE_INVALID_REQUEST
    * AdRequest.ERROR_CODE_NETWORK_ERROR
    * AdRequest.ERROR_CODE_NO_FILL
  * reason is an english string with the reason of the error (for logging purposes).
      
#### admob.events.onAdOpened
Called when an ad opens an overlay that covers the screen.

* e: JSON object.  
*Example:* `{ adType : "banner" }`  
  * adType can be `admob.AD_TYPE.BANNER` or `admob.AD_TYPE.INTERSTITIAL`
      
#### admob.events.onAdClosed
Called when the user is about to return to the application after clicking on an ad.

* e: JSON object.  
*Example:* `{ adType : "banner" }`  
  * adType can be `admob.AD_TYPE.BANNER` or `admob.AD_TYPE.INTERSTITIAL`
      
#### admob.events.onAdLeftApplication
Called when an ad leaves the application (e.g., to go to the browser).

* e: JSON object.  
*Example:* `{ adType : "banner" }`  
  * adType can be `admob.AD_TYPE.BANNER` or `admob.AD_TYPE.INTERSTITIAL`
      
#### admob.events.onInAppPurchaseRequested
Called when the user clicks the buy button of an in-app purchase ad. You shoud complete the transaction by calling `admob.recordResolution(...)` or `admob.recordPlayBillingResolution(...)`.

* e: JSON object.  
*Example:* `{ adType : "banner" }`  
  * adType can be `admob.AD_TYPE.BANNER` or `admob.AD_TYPE.INTERSTITIAL`
      

---
## Quick example with cordova CLI ##
```c
    cordova create <project_folder> com.<company_name>.<app_name> <AppName>
    cd <project_folder>
    cordova platform add android
    cordova platform add ios

    // cordova will handle dependency automatically
    cordova plugin add com.admob.google

    // now remove the default www content, copy the demo html file to www
    rm -rf www/*;
    cp plugins/com.admob.google/test/* www/

    cordova prepare; cordova run android; cordova run ios;
    // or import into Xcode / eclipse
```

---
## Complete example code ##
Call the following code inside `onDeviceReady()`. (This is because only after device ready you will have the plugin working).
```javascript

    function initAds() {
      if (admob) {
        var adPublisherIds = {
          ios : {
            banner : "ca-app-pub-8440343014846849/3119840614",
            interstitial : "ca-app-pub-8440343014846849/4596573817"
          },
          android : {
            banner : "ca-app-pub-8440343014846849/3119840614",
            interstitial : "ca-app-pub-8440343014846849/4596573817"
          }
        };
    	  
        var admobid = (/(android)/i.test(navigator.userAgent)) ? adPublisherIds.android : adPublisherIds.ios;
            
        admob.setOptions({
          publisherId: admobid.banner,
          interstitialAdId: admobid.interstitial
        });

        registerAdEvents();
        
      } else {
        alert('AdMobAds plugin not ready');
      }
    }
    
    function onAdLoaded(e) {
      if (e.adType === admob.AD_TYPE.INTERSTITIAL) {
        admob.showInterstitialAd();
        showNextInterstitial = setTimeout(function() {
          admob.requestInterstitialAd();
        }, 2 * 60 * 1000); // 2 minutes
      }
    }
    
    // optional, in case respond to events
    function registerAdEvents() {
      document.addEventListener(admob.events.onAdLoaded, onAdLoaded);
      document.addEventListener(admob.events.onAdFailedToLoad, function (e) {});
      document.addEventListener(admob.events.onAdOpened, function (e) {});
      document.addEventListener(admob.events.onAdClosed, function (e) {});
      document.addEventListener(admob.events.onAdLeftApplication, function (e) {});
      document.addEventListener(admob.events.onInAppPurchaseRequested, function (e) {});
    }
        
    function onDeviceReady() {
      document.removeEventListener('deviceready', onDeviceReady, false);
      initAds();

      // display a banner at startup
      admob.createBannerView();
        
      // request an interstitial
      admob.requestInterstitialAd();
    }
    
    document.addEventListener("deviceready", onDeviceReady, false);
```

See the working example code in the [demo under test folder](https://github.com/appfeel/admob-google-cordova/tree/master/test/index.html).

---
## Donate ##
You can use this cordova plugin for free. To support this project, donation is welcome.  
Donation can be accepted in either of following ways:
* Share 2% Ad traffic. (It's not mandatory. If you are unwilling to share, please fork and remove the donation code.)
+ Donate via [paypal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=MFQHUTN8U9XD6&lc=ES&item_name=AppFeel&item_number=com%2eadmob%2egoogle&amount=10%2e00&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)

---
## Screenshots ##
iPhone:

![ScreenShot](demo/iphone.png)

iPad Banner Portrait:

![ScreenShot](demo/banner-ipad.png)

iPad Banner Landscape:

![ScreenShot](demo/banner-landscape-ipad.png)

---
## License ##
The MIT License

Copyright (c) 2011 Matt Kane Copyright (c) 2013 Jean-Christophe Hoelt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---
## Credits ##
[floatinghotpot/cordova-plugin-admob](https://github.com/floatinghotpot/cordova-plugin-admob.git)

[aliokan/cordova-plugin-admob](https://github.com/aliokan/cordova-plugin-admob)