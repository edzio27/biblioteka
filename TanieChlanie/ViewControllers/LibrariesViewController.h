//
//  LibrariesViewController.h
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 02.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckLibraryDelegate <NSObject>

- (void)libraryWasChecked:(NSString *)libraryTitle;

@end

@interface LibrariesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *libraryDictionary;
@property (nonatomic, weak) id<CheckLibraryDelegate> delegate;

@end
