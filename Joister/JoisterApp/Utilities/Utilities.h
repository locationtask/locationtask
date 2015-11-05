//
//  Utilities.h
//  JoisterApp
//
//  Created by Narendra.b on 03/11/15.
//  Copyright (c) 2015 Narendra.b. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Utilities : NSObject

//PROGRESS HUB METHODS
+ (void)showGlobalProgressHUDWithTitle:(NSString *)title;
+ (void)dismissGlobalHUD;

@end
