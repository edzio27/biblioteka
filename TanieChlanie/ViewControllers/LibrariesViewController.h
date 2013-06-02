//
//  LibrariesViewController.h
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 02.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibrariesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *libraryDictionary;

@end
