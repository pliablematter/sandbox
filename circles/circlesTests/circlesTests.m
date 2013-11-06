//
//  circlesTests.m
//  circlesTests
//
//  Created by Doug Burns on 11/5/13.
//  Copyright (c) 2013 Pliable Matter LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>

@interface circlesTests : XCTestCase

@end

@implementation circlesTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    
    CLLocationCoordinate2D start = CLLocationCoordinate2DMake(40.729047, -73.994491);
    
    CLLocationCoordinate2D end = [self coordinateFromCoord:start atDistanceKm:.1 atBearingDegrees:270];
    
    //NSLog(@"Start: %f %f", start.latitude, start.longitude);
    NSLog(@"End: %f, %f", end.latitude, end.longitude);
    
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

@end
