//
//  ViewController.m
//  ZaHunter
//
//  Created by Kyle Magnesen on 1/21/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "PizzeriaViewController.h"
#import "Pizzeria.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PizzeriaViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property NSTimeInterval totalTravelTime;
@property CLLocationManager *locationManager;
@property NSMutableArray *pizzaPlaces;
@end

@implementation PizzeriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];

    [self.locationManager startUpdatingLocation];
}

#pragma mark Location And Directions

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 1000 && location.verticalAccuracy < 1000) {
            [self.locationManager stopUpdatingLocation];
            [self reverseGeocoding:location];
            break;
        }
    }
}

- (void)reverseGeocoding:(CLLocation *)location{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.firstObject;
        [self findPizzaNear:placemark.location];
    }];
}


- (void)findPizzaNear:(CLLocation *)location{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Pizza";
    request.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 20000, 20000);

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSArray *mapItems = response.mapItems;

        self.pizzaPlaces = [[NSMutableArray alloc]init];
        for (MKMapItem *mapItem in mapItems) {
            Pizzeria *pizza = [[Pizzeria alloc] initWithmapItem:mapItem];
            [self.pizzaPlaces addObject:pizza];
            pizza.distanceInMeters = [pizza.mapItem.placemark.location distanceFromLocation:location];
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"distanceInMeters" ascending:YES];
        [self.pizzaPlaces sortedArrayUsingDescriptors:@[sort]];
        [self.tableView reloadData];
    }];
}

#pragma mark Actions

- (IBAction)onSegmentControlTapped:(UISegmentedControl *)sender {

}

- (IBAction)onGetDirectionsButtonTapped:(UIButton *)sender {

}

#pragma mark Map Segue

- (IBAction)onMapButtonTapped:(UIBarButtonItem *)sender {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

# pragma mark UITableViewCell DataSource And Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pizzaPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZaCell" forIndexPath:indexPath];

    MKMapItem *pizzaMapItem;
    pizzaMapItem = [self.pizzaPlaces objectAtIndex:indexPath.row];
    Pizzeria *pizza = [self.pizzaPlaces objectAtIndex:indexPath.row];
    cell.textLabel.text = pizzaMapItem.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f mi", pizza.distanceInMeters / 1609.35];
    return cell;
}

@end
