//
//  Position.h
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 26.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Position : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * mainURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * imageURL;

@end
