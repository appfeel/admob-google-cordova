//
//  AppFeelBannerViewDelegate.m
//  gtrack
//
//  Created by Miquel Martín Goula on 27/06/14.
//  Copyright (c) 2014 appFeel. All rights reserved.
//

#import "AppFeelBannerViewDelegate.h"
#import "NSDictionary+JSONWritter.h"

@implementation AppFeelBannerViewDelegate
@synthesize webView;

- (id)initWithWebView:(AppMobiWebView *)webview {
    self = [super init];
    if (self) {
        self.webView = webview;
    }
    return self;
}


#pragma mark Ad Request Lifecycle Notifications

// Sent when an ad request loaded an ad.  This is a good opportunity to add this
// view to the hierarchy if it has not yet been added.  If the ad was received
// as a part of the server-side auto refreshing, you can examine the
// hasAutoRefreshed property of the view.
- (void)adViewDidReceiveAd:(GADBannerView *)view {
    NSArray *keys = [NSArray arrayWithObjects:@"type", nil];
    NSArray *objs = [NSArray arrayWithObjects:@"banner", nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    NSMutableString *js = [[NSMutableString alloc] initWithString:@""];
    [js appendFormat:@"var ev = AppFeelRaiseEvent(AppFeel.events.onAdLoaded, %@);", [params bv_jsonStringWithPrettyPrint:false]];
    
	NSLog(@"%@", js);
	[webView injectJS:js];
}

// Sent when an ad request failed.  Normally this is because no network
// connection was available or no ads were available (i.e. no fill).  If the
// error was received as a part of the server-side auto refreshing, you can
// examine the hasAutoRefreshed property of the view.
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSArray *keys = [NSArray arrayWithObjects:@"type", @"errorCode", nil];
    NSArray *objs = [NSArray arrayWithObjects:@"banner", [error code], nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    NSMutableString *js = [[NSMutableString alloc] initWithString:@""];
    [js appendFormat:@"var ev = AppFeelRaiseEvent(AppFeel.events.onAdFailedToLoad, %@);", [params bv_jsonStringWithPrettyPrint:false]];
    
	NSLog(@"%@", js);
	[webView injectJS:js];
}

#pragma mark Click-Time Lifecycle Notifications

// Sent just before presenting the user a full screen view, such as a browser,
// in response to clicking on an ad.  Use this opportunity to stop animations,
// time sensitive interactions, etc.
//
// Normally the user looks at the ad, dismisses it, and control returns to your
// application by calling adViewDidDismissScreen:.  However if the user hits the
// Home button or clicks on an App Store link your application will end.  On iOS
// 4.0+ the next method called will be applicationWillResignActive: of your
// UIViewController (UIApplicationWillResignActiveNotification).  Immediately
// after that adViewWillLeaveApplication: is called.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSArray *keys = [NSArray arrayWithObjects:@"type", nil];
    NSArray *objs = [NSArray arrayWithObjects:@"banner", nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    NSMutableString *js = [[NSMutableString alloc] initWithString:@""];
    [js appendFormat:@"var ev = AppFeelRaiseEvent(AppFeel.events.onAdOpened, %@);", [params bv_jsonStringWithPrettyPrint:false]];
    
	NSLog(@"%@", js);
	[webView injectJS:js];
}

// Sent just before dismissing a full screen view.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {

}

// Sent just after dismissing a full screen view.  Use this opportunity to
// restart anything you may have stopped as part of adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
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
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSArray *keys = [NSArray arrayWithObjects:@"type", nil];
    NSArray *objs = [NSArray arrayWithObjects:@"banner", nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    
    NSMutableString *js = [[NSMutableString alloc] initWithString:@""];
    [js appendFormat:@"var ev = AppFeelRaiseEvent(AppFeel.events.onAdLeftApplication, %@);", [params bv_jsonStringWithPrettyPrint:false]];
    
	NSLog(@"%@", js);
	[webView injectJS:js];
}

@end
