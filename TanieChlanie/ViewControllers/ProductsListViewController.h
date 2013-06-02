//
//  ProductsListViewController.h
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 28.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSCacheDelegate>

@property (nonatomic, strong) NSString *shopName;

@end
