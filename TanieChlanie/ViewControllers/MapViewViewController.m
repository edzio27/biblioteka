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

@interface MapViewViewController ()

@property (nonatomic, strong) NSMutableArray *listLibrary;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

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

- (NSMutableArray *)listLibrary {
    if(_listLibrary == nil) {
        _listLibrary = [[NSMutableArray alloc] init];
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Library" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        _listLibrary = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
        
        Library *l = [_listLibrary objectAtIndex:5];
        NSLog(@"%@", l.longitude);
        NSLog(@"%@", l.number);
        NSLog(@"%@", l.longitude);
        
    }
    return _listLibrary;
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
    for(int i = 0; i < self.listLibrary.count; i++) {
        Library *library = [self.listLibrary objectAtIndex:i];
        NSLog(@"%@", library.latitude);
        NSLog(@"%@", library.longitude);
        MyLocation *pin = [[MyLocation alloc] initWithName:[NSString stringWithFormat:@"Filia %@", library.number] address:@"eloelo" coordinate:CLLocationCoordinate2DMake([library.latitude doubleValue], [library.longitude doubleValue]) identifier:[NSNumber numberWithFloat:2]];
        [self.mapView addAnnotation:pin];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    [self showAllPins];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation{
    NSLog(@"inside viewAnnotation");
    static NSString *parkingAnnotationIdentifier=@"ParkingAnnotationIdentifier";
    
    if([annotation isKindOfClass:[MyLocation class]]){
        MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:parkingAnnotationIdentifier] ;
        customPinView.pinColor = MKPinAnnotationColorRed;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rightButton.tag = [((MyLocation *)annotation).identifier integerValue];
        [rightButton addTarget:self action:@selector(showGallery:) forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        return customPinView;
    }
    return nil;
}

@end
