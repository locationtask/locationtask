//
//  Utilities.m
//  JoisterApp
//
//  Created by Narendra.b on 03/11/15.
//  Copyright (c) 2015 Narendra.b. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

#pragma mark -
#pragma mark Global Usage of the HUD
#pragma mark -

+ (void)showGlobalProgressHUDWithTitle:(NSString *)title {

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.labelText = title;
    });
}

+ (void)dismissGlobalHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Do something...
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        [MBProgressHUD hideHUDForView:window animated:YES];
    });
    
    
    
}
@end
