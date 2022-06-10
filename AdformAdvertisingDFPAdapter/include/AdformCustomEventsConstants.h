//
//  AdformCustomEventsConstants.h
//  dfp-mediation
//
//  Created by Vladas Drejeris on 05/05/16.
//  Copyright © 2016 adform. All rights reserved.
//

#import <Foundation/Foundation.h>

// These keys may be used to assign additional parameters
// to Adform custom event objects.

/**
 Use this parameter to set a NSDictionary with key value pairs 
 to custom event extras to be passed to Adform banners.
 */
extern NSString * const kAFAKeyValuesKey;

/**
 Use this parameter to set a NSURL with custom impression 
 to custom event extras to be passed to Adform banners.
 */
extern NSString * const kAFACustomImpressionKey;
