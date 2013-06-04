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
#import "ResultSearchViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
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
        _button1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
        _button1.layer.cornerRadius = 10.0f;
        _button1.layer.masksToBounds = YES;
        _button1.titleLabel.textColor = [UIColor whiteColor];
        _button1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button1 setTitle:@"Wyszukaj" forState:UIControlStateNormal];
        _button1.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17];
        [_button1 setBackgroundColor:[UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0]];
        [_button1 addTarget:self action:@selector(showAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton *)button2 {
    if(_button2 == nil) {
        _button2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 250, 280, 40)];
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
        NSString *title = self.textField.text;
        ParseViewController *parse = [[ParseViewController alloc] init];
        parse.delegate = self;
        [parse findSearchPathWithCookie:^(NSString *result) {
            [parse downloadResultWithTitle:title cookie:result andHandler:^(NSMutableDictionary *result) {
                [self.progressHUD hide:YES];
                [self.progressHUD removeFromSuperview];
                self.progressHUD = nil;
                ResultSearchViewController *products = [[ResultSearchViewController alloc] init];
                [self.navigationController pushViewController:products animated:YES];
            }];
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
            libraries.delegate = self;
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
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.returnKeyType = UIReturnKeyDone;
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

- (void)libraryWasChecked:(NSString *)libraryTitle {
    [self.button2 setTitle:libraryTitle forState:UIControlStateNormal];
}

@end
