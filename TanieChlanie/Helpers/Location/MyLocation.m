//
//  MyLocation.m
//  Photrail
//
//  Created by Eugeniusz Keptia on 8/28/12.
//  Copyright (c) 2012 edzio27developer@gmail.com. All rights reserved.
//

#import "MyLocation.h"

@implementation MyLocation

- (id)initWithName:(NSString*)name address:(NSString*)address 
        coordinate:(CLLocationCoordinate2D)coordinate identifier:(NSNumber *)identifiers {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        _identifier = identifiers;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (NSNumber *)identyfikator {
    return _identifier;
}

@end