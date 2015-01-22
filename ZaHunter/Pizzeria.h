//
//  Pizzeria.h
//  ZaHunter
//
//  Created by Kyle Magnesen on 1/21/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import "Foundation/Foundation.h"
#import <MapKit/MapKit.h>

@interface Pizzeria : NSObject

-(instancetype)initWithmapItem:(MKMapItem *)mapItem;

@property CLLocationDistance distanceFromUser;
@property NSString *name;
@property MKMapItem *mapItem;

@property NSMutableArray *pizzeriaArray;
@property double distanceInMeters;

@end
