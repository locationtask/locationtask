//
//  HomeScreenViewController.m
//  JoisterApp
//
//  Created by Narendra.b on 04/11/15.
//  Copyright (c) 2015 Narendra.b. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "LocationManager.h"
#import "Location.h"
#import "LocationTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

@interface HomeScreenViewController () <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate> {
 
    IBOutlet UITableView *locationTableView;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D userCoordinate;
    NSMutableArray *locationMainArray;
    NSArray *sectionHeader;
}
@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Creating Section Headers
    sectionHeader = @[@"Distance within 2km",
                      @"Distance within 5km",
                      @"Distance within 10km",
                      @"Distance above 10km"];
    
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 500; // meters
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}
//delegate that tells authorization status for the application changed. The location manager object reporting the event
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
       //User Denied the Authorization, show an alert to enable when he need
    }
    else if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [locationManager startUpdatingLocation];
    }
    
}
//delegate that tells new location data is available. The location manager object that generated the triggers event. (startUpdatingLocation)
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        //Should be looping into this for every 15 seconds, instead of 1 or 2 seconds.
        userCoordinate = location.coordinate;
        [self mappingWithCurrentLocaiton];
    }
}

-(void)mappingWithCurrentLocaiton {
    LocationManager *location = [[LocationManager alloc] init];
    CGFloat lat = userCoordinate.latitude;
    CGFloat lng = userCoordinate.longitude;
    //Making a call with updated coordinates and calculate list with different distances
    locationMainArray = [[location calculateByDistanceFromLocation:lat lng:lng] mutableCopy];
    [locationTableView reloadData];
}

#pragma mark- Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *locArray = [NSArray arrayWithArray:[locationMainArray objectAtIndex:section]];
    return locArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [sectionHeader count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSMutableString *theString =[sectionHeader objectAtIndex:section];
    return theString;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier1 = @"cell";
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[LocationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
    }
    NSArray *locArray = [NSArray arrayWithArray:[locationMainArray objectAtIndex:indexPath.section]];
    Location *loc = (Location *)[locArray objectAtIndex:indexPath.row];
    cell.addressOne.text = loc.address_one;
    cell.addressTwo.text = loc.address_two;
    cell.landMark.text   = [NSString stringWithFormat:@"Landmark: %@",loc.landmark];
    return cell;
}
#pragma mark-

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
