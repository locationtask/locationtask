//
//  ViewController.m
//  JoisterApp
//
//  Created by Narendra.b on 03/11/15.
//  Copyright (c) 2015 Narendra.b. All rights reserved.
//

#import "ViewController.h"
#import "DatabaseManager.h"
#import "NSURLConnection+Blocks.h"
#import "LocationManager.h"
#import "HomeScreenViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Finding whether we have Data in the DB
    [self findDataFromDB];
}
//Making Asyncrequest
-(void)makeSignInAPICall {
    //Making API call to SignIn to get k and c value
    [Utilities showGlobalProgressHUDWithTitle:@"SignIn..."];
    NSURL *url = [NSURL URLWithString:SIGN_IN_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    request.HTTPBody = [self signinParameterInfo];
    [NSURLConnection asyncRequest:request
                          success:^(NSData *data, NSURLResponse *response) {
                            [Utilities dismissGlobalHUD];
                              NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                              NSString *result = [responseData objectForKey:@"result"];
                              if([result isEqualToString:@"success"]) {

                                  NSString *cValue = [[responseData objectForKey:@"data"] objectForKey:@"c"];
                                  NSString *kValue = [[responseData objectForKey:@"data"] objectForKey:@"k"];
                                  //Makeing API call for get Location Data
                                  [self makeSyncDataAPICallWithKey:cValue :kValue];
                              }
                              
                          }
                          failure:^(NSData *data, NSError *error) {
                              NSLog(@"Error: %@", error);
                            [Utilities dismissGlobalHUD];
                          }];
    
}
//Making Asyncrequest
-(void)makeSyncDataAPICallWithKey:(NSString *)cValue : (NSString *)kValue {
    //Makeing API call for get Location Data
    [Utilities showGlobalProgressHUDWithTitle:@"Fetching Data..."];
    NSURL *url = [NSURL URLWithString:SYNC_DATA_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    request.timeoutInterval=300.0;
    request.HTTPBody = [self syncDataParameterInfoWithValues:cValue :kValue];
    [NSURLConnection asyncRequest:request
                          success:^(NSData *data, NSURLResponse *response) {
                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                              NSArray *locationArray = [responseDictionary objectForKey:@"locations"];
                              [Utilities dismissGlobalHUD];
                              LocationManager *locationManager = [[LocationManager alloc]init];
                              [locationManager insertRecordsIntoLocationTableWithArray:locationArray];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self navigateToHomeScreen];
                              });
                              
                          }
                          failure:^(NSData *data, NSError *error) {
                              NSLog(@"Error: %@", error);
                              [Utilities dismissGlobalHUD];
                          }];
    
}
- (NSData *)signinParameterInfo {
    
    NSDictionary *param = @{@"username":@"narendra.b",
                                @"password":@"gt12345678",
                                @"is_mobile":@"1",
                                @"os_version":@"5.1.1",
                                @"device_key":@"123456789",
                                @"browser_version":@"",
                                @"device":@"android",
                                @"mobile_app_name":@"Joister",
                                @"remember_me":@"1"
                                };
    NSError *error;
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:param
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    return jsondata;
    
}
- (NSData *)syncDataParameterInfoWithValues:(NSString *)cValue : (NSString *)kValue {
    
    NSDictionary *param = @{@"c":cValue,
                            @"k":kValue
                            };
    NSError *error;
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:param
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    return jsondata;
    
}

-(void)findDataFromDB {
    //Checking if DB has Records, if we don't have record make a API call to get Records
    [[DatabaseManager sharedDatabaseManager] openDatabase];
    BOOL isDataBaseOpen =  [[[DatabaseManager sharedDatabaseManager] database] open];
    if(isDataBaseOpen) {
        NSString *query = [NSString stringWithFormat:@"select count(*) as totRec from location"];
        FMResultSet *resultSet = [[[DatabaseManager sharedDatabaseManager] database] executeQuery:query];
        [resultSet next];
        int totalRecords = [[resultSet objectForColumnName:@"totRec"] integerValue];
        [[[DatabaseManager sharedDatabaseManager] database] close];
        //Checking total record if no records in DB, make a call to signin and sync data
        if(totalRecords==0) {
            [self makeSignInAPICall];
        }else {
        //Since we have records, navigate to home screen and populate records in tableview
            [self navigateToHomeScreen];
        }
        
    }
}

-(void)navigateToHomeScreen {
    [self performSegueWithIdentifier:@"homeSegue" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
