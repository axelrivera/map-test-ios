//
//  MapViewController.h
//  MapTest
//
//  Created by Axel Rivera on 8/10/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (copy, nonatomic) NSString *addressString;

- (id)initWithAddressString:(NSString *)addressString;

@end
