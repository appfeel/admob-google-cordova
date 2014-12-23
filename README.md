*<p style="font-size: small;" align="right"><a color="#232323;" href>Made in Barcelona with <span color="#FCB">Love</span> and <span color="#BBCCFF">Code</span></a></p>*

Cordova AdMob plugin
====================

Monetize your Cordova/Phonegap/XDK apps with AdMob ads, **using latest Google AdMob SDK**.
With this Cordova/Phonegap/XDK plugin you can show AdMob ads as easy as:

    admob.createBannerView({publisherId: "ca-app-pub-8440343014846849/3119840614"});

Or

    admob.requestInterstitialAd({interstitialAdId: "ca-app-pub-8440343014846849/4596573817", autoShowInterstitial: true});

![Integrate cordova admob plugin](https://github.com/appfeel/admob-google-cordova/blob/master/demo/integrate-admob-cordova.gif)


---
## Testimonials ##

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
- [Cordova/PhoneGap CLI](https://github.com/appfeel/admob-google-demo)
- [PhoneGap Build](https://github.com/appfeel/admob-phonegap-build-demo)

---
## Quick start ##

To install this plugin, follow the [Command-line Interface Guide](http://cordova.apache.org/docs/en/edge/guide_cli_index.md.html#The%20Command-line%20Interface). You can use one of the following command lines:

* `cordova plugin add com.admob.google`
* `cordova plugin add https://github.com/appfeel/admob-google-cordova.git`


To use in [Phonegap Build](https://build.phonegap.com), place the following tag in your `config.xml` file:

```xml
<gap:plugin name="com.admob.google" source="plugins.cordova.io" />
```

To start showing ads, place the following code in your `onDeviceReady` callback. Replace corresponding id's with yours:

*Note: ensure you have a proper [AdMob](https://apps.admob.com/admob/signup) and [tappx](http://www.tappx.com/?h=dec334d63287772de859bdb4e977fce6) accounts and get your publisher id's*.

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
      admob.requestInterstitial();
    }
    
    document.addEventListener("deviceready", onDeviceReady, false);
```

If you don't specify tappxId, no tappx requests will be placed (even if you specify a tappxShare). [See Tappx configuration](https://github.com/appfeel/admob-google-cordova/wiki/Tappx-configuration) for more detailed info.

---
## Full documentation ##

Visit the [wiki](https://github.com/appfeel/admob-google-cordova/wiki) pages to know in detail about Google AdMob Cordova plugin, where you will find the following topics:

* [Index](https://github.com/appfeel/admob-google-cordova/wiki/Index)
* [About Cordova AdMob plugin](https://github.com/appfeel/admob-google-cordova/wiki/About-Cordova-AdMob-plugin)
* [Change Log](https://github.com/appfeel/admob-google-cordova/wiki/Change-Log)
* [Testimonials](https://github.com/appfeel/admob-google-cordova/wiki/Testimonials)
* [Setup](https://github.com/appfeel/admob-google-cordova/wiki/Setup)
* [Angular.js, Ionic apps](https://github.com/appfeel/admob-google-cordova/wiki/Angular.js,-Ionic-apps)
* [Tappx configuration](https://github.com/appfeel/admob-google-cordova/wiki/Tappx-configuration)
* [Javascript API](https://github.com/appfeel/admob-google-cordova/wiki/Javascript-API)
  * [setOptions](https://github.com/appfeel/admob-google-cordova/wiki/setOptions)
  * Banners
    * [createBannerView](https://github.com/appfeel/admob-google-cordova/wiki/createBannerView)
    * [showAd](https://github.com/appfeel/admob-google-cordova/wiki/showAd)
    * [destroyBannerView](https://github.com/appfeel/admob-google-cordova/wiki/destroyBannerView)
  * Interstitials
    * [requestInterstitialAd](https://github.com/appfeel/admob-google-cordova/wiki/requestInterstitialAd)
    * [showInterstitialAd](https://github.com/appfeel/admob-google-cordova/wiki/showInterstitialAd)
  * In app purchase
    * [recordResolution](https://github.com/appfeel/admob-google-cordova/wiki/recordResolution)
    * [recordPlayBillingResolution](https://github.com/appfeel/admob-google-cordova/wiki/recordPlayBillingResolution)
* [Complete example code](https://github.com/appfeel/admob-google-cordova/wiki/Complete-example-code)
* [Contributing](https://github.com/appfeel/admob-google-cordova/wiki/Contributing)
* [Screenshots](https://github.com/appfeel/admob-google-cordova/wiki/Screenshots)

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

You can also support this project by sharing 2% Ad traffic (it's not mandatory: if you are unwilling to share, please fork and remove the donation code).

Love the project? Wanna buy me a coffee (or a beer :D)? [Click here](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ELWJTK68B9A54&item_name=AppFeel+admob+for+cordova&item_number=com%2eadmob%2egoogle)

---
## Screenshots ##
#### iPhone:

![Phonegp Cordova admob plugin in iPhone](https://github.com/appfeel/admob-google-cordova/blob/master/demo/iphone.png)

#### iPad Banner Portrait:

![Phonegp Cordova admob plugin in iPad](https://github.com/appfeel/admob-google-cordova/blob/master/demo/banner-ipad.png)

#### iPad Banner Landscape:

![Phonegp Cordova admob plugin](https://github.com/appfeel/admob-google-cordova/blob/master/demo/banner-landscape-ipad.png)

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