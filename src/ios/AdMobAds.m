//
//  AppFeelAds.m
//  gtrack
//
//  Created by Miquel Martín Goula on 27/06/14.
//  Copyright (c) 2014 appFeel. All rights reserved.
//

#import "AppFeelAds.h"

@implementation AppFeelAds

- (id)initWithWebView:(AppMobiWebView *)webview {
    self = [super initWithWebView:webView];
    
    if (self) {
        bannerAdListener = [[AppFeelBannerViewDelegate alloc] initWithWebView:webView];
        interstitialAdListener = [[AppFeelInterstitialDelegate alloc] initWithWebView:webView];
    }
    
    return self;
}

- (void)dealloc {
    if (adView != nil) {
        adView.delegate = nil;
    }
    
    if (interstitial != nil) {
        interstitial.delegate = nil;
    }
}

- (void)requestBannerAds:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSString *adUnitId = (NSString *)[arguments objectAtIndex:0];
    NSString *sAdSize = (NSString *)[arguments objectAtIndex:1];
    NSString *testDeviceIds = (NSString *)[arguments objectAtIndex:3];
    NSScanner *scanner = [NSScanner scannerWithString:sAdSize];
    int adSize;
    
    if (![scanner scanInt:&adSize]) {
        adSize = 5;
    }
    
    if (![adUnitId  isEqual: @""]) {
        [self stopBannerAds:nil withDict:nil];
        GADRequest *request = [GADRequest request];
        
        switch (adSize) {
            case 0:
                adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
                break;

            case 1:
                adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
                break;
                
            case 2:
                adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
                break;
                
            case 3:
                adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
                break;
                
            case 4:
            default:
                adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
                break;
                
            case 5:
                adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
                break;
                
            case 6:
                adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
                break;
                
            case 7:
                adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSkyscraper];
                break;
        }
        
        if (![testDeviceIds isEqual:@""]) {
            request.testing = true;
            request.testDevices = [testDeviceIds componentsSeparatedByString:@";"];

        } else {
            request.testing = false;
        }
        
        adView.adUnitID = adUnitId;
        adView.rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view ] addSubview:adView];
        [adView setDelegate:bannerAdListener];
        [adView loadRequest:request];
        
    }
}

- (void)pauseBannerAds:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
}

- (void)resumeBannerAds:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
}

- (void)stopBannerAds:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    [adView finalize];
}

- (void)requestInterstitial:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSString *adUnitId = (NSString *)[arguments objectAtIndex:0];
    NSString *testDeviceIds = (NSString *)[arguments objectAtIndex:2];
    
    if (![adUnitId  isEqual: @""]) {
        interstitial = [[GADInterstitial alloc] init];
        GADRequest *request = [GADRequest request];
        if (![testDeviceIds isEqual:@""]) {
            request.testing = true;
            request.testDevices = [testDeviceIds componentsSeparatedByString:@";"];

        } else {
            request.testing = false;
        }
        
        interstitial.adUnitID = adUnitId;
        [interstitial setDelegate:interstitialAdListener];
        [interstitial loadRequest:request];
    }
}

- (void)isInterstitialAvailable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    if (interstitial != nil && [interstitial isReady]) {
        [interstitialAdListener interstitialDidReceiveAd:nil];
    }
}

- (void)displayInterstitial:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    if (interstitial != nil && [interstitial isReady]) {
        [interstitial presentFromRootViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
    }
}

- (void)recordResolution:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
}

- (void)recordPlayBillingResolution:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
}

@end
