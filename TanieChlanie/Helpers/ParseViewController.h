//
//  ParseViewController.h
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 27.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HideIndicatorDelegate <NSObject>

- (void)hideIndicator;

@end

@interface ParseViewController : UIViewController

- (void)downloadLibrariesWithTitle:(NSString *)title andHandler:(void(^)(NSMutableDictionary *result))handler;
- (void)downloadResultWithTitle:(NSString *)title andHandler:(void(^)(NSMutableDictionary *result))handler;
- (void)downloadDetailPositionWithURL:(NSString *)url andHandler:(void(^)(NSMutableDictionary *result))handler;

@property (nonatomic, weak) id<HideIndicatorDelegate> delegate;

@end
