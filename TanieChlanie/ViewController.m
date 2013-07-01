//
//  ViewController.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 27.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ViewController.h"
#import "ParseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "LibrariesViewController.h"
#import "ResultSearchViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "NSString+URLEncoding.h"


@interface ViewController ()

@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableDictionary *libraries;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation ViewController

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (UIView *)titleView {
    if(_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        titleLabel.text = @"MBP Wrocław";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:titleLabel];
    }
    return _titleView;
}

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
        _button1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 270, 280, 50)];
        _button1.layer.cornerRadius = 0.0f;
        _button1.layer.masksToBounds = YES;
        _button1.titleLabel.textColor = [UIColor whiteColor];
        _button1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button1 setTitle:@"Wyszukaj" forState:UIControlStateNormal];
        _button1.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17];
        [_button1 setBackgroundColor:RED_COLOR];
        [_button1 addTarget:self action:@selector(showAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton *)button2 {
    if(_button2 == nil) {
        _button2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 280, 50)];
        _button2.layer.cornerRadius = 0.0f;
        _button2.layer.masksToBounds = YES;
        _button2.titleLabel.textColor = [UIColor whiteColor];
        _button2.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button2 setTitle:@"Wybierz filie" forState:UIControlStateNormal];
        _button2.titleLabel.numberOfLines = 2;
        _button2.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17];
        [_button2 setBackgroundColor:RED_COLOR];
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

- (BOOL)librariesDownloaded {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"librariesDictionary"] == nil) {
        return NO;
    }
    return YES;
}

- (void)showAll {
    if([self isThereInternetConnection]) {
        [self.progressHUD show:YES];
        NSString *title = [NSString encodeURL:self.textField.text];
        ParseViewController *parse = [[ParseViewController alloc] init];
        parse.delegate = self;
        NSArray *array = [self.libraries allKeysForObject:self.button2.titleLabel.text];
        NSString *value = nil;
        if(array.count > 0) {
            value = [array objectAtIndex:0];
        } else {
            value = @"MBP";
        }
        if(![self librariesDownloaded]) {
            [parse downloadLibrariesWithTitle:title andHandler:^(NSMutableDictionary *result) {
                [parse findSearchPathWithCookie:^(NSString *result) {
                    [parse downloadResultWithTitle:title library:value cookie:result andHandler:^(NSMutableDictionary *result) {
                        [self.progressHUD hide:YES];
                        [self.progressHUD removeFromSuperview];
                        self.progressHUD = nil;
                        ResultSearchViewController *products = [[ResultSearchViewController alloc] init];
                        products.positionTitle = title;
                        [self.navigationController pushViewController:products animated:YES];
                    }];
                }];
            }];

        } else {
            [parse findSearchPathWithCookie:^(NSString *result) {
                [parse downloadResultWithTitle:title library:value cookie:result andHandler:^(NSMutableDictionary *result) {
                    [self.progressHUD hide:YES];
                    [self.progressHUD removeFromSuperview];
                    self.progressHUD = nil;
                    ResultSearchViewController *products = [[ResultSearchViewController alloc] init];
                    products.positionTitle = title;
                    [self.navigationController pushViewController:products animated:YES];
                }];
            }];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Błąd połączenia" message:@"Brak połączenia z siecią" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)showLibraries {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([self isThereInternetConnection]) {
        [self.progressHUD show:YES];
        NSString *title = @"piekara";
        ParseViewController *parse = [[ParseViewController alloc] init];
        parse.delegate = self;
        if(![self librariesDownloaded]) {
            [parse downloadLibrariesWithTitle:title andHandler:^(NSMutableDictionary *result) {
                [self.progressHUD hide:YES];
                [self.progressHUD removeFromSuperview];
                self.progressHUD = nil;
                LibrariesViewController *libraries = [[LibrariesViewController alloc] init];
                libraries.delegate = self;
                [userDefault setObject:result forKey:@"librariesDictionary"];
                libraries.libraryDictionary = result;
                [self.navigationController pushViewController:libraries animated:YES];
            }];
        } else {
            [self.progressHUD hide:YES];
            [self.progressHUD removeFromSuperview];
            self.progressHUD = nil;
            LibrariesViewController *libraries = [[LibrariesViewController alloc] init];
            libraries.delegate = self;
            libraries.libraryDictionary = [userDefault objectForKey:@"librariesDictionary"];
            [self.navigationController pushViewController:libraries animated:YES];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Błąd połączenia" message:@"Brak połączenia z siecią" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.button1];
    [self.scrollView addSubview:self.button2];
    
    [self.textField.layer setCornerRadius:0.0f];
    self.textField.layer.masksToBounds = YES;
    [self.textField setBackgroundColor:GRAY_COLOR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.titleView;
    /* custom imageview in bavigationbar */
    UIImage *image = [[UIImage imageNamed:@"navigationbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:RED_COLOR];
    self.scrollView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark keyboard

- (void)keyboardDidAppear:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGRect rectTableView = CGRectMake(0,
                                      0,
                                      [[UIScreen mainScreen] bounds].size.width,
                                      [[UIScreen mainScreen] bounds].size.height
                                      - self.navigationController.navigationBar.frame.size.height
                                      - [UIApplication sharedApplication].statusBarFrame.size.height
                                      - keyboardFrameBeginRect.size.height);
    [self.scrollView setContentOffset:CGPointMake(rectTableView.origin.x, rectTableView.origin.y+100) animated:YES];
}

- (void)keyboardDidDisappear:(NSNotification *)notification {
    CGRect rectTableView = CGRectMake(0,
                                      0,
                                      [[UIScreen mainScreen] bounds].size.width,
                                      [[UIScreen mainScreen] bounds].size.height
                                      - self.navigationController.navigationBar.frame.size.height
                                      - [UIApplication sharedApplication].statusBarFrame.size.height);
    self.scrollView.frame = rectTableView;
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
