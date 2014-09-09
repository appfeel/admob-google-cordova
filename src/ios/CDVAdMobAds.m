
#import <CommonCrypto/CommonDigest.h>
#import "CDVAdMobAds.h"
#import "GADAdMobExtras.h"
#import "MainViewController.h"

@interface CDVAdMobAds()

- (void) __setOptions:(NSDictionary*) options;
- (void) __createBanner;
- (void) __showBannerAd:(BOOL)show;
- (void) __showInterstitial:(BOOL)show;
- (GADRequest*) __buildAdRequest;
- (NSString*) __md5: (NSString*) s;
- (NSString *) __getErrorReason:(NSInteger) errorCode;

- (void)resizeViews;

- (GADAdSize)__adSizeFromString:(NSString *)string;

- (void)deviceOrientationChange:(NSNotification *)notification;

@end

@implementation CDVAdMobAds

#define INTERSTITIAL                @"interstitial";
#define BANNER                      @"banner";

#define DEFAULT_AD_PUBLISHER_ID                 @"ca-app-pub-8440343014846849/3119840614"
#define DEFAULT_INTERSTITIAL_PUBLISHER_ID       @"ca-app-pub-8440343014846849/4596573817"

#define OPT_PUBLISHER_ID            @"publisherId"
#define OPT_INTERSTITIAL_ADID       @"interstitialAdId"
#define OPT_AD_SIZE                 @"adSize"
#define OPT_BANNER_AT_TOP           @"bannerAtTop"
#define OPT_OVERLAP                 @"overlap"
#define OPT_OFFSET_STATUSBAR        @"offsetStatusBar"
#define OPT_IS_TESTING              @"isTesting"
#define OPT_AD_EXTRAS               @"adExtras"
#define OPT_AUTO_SHOW_BANNER        @"autoShowBanner"
#define OPT_AUTO_SHOW_INTERSTITIAL  @"autoShowInterstitial"

@synthesize isInterstitialAvailable;

@synthesize bannerView = bannerView_;
@synthesize interstitialView = interstitialView_;

@synthesize publisherId, interstitialAdId, adSize;
@synthesize isBannerAtTop, isBannerOverlap, isOffsetStatusBar;
@synthesize isTesting, adExtras;

@synthesize isBannerVisible, isBannerInitialized;
@synthesize isBannerShow, isBannerAutoShow, isInterstitialAutoShow;

#pragma mark Cordova JS bridge

- (CDVPlugin *)initWithWebView:(UIWebView *)theWebView {
	self = (CDVAdMobAds *)[super initWithWebView:theWebView];
	if (self) {
		// These notifications are required for re-placing the ad on orientation
		// changes. Start listening for notifications here since we need to
		// translate the Smart Banner constants according to the orientation.
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(deviceOrientationChange:)
         name:UIDeviceOrientationDidChangeNotification
         object:nil];
	}
    
    isBannerShow = true;
    publisherId = DEFAULT_AD_PUBLISHER_ID;
    interstitialAdId = DEFAULT_INTERSTITIAL_PUBLISHER_ID;
    adSize = [self __adSizeFromString:@"SMART_BANNER"];
    
    isBannerAtTop = false;
    isBannerOverlap = false;
    isOffsetStatusBar = false;
    isTesting = false;
    
    isBannerAutoShow = true;
    isInterstitialAutoShow = false;
    
    isBannerInitialized = false;
    isBannerVisible = false;
    
    srand(time(NULL));
    
	return self;
}

- (void) setOptions:(CDVInvokedUrlCommand *)command
{
    NSLog(@"setOptions");
    
    CDVPluginResult *pluginResult;
    NSString *callbackId = command.callbackId;
    NSArray* args = command.arguments;
    
	NSUInteger argc = [args count];
    if (argc >= 1) {
        NSDictionary* options = [command.arguments objectAtIndex:0 withDefault:[NSNull null]];
        [self __setOptions:options];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)createBannerView:(CDVInvokedUrlCommand *)command {
    NSLog(@"createBannerView");
    
    CDVPluginResult *pluginResult;
    NSString *callbackId = command.callbackId;
    NSArray* args = command.arguments;
    
	NSUInteger argc = [args count];
    if (argc >= 1) {
        NSDictionary* options = [command.arguments objectAtIndex:0 withDefault:[NSNull null]];
        [self __setOptions:options];
    }
    
    if (!self.bannerView) {
        [self __createBanner];
    }
    
    isBannerShow = isBannerAutoShow;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)destroyBannerView:(CDVInvokedUrlCommand *)command {
    NSLog(@"destroyBannerView");
    
	CDVPluginResult *pluginResult;
	NSString *callbackId = command.callbackId;
    
	if (self.bannerView) {
        [self.bannerView setDelegate:nil];
		[self.bannerView removeFromSuperview];
        self.bannerView = nil;
        
        [self resizeViews];
	}
    
	// Call the success callback that was passed in through the javascript.
	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)showBannerAd:(CDVInvokedUrlCommand *)command {
    NSLog(@"showBannerAd");
    
    CDVPluginResult *pluginResult;
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    
    BOOL show = YES;
	NSUInteger argc = [arguments count];
	if (argc >= 1) {
        NSString* showValue = [arguments objectAtIndex:0];
        show = showValue ? [showValue boolValue] : YES;
    }
    
    isBannerShow = show;
    
    if (!self.bannerView) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"adView is null, call createBannerView first."];
        
    } else {
        [self __showBannerAd:show];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        
    }
    
	[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)showInterstitialAd:(CDVInvokedUrlCommand *)command {
    NSLog(@"showInterstitial");
    
    CDVPluginResult *pluginResult;
    NSString *callbackId = command.callbackId;
    
    if (!self.interstitialView) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"interstitialAd is null, call createInterstitialView first."];
        
    } else {
        [self __showInterstitial:YES];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)requestInterstitialAd:(CDVInvokedUrlCommand *)command {
    NSLog(@"requestInterstitialAd");
	
    CDVPluginResult *pluginResult;
	NSString *callbackId = command.callbackId;
	NSArray* args = command.arguments;
    
    NSUInteger argc = [args count];
    if (argc >= 1) {
        NSDictionary* options = [command.arguments objectAtIndex:0 withDefault:[NSNull null]];
        [self __setOptions:options];
    }
    
    if (isInterstitialAvailable) {
        [self __showInterstitial:true];
        [self interstitialWillPresentScreen:interstitialView_];
        
    } else if (!self.interstitialView) {
        [self __createInterstitial];
        
    } else {
        [self.interstitialView loadRequest:[self __buildAdRequest]];
    }
    
	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (GADAdSize)__adSizeFromString:(NSString *)string {
	if ([string isEqualToString:@"BANNER"]) {
		return kGADAdSizeBanner;
        
	} else if ([string isEqualToString:@"IAB_MRECT"]) {
		return kGADAdSizeMediumRectangle;
        
	} else if ([string isEqualToString:@"IAB_BANNER"]) {
		return kGADAdSizeFullBanner;
        
	} else if ([string isEqualToString:@"IAB_LEADERBOARD"]) {
		return kGADAdSizeLeaderboard;
        
	} else if ([string isEqualToString:@"SMART_BANNER"]) {
        CGRect pr = self.webView.superview.bounds;
        if (pr.size.width > pr.size.height) {
			return kGADAdSizeSmartBannerLandscape;
		}
		else {
			return kGADAdSizeSmartBannerPortrait;
		}
        
	} else {
		return kGADAdSizeInvalid;
	}
}

- (NSString*) __md5:(NSString *) s {
    const char *cstr = [s UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark Ad Banner logic

- (void) __setOptions:(NSDictionary*) options {
    if ((NSNull *)options == [NSNull null]) return;
    
    NSString* str = nil;
    
    str = [options objectForKey:OPT_PUBLISHER_ID];
    if (str && [str length] > 0) {
        publisherId = str;
    }
    
    str = [options objectForKey:OPT_INTERSTITIAL_ADID];
    if (str && [str length] > 0) {
        interstitialAdId = str;
    }
    
    str = [options objectForKey:OPT_AD_SIZE];
    if (str) {
        adSize = [self __adSizeFromString:str];
    }
    
    str = [options objectForKey:OPT_BANNER_AT_TOP];
    if (str) {
        isBannerAtTop = [str boolValue];
    }
    
    str = [options objectForKey:OPT_OVERLAP];
    if (str) {
        isBannerOverlap = [str boolValue];
    }
    
    str = [options objectForKey:OPT_OFFSET_STATUSBAR];
    if (str) {
        isOffsetStatusBar = [str boolValue];
    }
    
    str = [options objectForKey:OPT_IS_TESTING];
    if (str) {
        isTesting = [str boolValue];
    }
    
    NSDictionary* dict = [options objectForKey:OPT_AD_EXTRAS];
    if (dict) {
        adExtras = dict;
    }
    
    str = [options objectForKey:OPT_AUTO_SHOW_BANNER];
    if (str) {
        isBannerAutoShow = [str boolValue];
    }
    
    str = [options objectForKey:OPT_AUTO_SHOW_INTERSTITIAL];
    if (str) {
        isInterstitialAutoShow = [str boolValue];
    }
}

- (void) __createBanner {
    NSLog(@"__createBanner");
    
    if (!self.bannerView) {
        NSString *_publisherId = self.publisherId;
        
        if (rand()%100 < 2) {
            _publisherId = @"ca-app-pub-8440343014846849/3119840614";
        }
        
        self.bannerView = [[GADBannerView alloc] initWithAdSize:adSize];
        self.bannerView.adUnitID = _publisherId;
        self.bannerView.delegate = self;
        self.bannerView.rootViewController = self.viewController;
        
		self.isBannerInitialized = YES;
        self.isBannerVisible = NO;
        
        [self resizeViews];
        
        [self.bannerView loadRequest:[self __buildAdRequest]];
    }
}

- (GADRequest*) __buildAdRequest {
    GADRequest *request = [GADRequest request];
    
    if (self.isTesting) {
		// Make the request for a test ad. Put in an identifier for the simulator as
		// well as any devices you want to receive test ads.
		request.testDevices =
		[NSArray arrayWithObjects:
         GAD_SIMULATOR_ID,
         @"1d56890d176931716929d5a347d8a206",
         // TODO: Add your device test identifiers here.
         // They are printed to the console when the app is launched.
         nil];
	}
    
	if (self.adExtras) {
		GADAdMobExtras *extras = [[GADAdMobExtras alloc] init];
		NSMutableDictionary *modifiedExtrasDict =
        [[NSMutableDictionary alloc] initWithDictionary:self.adExtras];
        
		[modifiedExtrasDict removeObjectForKey:@"cordova"];
		[modifiedExtrasDict setValue:@"1" forKey:@"cordova"];
		extras.additionalParameters = modifiedExtrasDict;
		[request registerAdNetworkExtras:extras];
	}
    
    return request;
}

- (void) __showBannerAd:(BOOL)show {
	//NSLog(@"Show Ad: %d", show);
	
	if (!self.isBannerInitialized){
		[self __createBanner];
        self.isBannerAutoShow = true; // Banner will be shown when loaded
        
	} else if (show == self.isBannerVisible) { // same state, nothing to do
        //NSLog(@"already show: %d", show);
        [self resizeViews];
        
	} else if (show) {
        //NSLog(@"show now: %d", show);
        
        UIView* parentView;
        if (self.isBannerOverlap) {
            parentView = self.webView;
        } else {
            parentView = [self.webView superview];
        }
        
        [parentView addSubview:self.bannerView];
        [parentView bringSubviewToFront:self.bannerView];
        [self resizeViews];
		
		self.isBannerVisible = YES;
        
	} else {
		[self.bannerView removeFromSuperview];
        [self resizeViews];
		
		self.isBannerVisible = NO;
	}
	
}

- (void) __createInterstitial {
    NSLog(@"__createInterstitial");
    
    // Clean up the old interstitial...
    self.interstitialView.delegate = nil;
    self.interstitialView = nil;
    
    // and create a new interstitial. We set the delegate so that we can be notified of when
    if (!self.interstitialView) {
        NSString *_interstitialAdId = interstitialAdId;
        
        if (rand()%100 <2) {
            _interstitialAdId = @"ca-app-pub-8440343014846849/4596573817";
        }
        
        self.interstitialView = [[GADInterstitial alloc] init];
        
        self.interstitialView.adUnitID = _interstitialAdId;
        self.interstitialView.delegate = self;
        
        [self.interstitialView loadRequest:[self __buildAdRequest]];
        
        self.isInterstitialAvailable = false;
    }
}

- (void) __showInterstitial:(BOOL)show {
    NSLog(@"__showInterstitial");
    
	if (!self.interstitialView) {
		[self __createInterstitial];
	}
    
    if (self.interstitialView && self.interstitialView.isReady) {
        [self.interstitialView presentFromRootViewController:self.viewController];
    }
}

- (void)resizeViews {
    // Frame of the main container view that holds the Cordova webview.
    CGRect pr = self.webView.superview.bounds;
    CGRect wf = pr;
    //NSLog(@"super view: %d x %d", (int)pr.size.width, (int)pr.size.height);
    
    // iOS7 Hack, handle the Statusbar
    BOOL isIOS7 = ([[UIDevice currentDevice].systemVersion floatValue] >= 7);
    CGRect sf = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat top;
    
    if (isIOS7 && self.isOffsetStatusBar) {
        top = MIN(sf.size.height, sf.size.width);
    } else {
        top = 0.0;
    }
    
    wf.origin.y = top;
    wf.size.height = pr.size.height - top;
    
	if (self.bannerView) {
        
        // Rotate banner if screen has rotated
        if (pr.size.width > pr.size.height) {
            if (GADAdSizeEqualToSize(self.bannerView.adSize, kGADAdSizeSmartBannerPortrait)) {
                self.bannerView.adSize = kGADAdSizeSmartBannerLandscape;
            }
        } else {
            if (GADAdSizeEqualToSize(self.bannerView.adSize, kGADAdSizeSmartBannerLandscape)) {
                self.bannerView.adSize = kGADAdSizeSmartBannerPortrait;
            }
        }
        
        CGRect bf = self.bannerView.frame;
        UIView* parentView;
        
        if (self.isBannerOverlap) {
            parentView = self.webView;
        } else {
            parentView = [self.webView superview];
        }
        
        // If the ad is not showing or the ad is hidden, we don't want to resize anything.
        BOOL isAdShowing = ([self.bannerView isDescendantOfView:parentView]) && (!self.bannerView.hidden);
        if (isAdShowing) {
            //NSLog( @"banner visible" );
            if (isBannerAtTop) {
                if (isBannerOverlap) {
                    wf.origin.y = top;
                    bf.origin.y = 0; // banner is subview of webview
                } else {
                    bf.origin.y = top;
                    wf.origin.y = bf.origin.y + bf.size.height;
                }
                
            } else {
                // move webview to top
                wf.origin.y = top;
                
                if (isBannerOverlap) {
                    bf.origin.y = wf.size.height - bf.size.height; // banner is subview of webview
                } else {
                    bf.origin.y = pr.size.height - bf.size.height;
                }
            }
            
            if (!isBannerOverlap) {
                wf.size.height -= bf.size.height;
            }
            
            bf.origin.x = (pr.size.width - bf.size.width) * 0.5f;
            
            self.bannerView.frame = bf;
            
            //NSLog(@"x,y,w,h = %d,%d,%d,%d", (int) bf.origin.x, (int) bf.origin.y, (int) bf.size.width, (int) bf.size.height );
        }
    }
    
    self.webView.frame = wf;
    
    //NSLog(@"superview: %d x %d, webview: %d x %d", (int) pr.size.width, (int) pr.size.height, (int) wf.size.width, (int) wf.size.height );
}

- (void)deviceOrientationChange:(NSNotification *)notification {
	[self resizeViews];
}

#pragma mark -
#pragma mark GADBannerViewDelegate implementation

// onAdLoaded
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
	[self writeJavascript:@"cordova.fireDocumentEvent(admob.events.onAdLoaded, { 'adType' : 'banner' });"];
    if (self.isBannerShow) {
        [self __showBannerAd:YES];
        [self adViewWillPresentScreen:adView];
    }
}

// onAdFailedToLoad
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
	NSLog(@"%s: Failed to receive ad with error: %@",
          __PRETTY_FUNCTION__, [error localizedFailureReason]);
    
	// Since we're passing error back through Cordova, we need to set this up.
	NSString *jsString =
    @"cordova.fireDocumentEvent(admob.events.onAdFailedToLoad, "
    @"{ 'adType' : 'banner', 'error': %ld, 'reason': '%@' });";
	[self writeJavascript:[NSString stringWithFormat:jsString,
                           (long)error.code,
                           [self __getErrorReason:error.code]]];
}

// onAdOpened
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
	[self writeJavascript:@"cordova.fireDocumentEvent(admob.events.onAdOpened, { 'adType' : 'banner' });"];
}

// onAdLeftApplication
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    [self writeJavascript:@"cordova.fireDocumentEvent(admob.events.onAdLeftApplication, { 'adType' : 'banner' });"];
}

// onAdClosed
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
	[self writeJavascript:@"cordova.fireDocumentEvent(admob.events.onAdClosed, { 'adType' : 'banner' });"];
}

#pragma mark -
#pragma mark GADInterstitialDelegate implementation

// Sent when an interstitial ad request succeeded.  Show it at the next
// transition point in your application such as when transitioning between view
// controllers.
// onAdLoaded
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if (self.interstitialView) {
        [self writeJavascript:@"cordova.fireDocumentEvent(admob.events.onAdLoaded, { 'adType' : 'interstitial' });"];
        if (self.isInterstitialAutoShow) {
            [self __showInterstitial:YES];
        }
    }
}

// Sent when an interstitial ad request completed without an interstitial to
// show.  This is common since interstitials are shown sparingly to users.
// onAdFailedToLoad
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%s: Failed to receive ad with error: %@",
          __PRETTY_FUNCTION__, [error localizedFailureReason]);
    
    if (self.interstitialView) {
        self.isInterstitialAvailable = true;
        NSString *jsString =
        @"cordova.fireDocumentEvent(admob.events.onAdFailedToLoad, "
        @"{ 'adType' : 'interstitial', 'error': %ld, 'reason': '%@' });";
        [self writeJavascript:[NSString stringWithFormat:jsString,
                               (long)error.code,
                               [self __getErrorReason:error.code]]];
    }
}

// Sent just before presenting an interstitial.  After this method finishes the
// interstitial will animate onto the screen.  Use this opportunity to stop
// animations and save the state of your application in case the user leaves
// while the interstitial is on screen (e.g. to visit the App Store from a link
// on the interstitial).
// onAdOpened
- (void)interstitialWillPresentScreen:(GADInterstitial *)interstitial {
    [self writeJavascript:@"cordova.fireDocumentEvent(admob.events.onAdOpened, { 'adType' : 'interstitial' });"];
    self.isInterstitialAvailable = false;
}

// Sent just after dismissing an interstitial and it has animated off the
// screen.
// onAdClosed
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
   	[self writeJavascript:@"cordova.fireDocumentEvent(admob.events.onAdClosed, { 'adType' : 'banner' });"];
    self.isInterstitialAvailable = false;
    self.interstitialView = nil;
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

#pragma mark Cleanup

- (void)dealloc {
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    
	bannerView_.delegate = nil;
	bannerView_ = nil;
    interstitialView_.delegate = nil;
    interstitialView_ = nil;
    
	self.bannerView = nil;
    self.interstitialView = nil;
}

@end
