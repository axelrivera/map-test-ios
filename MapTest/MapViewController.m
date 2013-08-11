//
//  MapViewController.m
//  MapTest
//
//  Created by Axel Rivera on 8/10/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *addressLocation;

@end

@implementation MapViewController

- (id)init
{
    self = [super initWithNibName:@"MapViewController" bundle:nil];
    if (self) {
        self.title = @"Map";
        _addressString = [@"" copy];
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (id)initWithAddressString:(NSString *)addressString
{
    self = [self init];
    if (self) {
        _addressString = [addressString copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Directions"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(mapsAction:)];
    self.mapView.showsUserLocation = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self startUpdatingLocation];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.geocoder geocodeAddressString:self.addressString
                      completionHandler:^(NSArray *placemarks, NSError* error)
     {
         NSLog(@"Trying to get Address");

         if ([placemarks count] > 0) {
             CLPlacemark *placemark = placemarks[0];
             NSLog(@"Placemark: %@", placemark);

             self.addressLocation = placemark.location;
             self.navigationItem.rightBarButtonItem.enabled = YES;

             CLLocationCoordinate2D coordinate = placemark.location.coordinate;
             MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
             [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];

             MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
             point.coordinate = coordinate;
             point.title = self.addressString;

             [self.mapView addAnnotation:point];
         }
     }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapsAction:(id)sender
{
    NSString *URLString = [NSString stringWithFormat:@"http://maps.apple.com?ll=%+.6f,%+.6f",
                           self.addressLocation.coordinate.latitude,
                           self.addressLocation.coordinate.longitude];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL];
    }
}

#pragma mark - Location Methods

- (void)startUpdatingLocation
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }

    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;

    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500;

    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 5.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

@end
