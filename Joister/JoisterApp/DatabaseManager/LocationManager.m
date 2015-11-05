//
//  LocationManager.m
//  JoisterApp
//
//  Created by Narendra.b on 04/11/15.
//  Copyright (c) 2015 Narendra.b. All rights reserved.
//

#import "LocationManager.h"
#import "Location.h"
#import "DatabaseManager.h"

@implementation LocationManager

-(void)insertRecordsIntoLocationTableWithArray:(NSArray *)locationArray {
    NSString *insertQuery;
    //Singleton Datamanager database open
    [[[DatabaseManager sharedDatabaseManager] database] open];
    //Iterating LocationArray and Inserting Records into DB table
    for (NSDictionary *locationDictionary in locationArray) {
        insertQuery = [NSString stringWithFormat:@"insert into location values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[locationDictionary objectForKey:@"availability_type"],
                       [locationDictionary objectForKey:@"availability_type"],
                       [locationDictionary objectForKey:@"address_one"],
                       [locationDictionary objectForKey:@"address_two"],
                       [locationDictionary objectForKey:@"landmark"],
                       [locationDictionary objectForKey:@"country"],
                       [locationDictionary objectForKey:@"states"],
                       [locationDictionary objectForKey:@"city"],
                       [locationDictionary objectForKey:@"pincode"],
                       [locationDictionary objectForKey:@"latitude"],
                       [locationDictionary objectForKey:@"longitude"],
                       [locationDictionary objectForKey:@"node_id"],
                       [locationDictionary objectForKey:@"product_id"],
                       [locationDictionary objectForKey:@"updated"]];
       
    [[[DatabaseManager sharedDatabaseManager] database] executeUpdate:insertQuery];
    }
    
    [[[DatabaseManager sharedDatabaseManager] database] close];
}
-(NSMutableArray *)calculateByDistanceFromLocation:(CGFloat )lat lng:(CGFloat)lng {
    //Hardcoded default values
    //ToDo: Need to remove below 2 lines
    lat = 19.10551362917248;
    lng = 72.88121938705444;
    
    //Creating mainArrays to hold subArrays of differnt distances
    NSMutableArray *locationMainArray = [NSMutableArray array];
    
    /*NSString *query  = [NSString stringWithFormat:@"SELECT *,(((acos(sin(('%f'*pi()/180)) * sin(('Latitude'*pi()/180))+cos(('%f'*pi()/180)) * cos(('Latitude'*pi()/180)) * cos((('%f'- 'Longitude')*pi()/180))))*180/pi())*60*1.1515*1.609344) as distance FROM 'location' WHERE distance >= '2'",lat,lat,lng];
     
    // NSString *searchNearMeQuery = [NSString stringWithFormat:@"SELECT *, ( 6371 * acos( cos( radians({%f}) ) * cos( radians( 'latitude' ) ) * cos( radians( 'longitude' ) - radians({%f}) ) + sin( radians({%f}) ) * sin( radians( 'latitude' ) ) ) ) AS distance    FROM locations     HAVING distance <= 2000    ORDER BY distance ASC",lat,lng,lat];
     */
    [[[DatabaseManager sharedDatabaseManager] database] open];
    
    int count=1;
    while(count<=4) {
        //Creating subArrays with Distances
        NSArray *distance = [[NSArray alloc]initWithObjects:@"<=2",@"<=5",@"<=10",@">=10", nil];
        NSString *query = [NSString stringWithFormat:@"SELECT ((((%f-latitude) *(%f-latitude)) + ((%f-longitude)* (%f-longitude)))*10000) as distance, * FROM location where distance %@ ORDER BY distance desc",lat,lat,lng,lng,[distance objectAtIndex:count-1]];

        FMResultSet *rs = [[[DatabaseManager sharedDatabaseManager] database] executeQuery:query];
        NSMutableArray *locationSubArray = [NSMutableArray array];
        while ([rs next]) {
            Location *loc =[[Location alloc]init];
            loc.availablity_Id      =   [rs stringForColumn:@"availability_Id"];
            loc.availablity_type    =   [rs stringForColumn:@"availability_type"];
            loc.address_one         =   [rs stringForColumn:@"address_one"];
            loc.address_two         =   [rs stringForColumn:@"address_two"];
            loc.landmark            =   [rs stringForColumn:@"landmark"];
            loc.country             =   [rs stringForColumn:@"country"];
            loc.states              =   [rs stringForColumn:@"states"];
            loc.city                =   [rs stringForColumn:@"city"];
            loc.pincode             =   [rs stringForColumn:@"pincode"];
            loc.latitude            =   [rs stringForColumn:@"latitude"];
            loc.longitude           =   [rs stringForColumn:@"longitude"];
            loc.node_id             =   [rs stringForColumn:@"node_id"];
            loc.product_id          =   [rs stringForColumn:@"product_id"];
            loc.updated             =   [rs stringForColumn:@"updated"];
            
            [locationSubArray addObject:loc];
        }
        count++;
        [locationMainArray addObject:locationSubArray];
    }
    return locationMainArray;
}
@end
