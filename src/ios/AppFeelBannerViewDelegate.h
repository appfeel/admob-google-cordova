//
//  AppFeelBannerViewDelegate.h
//  gtrack
//
//  Created by Miquel Martín Goula on 27/06/14.
//  Copyright (c) 2014 appFeel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBannerViewDelegate.h"
#import "AppMobiWebView.h"
#import "GADRequestError.h"

@interface AppFeelBannerViewDelegate : NSObject<GADBannerViewDelegate> {
	AppMobiWebView *webView;
}

- (id)initWithWebView:(AppMobiWebView *)webview;

@property (nonatomic, retain) UIWebView *webView;

@end
