#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GADAdSize.h"
#import "GADBannerView.h"
#import "GADInterstitial.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitialDelegate.h"

#pragma mark - JS requestAd options

@class GADBannerView;
@class GADInterstitial;

#pragma mark AdMobAds Plugin

@interface CDVAdMobAds : CDVPlugin <GADBannerViewDelegate, GADInterstitialDelegate> {
}

@property (assign) BOOL isInterstitialAvailable;

@property(nonatomic, retain) GADBannerView *bannerView;
@property(nonatomic, retain) GADInterstitial *interstitialView;

@property (nonatomic, retain) NSString* publisherId;
@property (nonatomic, retain) NSString* interstitialAdId;

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

- (void) setOptions:(CDVInvokedUrlCommand *)command;

- (void)createBannerView:(CDVInvokedUrlCommand *)command;
- (void)showBannerAd:(CDVInvokedUrlCommand *)command;
- (void)destroyBannerView:(CDVInvokedUrlCommand *)command;

- (void)requestInterstitialAd:(CDVInvokedUrlCommand *)command;
- (void)showInterstitialAd:(CDVInvokedUrlCommand *)command;

@end
