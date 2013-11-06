//
//  ViewController.m
//  circles
//
//  Created by Doug Burns on 11/5/13.
//  Copyright (c) 2013 Pliable Matter LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(40.729047, -73.994491);
    [self.mapView setCenterCoordinate:center];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, 1500, 1500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    float regionRadius = 100;
    float cushionRadius = regionRadius * 3;
    float offset = (regionRadius * 4) / 1000; // Cushion center is offset 4x the radius of the region (in meters)
    
    CLLocationCoordinate2D north = [self coordinateFromCoord:center atDistanceKm:offset atBearingDegrees:0];
    CLLocationCoordinate2D east = [self coordinateFromCoord:center atDistanceKm:offset atBearingDegrees:90];
    CLLocationCoordinate2D south = [self coordinateFromCoord:center atDistanceKm:offset atBearingDegrees:180];
    CLLocationCoordinate2D west = [self coordinateFromCoord:center atDistanceKm:offset atBearingDegrees:270];
    
    [self.mapView addOverlay:[MKCircle circleWithCenterCoordinate:center radius:regionRadius]];
    [self.mapView addOverlay:[MKCircle circleWithCenterCoordinate:north radius:cushionRadius]];
    [self.mapView addOverlay:[MKCircle circleWithCenterCoordinate:east radius:cushionRadius]];
    [self.mapView addOverlay:[MKCircle circleWithCenterCoordinate:south radius:cushionRadius]];
    [self.mapView addOverlay:[MKCircle circleWithCenterCoordinate:west radius:cushionRadius]];
}

- (MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        renderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:.2];
        return renderer;
    }
    return nil;
}

- (CLLocationCoordinate2D)coordinateFromCoord:(CLLocationCoordinate2D)fromCoord
                                 atDistanceKm:(double)distanceKm
                             atBearingDegrees:(double)bearingDegrees
{
    double distanceRadians = distanceKm / 6371.0;
    //6,371 = Earth's radius in km
    double bearingRadians = [self radiansFromDegrees:bearingDegrees];
    double fromLatRadians = [self radiansFromDegrees:fromCoord.latitude];
    double fromLonRadians = [self radiansFromDegrees:fromCoord.longitude];
    
    double toLatRadians = asin(sin(fromLatRadians) * cos(distanceRadians)
                               + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians) );
    
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                 * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                 - sin(fromLatRadians) * sin(toLatRadians));
    
    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;
    
    CLLocationCoordinate2D result;
    result.latitude = [self degreesFromRadians:toLatRadians];
    result.longitude = [self degreesFromRadians:toLonRadians];
    
    return result;
}

- (double)radiansFromDegrees:(double)degrees
{
    return degrees * (M_PI/180.0);
}

- (double)degreesFromRadians:(double)radians
{
    return radians * (180.0/M_PI);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
