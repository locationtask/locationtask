//
//  NSURLRequest+NSURLRequestSSLY.h
//  JoisterApp
//
//  Created by Narendra.b on 03/11/15.
//  Copyright (c) 2015 Narendra.b. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (NSURLRequestSSLY)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
@end
