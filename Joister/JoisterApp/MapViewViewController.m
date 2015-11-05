//
//  MapViewViewController.m
//  Joister
//
//  Created by Narendra.b on 05/11/15.
//  Copyright (c) 2015 Narendra.b. All rights reserved.
//

#import "MapViewViewController.h"
#import "LRouteController.h"

@interface MapViewViewController () <GMSMapViewDelegate> {
    LRouteController *routeController;
    GMSPolyline *polyline;
    GMSMarker *markerStart;
    GMSMarker *markerFinish;
}
@property (strong, nonatomic) IBOutlet GMSMapView *gmsMapView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *showDetails;
@property (strong, nonatomic) IBOutlet UILabel *addressOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *landmarkLabel;

@end

@implementation MapViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.location!=nil) {
        float lat = [self.location.latitude floatValue];
        float lng = [self.location.longitude floatValue];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                                longitude:lng
                                                                     zoom:18];
        self.gmsMapView.camera = camera;
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
        markerFinish= [GMSMarker markerWithPosition:position];
        markerFinish.icon = [UIImage imageNamed:@"greenDot"];
        markerFinish.map = self.gmsMapView;
        
        self.addressOneLabel.text   =   self.location.address_one;
        self.addressTwoLabel.text   =   self.location.address_two;
        self.landmarkLabel.text     =   self.location.landmark;
        self.backView.frame         =   CGRectMake(0, 22, self.view.frame.size.width, self.backView.frame.size.height);
        self.showDetails.frame      =   CGRectMake(0, 22+self.backView.frame.size.height, self.view.frame.size.width, self.showDetails.frame.size.height);
        [self.gmsMapView addSubview:self.backView];
        [self.gmsMapView addSubview:self.showDetails];
    }else {
        /* Current Location
        float lat = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Lat"] floatValue];
        float lng = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Lng"] floatValue];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                                longitude:lng
                                                                     zoom:18];*/
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:19.10551362917248
                                                                longitude:72.88121938705444
                                                                     zoom:12];
        
        self.backView.frame         =   CGRectMake(0, 22, self.view.frame.size.width, self.backView.frame.size.height);
        [self.gmsMapView addSubview:self.backView];
        [self.showDetails removeFromSuperview];
        self.gmsMapView.camera = camera;
        self.gmsMapView.delegate = self;
        self.gmsMapView.myLocationEnabled = YES;
        [self potMarkerOnMap];
    }
}

-(void)potMarkerOnMap {
    LocationManager *locationManager = [[LocationManager alloc] init];
    NSMutableArray *allLocs = [locationManager allLocationRecords];
    
    for (Location *loc in allLocs) {
        float lat = [loc.latitude floatValue];
        float lng = [loc.longitude floatValue];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = @"Location";
        marker.snippet = [NSString stringWithFormat:@"%@\n%@\n%@",loc.address_one,loc.address_two,loc.landmark];
        marker.infoWindowAnchor = CGPointMake(0.5, 0.5);
        marker.icon = [UIImage imageNamed:@"greenDot"];
        marker.map = self.gmsMapView;
    }
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getDirectionButtonAction:(id)sender {
    
    /* Current 
     float startlat  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Lat"] floatValue];
    float startlng  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Lng"] floatValue];*/

    float startlat  = 19.10551362917248;
    float startlng  = 72.88121938705444;
    float finishlat = [self.location.latitude floatValue];
    float finishlng = [self.location.longitude floatValue];

    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(startlat, startlng);
    markerStart= [GMSMarker markerWithPosition:position];
    markerStart.icon = [UIImage imageNamed:@"greenDot"];
    markerStart.map = self.gmsMapView;
    
    CLLocation *startLocation  = [[CLLocation alloc] initWithLatitude:startlat longitude:startlng];
    CLLocation *finishLocation = [[CLLocation alloc] initWithLatitude:finishlat longitude:finishlng];
    
    NSMutableArray *directionCoordinates = [NSMutableArray new];
    [directionCoordinates addObject:startLocation];
    [directionCoordinates addObject:finishLocation];
    
    routeController = [LRouteController new];
    
    if ([directionCoordinates count] > 1)
    {
        //Draw line between two co-ordinate
        [routeController getPolylineWithLocations:directionCoordinates travelMode:TravelModeDriving andCompletitionBlock:^(GMSPolyline *polylines, NSError *error) {
            if (error)
            {
                NSLog(@"%@", error);
            }
            else if (!polylines)
            {
                NSLog(@"No route");
                [directionCoordinates removeAllObjects];
            }
            else
            {
                //Drow route
                markerStart.position = [[directionCoordinates objectAtIndex:0] coordinate];
                markerStart.map = self.gmsMapView;
                
                markerFinish.position = [[directionCoordinates lastObject] coordinate];
                markerFinish.map = self.gmsMapView;
                
                polyline = polylines;
                polyline.strokeWidth = 3;
                polyline.strokeColor = [UIColor blueColor];
                polyline.map = self.gmsMapView;
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
