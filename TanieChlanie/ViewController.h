//
//  ViewController.h
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 27.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MBProgressHUD.h"
#import "ParseViewController.h"

@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate, MBProgressHUDDelegate, HideIndicatorDelegate>

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;

@end
