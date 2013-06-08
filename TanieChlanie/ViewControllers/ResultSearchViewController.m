//
//  ResultSearchViewController.m
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 03.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "AppDelegate.h"
#import "ResultSearchViewController.h"
#import <CoreData/CoreData.h>
#import "Position.h"
#import "PositionResultViewController.h"
#import "ParseViewController.h"
#import "Reachability.h"
#import "ProductCell.h"

static int searchValue;

@interface ResultSearchViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *positionList;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) UIButton *loadMoreButton;

@end

@implementation ResultSearchViewController

- (UIButton *)loadMoreButton {
    if(_loadMoreButton == nil) {
        _loadMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(10,
                                                                     [[UIScreen mainScreen] bounds].size.height - self.navigationController.navigationBar.frame.size.height - 85,
                                                                     300,
                                                                     40)];
        _loadMoreButton.backgroundColor = RED_COLOR;
        _loadMoreButton.titleLabel.textColor = [UIColor whiteColor];
        [_loadMoreButton setTitle:@"Więcej wyników" forState:UIControlStateNormal];
        [_loadMoreButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadMoreButton;
}

- (void)showMore {
    searchValue++;
    NSString *value = [NSString stringWithFormat:@"%d", 10*searchValue + 1];
    ParseViewController *parser = [[ParseViewController alloc] init];
    [parser downloadMoreResultsPart:value title:self.positionTitle andHandler:^(NSMutableDictionary *handler) {
        self.positionList = nil;
        [self.tableView reloadData];
    }];
}

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (NSMutableArray *)positionList {
    if(_positionList == nil) {
        _positionList = [[NSMutableArray alloc] init];
        
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Position" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        _positionList = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    }
    return _positionList;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        CGRect rectTableView = CGRectMake(0,
                                          0,
                                          [[UIScreen mainScreen] bounds].size.width,
                                          [[UIScreen mainScreen] bounds].size.height
                                          - self.navigationController.navigationBar.frame.size.height
                                          - [UIApplication sharedApplication].statusBarFrame.size.height - 80);
        _tableView = [[UITableView alloc] initWithFrame:rectTableView style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark -
#pragma mark tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.positionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    ProductCell *cell =  (ProductCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Position *position = [self.positionList objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = position.title;
    cell.authorLabel.text = position.author;
    cell.dateLabel.text = position.year;
    
    if(fmod((double)indexPath.row, (double)2) == 0) {
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundView.backgroundColor = GRAY_COLOR;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", ((Position *)[self.positionList objectAtIndex:indexPath.row]).mainURL);
    if([self isThereInternetConnection]) {
        [self.progressHUD show:YES];
        NSString *url = ((Position *)[self.positionList objectAtIndex:indexPath.row]).mainURL;
        ParseViewController *parse = [[ParseViewController alloc] init];
        [parse downloadDetailPositionWithURL:url andHandler:^(NSMutableDictionary *result) {
            [self.progressHUD hide:YES];
            [self.progressHUD removeFromSuperview];
            self.progressHUD = nil;
            PositionResultViewController *position = [[PositionResultViewController alloc] init];
            [self.navigationController pushViewController:position animated:YES];
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Błąd połączenia" message:@"Brak połączenia z siecią" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (BOOL)isThereInternetConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    return internetStatus != NotReachable ? YES : NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.loadMoreButton];
    searchValue = 0;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
