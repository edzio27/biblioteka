//
//  UIImage+MapShot.m
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 17.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "UIImage+MapShot.h"

@implementation UIImage (MapShot)

+ (UIImage *)getImageMapWithLatitude:(float)latitude andLongitude:(float)longitude {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%f,%f&zoom=10&markers=%f,%f&size=100x100&sensor=false", latitude, longitude, latitude, longitude]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    return img;
}

@end
