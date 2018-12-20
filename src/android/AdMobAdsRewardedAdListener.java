/*
 AdMobAdsListener.java
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

package com.appfeel.cordova.admob;

import android.annotation.SuppressLint;
import android.util.Log;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.reward.RewardedVideoAdListener;
import com.google.android.gms.ads.reward.RewardItem;

@SuppressLint("DefaultLocale")
public class AdMobAdsRewardedAdListener implements RewardedVideoAdListener {

    private String adType = "";
    private AdMobAds admobAds;
    private boolean isBackFill = false;

    public AdMobAdsRewardedAdListener(String adType, AdMobAds admobAds, boolean isBackFill) {
        this.adType = adType;
        this.admobAds = admobAds;
        this.isBackFill = isBackFill;
    }

    @Override
    public void onRewarded(RewardItem reward) {
        admobAds.cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d(AdMobAds.ADMOBADS_LOGTAG, adType + ": rewarded");
                String event = String.format("javascript:cordova.fireDocumentEvent(admob.events.onRewardedAd, { 'adType': '%s' });", adType);
                admobAds.webView.loadUrl(event);
            }
        });
    }

    @Override
    public void onRewardedVideoAdLeftApplication() {
        admobAds.cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d(AdMobAds.ADMOBADS_LOGTAG, adType + ": left application");
                String event = String.format("javascript:cordova.fireDocumentEvent(admob.events.onAdLeftApplication, { 'adType': '%s' });", adType);
                admobAds.webView.loadUrl(event);
            }
        });
    }

    @Override
    public void onRewardedVideoAdClosed() {
        admobAds.cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d(AdMobAds.ADMOBADS_LOGTAG, adType + ": ad closed after clicking on it");
                String event = String.format("javascript:cordova.fireDocumentEvent(admob.events.onAdClosed, { 'adType': '%s' });", adType);
                admobAds.webView.loadUrl(event);
            }
        });
    }

    @Override
    public void onRewardedVideoAdFailedToLoad(int errorCode) {
        if (this.isBackFill) {
            final int code = errorCode;
            admobAds.cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    String reason = getErrorReason(code);
                    Log.d(AdMobAds.ADMOBADS_LOGTAG, adType + ": failed to load ad (" + reason + ")");
                    String event = String.format("javascript:cordova.fireDocumentEvent(admob.events.onAdFailedToLoad, { 'adType': '%s', 'error': %d, 'reason': '%s' });", adType, code, reason);
                    admobAds.webView.loadUrl(event);
                }
            });
        } else {
            admobAds.tryBackfill(adType);
        }
    }

    /**
     * Gets a string error reason from an error code.
     */
    public String getErrorReason(int errorCode) {
        String errorReason = "Unknown";
        switch (errorCode) {
            case AdRequest.ERROR_CODE_INTERNAL_ERROR:
                errorReason = "Internal error";
                break;
            case AdRequest.ERROR_CODE_INVALID_REQUEST:
                errorReason = "Invalid request";
                break;
            case AdRequest.ERROR_CODE_NETWORK_ERROR:
                errorReason = "Network Error";
                break;
            case AdRequest.ERROR_CODE_NO_FILL:
                errorReason = "No fill";
                break;
        }
        return errorReason;
    }

    @Override
    public void onRewardedVideoAdLoaded() {
        admobAds.onAdLoaded(adType);
        admobAds.cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d(AdMobAds.ADMOBADS_LOGTAG, adType + ": ad loaded");
                String event = String.format("javascript:cordova.fireDocumentEvent(admob.events.onAdLoaded, { 'adType': '%s' });", adType);
                admobAds.webView.loadUrl(event);
            }
        });
    }

    @Override
    public void onRewardedVideoAdOpened() {
        admobAds.onAdOpened(adType);
        admobAds.cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d(AdMobAds.ADMOBADS_LOGTAG, adType + ": ad opened");
                String event = String.format("javascript:cordova.fireDocumentEvent(admob.events.onAdOpened, { 'adType': '%s' });", adType);
                admobAds.webView.loadUrl(event);
            }
        });
    }

    @Override
    public void onRewardedVideoStarted() {
        admobAds.cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d(AdMobAds.ADMOBADS_LOGTAG, adType + ": ad video started");
                String event = String.format("javascript:cordova.fireDocumentEvent(admob.events.onRewardedAdVideoStarted, { 'adType': '%s' });", adType);
                admobAds.webView.loadUrl(event);
            }
        });
    }

    @Override
    public void onRewardedVideoCompleted() {
        admobAds.cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d(AdMobAds.ADMOBADS_LOGTAG, adType + ": ad video completed");
                String event = String.format("javascript:cordova.fireDocumentEvent(admob.events.onRewardedAdVideoCompleted, { 'adType': '%s' });", adType);
                admobAds.webView.loadUrl(event);
            }
        });
    }

}
