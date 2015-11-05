//
//  LocationManager.h
//  JoisterApp
//
//  Created by Narendra.b on 04/11/15.
//  Copyright (c) 2015 Narendra.b. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject
-(void)insertRecordsIntoLocationTableWithArray:(NSArray *)locationArray;
-(NSMutableArray *)calculateByDistanceFromLocation:(CGFloat )lat lng:(CGFloat)lng;
@end
