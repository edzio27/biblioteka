//
//  MapViewViewController.m
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 10.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "MapViewViewController.h"
#import "MyLocation.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Library.h"
#import "PositionDetail.h"

#define CENTER_LATITUDE 51.107779
#define CENTER_LONGITUDE 17.038583

@interface MapViewViewController ()

@property (nonatomic, strong) NSMutableArray *listLibrary;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *pinsArray;

@end

@implementation MapViewViewController

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (MKMapView *)mapView {
    if(_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)showAllPins {
    self.pinsArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.libraryDetailArray.count; i++) {
        Library *library = [self.libraryDetailArray objectAtIndex:i];
        PositionDetail *positionDetail = [self.positionDetailArray objectAtIndex:i];
        NSString *status = nil;
        if(positionDetail.termin == nil) {
            status = [NSString stringWithFormat:@"Dostępne"];
        } else {
            status = [NSString stringWithFormat:@"Dostępne od: %@", positionDetail.termin];
        }
        
        MyLocation *pin = [[MyLocation alloc] initWithName:[NSString stringWithFormat:@"Filia %@", library.number] address:status coordinate:CLLocationCoordinate2DMake([library.latitude doubleValue], [library.longitude doubleValue]) identifier:[NSNumber numberWithFloat:2]];
        [self.pinsArray addObject:pin];
        [self.mapView addAnnotation:pin];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Mapa dostępności";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.view addSubview:self.mapView];
    [self showAllPins];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    region.center = CLLocationCoordinate2DMake(CENTER_LATITUDE, CENTER_LONGITUDE);
    span.latitudeDelta = 0.18;
    span.longitudeDelta = 0.18;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}

/*
- (void)showSelectedPin {
    if(self.selectedPinNumber) {
        int selectedPin = [self.selectedPinNumber intValue];
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self mapView:self.mapView viewForAnnotation:[self.pinsArray objectAtIndex:selectedPin]];
        NSLog(@"%@", annotationView);
        [annotationView setSelected:YES animated:YES];
    }
}
*/
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation{
    static NSString *parkingAnnotationIdentifier=@"ParkingAnnotationIdentifier";
    
    if([annotation isKindOfClass:[MyLocation class]]){
        MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:parkingAnnotationIdentifier] ;
        customPinView.pinColor = MKPinAnnotationColorRed;
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        return customPinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
}

@end
