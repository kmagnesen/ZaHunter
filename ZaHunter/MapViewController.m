//
//  MapViewController.m
//  ZaHunter
//
//  Created by Kyle Magnesen on 1/21/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "MapViewController.h"
#import "PizzeriaViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if (annotation == mapView.userLocation) {
        return nil;
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];

    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return pin;
}


@end
