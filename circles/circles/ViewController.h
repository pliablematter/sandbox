//
//  ViewController.h
//  circles
//
//  Created by Doug Burns on 11/5/13.
//  Copyright (c) 2013 Pliable Matter LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
