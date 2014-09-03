//
//  AppFeelInterstitialViewDelegate.m
//  gtrack
//
//  Created by Miquel Martín Goula on 27/06/14.
//  Copyright (c) 2014 appFeel. All rights reserved.
//

#import "AppFeelInterstitialDelegate.h"
#import "NSDictionary+JSONWritter.h"

@implementation AppFeelInterstitialDelegate
@synthesize webView;

- (id)initWithWebView:(AppMobiWebView *)webview {
    self = [super init];
    if (self) {
        self.webView = webview;
    }
    return self;
}

#pragma mark Ad Request Lifecycle Notifications
// Sent when an interstitial ad request succeeded.  Show it at the next
// transition point in your application such as when transitioning between view
// controllers.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSArray *keys = [NSArray arrayWithObjects:@"type", nil];
    NSArray *objs = [NSArray arrayWithObjects:@"banner", nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    NSMutableString *js = [[NSMutableString alloc] initWithString:@""];
    [js appendFormat:@"var ev = AppFeelRaiseEvent(AppFeel.events.onAdLoaded, %@);", [params bv_jsonStringWithPrettyPrint:false]];
    
	NSLog(@"%@", js);
	[webView injectJS:js];
}

// Sent when an interstitial ad request completed without an interstitial to
// show.  This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSArray *keys = [NSArray arrayWithObjects:@"type", @"errorCode", nil];
    NSArray *objs = [NSArray arrayWithObjects:@"banner", [error code], nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    NSMutableString *js = [[NSMutableString alloc] initWithString:@""];
    [js appendFormat:@"var ev = AppFeelRaiseEvent(AppFeel.events.onAdFailedToLoad, %@);", [params bv_jsonStringWithPrettyPrint:false]];
    
	NSLog(@"%@", js);
	[webView injectJS:js];
}

#pragma mark Display-Time Lifecycle Notifications

// Sent just before presenting an interstitial.  After this method finishes the
// interstitial will animate onto the screen.  Use this opportunity to stop
// animations and save the state of your application in case the user leaves
// while the interstitial is on screen (e.g. to visit the App Store from a link
// on the interstitial).
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSArray *keys = [NSArray arrayWithObjects:@"type", nil];
    NSArray *objs = [NSArray arrayWithObjects:@"banner", nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    NSMutableString *js = [[NSMutableString alloc] initWithString:@""];
    [js appendFormat:@"var ev = AppFeelRaiseEvent(AppFeel.events.onAdOpened, %@);", [params bv_jsonStringWithPrettyPrint:false]];
    
	NSLog(@"%@", js);
	[webView injectJS:js];
}

// Sent before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    
}

// Sent just after dismissing an interstitial and it has animated off the
// screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSArray *keys = [NSArray arrayWithObjects:@"type", nil];
    NSArray *objs = [NSArray arrayWithObjects:@"banner", nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    
    NSMutableString *js = [[NSMutableString alloc] initWithString:@""];
    [js appendFormat:@"var ev = AppFeelRaiseEvent(AppFeel.events.onAdClosed, %@);", [params bv_jsonStringWithPrettyPrint:false]];
    
	NSLog(@"%@", js);
	[webView injectJS:js];
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSArray *keys = [NSArray arrayWithObjects:@"type", nil];
    NSArray *objs = [NSArray arrayWithObjects:@"banner", nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    
    NSMutableString *js = [[NSMutableString alloc] initWithString:@""];
    [js appendFormat:@"var ev = AppFeelRaiseEvent(AppFeel.events.onAdLeftApplication, %@);", [params bv_jsonStringWithPrettyPrint:false]];
    
	NSLog(@"%@", js);
	[webView injectJS:js];
}

@end
