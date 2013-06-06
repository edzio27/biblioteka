//
//  AppDelegate.h
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 27.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#define RED_COLOR [UIColor colorWithRed:0.53 green:0.00 blue:0.17 alpha:1.00]
#define GRAY_COLOR [UIColor colorWithRed:0.85 green:0.85 blue:0.86 alpha:1.00]

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, strong) NSString *cookieString;

/* core data */
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@property (nonatomic, strong) MBProgressHUD *hud;

@end
