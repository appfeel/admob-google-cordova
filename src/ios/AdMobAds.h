//
//  AppFeelAds.h
//  gtrack
//
//  Created by Miquel Martín Goula on 27/06/14.
//  Copyright (c) 2014 appFeel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppFeelCommand.h"
#import "AppFeelBannerViewDelegate.h"
#import "AppFeelInterstitialDelegate.h"
#import "GADBannerView.h"
#import "GADInterstitial.h"
#import "GADRequest.h"

@interface AppFeelAds : AppFeelCommand {
    GADBannerView *adView;
    GADInterstitial *interstitial;
    AppFeelBannerViewDelegate *bannerAdListener;
    AppFeelInterstitialDelegate *interstitialAdListener;
}

- (void)requestBannerAds:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)pauseBannerAds:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)resumeBannerAds:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)stopBannerAds:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)requestInterstitial:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)displayInterstitial:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)recordResolution:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)recordPlayBillingResolution:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
