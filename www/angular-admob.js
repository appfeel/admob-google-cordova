/*
 admobAngular.js
 Copyright 2014 AppFeel. All rights reserved.
 http://www.appfeel.com
 
 AdMobAds Cordova Plugin (com.admob.google)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to
 deal in the Software without restriction, including without limitation the
 rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 sell copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */


// Support for Ionic/Angular apps
if (typeof angular !== 'undefined') {
  var admobModule = angular.module('admobModule', []);

  window.admob = window.admob || {}; // Cordova admob script is injected after angular one does!!

  function AdmobLauncher($timeout, $q, $rootScope, options) {
    var
      deviceready = $q.defer(),
      makePromise,
      angularAdmob;

    /**
     * Promise wrapper for Cordova native methods.
     * @param   {Function} fn    The javascript function to be called.
     * @param   {Array}    args  The arguments to apply to fn.
     * @param   {Boolean}  sync  When set to true resolves the promise inmediately, otherwise in a timeout wrapper.
     * @returns {Object}   $q.defer().promise object.
     */
    makePromise = function makePromise(fn, args, sync) {
      var
        deferred = $q.defer(),
        success = function (response) {
          if (sync) {
            deferred.resolve(response);
          } else {
            $timeout(function () {
              deferred.resolve(response);
            });
          }
        },
        fail = function (response) {
          if (sync) {
            deferred.reject(response);
          } else {
            $timeout(function () {
              deferred.reject(response);
            });
          }
        };

      args.push(success);
      args.push(fail);
      fn.apply(window.admob, args);
      return deferred.promise;
    };

    /**
     * Resolves the deviceready promise. In this way admob methods are always executed when deviceready.
     */
    function onDeviceready() {
      deviceready.resolve();
      document.removeEventListener('deviceready', onDeviceready, false);
    }
    document.addEventListener('deviceready', onDeviceready, false);


    // The returning object
    angularAdmob = {
      events: {},
      AD_SIZE: {},
      AD_TYPE: {},
      PURCHASE_RESOLUTION: {},
      options: {},
      setOptions: function (options) {
        return deviceready.promise.then(function () {
          return makePromise(admob.setOptions, [options]);
        });
      },
      createBannerView: function (options) {
        return deviceready.promise.then(function () {
          return makePromise(admob.createBannerView, [options]);
        });
      },
      showBannerAd: function (show) {
        return deviceready.promise.then(function () {
          return makePromise(admob.showBannerAd, [show]);
        });
      },
      destroyBannerView: function () {
        return deviceready.promise.then(function () {
          return makePromise(admob.destroyBannerView, []);
        });
      },
      requestInterstitialAd: function (options) {
        return deviceready.promise.then(function () {
          return makePromise(admob.requestInterstitialAd, [options]);
        });
      },
      showInterstitialAd: function () {
        return deviceready.promise.then(function () {
          return makePromise(admob.showInterstitialAd, []);
        });
      },
      recordResolution: function (purchaseId, resolution) {
        return deviceready.promise.then(function () {
          return makePromise(admob.recordResolution, [purchaseId, resolution]);
        });
      },
      recordPlayBillingResolution: function (purchaseId, billingResponseCode) {
        return deviceready.promise.then(function () {
          return makePromise(admob.recordPlayBillingResolution, [purchaseId, billingResponseCode]);
        });
      }
    };

    // Manage admob events
    function _onAdLoaded(e) {
      $rootScope.$broadcast(angularAdmob.events.onAdLoaded, e);
    }

    function _onAdFailedToLoad(e) {
      $rootScope.$broadcast(angularAdmob.events.onAdFailedToLoad, e);
    }

    function _onAdOpened(e) {
      $rootScope.$broadcast(angularAdmob.events.onAdOpened, e);
    }

    function _onAdLeftApplication(e) {
      $rootScope.$broadcast(angularAdmob.events.onAdLeftApplication, e);
    }

    function _onAdClosed(e) {
      $rootScope.$broadcast(angularAdmob.events.onAdClosed, e);
    }

    function _onInAppPurchaseRequested(e) {
      $rootScope.$broadcast(angularAdmob.events.onInAppPurchaseRequested, e);
    }

    deviceready.promise.then(function () {
      var admobEvt;

      document.addEventListener(admob.events.onAdLoaded, angularAdmob._onAdLoaded, true);
      document.addEventListener(admob.events.onAdFailedToLoad, angularAdmob._onAdFailedToLoad, true);
      document.addEventListener(admob.events.onAdOpened, angularAdmob._onAdOpened, true);
      document.addEventListener(admob.events.onAdLeftApplication, angularAdmob._onAdLeftApplication, true);
      document.addEventListener(admob.events.onAdClosed, angularAdmob._onAdClosed, true);
      document.addEventListener(admob.events.onInAppPurchaseRequested, angularAdmob._onInAppPurchaseRequested, true);

      angularAdmob.events = {};
      for (admobEvt in admob.events) {
        if (admob.events[admobEvt].hasOwnProperty(admobEvt)) {
          angularAdmob.events[admobEvt] = options.eventPrefix + admob.events[admobEvt];
        }
      }

      angularAdmob.AD_SIZE = admob.AD_SIZE;
      angularAdmob.AD_TYPE = admob.AD_TYPE;
      angularAdmob.PURCHASE_RESOLUTION = admob.PURCHASE_RESOLUTION;
      angularAdmob.options = admob.options;
    });

    // Clean up
    $rootScope.$on('$destroy', function (event) {
      document.removeEventListener(admob.events.onAdLoaded, angularAdmob._onAdLoaded, true);
      document.removeEventListener(admob.events.onAdFailedToLoad, angularAdmob._onAdFailedToLoad, true);
      document.removeEventListener(admob.events.onAdOpened, angularAdmob._onAdOpened, true);
      document.removeEventListener(admob.events.onAdLeftApplication, angularAdmob._onAdLeftApplication, true);
      document.removeEventListener(admob.events.onAdClosed, angularAdmob._onAdClosed, true);
      document.removeEventListener(admob.events.onInAppPurchaseRequested, angularAdmob._onInAppPurchaseRequested, true);
    });


    return angularAdmob;
  }

  /**
   * This is the Angular provider for Admob.
   * @returns {Object} The provider.
   */
  function AdmobProvider() {
    'use strict';

    var options = {
      eventPrefix: 'admob:'
    };

    /**
     * Sets the event prefix. By default is set to 'admob:'.
     * @param {String} prefix The prefix for admob events.
     */
    this.setPrefix = function setPrefix(prefix) {
      options.eventPrefix = prefix;
    }

    /**
     * Sets admob options. They can be also set in run mode.
     * @param {Object} admobOptions Admob plugin options.
     */
    this.setOptions = function setOptions(admobOptions) {
      document.addEventListener('deviceready', function onDeviceready() {
        document.removeEventListener('deviceready', onDeviceready, false);
        admob.setOptions(admobOptions);
      }, false);
    }

    // expose to provider
    this.$get = ['$timeout', '$q', '$rootScope',
      function admobFactory($timeout, $q, $rootScope) {
        return new AdmobLauncher($timeout, $q, $rootScope, options);
    }];
  }
  admobModule.provider('admobSvc', AdmobProvider);
}