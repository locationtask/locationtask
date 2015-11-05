//
//  DatabaseManager.h
//  JoisterApp
//
//  Created by Narendra.b on 03/11/15.
//  Copyright (c) 2015 Narendra.b. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseManager : NSObject

@property(nonatomic,strong) FMDatabase *database;

+(DatabaseManager *)sharedDatabaseManager;
-(void)createDatabase;
-(void)openDatabase;

@end
