//
//  ShopListViewController.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 28.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ShopListViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "ProductCell.h"
#import "ProductsListViewController.h"

@interface ShopListViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;

/* core data */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *productsList;
@property (nonatomic, strong) NSMutableArray *shopList;

@end

@implementation ShopListViewController

#pragma mark -
#pragma mark initialization

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:23];
        _titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"Wybierz sklep";
    }
    return _titleLabel;
}

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        CGRect rectTableView = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height
                                          - self.navigationController.navigationBar.frame.size.height - 30);
        _tableView = [[UITableView alloc] initWithFrame:rectTableView style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark -
#pragma mark Arrays

- (NSMutableArray *)shopList {
    if(_shopList == nil) {
        _shopList = [[NSMutableArray alloc] init];
        
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Shop" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        _shopList = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    }
    return _shopList;
}

- (NSMutableArray *)productsList {
    if(_productsList == nil) {
        _productsList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.shopList.count; i++) {
            
            NSError *error;
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            NSManagedObject *details = [self.shopList objectAtIndex:i];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shop = %@", details];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            [_productsList addObject:array];
        }
    }
    return _productsList;
}

#pragma mark -
#pragma mark tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shopList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSManagedObject *details = [self.shopList objectAtIndex:indexPath.row];
    cell.priceLabel.frame = CGRectMake(20, 30, 200, 30);
    cell.priceLabel.textAlignment = NSTextAlignmentLeft;
    cell.priceLabel.text = [NSString stringWithFormat:@"%d produktów", [[self.productsList objectAtIndex:indexPath.row] count]];
    cell.titleLabel.frame = CGRectMake(20, 0, 240, 40);
    cell.titleLabel.text = [details valueForKey:@"name"];
    //cell.productImageView.image = [UIImage imageNamed:@"no-image-blog-one"];
    cell.productImageView.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductsListViewController *products = [[ProductsListViewController alloc] init];
    NSManagedObject *details = [self.shopList objectAtIndex:indexPath.row];
    products.shopName = [details valueForKey:@"name"];
    [self.navigationController pushViewController:products animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.titleView = self.titleLabel;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
