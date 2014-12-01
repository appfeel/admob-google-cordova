Cordova AdMob plugin
====================

Monetize your Cordova/Phonegap/XDK apps with AdMob ads, **using latest Google AdMob SDK**.
With this Cordova/Phonegap/XDK plugin you can show AdMob ads as easy as:

    admob.createBannerView({publisherId: "ca-app-pub-8440343014846849/3119840614"});

Or

    admob.requestInterstitialAd({interstitialAdId: "ca-app-pub-8440343014846849/4596573817", autoShowInterstitial: true});

## New Features ##

#### Nov-2014: ####
* **Connectivity detection**: When a new connection to WiFi or 3G/GPRS is detected, the ads are automatically shown if you asked to show them before and there was no connection.

* **[Integration with tappx](http://www.tappx.com/?h=dec334d63287772de859bdb4e977fce6)**: the developers community that exchanges advertisement to promote their apps. You can advertise your app for **FREE**. You can decide how much inventory you divert to Tappx.

* **Back-filling**: your lost inventary is delivered to [tappx (you must have a free account)](http://www.tappx.com/?h=dec334d63287772de859bdb4e977fce6).

#### Oct-2014: ####
* **Google Libraries externalitzation**: The libraries are fetched from external repository, to help it keeping updated.

* **Intel XDK**: Added support to Intel XDK platform and uploaded examples on how to integrate it.

---
## Testimonials ##

* [Visual Scale Android](https://play.google.com/store/apps/details?id=com.appfeel.visualanalogscale), [Visual Scale iOS](https://itunes.apple.com/app/id940214847?mt=8), a free app to help doctors and physiotherapists in their daily work:

> It was really easy to integrate, thanks.

<br><br>
**[Place your testimonial here](https://github.com/appfeel/admob-google-cordova/issues)**


---
## Platform SDK supported ##

* iOS, using AdMob SDK for iOS, v6.12.2
* Android, using Google Play Service for Android, v6.1

---
## Demo projects: ##
- [Intel XDK](https://github.com/appfeel/admob-google-xdk)
- [Cordova/PhoneGap](https://github.com/appfeel/admob-google-demo)

---
## Quick start ##

To install this plugin, follow the [Command-line Interface Guide](http://cordova.apache.org/docs/en/edge/guide_cli_index.md.html#The%20Command-line%20Interface). You can use one of the following command lines:

* `cordova plugin add com.admob.google`
* `cordova plugin add https://github.com/appfeel/admob-google-cordova.git`

To start showing ads, place the following code in your `onDeviceReady` callback (replace id's with your own):
```javascript
    
    function onDeviceReady() {
      document.removeEventListener('deviceready', onDeviceReady, false);
      
      // Set AdMobAds options:
      admob.setOptions({
        publisherId:          "ca-app-pub-8440343014846849/3119840614",  // Required
        interstitialAdId:     "ca-app-pub-8440343014846849/4596573817",  // Optional
        tappxIdiOs:           "/120940746/Pub-2702-iOS-8226",            // Optional
        tappxIdAndroid:       "/120940746/Pub-2700-Android-8171",        // Optional
        tappxShare:           0.5                                        // Optional
      });
      
      // Start showing banners (atomatic when autoShowBanner is set to true)
      admob.createBannerView();
      
      // Request interstitial (will present automatically when autoShowInterstitial is set to true)
      admob.requestIntertitial();
    }
    
    document.addEventListener("deviceready", onDeviceReady, false)
```
*Note: ensure you have a proper [AdMob](https://apps.admob.com/admob/signup) and [tappx](http://www.tappx.com/?h=dec334d63287772de859bdb4e977fce6) accounts and get your publisher id's*.

---
## Javascript API ##

*Note:* All success callbacks are in the form `'function () {}'`, and all failure callbacks are in the form `'function (err) {}'` where `err` is a String explaining the error reason.

#### setOptions(options, success, fail);
Set the options to start displaying ads:

* options: setup options (see [options](#options)).
* success: success callback.
* failure: failure callback.

#### Options
A JSON object whith the following fields:

* ***publisherId***: (Required) Your publisher id code from your AdMob account. [You can get it from AdMob](https://apps.admob.com/admob/signup).
* **interstitialAdId**: (Optional) Your interstitial id code from your AdMob account. Defaults to `publisherId`.
* **tappxIdiOS**: (Optional) Your tappx id for iOS apps. **[You can get it from tappx](http://www.tappx.com/?h=dec334d63287772de859bdb4e977fce6)**. It is also used to backfill your lost inventory (when there are no Admob ads available).
* **tappxIdAndroid**: (Optional) Your tappx id for Android apps. **[You can get it from tappx](http://www.tappx.com/?h=dec334d63287772de859bdb4e977fce6)**. It is also used to backfill your lost inventory (when there are no Admob ads available).
* **tappxShare**: (Optional) If any of tappxId is present, it tells the percentage of traffic diverted to tappx. Defaults to 50% (0.5).
* **bannerAtTop**: (Optional) Indicates whether to put banner ads at top when set to true or at bottom when set to false. Default `false`.
* **adSize**: (Optional) Indicates the size of banner ads.  
Available values are (see [Google Docs](https://developers.google.com/mobile-ads-sdk/docs/admob/android/banner#size) for more info):
  * admob.AD_SIZE.BANNER: 320x50. Standard Banner (Phones and Tablets).
  * admob.AD_SIZE.IAB_MRECT: 300x250. IAB Medium Rectangle (Phones and Tablets).
  * admob.AD_SIZE.IAB_BANNER: 468x60. IAB Full-Size Banner (Tablets).
  * admob.AD_SIZE.IAB_LEADERBOARD: 728x90. IAB Leaderboard (Tablets).
  * admob.AD_SIZE.SMART_BANNER: ([See table](https://developers.google.com/mobile-ads-sdk/docs/admob/android/banner#smart)) Smart Banner (Phones and Tablets).
* **overlap**: (Optional) Allow banner overlap webview. Default `false`.
* **offsetStatusBar**: (Optional) Set to true to avoid ios7 status bar overlap. Default `false`.
* **isTesting**: (Optional) Set to true for receiving test ads (do not test with real ads as your account will be banned). Default `false`.
* **adExtras**: (Options) A JSON object with additional {key: value} pairs (see [Google Docs](https://developers.google.com/mobile-ads-sdk/docs/admob/android/banner#color) for more info).
* **autoShowBanner**: (Optional) Auto show banners ad when available (`admob.events.onAdLoaded` event is called). Default `true`.
* **autoShowInterstitial**: (Optional) Auto show interstitials ad when available (`admob.events.onAdLoaded` event is called). Default `false`.

*Example (those are also the default options, except for tappxId's which are empty by default):*
```javascript
{
  publisherId:          "ca-app-pub-8440343014846849/3119840614",
  interstitialAdId:     "ca-app-pub-8440343014846849/4596573817",
  tappxIdiOs:           "/120940746/Pub-2702-iOS-8226",
  tappxIdAndroid:       "/120940746/Pub-2700-Android-8171",
  tappxShare:           0.5,
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
Please note that `onPause` event is raised when an interstitial is shown.

* e: JSON object.  
*Example:* `{ adType : "banner" }`  
  * adType can be `admob.AD_TYPE.BANNER` or `admob.AD_TYPE.INTERSTITIAL`
      
#### admob.events.onAdClosed
Called when the user is about to return to the application after clicking on an ad.
Please note that `onResume` event is raised when an interstitial is closed.

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
Note that the admob ads are configured inside `onDeviceReady()`. This is because only after device ready the AdMob Cordova plugin will be working.

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
          publisherId:      admobid.banner,
          interstitialAdId: admobid.interstitial,
          tappxIdiOs:       "/120940746/Pub-2702-iOS-8226",
          tappxIdAndroid:   "/120940746/Pub-2700-Android-8171",
          tappxShare:       0.5
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

---
## Contributing ##
You can use this cordova plugin for free. You can contribute to this project in many ways:

* Testimonials of apps that are using this plugin gives your app free marketing and will be especially helpful. [Open an issue](https://github.com/appfeel/admob-google-cordova/issues).
* Register to [tappx](http://www.tappx.com/?h=dec334d63287772de859bdb4e977fce6) by using this link: http://www.tappx.com/?h=dec334d63287772de859bdb4e977fce6. It is our Guess-Link and for each affiliate we will get 50k tappix (free exchange ads).
* [Reporting issues](https://github.com/appfeel/admob-google-cordova/issues).
* Patching and bug fixing, especially when submitted with test code. [Open a pull request](https://github.com/appfeel/admob-google-cordova/pulls).
* Other enhancements.

You can also support this project by sharing 2% Ad traffic (it's not mandatory: if you are unwilling to share, please fork and remove the donation code) and by donations via [paypal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=MFQHUTN8U9XD6&lc=ES&item_name=AppFeel&item_number=com%2eadmob%2egoogle&amount=10%2e00&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)

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
```
The MIT License

Copyright (c) 2014 AppFeel

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
---
## Credits ##

* [appFeel](http://www.appfeel.com)
* floatinghotpot/cordova-plugin-admob
* aliokan/cordova-plugin-admob