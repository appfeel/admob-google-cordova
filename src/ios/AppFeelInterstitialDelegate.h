//
//  AppFeelInterstitialViewDelegate.h
//  gtrack
//
//  Created by Miquel Martín Goula on 27/06/14.
//  Copyright (c) 2014 appFeel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADInterstitialDelegate.h"
#import "AppMobiWebView.h"
#import "GADRequestError.h"

@interface AppFeelInterstitialDelegate : NSObject<GADInterstitialDelegate> {
	AppMobiWebView *webView;
}

- (id)initWithWebView:(AppMobiWebView *)webview;
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad;

@property (nonatomic, retain) UIWebView *webView;

@end
