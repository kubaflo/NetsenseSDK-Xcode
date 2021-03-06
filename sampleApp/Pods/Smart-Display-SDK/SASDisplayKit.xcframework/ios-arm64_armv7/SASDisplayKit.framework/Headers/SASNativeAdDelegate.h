//
//  SASNativeAdDelegate.h
//  SmartAdServer
//
//  Created by Julien Gomez on 12/10/2015.
//  Copyright © 2018 Smart AdServer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SASNativeAd;

/**
 Protocol that must be implemented by SASNativeAd delegate.
 */
@protocol SASNativeAdDelegate <NSObject>

@optional

/**
 Asks the delegate whether the SDK should handles the opening action for the provided URL.
 
 You can implement this method if you want to process some URLs yourself, for instance to make
 an in app redirection.
 
 @note Please note that click pixels will be sent, even if you choose to handle a particular URL yourself.
 
 @param nativeAd The instance of SASAdNativeAd responsible for the click.
 @param URL The URL that will be called.
 @return YES if the Smart Display SDK should handle the URL, NO if the app should do it by itself.
 
 @note This method is deprecated and will be removed in future releases. Publishers should not interfere client-side with clicks to avoid counting issues. However, if you still want to be warned in case of click, implement the nativeAd:didClickWithUrl: method.
 */
- (BOOL)nativeAd:(SASNativeAd *)nativeAd shouldHandleClickURL:(NSURL *)URL __deprecated_msg("Use 'nativeAd:didClickWithURL:' instead");

/**
 Notifies the delegate when a click is performed on the native ad.
 
 @param nativeAd The instance of SASAdNativeAd.
 @param URL The URL that is called.
 */
- (void)nativeAd:(SASNativeAd *)nativeAd didClickWithURL:(NSURL *)URL;

/**
 Notifies the delegate that a modal view will appear to display the ad's landing page.
 
 @param nativeAd The instance of SASAdNativeAd displaying the modal view.
 */
- (void)nativeAdWillPresentModalView:(SASNativeAd *)nativeAd;

/**
 Notifies the delegate that the previously open modal view will be dismissed.
 
 @param nativeAd The instance of SASAdNativeAd closing the modal view.
 */
- (void)nativeAdWillDismissModalView:(SASNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
