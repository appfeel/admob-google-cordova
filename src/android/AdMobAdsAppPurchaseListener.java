/*
 AdMobAdsPurchaseListener.java
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
import android.util.SparseArray;

import com.google.android.gms.ads.purchase.InAppPurchase;
import com.google.android.gms.ads.purchase.InAppPurchaseListener;

@SuppressLint("DefaultLocale")
public class AdMobAdsAppPurchaseListener implements InAppPurchaseListener {
    private AdMobAds admobAds;
    private static int purchaseId = 0;
    private SparseArray<InAppPurchase> purchases = new SparseArray<InAppPurchase>();

    public AdMobAdsAppPurchaseListener(AdMobAds admobAds) {
        this.admobAds = admobAds;
    }

    @Override
    synchronized public void onInAppPurchaseRequested(final InAppPurchase inAppPurchase) {
        admobAds.cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d(AdMobAds.ADMOBADS_LOGTAG, "AdMobAdsAppPurchaseListener.onInAppPurchaseRequested: In app purchase. SKU: " + inAppPurchase.getProductId());
                purchases.put(purchaseId, inAppPurchase);
                String event = String.format("javascript:cordova.fireDocumentEvent(admob.events.onInAppPurchaseRequested, { 'purchaseId': %d, 'productId': '%s' });", purchaseId, inAppPurchase.getProductId());
                admobAds.webView.loadUrl(event);
                purchaseId++;
            }
        });
    }

    public InAppPurchase getPurchase(int purchaseId) {
        return purchases.get(purchaseId);
    }

    public void removePurchase(int purchaseId) {
        purchases.remove(purchaseId);
    }

}
