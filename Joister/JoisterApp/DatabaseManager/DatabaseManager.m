//
//  DatabaseManager.m
//  JoisterApp
//
//  Created by Narendra.b on 03/11/15.
//  Copyright (c) 2015 Narendra.b. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

+(DatabaseManager *)sharedDatabaseManager {
    static dispatch_once_t taken;
    static DatabaseManager *shared = nil;
    
    dispatch_once(&taken, ^{
        shared = [[DatabaseManager alloc] init];
    });
    return shared;
}

-(void)createDatabase
{
    // First, test for existence.
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [cacheDirectory stringByAppendingPathComponent:@"joisterDB.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];

    if (success) {
        self.database = [FMDatabase databaseWithPath:writableDBPath];
    }else {
    // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"joisterDB.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        self.database = [FMDatabase databaseWithPath:writableDBPath];
    }

}

-(void)openDatabase
{
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [NSString stringWithFormat:@"%@/",[paths objectAtIndex:0]];
    //Getting the DB File name
    NSString *fileName = @"joisterDB";
    
    NSString *writableDBPath = [NSString stringWithFormat:@"%@/%@",cacheDirectory,fileName];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if(success) {
        self.database = [FMDatabase databaseWithPath:writableDBPath];
    }
}


@end
