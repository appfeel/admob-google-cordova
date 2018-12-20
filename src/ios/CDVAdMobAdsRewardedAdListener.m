
/*
 CDVAdMobAdsRewardedAdListener.m
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

#import <Foundation/Foundation.h>
#include "CDVAdMobAds.h"
#include "CDVAdMobAdsRewardedAdListener.h"

@interface CDVAdMobAdsRewardedAdListener()
- (NSString *) __getErrorReason:(NSInteger) errorCode;
@end


@implementation CDVAdMobAdsRewardedAdListener

@synthesize adMobAds;
@synthesize isBackFill;

- (instancetype)initWithAdMobAds: (CDVAdMobAds *)originalAdMobAds andIsBackFill: (BOOL)andIsBackFill {
    self = [super init];
    if (self) {
        adMobAds = originalAdMobAds;
        isBackFill = andIsBackFill;
    }
    return self;
}

- (void)rewardBasedVideoAdDidFailedToShow:(GADRewardBasedVideoAd *)rewarded {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
       NSString *jsString =
        @"setTimeout(function (){ cordova.fireDocumentEvent(admob.events.onAdFailedToLoad, "
        @"{ 'adType' : 'rewarded', 'error': %ld, 'reason': '%@' }); }, 1);";
        [adMobAds.commandDelegate evalJs:[NSString stringWithFormat:jsString,
                                          0,
                                          @"Advertising tracking may be disabled. To get test ads on this device, enable advertising tracking."]];
    }];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(GADAdReward *)reward {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [adMobAds.commandDelegate evalJs:@"setTimeout(function (){ cordova.fireDocumentEvent(admob.events.onRewardedAd, { 'adType': 'rewarded' }); }, 1);"];
    }];
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [adMobAds.commandDelegate evalJs:@"setTimeout(function (){ cordova.fireDocumentEvent(admob.events.onAdLoaded, { 'adType': 'rewarded' }); }, 1);"];
    }];
    [adMobAds onRewardedAd:rewardBasedVideoAd adListener:self];
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [adMobAds.commandDelegate evalJs:@"setTimeout(function (){ cordova.fireDocumentEvent(admob.events.onAdOpened, { 'adType': 'rewarded' }); }, 1);"];
    }];
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [adMobAds.commandDelegate evalJs:@"setTimeout(function (){ cordova.fireDocumentEvent(admob.events.onRewardedAdVideoStarted, { 'adType': 'rewarded' }); }, 1);"];
    }];
}

- (void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [adMobAds.commandDelegate evalJs:@"setTimeout(function (){ cordova.fireDocumentEvent(admob.events.onRewardedAdVideoCompleted, { 'adType': 'rewarded' }); }, 1);"];
    }];
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [adMobAds.commandDelegate evalJs:@"setTimeout(function (){ cordova.fireDocumentEvent(admob.events.onAdClosed, { 'adType': 'rewarded' }); }, 1);"];
    }];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [adMobAds.commandDelegate evalJs:@"setTimeout(function (){ cordova.fireDocumentEvent(admob.events.onAdLeftApplication, { 'adType': 'rewarded' }); }, 1);"];
    }];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didFailToLoadWithError:(NSError *)error {
    if (isBackFill) {
        adMobAds.isRewardedAvailable = false;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *jsString =
            @"setTimeout(function (){ cordova.fireDocumentEvent(admob.events.onAdFailedToLoad, "
            @"{ 'adType' : 'rewarded', 'error': %ld, 'reason': '%@' }); }, 1);";
            [adMobAds.commandDelegate evalJs:[NSString stringWithFormat:jsString,
                                              (long)error.code,
                                              [self __getErrorReason:error.code]]];
        }];
    } else {
        [adMobAds tryToBackfillRewardedAd];
    }
}

- (NSString *) __getErrorReason:(NSInteger) errorCode {
    switch (errorCode) {
        case kGADErrorServerError:
        case kGADErrorOSVersionTooLow:
        case kGADErrorTimeout:
            return @"Internal error";
            break;
            
        case kGADErrorInvalidRequest:
            return @"Invalid request";
            break;
            
        case kGADErrorNetworkError:
            return @"Network Error";
            break;
            
        case kGADErrorNoFill:
            return @"No fill";
            break;
            
        default:
            return @"Unknown";
            break;
    }
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
    adMobAds = nil;
}

@end