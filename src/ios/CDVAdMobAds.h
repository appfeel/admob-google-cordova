/*
 CDVAdMobAds.h
 Copyright 2015 AppFeel. All rights reserved.
 http://www.appfeel.com
 
 AdMobAds Cordova Plugin (cordova-admob)
 
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

#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <GoogleMobileAds/GADAdSize.h>
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADBannerViewDelegate.h>
#import <GoogleMobileAds/GADInterstitialDelegate.h>
#import "CDVAdMobAdsAdListener.h"
#import "AppFeelReachability.h"

#pragma mark - JS requestAd options

@class GADBannerView;
@class GADInterstitial;
@class CDVAdMobAdsAdListener;

#pragma mark AdMobAds Plugin

@interface CDVAdMobAds : CDVPlugin {
}

@property (assign) BOOL isInterstitialAvailable;

@property (nonatomic, retain) GADBannerView *bannerView;
@property (nonatomic, retain) GADInterstitial *interstitialView;
@property (nonatomic, retain) CDVAdMobAdsAdListener *adsListener;
@property (nonatomic, retain) CDVAdMobAdsAdListener *backFillAdsListener;

@property (nonatomic, retain) NSString* publisherId;
@property (nonatomic, retain) NSString* interstitialAdId;
@property (nonatomic, retain) NSString* tappxId;

@property (assign) GADAdSize adSize;
@property (assign) BOOL isBannerAtTop;
@property (assign) BOOL isBannerOverlap;
@property (assign) BOOL isOffsetStatusBar;

@property (assign) BOOL isTesting;
@property (nonatomic, retain) NSDictionary* adExtras;

@property (assign) BOOL isBannerVisible;
@property (assign) BOOL isBannerInitialized;
@property (assign) BOOL isBannerShow;
@property (assign) BOOL isBannerAutoShow;
@property (assign) BOOL isInterstitialAutoShow;
@property (assign) BOOL isGo2TappxInInterstitialBackfill;
@property (assign) BOOL isGo2TappxInBannerBackfill;
@property (assign) BOOL hasTappx;
@property (assign) double tappxShare;

- (void)setOptions:(CDVInvokedUrlCommand *)command;

- (void)createBannerView:(CDVInvokedUrlCommand *)command;
- (void)showBannerAd:(CDVInvokedUrlCommand *)command;
- (void)destroyBannerView:(CDVInvokedUrlCommand *)command;

- (void)requestInterstitialAd:(CDVInvokedUrlCommand *)command;
- (void)showInterstitialAd:(CDVInvokedUrlCommand *)command;

- (void)onBannerAd:(GADBannerView *)adView adListener:(CDVAdMobAdsAdListener *)adListener ;
- (void)onInterstitialAd:(GADInterstitial *)interstitial adListener:(CDVAdMobAdsAdListener *)adListener;
- (void)tryToBackfillBannerAd;
- (void)tryToBackfillInterstitialAd;

@end
