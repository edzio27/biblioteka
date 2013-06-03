//
//  PositionDetail.h
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 03.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PositionDetail : NSManagedObject

@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * termin;
@property (nonatomic, retain) NSString * library;
@property (nonatomic, retain) NSString * amount;

@end
