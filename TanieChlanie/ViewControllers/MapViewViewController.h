//
//  MapViewViewController.h
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 10.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewViewController : UIViewController <MKMapViewDelegate, MKAnnotation>

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) NSMutableArray *positionDetailArray;
@property (nonatomic, strong) NSMutableArray *libraryDetailArray;
@property (nonatomic, strong) NSNumber *selectedPinNumber;

@end
