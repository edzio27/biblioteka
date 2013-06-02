//
//  ViewController.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 27.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ViewController.h"
#import "ParseViewController.h"
#import "ProductsListViewController.h"
#import "ShopListViewController.h"
#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "LibrariesViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation ViewController

- (MBProgressHUD *)progressHUD {
    if(_progressHUD == nil) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"Ładowanie...";
    }
    return _progressHUD;
}

- (void)openEmail {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[@"eugeniusz.keptia@gmail.com"]];
    if ([MFMailComposeViewController canSendMail]) {
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)button1 {
    if(_button1 == nil) {
        _button1 = [[UIButton alloc] initWithFrame:CGRectMake(70, 180, 180, 40)];
        _button1.layer.cornerRadius = 10.0f;
        _button1.layer.masksToBounds = YES;
        _button1.titleLabel.textColor = [UIColor whiteColor];
        _button1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button1 setTitle:@"Pokaż wszystkie" forState:UIControlStateNormal];
        _button1.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17];
        [_button1 setBackgroundColor:[UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0]];
        [_button1 addTarget:self action:@selector(showAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton *)button2 {
    if(_button2 == nil) {
        _button2 = [[UIButton alloc] initWithFrame:CGRectMake(70, 240, 180, 40)];
        _button2.layer.cornerRadius = 10.0f;
        _button2.layer.masksToBounds = YES;
        _button2.titleLabel.textColor = [UIColor whiteColor];
        _button2.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button2 setTitle:@"Wybierz filie" forState:UIControlStateNormal];
        _button2.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17];
        [_button2 setBackgroundColor:[UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0]];
        [_button2 addTarget:self action:@selector(showLibraries) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

- (UIButton *)button3 {
    if(_button3 == nil) {
        _button3 = [[UIButton alloc] initWithFrame:CGRectMake(70, 300, 180, 40)];
        _button3.layer.cornerRadius = 10.0f;
        _button3.layer.masksToBounds = YES;
        _button3.titleLabel.textColor = [UIColor whiteColor];
        _button3.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button3 setTitle:@"Wyszukaj" forState:UIControlStateNormal];
        _button3.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17];
        [_button3 setBackgroundColor:[UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0]];
        [_button3 addTarget:self action:@selector(showSearchResult) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}

- (UIImageView *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 320, 75)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.image = [UIImage imageNamed:@"logo"];
    }
    return _titleLabel;
}

- (UILabel *)authorLabel {
    if(_authorLabel == nil) {
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                 [[UIScreen mainScreen] bounds].size.height - 70,
                                                                 self.view.frame.size.width,
                                                                 50)];
        _authorLabel.backgroundColor = [UIColor clearColor];
        _authorLabel.numberOfLines = 2;
        _authorLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:10];
        _authorLabel.textColor = [UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0];
        _authorLabel.textAlignment = NSTextAlignmentCenter;
        _authorLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openEmail)];
        tapGesture.numberOfTapsRequired = 1;
        
        [_authorLabel addGestureRecognizer:tapGesture];
        _authorLabel.text = @"Aplikacja stworzona przez: Eugeniusz Keptia eugeniusz.keptia@gmail.com";
    }
    return _authorLabel;
}

- (BOOL)isThereInternetConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    return internetStatus != NotReachable ? YES : NO;
}

- (void)showAll {
    if([self isThereInternetConnection]) {
        [self.progressHUD show:YES];
        NSString *title = @"piekara";
        ParseViewController *parse = [[ParseViewController alloc] init];
        parse.delegate = self;
        [parse downloadHTMLResponseWithTitle:title andHandler:^(NSString *result) {
            [self.progressHUD hide:YES];
            [self.progressHUD removeFromSuperview];
            self.progressHUD = nil;
            ProductsListViewController *products = [[ProductsListViewController alloc] init];
            [self.navigationController pushViewController:products animated:YES];
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Błąd połączenia" message:@"Brak połączenia z siecią" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)showLibraries {
    if([self isThereInternetConnection]) {
        [self.progressHUD show:YES];
        NSString *title = @"piekara";
        ParseViewController *parse = [[ParseViewController alloc] init];
        parse.delegate = self;
        [parse downloadLibrariesWithTitle:title andHandler:^(NSMutableDictionary *result) {
            [self.progressHUD hide:YES];
            [self.progressHUD removeFromSuperview];
            self.progressHUD = nil;
            LibrariesViewController *libraries = [[LibrariesViewController alloc] init];
            libraries.libraryDictionary = result;
            [self.navigationController pushViewController:libraries animated:YES];
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Błąd połączenia" message:@"Brak połączenia z siecią" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.322 green:0.314 blue:0.345 alpha:1.0];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    [self.view addSubview:self.authorLabel];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.titleLabel];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideIndicator {
    [self.progressHUD hide:YES];
    [self.progressHUD removeFromSuperview];
    self.progressHUD = nil;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Błąd połączenia" message:@"Przekoczono limit czasu!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
