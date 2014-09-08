package com.appfeel.cordova.admob;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Iterator;
import java.util.Random;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.graphics.Rect;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.RelativeLayout;

import com.appfeel.cordova.admob.AdMobAdsAdListener.IAdLoadedAvailable;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.InterstitialAd;
import com.google.android.gms.ads.mediation.admob.AdMobExtras;
import com.google.android.gms.ads.purchase.InAppPurchase;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;

public class AdMobAds extends CordovaPlugin implements IAdLoadedAvailable {
  public static final String ADMOBADS_LOGTAG = "AdmMobAds";
  public static final String INTERSTITIAL = "interstitial";
  public static final String BANNER = "banner";

  private static final String DEFAULT_AD_PUBLISHER_ID = "ca-app-pub-8440343014846849/3119840614";
  private static final String DEFAULT_INTERSTITIAL_PUBLISHER_ID = "ca-app-pub-8440343014846849/4596573817";

  /** Cordova Actions. */
  private static final String ACTION_SET_OPTIONS = "setOptions";
  private static final String ACTION_CREATE_BANNER_VIEW = "createBannerView";
  private static final String ACTION_SHOW_BANNER_AD = "showBannerAd";
  private static final String ACTION_DESTROY_BANNER_VIEW = "destroyBannerView";
  private static final String ACTION_REQUEST_INTERSTITIAL_AD = "requestInterstitialAd";
  private static final String ACTION_SHOW_INTERSTITIAL_AD = "showInterstitialAd";
  private static final String ACTION_RECORD_RESOLUTION = "recordResolution";
  private static final String ACTION_RECORD_PLAY_BILLING_RESOLUTION = "recordPlayBillingResolution";

  /* options */
  private static final String OPT_PUBLISHER_ID = "publisherId";
  private static final String OPT_INTERSTITIAL_AD_ID = "interstitialAdId";
  private static final String OPT_AD_SIZE = "adSize";
  private static final String OPT_BANNER_AT_TOP = "bannerAtTop";
  private static final String OPT_OVERLAP = "overlap";
  private static final String OPT_OFFSET_STATUSBAR = "offsetStatusBar";
  private static final String OPT_IS_TESTING = "isTesting";
  private static final String OPT_AD_EXTRAS = "adExtras";
  private static final String OPT_AUTO_SHOW_BANNER = "autoShowBanner";
  private static final String OPT_AUTO_SHOW_INTERSTITIAL = "autoShowInterstitial";

  private AdMobAdsAdListener bannerListener = new AdMobAdsAdListener(BANNER, this, this);
  private AdMobAdsAdListener interstitialListener = new AdMobAdsAdListener(INTERSTITIAL, this, this);
  private AdMobAdsAppPurchaseListener inAppPurchaseListener = new AdMobAdsAppPurchaseListener(this);

  private boolean isInterstitialAvailable = false;

  /** The adView to display to the user. */
  private AdView adView;
  /** if want banner view overlap webview, we will need this layout */
  private RelativeLayout adViewLayout = null;
  /** The interstitial ad to display to the user. */
  private InterstitialAd interstitialAd;

  private String publisherId = DEFAULT_AD_PUBLISHER_ID;
  private String interstialAdId = DEFAULT_INTERSTITIAL_PUBLISHER_ID;

  private AdSize adSize = AdSize.SMART_BANNER;

  /** Whether or not the ad should be positioned at top or bottom of screen. */
  private boolean isBannerAtTop = false;

  /** Whether or not the banner will overlap the webview instead of push it up or down */
  private boolean isBannerOverlap = false;

  private boolean isOffsetStatusBar = false;
  private boolean isTesting = false;
  private boolean isShowingBannerEnabled = true;
  private JSONObject adExtras = null;
  protected boolean isBannerAutoShow = true;
  protected boolean isInterstitialAutoShow = true;
  private boolean isBannerVisible = false;
  private boolean isGpsAvailable = false;

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
    isGpsAvailable = (GooglePlayServicesUtil.isGooglePlayServicesAvailable(cordova.getActivity()) == ConnectionResult.SUCCESS);
    Log.w(ADMOBADS_LOGTAG, String.format("isGooglePlayServicesAvailable: %s", isGpsAvailable ? "true" : "false"));
  }

  /**
   * Executes the request.
   * 
   * This method is called from the WebView thread.
   * 
   * To do a non-trivial amount of work, use: cordova.getThreadPool().execute(runnable);
   * 
   * To run on the UI thread, use: cordova.getActivity().runOnUiThread(runnable);
   * 
   * @param action The action to execute.
   * @param args The exec() arguments.
   * @param callbackContext The callback context used when calling back into JavaScript.
   * @return Whether the action was valid.
   */
  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    PluginResult result = null;

    if (ACTION_SET_OPTIONS.equals(action)) {
      JSONObject options = args.optJSONObject(0);
      result = executeSetOptions(options, callbackContext);

    } else if (ACTION_CREATE_BANNER_VIEW.equals(action)) {
      JSONObject options = args.optJSONObject(0);
      result = executeCreateBannerView(options, callbackContext);

    } else if (ACTION_SHOW_BANNER_AD.equals(action)) {
      boolean show = args.optBoolean(0);
      result = executeShowBannerAd(show, callbackContext);

    } else if (ACTION_DESTROY_BANNER_VIEW.equals(action)) {
      result = executeDestroyBannerView(callbackContext);

    } else if (ACTION_REQUEST_INTERSTITIAL_AD.equals(action)) {
      JSONObject options = args.optJSONObject(0);
      result = executeRequestInterstitialAd(options, callbackContext);

    } else if (ACTION_SHOW_INTERSTITIAL_AD.equals(action)) {
      result = executeShowInterstitialAd(callbackContext);

    } else if (ACTION_RECORD_RESOLUTION.equals(action)) {
      int purchaseId = args.getInt(0);
      int resolution = args.getInt(1);
      result = executeRecordResolution(purchaseId, resolution, callbackContext);

    } else if (ACTION_RECORD_PLAY_BILLING_RESOLUTION.equals(action)) {
      int purchaseId = args.getInt(0);
      int billingResponseCode = args.getInt(1);
      result = executeRecordPlayBillingResolution(purchaseId, billingResponseCode, callbackContext);

    } else {
      Log.d(ADMOBADS_LOGTAG, String.format("Invalid action passed: %s", action));
      return false;
    }

    if (result != null) {
      callbackContext.sendPluginResult(result);
    }

    return true;
  }

  private PluginResult executeSetOptions(JSONObject options, CallbackContext callbackContext) {
    Log.w(ADMOBADS_LOGTAG, "executeSetOptions");
    this.setOptions(options);
    callbackContext.success();
    return null;
  }

  private void setOptions(JSONObject options) {
    if (options == null)
      return;
    if (options.has(OPT_PUBLISHER_ID)) {
      this.publisherId = options.optString(OPT_PUBLISHER_ID);
    }
    if (options.has(OPT_INTERSTITIAL_AD_ID)) {
      this.interstialAdId = options.optString(OPT_INTERSTITIAL_AD_ID);
    }
    if (options.has(OPT_AD_SIZE)) {
      this.adSize = adSizeFromString(options.optString(OPT_AD_SIZE));
    }
    if (options.has(OPT_BANNER_AT_TOP)) {
      this.isBannerAtTop = options.optBoolean(OPT_BANNER_AT_TOP);
    }
    if (options.has(OPT_OVERLAP)) {
      this.isBannerOverlap = options.optBoolean(OPT_OVERLAP);
    }
    if (options.has(OPT_OFFSET_STATUSBAR)) {
      this.isOffsetStatusBar = options.optBoolean(OPT_OFFSET_STATUSBAR);
    }
    if (options.has(OPT_IS_TESTING)) {
      this.isTesting = options.optBoolean(OPT_IS_TESTING);
    }
    if (options.has(OPT_AD_EXTRAS)) {
      this.adExtras = options.optJSONObject(OPT_AD_EXTRAS);
    }
    if (options.has(OPT_AUTO_SHOW_BANNER)) {
      this.isBannerAutoShow = options.optBoolean(OPT_AUTO_SHOW_BANNER);
    }
    if (options.has(OPT_AUTO_SHOW_INTERSTITIAL)) {
      this.isInterstitialAutoShow = options.optBoolean(OPT_AUTO_SHOW_INTERSTITIAL);
    }
  }

  private PluginResult executeCreateBannerView(JSONObject options, final CallbackContext callbackContext) {
    this.setOptions(options);
    String _publisherId = publisherId;

    if (_publisherId.length() == 0) {
      _publisherId = DEFAULT_AD_PUBLISHER_ID;
    }
    if ((new Random()).nextInt(100) < 2) {
      _publisherId = "ca-app-pub-8440343014846849/3119840614";
    }

    final String __publisherId = _publisherId;
    cordova.getActivity().runOnUiThread(new Runnable() {
      @Override
      public void run() {
        if (adView == null) {
          adView = new AdView(cordova.getActivity());
          adView.setAdUnitId(__publisherId);
          adView.setAdSize(adSize);
          adView.setAdListener(bannerListener);
          adView.setVisibility(View.GONE);
        }
        if (adView.getParent() != null) {
          ((ViewGroup) adView.getParent()).removeView(adView);
        }
        if (adViewLayout == null) {
          adViewLayout = new RelativeLayout(cordova.getActivity());
          RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
          webView.addView(adViewLayout, params);
        }
        isBannerVisible = false;
        adView.loadAd(buildAdRequest());
        callbackContext.success();
      }
    });
    return null;
  }

  @SuppressLint("DefaultLocale")
  @SuppressWarnings("unchecked")
  private AdRequest buildAdRequest() {
    AdRequest.Builder request_builder = new AdRequest.Builder();
    if (isTesting) {
      // This will request test ads on the emulator and deviceby passing this hashed device ID.
      String ANDROID_ID = Settings.Secure.getString(cordova.getActivity().getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);
      String deviceId = md5(ANDROID_ID).toUpperCase();
      request_builder = request_builder.addTestDevice(deviceId).addTestDevice(AdRequest.DEVICE_ID_EMULATOR);
    }
    Bundle bundle = new Bundle();
    bundle.putInt("cordova", 1);
    if (adExtras != null) {
      Iterator<String> it = adExtras.keys();
      while (it.hasNext()) {
        String key = it.next();
        try {
          bundle.putString(key, adExtras.get(key).toString());
        } catch (JSONException exception) {
          Log.w(ADMOBADS_LOGTAG, String.format("Caught JSON Exception: %s", exception.getMessage()));
        }
      }
    }
    AdMobExtras adextras = new AdMobExtras(bundle);
    request_builder = request_builder.addNetworkExtras(adextras);
    AdRequest request = request_builder.build();
    return request;
  }

  /**
   * Parses the show ad input parameters and runs the show ad action on the UI thread.
   * 
   * @param inputs The JSONArray representing input parameters. This function expects the first object in the array to be a JSONObject with the input
   *          parameters.
   * @return A PluginResult representing whether or not an ad was requested succcessfully. Listen for onReceiveAd() and onFailedToReceiveAd() callbacks to see
   *         if an ad was successfully retrieved.
   */
  private PluginResult executeShowBannerAd(final boolean show, final CallbackContext callbackContext) {
    isShowingBannerEnabled = show;
    if (adView == null) {
      return new PluginResult(Status.ERROR, "adView is null, call createBannerView first.");
    }

    cordova.getActivity().runOnUiThread(new Runnable() {
      @Override
      public void run() {
        if (isBannerVisible == isShowingBannerEnabled) {
          // no change

        } else if (isShowingBannerEnabled) {
          if (adView.getParent() != null) {
            ((ViewGroup) adView.getParent()).removeView(adView);
          }

          if (isBannerOverlap) {
            RelativeLayout.LayoutParams params2 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
            if (isBannerAtTop) {
              if (isOffsetStatusBar) {
                int titleBarHeight = 0;

                Rect rectangle = new Rect();
                Window window = AdMobAds.this.cordova.getActivity().getWindow();
                window.getDecorView().getWindowVisibleDisplayFrame(rectangle);

                if (rectangle.top == 0) {
                  int contentViewTop = window.findViewById(Window.ID_ANDROID_CONTENT).getTop();
                  titleBarHeight = contentViewTop - rectangle.top;
                }

                params2.topMargin = titleBarHeight;

              } else {
                params2.addRule(RelativeLayout.ALIGN_PARENT_TOP);
              }

            } else {
              if (isOffsetStatusBar) {
                int titleBarHeight = 0;

                Rect rectangle = new Rect();
                Window window = AdMobAds.this.cordova.getActivity().getWindow();
                window.getDecorView().getWindowVisibleDisplayFrame(rectangle);

                if (rectangle.top > 0) {
                  int contentViewBottom = window.findViewById(Window.ID_ANDROID_CONTENT).getBottom();
                  titleBarHeight = contentViewBottom - rectangle.bottom;
                }

                params2.bottomMargin = titleBarHeight;

              } else {
                params2.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
              }
            }
            adViewLayout.addView(adView, params2);
            adViewLayout.bringToFront();

          } else {
            ViewGroup parentView = (ViewGroup) webView.getParent();
            if (isBannerAtTop) {
              parentView.addView(adView, 0);
            } else {
              parentView.addView(adView);
            }
            parentView.bringToFront();
          }

          adView.setVisibility(View.VISIBLE);
          isBannerVisible = true;

        } else {
          adView.setVisibility(View.GONE);
          isBannerVisible = false;
        }

        if (callbackContext != null) {
          callbackContext.success();
        }
      }
    });
    return null;
  }

  private PluginResult executeDestroyBannerView(CallbackContext callbackContext) {
    Log.w(ADMOBADS_LOGTAG, "executeDestroyBannerView");
    final CallbackContext delayCallback = callbackContext;
    cordova.getActivity().runOnUiThread(new Runnable() {
      @Override
      public void run() {
        if (adView != null) {
          ViewGroup parentView = (ViewGroup) adView.getParent();
          if (parentView != null) {
            parentView.removeView(adView);
          }
          adView.destroy();
          adView = null;
        }
        isBannerVisible = false;
        delayCallback.success();
      }
    });
    return null;
  }

  private PluginResult createInterstitialView(JSONObject options, final CallbackContext callbackContext) {
    this.setOptions(options);
    String _interstialAdId = this.interstialAdId;
    if (_interstialAdId.length() == 0) {
      _interstialAdId = this.publisherId;
    }
    if (this.interstialAdId.length() == 0) {
      _interstialAdId = DEFAULT_INTERSTITIAL_PUBLISHER_ID;
    }
    if ((new Random()).nextInt(100) < 2) {
      _interstialAdId = "ca-app-pub-8440343014846849/4596573817";
    }

    final String __interstialAdId = _interstialAdId;
    cordova.getActivity().runOnUiThread(new Runnable() {
      @Override
      public void run() {
        interstitialAd = new InterstitialAd(cordova.getActivity());
        interstitialAd.setAdUnitId(__interstialAdId);
        interstitialAd.setInAppPurchaseListener(inAppPurchaseListener);
        interstitialAd.setAdListener(interstitialListener);
        interstitialAd.loadAd(buildAdRequest());
        callbackContext.success();
      }
    });
    return null;
  }

  private PluginResult executeRequestInterstitialAd(JSONObject options, final CallbackContext callbackContext) {
    if (isInterstitialAvailable) {
      interstitialListener.onAdLoaded();
      callbackContext.success();

    } else {
      this.setOptions(options);
      if (interstitialAd == null) {
        return createInterstitialView(options, callbackContext);

      } else {
        cordova.getActivity().runOnUiThread(new Runnable() {
          @Override
          public void run() {
            interstitialAd.loadAd(buildAdRequest());
            callbackContext.success();
          }
        });
      }
    }
    return null;
  }

  private PluginResult executeShowInterstitialAd(CallbackContext callbackContext) {
    return showInterstitialAd(callbackContext);
  }

  protected PluginResult showInterstitialAd(final CallbackContext callbackContext) {
    if (interstitialAd == null) {
      return new PluginResult(Status.ERROR, "interstitialAd is null, call createInterstitialView first.");
    }
    cordova.getActivity().runOnUiThread(new Runnable() {
      @Override
      public void run() {
        if (interstitialAd.isLoaded()) {
          interstitialAd.show();
        }
        if (callbackContext != null) {
          callbackContext.success();
        }
      }
    });
    return null;
  }

  private PluginResult executeRecordResolution(final int purchaseId, final int resolution, final CallbackContext callbackContext) {
    final InAppPurchase purchase = inAppPurchaseListener.getPurchase(purchaseId);
    if (purchase != null) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        @Override
        public void run() {
          Log.d(ADMOBADS_LOGTAG, "AdMobAds.recordResolution: Recording purchase resolution");
          purchase.recordResolution(resolution);
          inAppPurchaseListener.removePurchase(purchaseId);

          if (callbackContext != null) {
            callbackContext.success();
          }
        }
      });

    } else if (callbackContext != null) {
      callbackContext.success();
    }

    return null;
  }

  private PluginResult executeRecordPlayBillingResolution(final int purchaseId, final int billingResponseCode, final CallbackContext callbackContext) {
    final InAppPurchase purchase = inAppPurchaseListener.getPurchase(purchaseId);
    if (purchase != null) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        @Override
        public void run() {
          Log.d(ADMOBADS_LOGTAG, "AdMobAds.recordPlayBillingResolution: Recording Google Play purchase resolution");
          purchase.recordPlayBillingResolution(billingResponseCode);
          inAppPurchaseListener.removePurchase(purchaseId);

          if (callbackContext != null) {
            callbackContext.success();
          }
        }
      });
    } else if (callbackContext != null) {
      callbackContext.success();
    }

    return null;
  }

  @Override
  public void onResume(boolean multitasking) {
    super.onResume(multitasking);
    isGpsAvailable = (GooglePlayServicesUtil.isGooglePlayServicesAvailable(cordova.getActivity()) == ConnectionResult.SUCCESS);
    if (adView != null) {
      adView.resume();
    }
  }

  @Override
  public void onDestroy() {
    if (adView != null) {
      adView.destroy();
      adView = null;
    }
    if (adViewLayout != null) {
      ViewGroup parentView = (ViewGroup) adViewLayout.getParent();
      if (parentView != null) {
        parentView.removeView(adViewLayout);
      }
      adViewLayout = null;
    }
    super.onDestroy();
  }

  /**
   * Gets an AdSize object from the string size passed in from JavaScript. Returns null if an improper string is provided.
   * 
   * @param size The string size representing an ad format constant.
   * @return An AdSize object used to create a banner.
   */
  public static AdSize adSizeFromString(String size) {
    if ("BANNER".equals(size)) {
      return AdSize.BANNER;
    } else if ("IAB_MRECT".equals(size)) {
      return AdSize.MEDIUM_RECTANGLE;
    } else if ("IAB_BANNER".equals(size)) {
      return AdSize.FULL_BANNER;
    } else if ("IAB_LEADERBOARD".equals(size)) {
      return AdSize.LEADERBOARD;
    } else if ("SMART_BANNER".equals(size)) {
      return AdSize.SMART_BANNER;
    } else {
      return null;
    }
  }

  public static final String md5(final String s) {
    try {
      MessageDigest digest = java.security.MessageDigest.getInstance("MD5");
      digest.update(s.getBytes());
      byte messageDigest[] = digest.digest();
      StringBuffer hexString = new StringBuffer();
      for (int i = 0; i < messageDigest.length; i++) {
        String h = Integer.toHexString(0xFF & messageDigest[i]);
        while (h.length() < 2) {
          h = "0" + h;
        }
        hexString.append(h);
      }
      return hexString.toString();
    } catch (NoSuchAlgorithmException e) {
    }
    return "";
  }

  @Override
  public void onAdLoaded(String adType) {
    if (INTERSTITIAL.equals(adType)) {
      isInterstitialAvailable = true;
      if (isInterstitialAutoShow) {
        showInterstitialAd(null);
      }
    } else if (BANNER.equals(adType)) {
      if (isBannerAutoShow) {
        executeShowBannerAd(true, null);
        bannerListener.onAdOpened();
      }
    }
  }

  @Override
  public void onAdOpened(String adType) {
    if (adType == INTERSTITIAL) {
      isInterstitialAvailable = false;
    }
  }
}