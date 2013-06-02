//
//  Product.h
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 31.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Shop;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * priceForLiter;
@property (nonatomic, retain) NSString * productURL;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) Shop *shop;

@end
