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


// Support for Angular
if (typeof angular !== 'undefined') {
  var admobModule = angular.module('admobModule', []);

  window.admob = window.admob || {}; // Cordova admob script is injected later than angular module!!

  function AdmobLauncher($timeout, $q, $rootScope, options) {
    var deviceready = $q.defer(),
      makePromise,
      cordovaAdmob;

    /**
     * Promise wrapper for Cordova native methods.
     * @param   {Function} fn    The javascript function to be called.
     * @param   {Array}    args  The arguments to apply to fn.
     * @param   {Boolean}  sync  When set to true resolves the promise inmediately, otherwise in a timeout wrapper.
     * @returns {Object}   $q.defer().promise object.
     */
    makePromise = function makePromise(fn, args, sync) {
      var deferred = $q.defer(),
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
    cordovaAdmob = {
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
      $rootScope.$broadcast('admob:' + admob.events.onAdLoaded, e);
    }

    function _onAdFailedToLoad(e) {
      $rootScope.$broadcast('admob:' + admob.events.onAdFailedToLoad, e);
    }

    function _onAdOpened(e) {
      $rootScope.$broadcast('admob:' + admob.events.onAdOpened, e);
    }

    function _onAdLeftApplication(e) {
      $rootScope.$broadcast('admob:' + admob.events.onAdLeftApplication, e);
    }

    function _onAdClosed(e) {
      $rootScope.$broadcast('admob:' + admob.events.onAdClosed, e);
    }

    function _onInAppPurchaseRequested(e) {
      $rootScope.$broadcast('admob:' + admob.events.onInAppPurchaseRequested, e);
    }
    
    deviceready.promise.then(function () {
      document.addEventListener(admob.events.onAdLoaded, _onAdLoaded, true);
      document.addEventListener(admob.events.onAdFailedToLoad, _onAdFailedToLoad, true);
      document.addEventListener(admob.events.onAdOpened, _onAdOpened, true);
      document.addEventListener(admob.events.onAdLeftApplication, _onAdLeftApplication, true);
      document.addEventListener(admob.events.onAdClosed, _onAdClosed, true);
      document.addEventListener(admob.events.onInAppPurchaseRequested, _onInAppPurchaseRequested, true);
      
      cordovaAdmob.events = admob.events;
      cordovaAdmob.AD_SIZE = admob.AD_SIZE;
      cordovaAdmob.AD_TYPE = admob.AD_TYPE;
      cordovaAdmob.PURCHASE_RESOLUTION = admob.PURCHASE_RESOLUTION;
      cordovaAdmob.options = admob.options;
      
    });
    
    // Clean up
    $rootScope.$on('$destroy', function (event) {
      document.removeEventListener(admob.events.onAdLoaded, _onAdLoaded, true);
      document.removeEventListener(admob.events.onAdFailedToLoad, _onAdFailedToLoad, true);
      document.removeEventListener(admob.events.onAdOpened, _onAdOpened, true);
      document.removeEventListener(admob.events.onAdLeftApplication, _onAdLeftApplication, true);
      document.removeEventListener(admob.events.onAdClosed, _onAdClosed, true);
      document.removeEventListener(admob.events.onInAppPurchaseRequested, _onInAppPurchaseRequested, true);
    });


    return cordovaAdmob;
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